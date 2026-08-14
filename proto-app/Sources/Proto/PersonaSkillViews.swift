import SwiftUI

// MARK: - Personas — audience personas (Relevant Radio listeners), read from personas/

struct PersonasView: View {
    @EnvironmentObject var repo: Repo
    let toast: (String) -> Void
    @State private var personas: [PersonaEntry] = []

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                HStack(alignment: .firstTextBaseline) {
                    Text("Personas").font(.system(size: 18, weight: .bold))
                    if !personas.isEmpty {
                        Text("\(personas.count) imported").font(.system(size: 12)).foregroundColor(.inkMuted)
                    }
                    Spacer()
                }

                if personas.isEmpty { emptyState } else {
                    ForEach(personas) { p in
                        PanelBox(title: p.name) {
                            MarkdownLite(text: p.body)
                            Text(p.path).font(.system(size: 10, design: .monospaced)).foregroundColor(.inkMuted)
                        }
                    }
                }
            }
            .padding(18)
            .frame(maxWidth: 860, alignment: .leading)
        }
        .onAppear { personas = Repo.loadPersonas(repoPath: repo.repoPath) }
        .onChange(of: repo.lastRefreshed) { _, _ in
            personas = Repo.loadPersonas(repoPath: repo.repoPath)
        }
    }

    /// Not "coming soon" — what this becomes, and the one action that starts it.
    var emptyState: some View {
        VStack(alignment: .leading, spacing: 14) {
            PanelBox(title: "What this becomes") {
                Text("The audience personas — Relevant Radio listeners — that the prototype is designed for. Not coworkers, not contacts.")
                    .font(.system(size: 12.5))
                Text("Once imported, they switch on the **Persona Pass** at close session: Claude walks the flows changed that session as each persona and reports where they'd hit friction. It's a design lint, not user research — beta data outranks it.")
                    .font(.system(size: 12.5))
                Text("Gated on you providing the documents (roadmap M4, Roadmap/proto-prd.md §9).")
                    .font(.system(size: 11)).foregroundColor(.inkMuted)
            }

            PanelBox(title: "Start the import") {
                Text("Hand Claude the persona documents, then paste this:")
                    .font(.system(size: 12)).foregroundColor(.inkMuted)
                Text(PERSONA_IMPORT_PROMPT)
                    .font(.system(size: 11.5, design: .monospaced))
                    .padding(11)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(hex: 0x20242A))
                    .foregroundColor(Color(hex: 0xD7E3F0))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                Button("Copy the import prompt") {
                    repo.copyToClipboard(PERSONA_IMPORT_PROMPT)
                    toast("Import prompt copied — attach your persona docs and paste into Claude Code")
                }
                .buttonStyle(.borderedProminent).tint(.accentBlue)
            }

            Text("Claude imports one markdown file per persona into personas/, with the persona's name as the H1. Proto reads that folder — it never writes it.")
                .font(.system(size: 11)).foregroundColor(.inkMuted)
        }
    }
}

// MARK: - Skills — the procedures that actually fire, read from .claude/skills/

struct SkillsView: View {
    @EnvironmentObject var repo: Repo
    let toast: (String) -> Void
    @State private var skills: [SkillEntry] = []
    @State private var selected: SkillEntry? = nil

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                if let s = selected { detail(s) } else { list }
            }
            .padding(18)
            .frame(maxWidth: 860, alignment: .leading)
        }
        .onAppear { load() }
        .onChange(of: repo.lastRefreshed) { _, _ in load() }
    }

    func load() {
        skills = Repo.loadSkills(repoPath: repo.repoPath)
        if let s = selected { selected = skills.first(where: { $0.slug == s.slug }) }
    }

    var list: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Skills").font(.system(size: 18, weight: .bold))
            Text("Say the phrase and Claude runs the procedure. Click one to read exactly what fires.")
                .font(.system(size: 12)).foregroundColor(.inkMuted)

            if skills.isEmpty {
                PanelBox(title: "None found") {
                    Text("No skills in .claude/skills/. Each one is a folder with a SKILL.md inside.")
                        .font(.system(size: 12)).foregroundColor(.inkMuted)
                }
            } else {
                VStack(spacing: 0) {
                    ForEach(skills) { s in
                        Button { selected = s } label: {
                            HStack(alignment: .top, spacing: 12) {
                                Text(s.trigger)
                                    .font(.system(size: 11.5, weight: .semibold, design: .monospaced))
                                    .foregroundColor(Color(hex: 0x2C567E))
                                    .padding(.horizontal, 8).padding(.vertical, 2)
                                    .background(Color(hex: 0xEEF3F8))
                                    .clipShape(RoundedRectangle(cornerRadius: 6))
                                    .frame(width: 190, alignment: .leading)
                                Text(oneLine(s.about))
                                    .font(.system(size: 12))
                                    .foregroundColor(.primary)
                                    .multilineTextAlignment(.leading)
                                    .fixedSize(horizontal: false, vertical: true)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 9, weight: .bold)).foregroundColor(.inkMuted)
                            }
                            .padding(.horizontal, 14).padding(.vertical, 10)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        if s.id != skills.last?.id { Divider() }
                    }
                }
                .background(Color(nsColor: .textBackgroundColor))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black.opacity(0.08), lineWidth: 1))
            }
        }
    }

    func detail(_ s: SkillEntry) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Button { selected = nil } label: {
                Text("← All skills").font(.system(size: 12.5, weight: .semibold)).foregroundColor(.accentBlue)
            }.buttonStyle(.plain)

            HStack(alignment: .firstTextBaseline) {
                Text(s.name).font(.system(size: 19, weight: .bold))
                Spacer()
                Button("Copy") {
                    repo.copyToClipboard(s.body)
                    toast("Skill text copied")
                }
            }
            Text(s.path).font(.system(size: 10.5, design: .monospaced)).foregroundColor(.inkMuted)

            PanelBox(title: "Fires when") {
                Text(s.about).font(.system(size: 12)).fixedSize(horizontal: false, vertical: true)
            }

            PanelBox(title: "What runs") {
                MarkdownLite(text: s.body)
            }
        }
    }

    /// Descriptions carry a "Use when…" clause for matching; the list only needs the claim.
    func oneLine(_ s: String) -> String {
        for marker in [" Use when", " Use it when", " Asks the scope"] {
            if let r = s.range(of: marker) { return String(s[..<r.lowerBound]) }
        }
        return s
    }
}
