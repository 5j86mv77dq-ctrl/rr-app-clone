import SwiftUI

/// The North Star tab (called "Vision" until 2026-08-14 — it collided with *the Vision*,
/// index.html). Content unchanged: vision.md + decisions.md.
struct NorthStarView: View {
    @EnvironmentObject var repo: Repo
    let toast: (String) -> Void
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                PanelBox(title: "vision.md · the tie-breaker") {
                    MarkdownLite(text: repo.markdown("vision.md"))
                    Button("Edit deliberately…") {
                        repo.copyToClipboard("open session — deliberate edit to vision.md. Discuss the change with me, apply it, and log the reasoning in decisions.md.")
                        toast("vision.md edit prompt copied — paste into Claude Code")
                    }
                    .padding(.top, 6)
                }
                PanelBox(title: "decisions.md · why the vision moved (or didn't)") {
                    MarkdownLite(text: repo.markdown("decisions.md"))
                }
            }
            .padding(18)
            .frame(maxWidth: 860, alignment: .leading)
        }
    }
}

struct ManualView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Text("User Manual").font(.system(size: 18, weight: .bold))
                Text("Work done outside the ritual is not recorded: the changelog, the staleness pins, and this board go wrong silently. Four steps, every time.")
                    .font(.system(size: 12)).foregroundColor(.inkMuted)

                HStack(alignment: .top, spacing: 10) {
                    step(1, "Pick a slice", "From the Slices board. Check its status and base first. New idea → “New slice: <idea>” instead.")
                    step(2, "Open the session", "Click into the slice, hit ⧉ Start Session — it copies /open-session <page>. Paste into Claude Code.")
                    step(3, "Iterate", "Product language only. Review on local (instant) or Netlify (~30s after push).")
                    step(4, "Close the session", "Say “close session” — log, funnel triage, board update, push. Skipping this is what breaks the system.")
                }

                PanelBox(title: "Commands") {
                    Text("Every command is a skill — see the **Skills** tab for the trigger phrase and the full procedure that runs. ⧉ on any slice copies `/open-session <page>`.")
                        .font(.system(size: 12.5))
                }

                PanelBox(title: "Tracking — what lives where") {
                    Text("Workflow status (in review, in dev, shipped…) lives in ClickUp — Proto deliberately does not track it. The repo carries only technical truth:")
                        .font(.system(size: 12))
                    legend(prodBadge("beta"), "The designation, when the mirror of the real app is in beta — in the real app, not shipped to everyone.")
                    legend(prodBadge("prod"), "The same designation once it ships. One slice at a time; default base for one-offs. Moves when you tell Claude “X is now production.”")
                    legend(staleBadge, "Computed from git: the base file changed since this slice's pin. Ask Claude to assess (cosmetic / structural / conceptual).")
                    legend(archivedBadge, "No longer a live workspace — shipped and done, merged into another slice, or abandoned. One state; the note says why. Collapsed at the bottom of the Slices board; never stale.")
                    legend(visionBadge, "The Vision (index.html) — the end-state page; never a slice.")
                }

                PanelBox(title: "PRDs") {
                    bullet("Name, ClickUp link, slice. Edit the rows in place; Proto saves as you go and close session commits.")
                }

                PanelBox(title: "Rules") {
                    bullet("One git branch (main). Claude runs all git.")
                    bullet("Every page is render-verified before push. Broken = one revert (~30s).")
                    bullet("in dev and later = frozen. No edits without explicit OK.")
                    bullet("Never stack more than 3 unshipped slices deep in a dependency line.")
                    bullet("Canon: Roadmap/proto-prd.md · records: CLAUDE.md, Roadmap/CHANGELOG.md, session-log.md, decisions.md.")
                }

                PanelBox(title: "Slice front matter") {
                    Text("Every slice file opens with this block — the per-file record. Proto and the dashboard read it; the rituals keep it current; the dashboard MANIFEST is its index (same commit).")
                        .font(.system(size: 12)).foregroundColor(Color(hex: 0x444444))
                    Text("""
<!--PROTO
name: Video On Demand
production: false
base: index.html @ 5d6b62c (2026-08-03)
dependsOn: none
-->
""")
                    .font(.system(size: 11, design: .monospaced))
                    .padding(10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(hex: 0x20242A))
                    .foregroundColor(Color(hex: 0xD7E3F0))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
            .padding(18)
            .frame(maxWidth: 860, alignment: .leading)
        }
    }

    func step(_ n: Int, _ title: String, _ body: String) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("\(n)").font(.system(size: 11, weight: .bold)).foregroundColor(.white)
                .frame(width: 18, height: 18).background(Color.accentBlue).clipShape(Circle())
            Text(title).font(.system(size: 12.5, weight: .bold))
            Text(body).font(.system(size: 11)).foregroundColor(.inkMuted)
        }
        .padding(11)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .background(Color(nsColor: .textBackgroundColor))
        .clipShape(RoundedRectangle(cornerRadius: 9))
        .overlay(RoundedRectangle(cornerRadius: 9).stroke(Color.black.opacity(0.08), lineWidth: 1))
    }

    func legend(_ b: Badge, _ v: String) -> some View {
        HStack(alignment: .top, spacing: 10) { b; Text(v).font(.system(size: 12)) }
    }

    func bullet(_ s: String) -> some View {
        HStack(alignment: .top, spacing: 6) { Text("•"); Text(s).font(.system(size: 12)) }
    }
}

struct SettingsSheet: View {
    @EnvironmentObject var repo: Repo
    @Environment(\.dismiss) var dismiss
    let toast: (String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Settings").font(.system(size: 15, weight: .bold))
            Text("Proto derives everything from the repo — these are the only knobs.")
                .font(.system(size: 11.5)).foregroundColor(.inkMuted)
            Divider()
            row("Repo folder") {
                Text(repo.repoPath).font(.system(size: 11, design: .monospaced)).lineLimit(1).truncationMode(.middle)
                Button("Choose…") {
                    let p = NSOpenPanel()
                    p.canChooseDirectories = true; p.canChooseFiles = false
                    if p.runModal() == .OK, let u = p.url { repo.repoPath = u.path }
                }
            }
            row("Branch") { Text("\(repo.branch)\(repo.dirty ? " · uncommitted changes" : " · clean")").font(.system(size: 12, design: .monospaced)) }
            row("Local server") { Text(repo.serverRunning ? "localhost:8000 running" : "not running").font(.system(size: 12)) }
            row("Stores") { Text("Nothing — the repo is the database").font(.system(size: 12)) }
            Divider()
            HStack {
                Button("↻ Refresh from repo") { repo.refresh(); toast("Re-read front matter, MANIFEST, changelog, git") }
                Spacer()
                Button("Done") { dismiss() }.buttonStyle(.borderedProminent).tint(.accentBlue)
            }
        }
        .padding(20)
        .frame(width: 560)
    }

    func row(_ k: String, @ViewBuilder _ v: () -> some View) -> some View {
        HStack(alignment: .firstTextBaseline) {
            Text(k).font(.system(size: 12)).foregroundColor(.inkMuted).frame(width: 100, alignment: .leading)
            v()
            Spacer()
        }
    }
}
