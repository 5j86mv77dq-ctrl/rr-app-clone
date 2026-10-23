import Foundation
import Security
import AppKit

// MARK: - Keychain (ClickUp + Netlify tokens; never written to disk or the repo)

enum Keychain {
    enum Account: String { case clickup, netlify }
    static let service = "com.peteratkinson.prototype"

    static func get(_ a: Account) -> String? {
        let q: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                kSecAttrService as String: service,
                                kSecAttrAccount as String: a.rawValue,
                                kSecReturnData as String: true,
                                kSecMatchLimit as String: kSecMatchLimitOne]
        var out: AnyObject?
        guard SecItemCopyMatching(q as CFDictionary, &out) == errSecSuccess,
              let data = out as? Data, let s = String(data: data, encoding: .utf8), !s.isEmpty else { return nil }
        return s
    }

    static func set(_ a: Account, _ value: String) {
        delete(a)
        let q: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                kSecAttrService as String: service,
                                kSecAttrAccount as String: a.rawValue,
                                kSecValueData as String: Data(value.utf8)]
        SecItemAdd(q as CFDictionary, nil)
    }

    static func delete(_ a: Account) {
        let q: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                kSecAttrService as String: service,
                                kSecAttrAccount as String: a.rawValue]
        SecItemDelete(q as CFDictionary)
    }
}

struct ServiceError: LocalizedError {
    var errorDescription: String?
    init(_ s: String) { errorDescription = s }
}

// MARK: - ClickUp (GET only — Prototype never changes ClickUp)

enum ClickUp {
    static func openParentTasks(listID: String, token: String) async throws -> [WaitingTask] {
        var out: [WaitingTask] = []
        for page in 0..<5 {
            var c = URLComponents(string: "https://api.clickup.com/api/v2/list/\(listID)/task")!
            c.queryItems = [.init(name: "archived", value: "false"),
                            .init(name: "include_closed", value: "false"),
                            .init(name: "subtasks", value: "false"),
                            .init(name: "page", value: String(page))]
            var req = URLRequest(url: c.url!)
            req.httpMethod = "GET"
            req.setValue(token, forHTTPHeaderField: "Authorization")
            let (data, resp) = try await URLSession.shared.data(for: req)
            let code = (resp as? HTTPURLResponse)?.statusCode ?? 0
            guard code == 200 else {
                throw ServiceError(code == 401 ? "ClickUp rejected the token — replace it in Settings." : "ClickUp answered \(code).")
            }
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            let tasks = json?["tasks"] as? [[String: Any]] ?? []
            for t in tasks {
                // parents only: subtasks carry a non-null `parent`
                if let parent = t["parent"], !(parent is NSNull) { continue }
                guard let id = t["id"] as? String, let name = t["name"] as? String else { continue }
                let status = (t["status"] as? [String: Any])?["status"] as? String ?? ""
                out.append(WaitingTask(id: id, name: name,
                                       url: t["url"] as? String ?? "https://app.clickup.com/t/\(id)",
                                       status: status))
            }
            if (json?["last_page"] as? Bool) ?? true || tasks.isEmpty { break }
        }
        return out
    }
}

// MARK: - Netlify (deploy permalinks for versions)

enum Netlify {
    static let site = "relevantradio.netlify.app"

    struct Deploy { var commit: String; var url: String; var date: String }

    /// Ready production deploys, newest first.
    static func deploys(token: String) async throws -> [Deploy] {
        var out: [Deploy] = []
        for page in 1...3 {
            let url = URL(string: "https://api.netlify.com/api/v1/sites/\(site)/deploys?per_page=100&page=\(page)")!
            var req = URLRequest(url: url)
            req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            let (data, resp) = try await URLSession.shared.data(for: req)
            guard (resp as? HTTPURLResponse)?.statusCode == 200 else { throw ServiceError("Netlify rejected the token.") }
            let list = (try JSONSerialization.jsonObject(with: data) as? [[String: Any]]) ?? []
            for d in list {
                guard (d["state"] as? String) == "ready",
                      (d["context"] as? String ?? "production") == "production",
                      let sha = d["commit_ref"] as? String, !sha.isEmpty,
                      let link = d["deploy_ssl_url"] as? String ?? d["deploy_url"] as? String else { continue }
                out.append(Deploy(commit: sha, url: link, date: String((d["created_at"] as? String ?? "").prefix(10))))
            }
            if list.count < 100 { break }
        }
        return out
    }
}

// MARK: - Claude Code launcher

/// Opens Terminal in the repo showing the request, waits for Enter, then starts Claude Code
/// with it. The CLI has no "type it in but don't send" mode, so the Enter happens here.
enum ClaudeLauncher {
    static var binary: String? {
        ["\(NSHomeDirectory())/.local/bin/claude", "/opt/homebrew/bin/claude", "/usr/local/bin/claude"]
            .first { FileManager.default.isExecutableFile(atPath: $0) }
    }

    static func shq(_ s: String) -> String { "'" + s.replacingOccurrences(of: "'", with: "'\\''") + "'" }

    /// Returns the toast to show.
    static func launch(prompt: String, repoPath: String, title: String, open: Bool = true) -> String {
        guard let claude = binary else {
            NSPasteboard.general.clearContents()
            NSPasteboard.general.setString(prompt, forType: .string)
            if let app = NSWorkspace.shared.urlForApplication(withBundleIdentifier: "com.anthropic.claudefordesktop") {
                NSWorkspace.shared.open(app)
            }
            return "Claude Code isn't installed in Terminal — request copied; paste it into Claude."
        }
        let dir = repoPath + "/prototype-tmp/launch"
        try? FileManager.default.createDirectory(atPath: dir, withIntermediateDirectories: true)
        let stamp = String(Int(Date().timeIntervalSince1970 * 1000))
        let promptFile = "\(dir)/\(stamp).txt"
        let script = "\(dir)/\(stamp).command"
        let body = """
        #!/bin/zsh
        cd \(shq(repoPath)) || exit 1
        printf '\\e]0;%s\\a' \(shq("Prototype — " + title))
        clear
        print -P "%B%F{blue}Prototype → Claude Code%f%b"
        print "────────────────────────────────────────"
        cat \(shq(promptFile))
        print "\\n────────────────────────────────────────"
        read -r "?Press Enter to start Claude on this (Ctrl-C to cancel) "
        rm -f \(shq(script))
        exec \(shq(claude)) "$(cat \(shq(promptFile)))"
        """
        do {
            try prompt.write(toFile: promptFile, atomically: true, encoding: .utf8)
            try body.write(toFile: script, atomically: true, encoding: .utf8)
            try FileManager.default.setAttributes([.posixPermissions: 0o755], ofItemAtPath: script)
        } catch {
            return "Couldn't prepare the launch: \(error.localizedDescription)"
        }
        guard open else { return script }
        let p = Process()
        p.executableURL = URL(fileURLWithPath: "/usr/bin/open")
        p.arguments = ["-a", "Terminal", script]
        try? p.run()
        return "Opened Claude Code in Terminal — press Enter there."
    }
}
