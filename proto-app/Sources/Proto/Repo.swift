import Foundation
import AppKit

@MainActor
final class Repo: ObservableObject {
    @Published var pages: [SliceEntry] = []
    @Published var branch = ""
    @Published var dirty = false
    @Published var lastRefreshed: Date? = nil
    @Published var loadError: String? = nil
    @Published var integrityWarnings: [String] = []
    @Published var serverRunning = false

    var repoPath: String {
        get { UserDefaults.standard.string(forKey: "repoPath") ?? "\(NSHomeDirectory())/Documents/AI/RR App Clone" }
        set { UserDefaults.standard.set(newValue, forKey: "repoPath"); refresh() }
    }

    // MARK: - shell

    @discardableResult
    func run(_ launchPath: String, _ args: [String], cwd: String? = nil) -> String {
        let p = Process()
        p.executableURL = URL(fileURLWithPath: launchPath)
        p.arguments = args
        p.currentDirectoryURL = URL(fileURLWithPath: cwd ?? repoPath)
        let pipe = Pipe()
        p.standardOutput = pipe
        p.standardError = Pipe()
        do { try p.run() } catch { return "" }
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        p.waitUntilExit()
        return String(data: data, encoding: .utf8) ?? ""
    }

    func git(_ args: [String]) -> String { run("/usr/bin/git", args) }

    // MARK: - refresh

    func refresh() {
        loadError = nil
        integrityWarnings = []
        let fm = FileManager.default
        guard fm.fileExists(atPath: repoPath + "/dashboard.html") else {
            loadError = "No dashboard.html at \(repoPath) — pick the repo folder in Settings (⚙)."
            pages = []
            return
        }
        branch = git(["rev-parse", "--abbrev-ref", "HEAD"]).trimmingCharacters(in: .whitespacesAndNewlines)
        dirty = !git(["status", "--porcelain"]).trimmingCharacters(in: .whitespacesAndNewlines).isEmpty

        var entries = parseManifest()
        for i in entries.indices {
            let e = entries[i]
            entries[i].updated = git(["log", "-1", "--format=%cs", "--", e.page]).trimmingCharacters(in: .whitespacesAndNewlines)
            if !e.basePath.isEmpty && !e.baseCommit.isEmpty {
                let out = git(["rev-list", "--count", "\(e.baseCommit)..HEAD", "--", e.basePath])
                entries[i].staleCount = Int(out.trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
            }
            // integrity: front matter ⇄ MANIFEST
            if !e.isMain, let f = parseFrontMatter(path: e.page) {
                var mm: [String] = []
                if f.stage != e.stage { mm.append("stage: fm '\(f.stage)' ≠ MANIFEST '\(e.stage)'") }
                if f.production != e.isProduction { mm.append("production flag differs") }
                if !e.baseCommit.isEmpty && !f.base.contains(e.baseCommit) { mm.append("base pin: fm '\(f.base.prefix(40))…' lacks \(e.baseCommit)") }
                entries[i].fmMismatches = mm
                if !mm.isEmpty { integrityWarnings.append("\(e.page): " + mm.joined(separator: " · ")) }
            }
        }
        pages = entries
        lastRefreshed = Date()
        ensureServer()
    }

    // MARK: - parsers

    private func slurp(_ rel: String) -> String? {
        try? String(contentsOfFile: repoPath + "/" + rel, encoding: .utf8)
    }

    private func firstMatch(_ text: String, _ pattern: String) -> String? {
        guard let re = try? NSRegularExpression(pattern: pattern, options: [.dotMatchesLineSeparators]) else { return nil }
        let r = NSRange(text.startIndex..., in: text)
        guard let m = re.firstMatch(in: text, range: r), m.numberOfRanges > 1,
              let g = Range(m.range(at: 1), in: text) else { return nil }
        return String(text[g])
    }

    func parseManifest() -> [SliceEntry] {
        guard let dash = slurp("dashboard.html"),
              let block = firstMatch(dash, "const MANIFEST = \\{(.*?)\\n  \\};") else {
            loadError = "Could not parse MANIFEST in dashboard.html"
            return []
        }
        var out: [SliceEntry] = []
        // split into entry chunks on `page:` occurrences
        let chunks = block.components(separatedBy: "page: \"").dropFirst()
        for chunk in chunks {
            let page = String(chunk.prefix(while: { $0 != "\"" }))
            func str(_ key: String) -> String {
                firstMatch(chunk, key + ":\\s*\"([^\"]*)\"") ?? ""
            }
            func boolean(_ key: String) -> Bool {
                (firstMatch(chunk, key + ":\\s*(true|false)") ?? "false") == "true"
            }
            var deps: [String] = []
            if let depsRaw = firstMatch(chunk, "dependsOn:\\s*\\[([^\\]]*)\\]") {
                deps = depsRaw.components(separatedBy: "\"").enumerated()
                    .filter { $0.offset % 2 == 1 }.map { $0.element }
            }
            out.append(SliceEntry(
                page: page,
                pretty: str("pretty"),
                role: str("role"),
                stage: str("stage"),
                isMain: boolean("isMain"),
                isProduction: boolean("isProduction"),
                base: str("base"),
                basePath: str("basePath"),
                baseCommit: str("baseCommit"),
                dependsOn: deps,
                funnel: str("funnel")
            ))
        }
        return out
    }

    func parseFrontMatter(path: String) -> FrontMatter? {
        guard let src = slurp(path) else { return nil }
        guard let block = firstMatch(src, "<!--PROTO\\n(.*?)-->") else { return nil }
        var f = FrontMatter()
        for line in block.components(separatedBy: "\n") {
            let parts = line.split(separator: ":", maxSplits: 1).map(String.init)
            guard parts.count == 2 else { continue }
            let key = parts[0].trimmingCharacters(in: .whitespaces)
            let val = parts[1].trimmingCharacters(in: .whitespaces)
            switch key {
            case "name": f.name = val
            case "stage": f.stage = val
            case "production": f.production = (val == "true")
            case "base": f.base = val
            case "dependsOn": f.dependsOn = val
            default: break
            }
        }
        return f
    }

    func changelog(for page: String) -> [ChangelogRow] {
        guard let log = slurp("Roadmap/CHANGELOG.md") else { return [] }
        // section heading contains `page` in backticks
        let sections = log.components(separatedBy: "\n## ")
        guard let section = sections.first(where: { $0.hasPrefix("`\(page)`") || $0.contains("`\(page)`") && $0.prefix(120).contains(page) }) else { return [] }
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
        return rows.reversed() // newest first
    }

    // MARK: - history / preview

    func history(for page: String) -> [HistoryEntry] {
        let out = git(["log", "--format=%h§%cs§%s", "-n", "20", "--", page])
        return out.components(separatedBy: "\n").compactMap { line in
            let p = line.components(separatedBy: "§")
            guard p.count >= 3 else { return nil }
            return HistoryEntry(sha: p[0], date: p[1], subject: p[2])
        }
    }

    /// Renders a historical version through the local server (assets stay root-relative).
    func previewURL(page: String, sha: String?) -> URL? {
        guard let sha else { return URL(string: "http://localhost:8000/" + page) }
        let tmpDir = repoPath + "/proto-tmp"
        try? FileManager.default.createDirectory(atPath: tmpDir, withIntermediateDirectories: true)
        let content = git(["show", "\(sha):\(page)"])
        guard !content.isEmpty else { return nil }
        let name = "preview-\(sha).html"
        try? content.write(toFile: tmpDir + "/" + name, atomically: true, encoding: .utf8)
        return URL(string: "http://localhost:8000/proto-tmp/" + name)
    }

    // MARK: - local server

    func ensureServer() {
        let check = run("/usr/sbin/lsof", ["-nP", "-iTCP:8000", "-sTCP:LISTEN"])
        if !check.isEmpty { serverRunning = true; return }
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

    func markdown(_ rel: String) -> String {
        slurp(rel) ?? "_\(rel) not found — it may not be created yet._"
    }
}
