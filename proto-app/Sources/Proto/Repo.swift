import Foundation
import AppKit

struct RepoSnapshot {
    var pages: [SliceEntry] = []
    var prds: [PRDEntry] = []
    var branch = ""
    var dirty = false
    var loadError: String? = nil
    var integrityWarnings: [String] = []
    var serverRunning = false
}

@MainActor
final class Repo: ObservableObject {
    @Published var pages: [SliceEntry] = []
    @Published var prds: [PRDEntry] = []
    @Published var branch = ""
    @Published var dirty = false
    @Published var lastRefreshed: Date? = nil
    @Published var loadError: String? = nil
    @Published var integrityWarnings: [String] = []
    @Published var serverRunning = false
    @Published var refreshing = false

    private var lastRefreshStart = Date.distantPast

    var repoPath: String {
        get { UserDefaults.standard.string(forKey: "repoPath") ?? "\(NSHomeDirectory())/Documents/AI/RR App Clone" }
        set { UserDefaults.standard.set(newValue, forKey: "repoPath"); refresh(force: true) }
    }

    // MARK: - shell (never blocks the main thread for long; stderr nulled — no pipe deadlock)

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

    nonisolated static func git(_ args: [String], cwd: String) -> String {
        sh("/usr/bin/git", args, cwd: cwd)
    }

    /// Instant localhost port probe (replaces the seconds-slow `lsof`).
    nonisolated static func portOpen(_ port: UInt16) -> Bool {
        let fd = socket(AF_INET, SOCK_STREAM, 0)
        guard fd >= 0 else { return false }
        defer { close(fd) }
        var tv = timeval(tv_sec: 0, tv_usec: 250_000)
        setsockopt(fd, SOL_SOCKET, SO_SNDTIMEO, &tv, socklen_t(MemoryLayout<timeval>.size))
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

    // MARK: - refresh (background load → main-thread apply)

    func refresh(force: Bool = false) {
        // debounce activation-triggered refreshes
        if !force, Date().timeIntervalSince(lastRefreshStart) < 2.0 { return }
        if refreshing { return }
        lastRefreshStart = Date()
        refreshing = true
        let path = repoPath
        Task.detached(priority: .userInitiated) {
            let snap = Repo.loadSnapshot(repoPath: path)
            await MainActor.run { [weak self] in
                guard let self else { return }
                self.pages = snap.pages
                self.prds = snap.prds
                self.branch = snap.branch
                self.dirty = snap.dirty
                self.loadError = snap.loadError
                self.integrityWarnings = snap.integrityWarnings
                self.serverRunning = snap.serverRunning
                self.lastRefreshed = Date()
                self.refreshing = false
                if !snap.serverRunning { self.spawnServer() }
            }
        }
    }

    nonisolated static func loadSnapshot(repoPath: String) -> RepoSnapshot {
        var snap = RepoSnapshot()
        guard FileManager.default.fileExists(atPath: repoPath + "/dashboard.html") else {
            snap.loadError = "No dashboard.html at \(repoPath) — pick the repo folder in Settings (⚙)."
            return snap
        }
        snap.branch = git(["rev-parse", "--abbrev-ref", "HEAD"], cwd: repoPath).trimmingCharacters(in: .whitespacesAndNewlines)
        snap.dirty = !git(["status", "--porcelain"], cwd: repoPath).trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        snap.serverRunning = portOpen(8000)

        var entries = parseManifest(repoPath: repoPath, error: &snap.loadError)
        for i in entries.indices {
            let e = entries[i]
            entries[i].updated = git(["log", "-1", "--format=%cs", "--", e.page], cwd: repoPath).trimmingCharacters(in: .whitespacesAndNewlines)
            // Archived slices are out of the working set: no staleness, no integrity noise.
            if e.archived { continue }
            if !e.basePath.isEmpty && !e.baseCommit.isEmpty {
                entries[i].staleCount = realStaleCount(repoPath: repoPath, pin: e.baseCommit, basePath: e.basePath)
            }
            if !e.isMain, let f = parseFrontMatter(repoPath: repoPath, page: e.page) {
                var mm: [String] = []
                if f.production != e.isProduction { mm.append("production flag differs") }
                if !e.baseCommit.isEmpty && !f.base.contains(e.baseCommit) { mm.append("base pin: fm lacks \(e.baseCommit)") }
                entries[i].fmMismatches = mm
                if !mm.isEmpty { snap.integrityWarnings.append("\(e.page): " + mm.joined(separator: " · ")) }
            }
        }
        snap.pages = entries
        snap.prds = parsePRDs(repoPath: repoPath)
        return snap
    }

    /// Staleness that ignores meta-only commits: a base commit counts only if it
    /// changed something OUTSIDE the PROTO front-matter block (design truth, not
    /// bookkeeping). Re-pin commits and stage/pin edits no longer flag dependents.
    nonisolated static func realStaleCount(repoPath: String, pin: String, basePath: String) -> Int {
        let list = git(["rev-list", "-n", "60", "\(pin)..HEAD", "--", basePath], cwd: repoPath)
        let shas = list.split(separator: "\n").map(String.init)
        var real = 0
        for sha in shas {
            let diff = git(["show", "--format=", sha, "--", basePath], cwd: repoPath)
            if diffHasContentChanges(diff) { real += 1 }
        }
        return real
    }

    nonisolated static func diffHasContentChanges(_ diff: String) -> Bool {
        for raw in diff.split(separator: "\n", omittingEmptySubsequences: false) {
            let line = String(raw)
            guard line.hasPrefix("+") || line.hasPrefix("-") else { continue }
            if line.hasPrefix("+++") || line.hasPrefix("---") { continue }
            let body = line.dropFirst().trimmingCharacters(in: .whitespaces)
            if body.isEmpty { continue }
            let metaPrefixes = ["<!--PROTO", "-->", "name:", "stage:", "production:", "base:", "dependsOn:"]
            if metaPrefixes.contains(where: { body.hasPrefix($0) }) { continue }
            return true
        }
        return false
    }

    // MARK: - parsers (nonisolated statics; usable from any thread)

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

    nonisolated static func parseManifest(repoPath: String, error: inout String?) -> [SliceEntry] {
        guard let dash = slurp(repoPath, "dashboard.html"),
              let block = firstMatch(dash, "const MANIFEST = \\{(.*?)\\n  \\};") else {
            error = "Could not parse MANIFEST in dashboard.html"
            return []
        }
        var out: [SliceEntry] = []
        let chunks = block.components(separatedBy: "page: \"").dropFirst()
        for chunk in chunks {
            let page = String(chunk.prefix(while: { $0 != "\"" }))
            func str(_ key: String) -> String { firstMatch(chunk, key + ":\\s*\"([^\"]*)\"") ?? "" }
            func boolean(_ key: String) -> Bool { (firstMatch(chunk, key + ":\\s*(true|false)") ?? "false") == "true" }
            var deps: [String] = []
            if let depsRaw = firstMatch(chunk, "dependsOn:\\s*\\[([^\\]]*)\\]") {
                deps = depsRaw.components(separatedBy: "\"").enumerated().filter { $0.offset % 2 == 1 }.map { $0.element }
            }
            let label = str("productionLabel")
            out.append(SliceEntry(
                page: page, pretty: str("pretty"), role: str("role"),
                isMain: boolean("isMain"), isProduction: boolean("isProduction"),
                base: str("base"), basePath: str("basePath"), baseCommit: str("baseCommit"),
                dependsOn: deps, funnel: str("funnel"),
                productionLabel: label.isEmpty ? "prod" : label,
                archived: boolean("archived"), archivedNote: str("archivedNote")
            ))
        }
        return out
    }

    nonisolated static func parseFrontMatter(repoPath: String, page: String) -> FrontMatter? {
        guard let src = slurp(repoPath, page) else { return nil }
        // front matter sits in the first ~1KB — avoid regexing megabyte-scale files
        let head = String(src.prefix(1200))
        guard let block = firstMatch(head, "<!--PROTO\\n(.*?)-->") else { return nil }
        var f = FrontMatter()
        for line in block.components(separatedBy: "\n") {
            let parts = line.split(separator: ":", maxSplits: 1).map(String.init)
            guard parts.count == 2 else { continue }
            let key = parts[0].trimmingCharacters(in: .whitespaces)
            let val = parts[1].trimmingCharacters(in: .whitespaces)
            switch key {
            case "name": f.name = val
            case "production": f.production = (val == "true")
            case "base": f.base = val
            case "dependsOn": f.dependsOn = val
            case "archived": f.archived = val
            default: break
            }
        }
        return f
    }

    // MARK: - PRD register (Roadmap/prds.md) — the ONE file Proto writes

    nonisolated static let prdsPath = "Roadmap/prds.md"
    nonisolated static let prdHeader = "| PRD | Slices | Doc | ClickUp | Notes |"
    nonisolated static let prdDivider = "|---|---|---|---|---|"

    nonisolated static func parsePRDs(repoPath: String) -> [PRDEntry] {
        guard let text = slurp(repoPath, prdsPath) else { return [] }
        var out: [PRDEntry] = []
        var inTable = false
        for raw in text.components(separatedBy: "\n") {
            let line = raw.trimmingCharacters(in: .whitespaces)
            if line.hasPrefix("| PRD ") { inTable = true; continue }
            guard inTable else { continue }
            if !line.hasPrefix("|") { inTable = false; continue }   // table ended
            if line.hasPrefix("|--") || line.hasPrefix("| ---") { continue }
            let cells = splitRow(line)
            guard cells.count >= 5, !cells[0].isEmpty else { continue }
            let slices = cells[1].components(separatedBy: ",")
                .map { $0.trimmingCharacters(in: .whitespaces).trimmingCharacters(in: CharacterSet(charactersIn: "`")) }
                .filter { !$0.isEmpty && $0 != "—" }
            out.append(PRDEntry(
                name: cells[0],
                slices: slices,
                doc: cells[2] == "—" ? "" : cells[2],
                clickup: cells[3] == "—" ? "" : cells[3],
                notes: cells[4] == "—" ? "" : cells[4]
            ))
        }
        return out
    }

    /// Split a markdown table row into its cells (drops the leading/trailing pipes).
    nonisolated static func splitRow(_ line: String) -> [String] {
        var body = line
        if body.hasPrefix("|") { body.removeFirst() }
        if body.hasSuffix("|") { body.removeLast() }
        return body.components(separatedBy: "|").map { $0.trimmingCharacters(in: .whitespaces) }
    }

    /// A pipe inside a cell would break the table; a newline would break the row.
    nonisolated static func cell(_ s: String) -> String {
        let t = s.replacingOccurrences(of: "|", with: "/")
            .replacingOccurrences(of: "\n", with: " ")
            .trimmingCharacters(in: .whitespaces)
        return t.isEmpty ? "—" : t
    }

    func prds(for page: String) -> [PRDEntry] {
        prds.filter { $0.slices.contains(page) }
    }

    /// Rewrite the table in Roadmap/prds.md, preserving every line above it.
    /// Returns nil on success, or a message to show the user.
    @discardableResult
    func savePRDs(_ list: [PRDEntry]) -> String? {
        let full = repoPath + "/" + Repo.prdsPath
        var preamble: [String]
        if let existing = Repo.slurp(repoPath, Repo.prdsPath) {
            let lines = existing.components(separatedBy: "\n")
            if let headerIdx = lines.firstIndex(where: { $0.trimmingCharacters(in: .whitespaces).hasPrefix("| PRD ") }) {
                preamble = Array(lines[..<headerIdx])
            } else {
                preamble = lines + [""]
            }
        } else {
            preamble = ["# PRDs", "",
                        "The register of product requirement docs and which slices they spec.",
                        "Proto reads and writes this file.", ""]
        }
        while let last = preamble.last, last.trimmingCharacters(in: .whitespaces).isEmpty { preamble.removeLast() }

        var lines = preamble + ["", Repo.prdHeader, Repo.prdDivider]
        for p in list {
            let slices = p.slices.isEmpty ? "—" : p.slices.joined(separator: ", ")
            lines.append("| \(Repo.cell(p.name)) | \(Repo.cell(slices)) | \(Repo.cell(p.doc)) | \(Repo.cell(p.clickup)) | \(Repo.cell(p.notes)) |")
        }
        let text = lines.joined(separator: "\n") + "\n"
        do {
            try text.write(toFile: full, atomically: true, encoding: .utf8)
        } catch {
            return "Couldn't write \(Repo.prdsPath): \(error.localizedDescription)"
        }
        prds = list
        return nil
    }

    @discardableResult
    func addPRD(name: String, slices: [String], doc: String, clickup: String, notes: String) -> String? {
        let clean = name.trimmingCharacters(in: .whitespaces)
        guard !clean.isEmpty else { return "A PRD needs a name." }
        guard !prds.contains(where: { $0.name.lowercased() == clean.lowercased() }) else {
            return "“\(clean)” is already in the register — attach it to this slice instead."
        }
        var list = prds
        list.append(PRDEntry(name: clean, slices: slices,
                             doc: doc.trimmingCharacters(in: .whitespaces),
                             clickup: clickup.trimmingCharacters(in: .whitespaces),
                             notes: notes.trimmingCharacters(in: .whitespaces)))
        return savePRDs(list)
    }

    /// Attach / detach a slice on an existing PRD.
    @discardableResult
    func setPRD(_ name: String, attached: Bool, to page: String) -> String? {
        var list = prds
        guard let i = list.firstIndex(where: { $0.name == name }) else { return "PRD not found." }
        var slices = list[i].slices.filter { $0 != page }
        if attached { slices.append(page) }
        list[i].slices = slices
        return savePRDs(list)
    }

    @discardableResult
    func removePRD(_ name: String) -> String? {
        savePRDs(prds.filter { $0.name != name })
    }

    // MARK: - instance conveniences for views (fast: file reads + single quick git calls)

    func parseFrontMatter(path: String) -> FrontMatter? {
        Repo.parseFrontMatter(repoPath: repoPath, page: path)
    }

    func changelog(for page: String) -> [ChangelogRow] {
        guard let log = Repo.slurp(repoPath, "Roadmap/CHANGELOG.md") else { return [] }
        let sections = log.components(separatedBy: "\n## ")
        guard let section = sections.first(where: { $0.contains("`\(page)`") }) else { return [] }
        var rows: [ChangelogRow] = []
        for line in section.components(separatedBy: "\n") {
            let t = line.trimmingCharacters(in: .whitespaces)
            guard t.hasPrefix("|"), !t.hasPrefix("|--"), !t.hasPrefix("| Date") else { continue }
            let cells = t.components(separatedBy: "|").map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
            guard cells.count >= 3 else { continue }
            var status = cells[2]
            if status.contains("🌐") { status = "🌐" }
            else if status.contains("🔀") { status = "🔀" }
            else if status.contains("⬜") { status = "⬜" }
            else { status = "meta" }
            rows.append(ChangelogRow(date: cells[0], text: cells[1], status: status))
        }
        return rows.reversed()
    }

    func history(for page: String) -> [HistoryEntry] {
        let out = Repo.git(["log", "--format=%h§%cs§%s", "-n", "20", "--", page], cwd: repoPath)
        return out.components(separatedBy: "\n").compactMap { line in
            let p = line.components(separatedBy: "§")
            guard p.count >= 3 else { return nil }
            return HistoryEntry(sha: p[0], date: p[1], subject: p[2])
        }
    }

    func previewURL(page: String, sha: String?) -> URL? {
        guard let sha else { return URL(string: "http://localhost:8000/" + page) }
        let tmpDir = repoPath + "/proto-tmp"
        try? FileManager.default.createDirectory(atPath: tmpDir, withIntermediateDirectories: true)
        let name = "preview-\(sha).html"
        let filePath = tmpDir + "/" + name
        if !FileManager.default.fileExists(atPath: filePath) {
            let content = Repo.git(["show", "\(sha):\(page)"], cwd: repoPath)
            guard !content.isEmpty else { return nil }
            try? content.write(toFile: filePath, atomically: true, encoding: .utf8)
        }
        return URL(string: "http://localhost:8000/proto-tmp/" + name)
    }

    // MARK: - local server

    private func spawnServer() {
        let p = Process()
        p.executableURL = URL(fileURLWithPath: "/usr/bin/python3")
        p.arguments = ["-m", "http.server", "8000"]
        p.currentDirectoryURL = URL(fileURLWithPath: repoPath)
        p.standardOutput = FileHandle.nullDevice
        p.standardError = FileHandle.nullDevice
        try? p.run()
        serverRunning = p.isRunning
    }

    // MARK: - actions

    func copyToClipboard(_ s: String) {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(s, forType: .string)
    }

    func openURL(_ s: String) {
        if let u = URL(string: s) { NSWorkspace.shared.open(u) }
    }

    func openFile(_ rel: String) {
        NSWorkspace.shared.open(URL(fileURLWithPath: repoPath + "/" + rel))
    }

    func fileExists(_ rel: String) -> Bool {
        FileManager.default.fileExists(atPath: repoPath + "/" + rel)
    }

    func markdown(_ rel: String) -> String {
        Repo.slurp(repoPath, rel) ?? "_\(rel) not found — it may not be created yet._"
    }
}
