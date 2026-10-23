import Foundation

/// Where a design is in its life. Written by Prototype at Start and by Claude afterwards
/// (the `prototype` skill owns the transitions). Raw values are the `prototype.json` contract.
enum Stage: String, Codable, CaseIterable {
    case looks          // 3 static looks being made / waiting for a pick
    case building       // a slice being built and iterated
    case testing        // a clean tester copy exists and is frozen
    case kept           // ported into the Vision
    case shipped        // copied into the Current app
    case archived

    var label: String {
        switch self {
        case .looks: return "3 looks"
        case .building: return "Building"
        case .testing: return "With testers"
        case .kept: return "Kept"
        case .shipped: return "Shipped"
        case .archived: return "Archived"
        }
    }
}

/// One design: a ClickUp item turned into a slice. Lives in `prototype.json` at the repo
/// root — a file only Prototype and Claude write, so Proto's MANIFEST and front matter
/// stay exactly as they were.
struct Design: Codable, Identifiable, Equatable {
    var id: String                  // kebab slug, also the slice filename
    var name: String
    var request: String             // the one sentence
    var start: String               // "looks" | "build"
    var clickupTaskId: String?
    var clickupURL: String?
    var page: String                // slices/<id>.html (may not exist until Claude's first push)
    var stage: Stage
    var frozen: String?             // nil | "testers" | "dev"
    var baseCommit: String?         // Current app commit this design last caught up to
    var looks: [String]?            // looks/<id>/a.html, b.html, c.html
    var pickedLook: String?
    var testerPage: String?
    var created: String

    var isFrozen: Bool { frozen == "testers" || frozen == "dev" }
    var startsWithLooks: Bool { start == "looks" }
}

struct DesignFile: Codable {
    var about: String = "Prototype's record of every design. Written by Prototype.app and by Claude (the `prototype` skill). Proto ignores it."
    var designs: [Design] = []
}

/// An open parent task in ClickUp's App › App Development › Design list.
struct WaitingTask: Identifiable, Equatable {
    var id: String
    var name: String
    var url: String
    var status: String
}

/// One push of a design, matched to the Netlify deploy that published it.
struct Version: Identifiable, Equatable {
    var id: String { sha }
    var sha: String
    var date: String
    var subject: String
    var url: String?        // deploy permalink for the page; nil when no deploy matched
}

/// A row in a design's changelog section, as the checklist sees it.
struct ChecklistRow: Identifiable, Equatable {
    enum State { case ported, queued, sliceOnly, pending }
    var id: String { line }
    var line: String        // the exact source line — the write-back anchor
    var date: String
    var text: String
    var state: State
}

/// Something with a page and a public link: the reference cards and every design.
struct LinkTarget {
    var page: String
    var name: String
    var netlifyURL: String { "https://relevantradio.netlify.app/" + (page == "index.html" ? "" : page) }
    var localURL: String { "http://localhost:8000/" + (page == "index.html" ? "" : page) }
}

extension Design {
    var link: LinkTarget { LinkTarget(page: page, name: name) }
}

/// Lowercase, hyphenated, filesystem- and URL-safe.
func slugify(_ s: String) -> String {
    let lowered = s.lowercased()
    var out = ""
    var lastHyphen = true
    for ch in lowered {
        if ch.isLetter || ch.isNumber, ch.isASCII {
            out.append(ch); lastHyphen = false
        } else if !lastHyphen {
            out.append("-"); lastHyphen = true
        }
    }
    while out.hasSuffix("-") { out.removeLast() }
    return out.isEmpty ? "design" : String(out.prefix(48))
}

// MARK: - prompts (each starts with /prototype so the skill fires deterministically)

enum Prompt {
    static func start(_ d: Design) -> String {
        var lines = ["/prototype start \(d.id)",
                     "",
                     "Request: \(d.request)",
                     "How to start: " + (d.startsWithLooks ? "Show me 3 looks first" : "Build it in the app now")]
        if let u = d.clickupURL { lines.append("ClickUp task: \(u)") }
        return lines.joined(separator: "\n")
    }
    static func pick(_ d: Design, look: String) -> String { "/prototype pick \(d.id) \(look)" }
    static func work(_ d: Design) -> String { "/prototype work \(d.id)" }
    static func testers(_ d: Design) -> String { "/prototype testers \(d.id)" }
    static func keep(_ d: Design) -> String { "/prototype keep \(d.id)" }
    static func shipped(_ d: Design) -> String { "/prototype shipped \(d.id)" }
}
