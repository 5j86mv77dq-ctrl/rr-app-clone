import Foundation

struct SliceEntry: Identifiable, Equatable {
    var id: String { page }
    var page: String            // path, join key ("index.html", "slices/x.html")
    var pretty: String
    var role: String
    var stage: String           // vision | draft | in-review | in-dev | shipped | archived | planned
    var isMain: Bool
    var isProduction: Bool
    var base: String            // display name
    var basePath: String        // path of base file ("" if none)
    var baseCommit: String      // 7-char pin ("" if none)
    var dependsOn: [String]     // page paths
    var funnel: String          // "3🌐 1🔀 2⬜" or ""

    // derived
    var staleCount: Int = 0     // commits on basePath since pin (0 = fresh)
    var updated: String = ""    // last commit date for this page
    var fmMismatches: [String] = []  // front matter ⇄ MANIFEST disagreements

    var isStale: Bool { staleCount > 0 }
    var funnelOpen: Bool { funnel.contains("⬜") }
    var localURL: String { "http://localhost:8000/" + (isMain ? "" : page) }
    var netlifyURL: String { "https://relevantradio.netlify.app/" + (isMain ? "" : page) }
}

struct FrontMatter {
    var name = ""
    var stage = ""
    var production = false
    var base = ""       // full pin line
    var dependsOn = ""
}

struct ChangelogRow: Identifiable {
    let id = UUID()
    var date: String
    var text: String
    var status: String  // "🌐" | "🔀" | "⬜" | "meta" | raw
}

struct HistoryEntry: Identifiable, Hashable {
    var id: String { sha }
    var sha: String
    var date: String
    var subject: String
}

enum Screen: String, CaseIterable {
    case slices = "Slices"
    case graph = "Graph"
    case vision = "Vision"
    case manual = "User Manual"

    var icon: String {
        switch self {
        case .slices: return "list.bullet.rectangle"
        case .graph: return "point.3.connected.trianglepath.dotted"
        case .vision: return "scope"
        case .manual: return "book"
        }
    }
}

func sessionPrompt(page: String, pretty: String) -> String {
    "open session — I'm working on \(page) (\(pretty)). Recap this slice from Roadmap/CHANGELOG.md and session-log.md, confirm the target file with me before editing, then we iterate in product language. When I say \"close session\", run the full close ritual: log, funnel triage, board update, push."
}

func reintegrationPrompt(page: String, pretty: String, basePath: String, baseCommit: String, count: Int) -> String {
    "reintegration — Slice \(page) (\(pretty)) is pinned to base \(basePath) @ \(baseCommit); the base has \(count) newer commit(s). Diff old vs new base and give me a verdict (cosmetic / structural / conceptual). If structural: re-copy the current base and re-apply this slice's feature delta from its changelog. Re-pin front matter + MANIFEST in the same commit."
}
