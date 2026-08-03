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
    case tasks = "Tasks"

    var icon: String {
        switch self {
        case .slices: return "list.bullet.rectangle"
        case .graph: return "point.3.connected.trianglepath.dotted"
        case .vision: return "scope"
        case .manual: return "book"
        case .tasks: return "checklist"
        }
    }
}

struct SetupTask: Identifiable {
    let id: String
    let title: String
    let detail: String
}

let SETUP_TASKS: [(section: String, tasks: [SetupTask])] = [
    ("Get running (today)", [
        SetupTask(id: "s1", title: "Grant Documents access",
                  detail: "The macOS prompt at first launch — Proto reads the repo from ~/Documents. If you clicked Don't Allow: System Settings → Privacy & Security → Files & Folders → Proto."),
        SetupTask(id: "s2", title: "Put Proto where you'll find it",
                  detail: "Drag Proto.app to /Applications or keep it in the Dock. Rebuild anytime with scripts/build-proto.sh (~10s)."),
        SetupTask(id: "s3", title: "Approve vision.md",
                  detail: "It's marked DRAFT. Read it in the Vision tab, then tell Claude “vision.md approved” — or “Edit deliberately…” with your changes."),
        SetupTask(id: "s4", title: "Run the loop once, end to end",
                  detail: "⧉ on Video On Demand → paste into Claude Code → make one small change → say “close session”. Proves the whole ritual works from this app.")
    ]),
    ("First week", [
        SetupTask(id: "f1", title: "Scope-trim Video On Demand",
                  detail: "It's a Vision copy by exception and owes a trim before leaving draft: strip anything that's neither in production nor in VOD scope."),
        SetupTask(id: "f2", title: "Hand Claude your persona documents",
                  detail: "Point Claude at the files; they get imported to personas/ and the Persona Pass switches on at session close (roadmap M4)."),
        SetupTask(id: "f3", title: "Send VOD to Father Rocky",
                  detail: "Share the Netlify URL yourself, then tell Claude “Father Rocky has VOD” — status flips to in review."),
        SetupTask(id: "f4", title: "Freeze + hand off VOD",
                  detail: "When approved: “dev team started VOD”. Claude drafts the gap note; the URL + gap note go to Brian's team as a question, never an order.")
    ]),
    ("Housekeeping", [
        SetupTask(id: "h1", title: "Re-share the new slice URLs with the team",
                  detail: "Old branch URLs are frozen. The team uses relevantradio.netlify.app/slices/… and the dashboard as the front door."),
        SetupTask(id: "h2", title: "Delete the frozen prd/ branches (after Aug 15)",
                  detail: "Tell Claude “delete the frozen branches” — the grace period for old shared URLs ends ~2026-08-15."),
        SetupTask(id: "h3", title: "Decide on the ClickUp mirror",
                  detail: "Optional: a read-only Prototype Slices list Claude syncs at close-session so the dev team can comment where they already work.")
    ])
]

func sessionPrompt(page: String, pretty: String) -> String {
    "open session — I'm working on \(page) (\(pretty)). Recap this slice from Roadmap/CHANGELOG.md and session-log.md, confirm the target file with me before editing, then we iterate in product language. When I say \"close session\", run the full close ritual: log, funnel triage, board update, push."
}

func reintegrationPrompt(page: String, pretty: String, basePath: String, baseCommit: String, count: Int) -> String {
    "reintegration — Slice \(page) (\(pretty)) is pinned to base \(basePath) @ \(baseCommit); the base has \(count) newer commit(s). Diff old vs new base and give me a verdict (cosmetic / structural / conceptual). If structural: re-copy the current base and re-apply this slice's feature delta from its changelog. Re-pin front matter + MANIFEST in the same commit."
}
