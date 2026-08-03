import SwiftUI

struct DetailView: View {
    @EnvironmentObject var repo: Repo
    let entry: SliceEntry
    let back: () -> Void
    let toast: (String) -> Void
    @State private var rows: [ChangelogRow] = []

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Button(action: back) {
                    Text("← All slices").font(.system(size: 12.5, weight: .semibold)).foregroundColor(.accentBlue)
                }.buttonStyle(.plain)

                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 8) {
                            Text(entry.pretty).font(.system(size: 19, weight: .bold))
                            if entry.isMain { visionBadge }
                            if entry.isProduction { prodBadge }
                            if entry.isStale { staleBadge }
                        }
                        Text(entry.page).font(.system(size: 11, design: .monospaced)).foregroundColor(.inkMuted)
                    }
                    Spacer()
                    HStack(spacing: 7) {
                        Button("Local ↗") { repo.openURL(entry.localURL) }
                        Button("Netlify ↗") { repo.openURL(entry.netlifyURL) }
                        Button {
                            repo.copyToClipboard(sessionPrompt(page: entry.page, pretty: entry.pretty))
                            toast("Session prompt copied — paste into Claude Code")
                        } label: {
                            Label("Start Session", systemImage: "doc.on.doc")
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.accentBlue)
                    }
                }

                // Facts
                HStack(alignment: .top, spacing: 10) {
                    PanelBox(title: "Based on") {
                        if entry.base.isEmpty {
                            Text("—").foregroundColor(.inkMuted)
                        } else {
                            Chip(text: entry.base)
                            Text(fmBaseLine()).font(.system(size: 11)).foregroundColor(.inkMuted)
                            if entry.isStale {
                                Text("⚠ base moved: \(entry.staleCount) commit(s) since pin \(entry.baseCommit)")
                                    .font(.system(size: 11, weight: .semibold)).foregroundColor(.dangerRed)
                                Button("Copy reintegration prompt") {
                                    repo.copyToClipboard(reintegrationPrompt(page: entry.page, pretty: entry.pretty, basePath: entry.basePath, baseCommit: entry.baseCommit, count: entry.staleCount))
                                    toast("Reintegration prompt copied — paste into Claude Code")
                                }
                                .font(.system(size: 11))
                            }
                        }
                    }
                    PanelBox(title: "Depends on") {
                        if entry.dependsOn.isEmpty {
                            Text("—").foregroundColor(.inkMuted)
                            Text("nothing blocks this slice").font(.system(size: 11)).foregroundColor(.inkMuted)
                        } else {
                            ForEach(entry.dependsOn, id: \.self) { d in
                                Chip(text: repo.pages.first(where: { $0.page == d })?.pretty ?? d)
                            }
                        }
                    }
                    PanelBox(title: "Funneled to the Vision") {
                        Text(entry.funnel.isEmpty ? "—" : entry.funnel).font(.system(size: 13, weight: .semibold))
                        Text(entry.funnelOpen ? "changes await a funnel decision — say “funnel to main”" : "fully triaged")
                            .font(.system(size: 11)).foregroundColor(.inkMuted)
                    }
                }

                if !entry.fmMismatches.isEmpty {
                    PanelBox(title: "⚠ Integrity") {
                        ForEach(entry.fmMismatches, id: \.self) { m in
                            Text(m).font(.system(size: 11.5)).foregroundColor(.dangerRed)
                        }
                    }
                }

                PanelBox(title: "Changelog · from Roadmap/CHANGELOG.md") {
                    if rows.isEmpty {
                        Text("No entries for this slice yet.").font(.system(size: 12)).foregroundColor(.inkMuted)
                    } else {
                        ForEach(rows) { r in
                            HStack(alignment: .top, spacing: 8) {
                                Text(r.date).font(.system(size: 10, design: .monospaced)).foregroundColor(.inkMuted)
                                    .frame(width: 74, alignment: .leading)
                                Text((try? AttributedString(markdown: r.text, options: .init(interpretedSyntax: .inlineOnlyPreservingWhitespace))) ?? AttributedString(r.text))
                                    .font(.system(size: 12))
                                Spacer()
                                Text(r.status).font(.system(size: 11))
                                    .padding(.horizontal, 6).padding(.vertical, 1)
                                    .background(r.status == "⬜" ? Color.amberSoft : r.status == "🌐" ? Color.accentSoft : Color(hex: 0xF1F1F3))
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                            }
                            .padding(.vertical, 2)
                        }
                    }
                }

                PanelBox(title: "Records") {
                    HStack(spacing: 8) {
                        Button("Open changelog") { open("Roadmap/CHANGELOG.md") }
                        Button("Open session log") { open("session-log.md") }
                        Button("Open slice file") { open(entry.page) }
                    }
                    Text("Sessions and persona flags live in the records; the close-session ritual keeps them current.")
                        .font(.system(size: 11)).foregroundColor(.inkMuted)
                }
            }
            .padding(18)
            .frame(maxWidth: 860, alignment: .leading)
        }
        .onAppear { rows = repo.changelog(for: entry.page) }
        .onChange(of: entry.page) { _, p in rows = repo.changelog(for: p) }
    }

    func fmBaseLine() -> String {
        repo.parseFrontMatter(path: entry.page)?.base ?? "pin: \(entry.basePath) @ \(entry.baseCommit)"
    }

    func open(_ rel: String) {
        NSWorkspace.shared.open(URL(fileURLWithPath: repo.repoPath + "/" + rel))
    }
}
