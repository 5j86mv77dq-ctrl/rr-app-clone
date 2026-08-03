import SwiftUI

struct VisionView: View {
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
                    step(2, "Open the session", "Click into the slice, hit ⧉ Start Session (copies the prompt), paste into Claude Code.")
                    step(3, "Iterate", "Product language only. Review on local (instant) or Netlify (~30s after push).")
                    step(4, "Close the session", "Say “close session” — log, funnel triage, board update, push. Skipping this is what breaks the system.")
                }

                PanelBox(title: "Commands") {
                    cmd("⧉ on any slice", "copies its session prompt; paste into Claude Code.")
                    cmd("open session", "recap; pick a page.")
                    cmd("Plain English", "“make the prayer card bigger.” Edited, render-verified, pushed.")
                    cmd("New slice: <idea>", "one-off (off current production) or a piece of a bigger feature; created as draft.")
                    cmd("Chop up <big feature>", "define the pieces together (MVP first); only the MVP gets built now.")
                    cmd("funnel to main", "port pending slice changes into the Vision.")
                    cmd("serve local", "start the local preview server (localhost:8000) — Proto also starts it automatically.")
                    cmd("close session", "log, triage changelog, update the board, push.")
                    cmd("Announcements", "“Father Rocky has X” → in review · “dev team started X” → in dev · “X shipped” → shipped · “X is now production” → moves the green tag · “retire X” → archived.")
                }

                PanelBox(title: "Statuses") {
                    legend(prodBadge, "A designation, not a stage. One slice at a time — the mirror of the real app. Default base for one-offs.")
                    legend(stageBadge("draft"), "Being built. Edit freely.")
                    legend(stageBadge("in-review"), "With Father Rocky. Light edits only.")
                    legend(stageBadge("in-dev"), "With the dev team. Frozen spec — no edits without explicit OK.")
                    legend(stageBadge("shipped"), "Live in the real app.")
                    legend(staleBadge, "Computed from git: the base file changed since this slice's pin. Ask Claude to assess (cosmetic / structural / conceptual).")
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
stage: draft
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

    func cmd(_ k: String, _ v: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Text(k).font(.system(size: 11, design: .monospaced))
                .padding(.horizontal, 7).padding(.vertical, 1)
                .background(Color(hex: 0xEEF3F8)).foregroundColor(Color(hex: 0x2C567E))
                .clipShape(RoundedRectangle(cornerRadius: 6))
            Text(v).font(.system(size: 12))
        }
    }

    func legend(_ b: Badge, _ v: String) -> some View {
        HStack(alignment: .top, spacing: 10) { b; Text(v).font(.system(size: 12)) }
    }

    func bullet(_ s: String) -> some View {
        HStack(alignment: .top, spacing: 6) { Text("•"); Text(s).font(.system(size: 12)) }
    }
}

struct TasksView: View {
    @AppStorage("doneTasks") private var doneRaw = ""
    var done: Set<String> { Set(doneRaw.split(separator: ",").map(String.init)) }
    var total: Int { SETUP_TASKS.reduce(0) { $0 + $1.tasks.count } }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                HStack(alignment: .firstTextBaseline) {
                    Text("Tasks").font(.system(size: 18, weight: .bold))
                    Text("\(done.count) of \(total) done").font(.system(size: 12)).foregroundColor(.inkMuted)
                    Spacer()
                    if !done.isEmpty {
                        Button("Reset") { doneRaw = "" }.font(.system(size: 11))
                    }
                }
                ProgressView(value: Double(done.count), total: Double(total)).tint(.accentBlue)
                Text("The checklist to get the Proto system fully live. Check things off as reality moves — the list itself is app-local; the truth it points at lives in the repo.")
                    .font(.system(size: 12)).foregroundColor(.inkMuted)

                ForEach(SETUP_TASKS, id: \.section) { group in
                    PanelBox(title: group.section) {
                        ForEach(group.tasks) { t in
                            taskRow(t)
                            if t.id != group.tasks.last?.id { Divider() }
                        }
                    }
                }
            }
            .padding(18)
            .frame(maxWidth: 860, alignment: .leading)
        }
    }

    func taskRow(_ t: SetupTask) -> some View {
        let isDone = done.contains(t.id)
        return Button {
            var s = done
            if isDone { s.remove(t.id) } else { s.insert(t.id) }
            doneRaw = s.sorted().joined(separator: ",")
        } label: {
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: isDone ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 16))
                    .foregroundColor(isDone ? .okGreen : Color(hex: 0xB0B0B5))
                    .padding(.top, 1)
                VStack(alignment: .leading, spacing: 3) {
                    Text(t.title)
                        .font(.system(size: 13, weight: .semibold))
                        .strikethrough(isDone)
                        .foregroundColor(isDone ? .inkMuted : .primary)
                    Text(t.detail)
                        .font(.system(size: 11.5))
                        .foregroundColor(.inkMuted)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer()
            }
            .contentShape(Rectangle())
            .padding(.vertical, 4)
        }
        .buttonStyle(.plain)
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
