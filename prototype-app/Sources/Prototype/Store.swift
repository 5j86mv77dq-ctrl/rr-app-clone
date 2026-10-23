import Foundation
import AppKit

/// Same fallback Proto uses; overridden by the `prototypeRepoPath` default (Settings).
let defaultRepoPath = "\(NSHomeDirectory())/Documents/Software/rr-app-clone"
let designListID = "901115600462"   // ClickUp: App › App Development › Design

struct Snapshot {
    var designs: [Design] = []
    var currentApp = LinkTarget(page: "slices/live-video.html", name: "Current app")
    var behind: [String: Int] = [:]     // design id → Current app commits since its catch-up
    var exists: Set<String> = []        // pages present on disk
    var loadError: String? = nil
}

/// The repo is the database. Reads `prototype.json`, the MANIFEST designation (which slice
/// is the Current app), git, and the changelog. Writes only `prototype.json`, the
/// checklist statuses in `Roadmap/CHANGELOG.md`, and — for Archive — the slice move.
@MainActor
final class Store: ObservableObject {
    @Published var designs: [Design] = []
    @Published var currentApp = LinkTarget(page: "slices/live-video.html", name: "Current app")
    @Published var behind: [String: Int] = [:]
    @Published var exists: Set<String> = []
    @Published var loadError: String? = nil
    @Published var waiting: [WaitingTask] = []
    @Published var clickupError: String? = nil
    @Published var hasClickUpToken = Keychain.get(.clickup) != nil
    @Published var hasNetlifyToken = Keychain.get(.netlify) != nil
    @Published var toast: String? = nil

    private var refreshing = false
    private var lastClickUp = Date.distantPast

    var repoPath: String {
        get { UserDefaults.standard.string(forKey: "prototypeRepoPath") ?? defaultRepoPath }
        set { UserDefaults.standard.set(newValue, forKey: "prototypeRepoPath"); refresh() }
    }

    var vision: LinkTarget { LinkTarget(page: "index.html", name: "The Vision") }
    var live: [Design] { designs.filter { $0.stage != .archived } }
    var archived: [Design] { designs.filter { $0.stage == .archived } }

    func design(_ id: String) -> Design? { designs.first { $0.id == id } }

    // MARK: - shell

    nonisolated static func sh(_ launchPath: String, _ args: [String], cwd: String) -> String {
        let p = Process()
        p.executableURL = URL(fileURLWithPath: launchPath)
        p.arguments = args
        p.currentDirectoryURL = URL(fileURLWithPath: cwd)
        let pipe = Pipe()
        p.standardOutput = pipe
        p.standardError = FileHandle.nullDevice
        do { try p.run() } catch { return "" }
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        p.waitUntilExit()
        return String(data: data, encoding: .utf8) ?? ""
    }

    @discardableResult
    nonisolated static func git(_ args: [String], cwd: String) -> String {
        sh("/usr/bin/git", args, cwd: cwd)
    }

    nonisolated static func gitOK(_ args: [String], cwd: String) -> Bool {
        let p = Process()
        p.executableURL = URL(fileURLWithPath: "/usr/bin/git")
        p.arguments = args
        p.currentDirectoryURL = URL(fileURLWithPath: cwd)
        p.standardOutput = FileHandle.nullDevice
        p.standardError = FileHandle.nullDevice
        do { try p.run() } catch { return false }
        p.waitUntilExit()
        return p.terminationStatus == 0
    }

    nonisolated static var today: String {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f.string(from: Date())
    }

    nonisolated static func slurp(_ repoPath: String, _ rel: String) -> String? {
        try? String(contentsOfFile: repoPath + "/" + rel, encoding: .utf8)
    }

    nonisolated static func firstMatch(_ text: String, _ pattern: String) -> String? {
        guard let re = try? NSRegularExpression(pattern: pattern, options: [.dotMatchesLineSeparators]) else { return nil }
        let r = NSRange(text.startIndex..., in: text)
        guard let m = re.firstMatch(in: text, range: r), m.numberOfRanges > 1,
              let g = Range(m.range(at: 1), in: text) else { return nil }
        return String(text[g])
    }

    // MARK: - refresh

    func refresh() {
        if refreshing { return }
        refreshing = true
        let path = repoPath
        Task.detached(priority: .userInitiated) {
            let snap = Store.load(repoPath: path)
            await MainActor.run { [weak self] in
                guard let self else { return }
                self.designs = snap.designs
                self.currentApp = snap.currentApp
                self.behind = snap.behind
                self.exists = snap.exists
                self.loadError = snap.loadError
                self.refreshing = false
                if !Store.portOpen(8000) { self.spawnServer() }
            }
        }
        if Date().timeIntervalSince(lastClickUp) > 60 { refreshClickUp() }
    }

    nonisolated static func load(repoPath: String) -> Snapshot {
        var snap = Snapshot()
        guard FileManager.default.fileExists(atPath: repoPath + "/dashboard.html") else {
            snap.loadError = "No rr-app-clone repo at \(repoPath). Pick the folder in Settings."
            return snap
        }
        snap.designs = readDesigns(repoPath: repoPath)
        if let page = currentAppPage(repoPath: repoPath) {
            snap.currentApp = LinkTarget(page: page, name: "Current app")
        }
        for d in snap.designs {
            for p in [d.page, d.testerPage].compactMap({ $0 }) + (d.looks ?? [])
            where FileManager.default.fileExists(atPath: repoPath + "/" + p) {
                snap.exists.insert(p)
            }
            // Frozen and finished designs are never refreshed, so never "behind".
            guard !d.isFrozen, d.stage == .building || d.stage == .looks,
                  let pin = d.baseCommit, !pin.isEmpty else { continue }
            snap.behind[d.id] = realChangeCount(repoPath: repoPath, pin: pin, path: snap.currentApp.page)
        }
        return snap
    }

    /// The production-designated slice: the MANIFEST entry carrying `isProduction: true`.
    nonisolated static func currentAppPage(repoPath: String) -> String? {
        guard let dash = slurp(repoPath, "dashboard.html"),
              let block = firstMatch(dash, "const MANIFEST = \\{(.*?)\\n  \\};") else { return nil }
        for chunk in block.components(separatedBy: "page: \"").dropFirst() {
            let page = String(chunk.prefix(while: { $0 != "\"" }))
            if firstMatch(chunk, "isProduction:\\s*(true)") != nil { return page }
        }
        return nil
    }

    /// Commits to `path` since `pin` that changed design, not just PROTO front matter —
    /// the same rule Proto uses, so the two apps agree on staleness.
    nonisolated static func realChangeCount(repoPath: String, pin: String, path: String) -> Int {
        let shas = git(["rev-list", "-n", "60", "\(pin)..HEAD", "--", path], cwd: repoPath)
            .split(separator: "\n").map(String.init)
        var real = 0
        for sha in shas where diffHasContentChanges(git(["show", "--format=", sha, "--", path], cwd: repoPath)) {
            real += 1
        }
        return real
    }

    nonisolated static func diffHasContentChanges(_ diff: String) -> Bool {
        let metaPrefixes = ["<!--PROTO", "-->", "name:", "stage:", "production:", "base:", "dependsOn:", "archived:", "purpose:"]
        for raw in diff.split(separator: "\n", omittingEmptySubsequences: false) {
            let line = String(raw)
            guard line.hasPrefix("+") || line.hasPrefix("-") else { continue }
            if line.hasPrefix("+++") || line.hasPrefix("---") { continue }
            let body = line.dropFirst().trimmingCharacters(in: .whitespaces)
            if body.isEmpty || metaPrefixes.contains(where: { body.hasPrefix($0) }) { continue }
            return true
        }
        return false
    }

    // MARK: - prototype.json

    nonisolated static let designsPath = "prototype.json"

    nonisolated static func readDesigns(repoPath: String) -> [Design] {
        guard let data = FileManager.default.contents(atPath: repoPath + "/" + designsPath),
              let file = try? JSONDecoder().decode(DesignFile.self, from: data) else { return [] }
        return file.designs
    }

    /// Read-modify-write against the file on disk (Claude may have edited it since the
    /// last refresh), so a Prototype write never clobbers Claude's.
    @discardableResult
    func mutateDesigns(_ change: (inout [Design]) -> Void) -> String? {
        var file = DesignFile()
        if let data = FileManager.default.contents(atPath: repoPath + "/" + Store.designsPath) {
            guard let parsed = try? JSONDecoder().decode(DesignFile.self, from: data) else {
                return "prototype.json doesn't parse — ask Claude to fix it before changing anything."
            }
            file = parsed
        }
        change(&file.designs)
        let enc = JSONEncoder()
        enc.outputFormatting = [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
        do {
            let data = try enc.encode(file)
            try (String(decoding: data, as: UTF8.self) + "\n")
                .write(toFile: repoPath + "/" + Store.designsPath, atomically: true, encoding: .utf8)
        } catch {
            return "Couldn't write prototype.json: \(error.localizedDescription)"
        }
        designs = file.designs
        return nil
    }

    /// Start: the record exists before Claude runs, so the card appears at once and the
    /// ClickUp item leaves "Waiting".
    func createDesign(name: String, request: String, looks: Bool, task: WaitingTask?) -> Design {
        var id = slugify(name)
        let taken = Set(designs.map(\.id))
        var n = 2
        let root = id
        while taken.contains(id) || FileManager.default.fileExists(atPath: repoPath + "/slices/\(id).html") {
            id = "\(root)-\(n)"; n += 1
        }
        let d = Design(id: id, name: name, request: request, start: looks ? "looks" : "build",
                       clickupTaskId: task?.id, clickupURL: task?.url,
                       page: "slices/\(id).html", stage: looks ? .looks : .building,
                       frozen: nil, baseCommit: nil, looks: nil, pickedLook: nil,
                       testerPage: nil, created: Store.today)
        if let err = mutateDesigns({ $0.append(d) }) { toast = err }
        return d
    }

    // MARK: - ClickUp (read only)

    func refreshClickUp() {
        lastClickUp = Date()
        guard let token = Keychain.get(.clickup) else {
            hasClickUpToken = false
            waiting = []
            return
        }
        hasClickUpToken = true
        Task {
            do {
                let tasks = try await ClickUp.openParentTasks(listID: designListID, token: token)
                let started = Set(designs.compactMap(\.clickupTaskId))
                waiting = tasks.filter { !started.contains($0.id) }
                clickupError = nil
            } catch {
                clickupError = error.localizedDescription
            }
        }
    }

    /// Tasks already started drop out of Waiting the moment a design records them.
    var waitingNow: [WaitingTask] {
        let started = Set(designs.compactMap(\.clickupTaskId))
        return waiting.filter { !started.contains($0.id) }
    }

    func saveToken(_ kind: Keychain.Account, _ value: String) {
        let v = value.trimmingCharacters(in: .whitespacesAndNewlines)
        if v.isEmpty { Keychain.delete(kind) } else { Keychain.set(kind, v) }
        hasClickUpToken = Keychain.get(.clickup) != nil
        hasNetlifyToken = Keychain.get(.netlify) != nil
        if kind == .clickup { refreshClickUp() }
    }

    // MARK: - versions (each push that changed the page = one Netlify deploy)

    func versions(for d: Design) async -> [Version] {
        let path = repoPath
        let pages = Set([d.page, "slices/" + (d.page as NSString).lastPathComponent])
        let commits = await Task.detached { Store.commits(repoPath: path, page: d.page) }.value
        guard let token = Keychain.get(.netlify),
              let deploys = try? await Netlify.deploys(token: token) else {
            return commits.map { Version(sha: $0.sha, date: $0.date, subject: $0.subject, url: nil) }
        }
        return await Task.detached { () -> [Version] in
            // Walk deploys oldest → newest; a deploy is a version when the page differs
            // from the previous deploy's copy.
            var out: [Version] = []
            var prevBlob = ""
            for dep in deploys.reversed() {
                guard let at = pages.first(where: { Store.gitOK(["cat-file", "-e", "\(dep.commit):\($0)"], cwd: path) }) else { continue }
                let blob = Store.git(["rev-parse", "\(dep.commit):\(at)"], cwd: path).trimmingCharacters(in: .whitespacesAndNewlines)
                if blob == prevBlob { continue }
                prevBlob = blob
                let subject = Store.git(["log", "-1", "--format=%s", dep.commit], cwd: path).trimmingCharacters(in: .whitespacesAndNewlines)
                out.append(Version(sha: String(dep.commit.prefix(7)), date: dep.date, subject: subject,
                                   url: dep.url + "/" + at))
            }
            return out.reversed()
        }.value
    }

    nonisolated static func commits(repoPath: String, page: String) -> [Version] {
        git(["log", "--follow", "--format=%h§%cs§%s", "-n", "30", "--", page], cwd: repoPath)
            .components(separatedBy: "\n").compactMap { line in
                let p = line.components(separatedBy: "§")
                guard p.count >= 3 else { return nil }
                return Version(sha: p[0], date: p[1], subject: p[2], url: nil)
            }
    }

    // MARK: - changelog checklist (Roadmap/CHANGELOG.md)

    nonisolated static let changelogPath = "Roadmap/CHANGELOG.md"
    nonisolated static let queuedMark = "⏫ to Vision"

    func checklist(for d: Design) -> [ChecklistRow] {
        guard let log = Store.slurp(repoPath, Store.changelogPath) else { return [] }
        return Store.checklist(log: log, pages: Store.pageAliases(d))
    }

    nonisolated static func pageAliases(_ d: Design) -> [String] {
        let file = (d.page as NSString).lastPathComponent
        return Array(Set([d.page, "slices/" + file, "slices/archive/" + file]))
    }

    nonisolated static func checklist(log: String, pages: [String]) -> [ChecklistRow] {
        var rows: [ChecklistRow] = []
        var inSection = false
        for raw in log.components(separatedBy: "\n") {
            if raw.hasPrefix("## ") {
                inSection = pages.contains { raw.contains("`\($0)`") }
                continue
            }
            guard inSection else { continue }
            let t = raw.trimmingCharacters(in: .whitespaces)
            guard t.hasPrefix("|"), !t.hasPrefix("|--"), !t.hasPrefix("| Date"), !t.hasPrefix("|---") else { continue }
            let cells = t.components(separatedBy: "|").map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
            guard cells.count >= 3, let status = cells.last else { continue }
            let state: ChecklistRow.State
            if status.contains("⏫") { state = .queued }
            else if status.contains("🌐") { state = .ported }
            else if status.contains("🔀") { state = .sliceOnly }
            else if status.contains("⬜") { state = .pending }
            else { continue }   // meta rows aren't decisions
            rows.append(ChecklistRow(line: raw, date: cells[0],
                                     text: cells[1..<(cells.count - 1)].joined(separator: " | "),
                                     state: state))
        }
        return rows
    }

    /// Tick → queued for the Vision; untick → slice-only. Ported rows are already in the
    /// Vision and stay ticked. Anchored on the exact line; re-read from disk first.
    func setChecklist(_ row: ChecklistRow, ticked: Bool) -> String? {
        guard row.state != .ported else { return "Already in the Vision." }
        guard let log = Store.slurp(repoPath, Store.changelogPath) else { return "Can't read the changelog." }
        let status = ticked ? "\(Store.queuedMark) (\(Store.today))" : "🔀 slice-only"
        guard let newLog = Store.replacingStatus(in: log, line: row.line, with: status) else {
            return "That line changed under us — reopen the checklist."
        }
        do {
            try newLog.write(toFile: repoPath + "/" + Store.changelogPath, atomically: true, encoding: .utf8)
        } catch { return error.localizedDescription }
        return nil
    }

    nonisolated static func replacingStatus(in log: String, line: String, with status: String) -> String? {
        var lines = log.components(separatedBy: "\n")
        guard let i = lines.firstIndex(of: line) else { return nil }
        var body = line
        while body.hasSuffix(" ") || body.hasSuffix("|") { body.removeLast() }
        guard let lastPipe = body.lastIndex(of: "|") else { return nil }
        lines[i] = String(body[...lastPipe]) + " " + status + " |"
        return lines.joined(separator: "\n")
    }

    // MARK: - Archive (the one action Prototype finishes itself, git included)

    func archive(_ d: Design) -> String? {
        guard d.stage != .archived else { return "Already archived." }
        guard d.page != currentApp.page else { return "That's the Current app — it can't be archived." }
        let path = repoPath
        let file = (d.page as NSString).lastPathComponent
        let newPage = "slices/archive/" + file
        let note = "\(Store.today) — archived from Prototype."
        var touched = [Store.designsPath]

        if FileManager.default.fileExists(atPath: path + "/" + d.page) {
            try? FileManager.default.createDirectory(atPath: path + "/slices/archive", withIntermediateDirectories: true)
            let tracked = Store.gitOK(["ls-files", "--error-unmatch", d.page], cwd: path)
            if tracked {
                Store.git(["mv", d.page, newPage], cwd: path)
            }
            if !FileManager.default.fileExists(atPath: path + "/" + newPage) {
                do { try FileManager.default.moveItem(atPath: path + "/" + d.page, toPath: path + "/" + newPage) }
                catch { return "Couldn't move the file: \(error.localizedDescription)" }
            }
            touched += [d.page, newPage]
            // Keep Proto's records honest when they exist; a missing anchor just skips that record.
            if let src = Store.slurp(path, newPage), let out = Store.frontMatterArchived(src, note: note) {
                try? out.write(toFile: path + "/" + newPage, atomically: true, encoding: .utf8)
            }
            if let dash = Store.slurp(path, "dashboard.html"),
               let out = Store.manifestArchived(dash, page: d.page, newPage: newPage, note: note) {
                try? out.write(toFile: path + "/dashboard.html", atomically: true, encoding: .utf8)
                touched.append("dashboard.html")
            }
        }
        let moved = FileManager.default.fileExists(atPath: path + "/" + newPage)
        if let err = mutateDesigns({ list in
            guard let i = list.firstIndex(where: { $0.id == d.id }) else { return }
            list[i].stage = .archived
            if moved { list[i].page = newPage }
        }) { return err }

        let name = d.name
        Task.detached {
            let onDisk = touched.filter { FileManager.default.fileExists(atPath: path + "/" + $0) }
            Store.git(["add", "--"] + onDisk, cwd: path)
            // a pathspec git has never seen fails the whole commit — keep only known paths
            let known = touched.filter { onDisk.contains($0) || Store.gitOK(["cat-file", "-e", "HEAD:\($0)"], cwd: path) }
            Store.git(["commit", "-m", "Archive design: \(name)", "--"] + known, cwd: path)
            Store.git(["push", "origin", "main"], cwd: path)
        }
        refresh()
        return nil
    }

    nonisolated static func frontMatterArchived(_ src: String, note: String) -> String? {
        let head = String(src.prefix(2000))
        guard let open = head.range(of: "<!--PROTO"),
              let close = head.range(of: "-->", range: open.upperBound..<head.endIndex) else { return nil }
        var block = String(head[open.upperBound..<close.lowerBound])
        block = block.components(separatedBy: "\n")
            .filter { !$0.trimmingCharacters(in: .whitespaces).hasPrefix("archived:") }
            .joined(separator: "\n")
        while block.hasSuffix("\n") { block.removeLast() }
        return src.replacingCharacters(in: open.lowerBound..<close.lowerBound,
                                       with: "<!--PROTO" + block + "\narchived: " + note + "\n")
    }

    nonisolated static func manifestArchived(_ dash: String, page: String, newPage: String, note: String) -> String? {
        guard let r = dash.range(of: "page: \"\(page)\"") else { return nil }
        let replacement = """
        page: "\(newPage)",
                archived: true,
                archivedNote: "\(note.replacingOccurrences(of: "\"", with: "'"))",
        """
        var end = r.upperBound
        if end < dash.endIndex, dash[end] == "," { end = dash.index(after: end) }
        return dash.replacingCharacters(in: r.lowerBound..<end, with: replacement)
    }

    // MARK: - local server (port 8000 — the repo's fixed local port)

    nonisolated static func portOpen(_ port: UInt16) -> Bool {
        let fd = socket(AF_INET, SOCK_STREAM, 0)
        guard fd >= 0 else { return false }
        defer { close(fd) }
        var addr = sockaddr_in()
        addr.sin_family = sa_family_t(AF_INET)
        addr.sin_port = port.bigEndian
        addr.sin_addr.s_addr = inet_addr("127.0.0.1")
        let result = withUnsafePointer(to: &addr) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                connect(fd, $0, socklen_t(MemoryLayout<sockaddr_in>.size))
            }
        }
        return result == 0
    }

    private func spawnServer() {
        let p = Process()
        p.executableURL = URL(fileURLWithPath: "/usr/bin/python3")
        p.arguments = ["-m", "http.server", "8000"]
        p.currentDirectoryURL = URL(fileURLWithPath: repoPath)
        p.standardOutput = FileHandle.nullDevice
        p.standardError = FileHandle.nullDevice
        try? p.run()
    }

    // MARK: - actions

    func copy(_ s: String, _ message: String) {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(s, forType: .string)
        toast = message
    }

    func open(_ s: String) {
        if let u = URL(string: s) { NSWorkspace.shared.open(u) }
    }

    func launch(_ prompt: String, title: String) {
        toast = ClaudeLauncher.launch(prompt: prompt, repoPath: repoPath, title: title)
    }
}
