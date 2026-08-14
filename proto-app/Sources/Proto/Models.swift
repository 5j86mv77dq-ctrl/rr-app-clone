import Foundation

struct SliceEntry: Identifiable, Equatable {
    var id: String { page }
    var page: String            // path, join key ("index.html", "slices/x.html")
    var pretty: String
    var role: String
    var isMain: Bool
    var isProduction: Bool
    var base: String            // display name
    var basePath: String        // path of base file ("" if none)
    var baseCommit: String      // 7-char pin ("" if none)
    var dependsOn: [String]     // page paths
    var funnel: String          // "3🌐 1🔀 2⬜" or ""
    var productionLabel: String = "prod"   // what the designation is CALLED: "beta" | "prod"
    var archived: Bool = false  // no longer a live workspace (shipped / merged / abandoned)
    var archivedNote: String = ""          // one line: why, with the date

    // derived
    var staleCount: Int = 0     // commits on basePath since pin (0 = fresh)
    var updated: String = ""    // last commit date for this page
    var fmMismatches: [String] = []  // front matter ⇄ MANIFEST disagreements

    /// Archived slices are never stale — nobody is going to work on them again.
    var isStale: Bool { !archived && staleCount > 0 }
    var funnelOpen: Bool { funnel.contains("⬜") }
    var localURL: String { "http://localhost:8000/" + (isMain ? "" : page) }
    var netlifyURL: String { "https://relevantradio.netlify.app/" + (isMain ? "" : page) }
}

struct FrontMatter {
    var name = ""
    var production = false
    var base = ""       // full pin line
    var dependsOn = ""
    var archived = ""   // "" = live; otherwise the one-line why-and-when
}

/// A row of Roadmap/prds.md: name · ClickUp link · the slice it specs.
/// A slice carries several PRDs; a PRD specs one slice (the field is a list only
/// because the file format is, and it costs nothing to keep).
struct PRDEntry: Identifiable, Equatable {
    var id: String { name }
    var name: String
    var clickup: String     // URL ("" if none)
    var slices: [String]    // page paths

    var slice: String { slices.first ?? "" }
    var hasClickUp: Bool { clickup.hasPrefix("http") }
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

/// Sidebar order is the declaration order. "North Star" was "Vision" until 2026-08-14 —
/// the label collided with *the Vision* (index.html, the end-state page) badly enough to be
/// misread as a duplicate slice. vision.md calls itself the North Star in its own H1.
enum Screen: String, CaseIterable {
    case northStar = "North Star"
    case slices = "Slices"
    case prds = "PRDs"
    case personas = "Personas"
    case skills = "Skills"
    case manual = "User Manual"

    var icon: String {
        switch self {
        case .northStar: return "location.north.circle"
        case .slices: return "list.bullet.rectangle"
        case .prds: return "doc.text"
        case .personas: return "person.2"
        case .skills: return "wand.and.stars"
        case .manual: return "book"
        }
    }
}

/// One `.claude/skills/<name>/SKILL.md`. Front matter gives the name and the description
/// that decides whether the skill fires; `body` is the procedure that actually runs.
struct SkillEntry: Identifiable, Equatable {
    var id: String { slug }
    var slug: String        // directory name
    var name: String        // front matter `name:`
    var about: String       // front matter `description:`
    var body: String        // everything after the front matter
    var path: String        // repo-relative

    /// The phrase Peter would say. Skill descriptions end with a "Use when…" clause;
    /// the first quoted phrase in it is the canonical trigger.
    var trigger: String {
        guard let q = about.range(of: "\"") else { return "/" + slug }
        let rest = about[q.upperBound...]
        guard let close = rest.range(of: "\"") else { return "/" + slug }
        return String(rest[..<close.lowerBound])
    }
}

struct PersonaEntry: Identifiable, Equatable {
    var id: String { path }
    var path: String
    var name: String
    var body: String
}

/// The phrase that starts the persona import (Personas is gated on Peter providing the
/// documents — proto-prd.md §9 M4). Copyable, the way the session prompt is.
let PERSONA_IMPORT_PROMPT = "Import my persona documents — here are the audience personas for the Relevant Radio app. Read them, import them to personas/ as one markdown file each with the persona's name as the H1, and from now on run the Persona Pass at close session: walk the flows we changed as each persona and report where they'd hit friction. It's a design lint, not user research — beta data outranks it."

/// The ⧉ button. A slash command invokes the open-session skill deterministically instead
/// of hoping a prose paragraph matches its description; the skill body carries the recap,
/// the page table and the confirm-before-editing gate. (Tasks tab retired 2026-08-14 — its
/// live items went to ClickUp, decisions.md and the Personas tab.)
func sessionPrompt(page: String, pretty: String) -> String {
    "/open-session \(page)"
}

func reintegrationPrompt(page: String, pretty: String, basePath: String, baseCommit: String, count: Int) -> String {
    "reintegration — Slice \(page) (\(pretty)) is pinned to base \(basePath) @ \(baseCommit); the base has \(count) newer commit(s). Diff old vs new base and give me a verdict (cosmetic / structural / conceptual). If structural: re-copy the current base and re-apply this slice's feature delta from its changelog. Re-pin front matter + MANIFEST in the same commit."
}
