import SwiftUI

/// The New design box: one sentence + how to start, then straight into Claude.
struct NewDesignSheet: View {
    @EnvironmentObject var store: Store
    @Environment(\.dismiss) private var dismiss
    let task: WaitingTask?
    @State private var request = ""
    @State private var looks: Bool? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("New design").font(.system(size: 18, weight: .bold))
            if let t = task {
                Button { store.open(t.url) } label: {
                    Label(t.name, systemImage: "checklist").font(.system(size: 11.5))
                }.buttonStyle(.link)
            }
            VStack(alignment: .leading, spacing: 6) {
                Text("What do you want to prototype?").font(.system(size: 13, weight: .semibold))
                TextField("One sentence", text: $request, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .lineLimit(2...5)
            }
            VStack(alignment: .leading, spacing: 8) {
                Text("How to start").font(.system(size: 13, weight: .semibold))
                choice(true, "Show me 3 looks first", "Three quick visual directions as static screens. You pick one, then Claude builds it into the app.")
                choice(false, "Build it in the app now", "Claude copies the Current app into a new design and builds the feature into it. Full app, every tab works.")
            }
            HStack {
                Spacer()
                Button("Cancel") { dismiss() }.keyboardShortcut(.cancelAction)
                Button("Start in Claude") { start() }
                    .keyboardShortcut(.defaultAction)
                    .buttonStyle(.borderedProminent)
                    .disabled(request.trimmingCharacters(in: .whitespaces).isEmpty || looks == nil)
            }
        }
        .padding(22)
        .frame(width: 500)
        .onAppear { request = task?.name ?? "" }
    }

    func choice(_ value: Bool, _ title: String, _ detail: String) -> some View {
        Button { looks = value } label: {
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: looks == value ? "largecircle.fill.circle" : "circle")
                    .foregroundColor(looks == value ? .accentBlue : .inkMuted)
                VStack(alignment: .leading, spacing: 2) {
                    Text(title).font(.system(size: 12.5, weight: .semibold))
                    Text(detail).font(.system(size: 11)).foregroundColor(.inkMuted)
                }
                Spacer()
            }
            .padding(10)
            .background(RoundedRectangle(cornerRadius: 8).fill(looks == value ? Color.accentSoft : Color.clear))
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(looks == value ? Color.accentBlue.opacity(0.5) : Color.black.opacity(0.1)))
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    func start() {
        guard let looks else { return }
        let sentence = request.trimmingCharacters(in: .whitespacesAndNewlines)
        let d = store.createDesign(name: task?.name ?? sentence, request: sentence, looks: looks, task: task)
        store.launch(Prompt.start(d), title: d.name)
        dismiss()
    }
}

/// Design detail: big phone preview, versions, and the decision buttons.
struct DesignDetail: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var shots: Screenshots
    let id: String
    @State private var versions: [Version] = []
    @State private var loadingVersions = false
    @State private var showChangelog = false
    @State private var confirm: Action? = nil
    @State private var previewURL: URL? = nil

    enum Action: String, Identifiable {
        case testers = "Send to testers", keep = "Keep", shipped = "Shipped", archive = "Archive"
        var id: String { rawValue }
    }

    var body: some View {
        if let d = store.design(id) {
            HStack(alignment: .top, spacing: 0) {
                preview(d)
                    .frame(width: 360)
                    .padding(18)
                Divider()
                ScrollView {
                    VStack(alignment: .leading, spacing: 18) {
                        header(d)
                        if d.stage == .looks { looksPanel(d) }
                        actions(d)
                        if let t = d.testerPage { testerPanel(d, t) }
                        versionsPanel(d)
                    }
                    .padding(22)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .navigationTitle(d.name)
            .sheet(isPresented: $showChangelog) { ChangelogSheet(design: d) }
            .confirmationDialog(confirm.map { "\($0.rawValue): \(d.name)?" } ?? "",
                                isPresented: Binding(get: { confirm != nil }, set: { if !$0 { confirm = nil } }),
                                presenting: confirm) { a in
                Button(a.rawValue, role: a == .archive ? .destructive : nil) { run(a, d) }
            } message: { a in
                Text(explain(a))
            }
            .task(id: d.page) { await loadVersions(d) }
        } else {
            Text("This design is no longer in prototype.json.").foregroundColor(.inkMuted)
        }
    }

    // MARK: pieces

    func preview(_ d: Design) -> some View {
        VStack(spacing: 8) {
            if store.exists.contains(d.page) {
                PhonePreview(url: previewURL ?? URL(string: d.link.localURL))
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: 30).fill(Color.phoneDark)
                    VStack(spacing: 8) {
                        ProgressView().controlSize(.small).tint(.white)
                        Text(d.stage == .looks ? "Waiting for 3 looks" : "Claude is building it")
                            .font(.system(size: 12)).foregroundColor(.white.opacity(0.7))
                    }
                }
            }
            if previewURL != nil {
                Button("Back to latest") { previewURL = nil }.buttonStyle(.link).font(.system(size: 11))
            }
        }
    }

    func header(_ d: Design) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Text(d.name).font(.system(size: 20, weight: .bold))
                stageBadge(d.stage)
            }
            StatusLine(design: d)
            Text("“\(d.request)”").font(.system(size: 12.5)).foregroundColor(.inkMuted).textSelection(.enabled)
            HStack(spacing: 12) {
                if let u = d.clickupURL {
                    Button { store.open(u) } label: { Label("ClickUp task", systemImage: "checklist") }.buttonStyle(.link)
                }
                Text("Started \(d.created)").foregroundColor(.inkMuted)
            }
            .font(.system(size: 11.5))
        }
    }

    func looksPanel(_ d: Design) -> some View {
        Panel {
            VStack(alignment: .leading, spacing: 10) {
                SectionTitle(text: "3 looks")
                let ready = (d.looks ?? []).filter { store.exists.contains($0) }
                if ready.isEmpty {
                    Text("Claude is making them. They'll appear here after its first push.")
                        .font(.system(size: 12)).foregroundColor(.inkMuted)
                } else {
                    HStack(alignment: .top, spacing: 12) {
                        ForEach(ready, id: \.self) { page in
                            let letter = ((page as NSString).lastPathComponent as NSString).deletingPathExtension
                            VStack(spacing: 6) {
                                Thumb(page: page, height: 220)
                                    .onTapGesture { previewURL = URL(string: "http://localhost:8000/" + page) }
                                Text("Look \(letter.uppercased())").font(.system(size: 12, weight: .semibold))
                                HStack(spacing: 4) {
                                    PillButton(label: "Open", icon: "safari") {
                                        store.open(LinkTarget(page: page, name: "").netlifyURL)
                                    }
                                    PillButton(label: "Pick", filled: true, tint: .revPurple) {
                                        store.launch(Prompt.pick(d, look: letter), title: d.name)
                                    }
                                }
                            }
                            .frame(maxWidth: 180)
                        }
                    }
                }
            }
        }
    }

    func actions(_ d: Design) -> some View {
        let finished = d.stage == .archived
        let hasPage = store.exists.contains(d.page)
        return VStack(alignment: .leading, spacing: 10) {
            Flow {
                PillButton(label: "Open", icon: "safari", filled: true) { store.open(d.link.netlifyURL) }
                PillButton(label: "Copy link", icon: "link") { store.copy(d.link.netlifyURL, "Link copied — ready for Fr. Rocky") }
                PillButton(label: "Open in Claude", icon: "terminal") { store.launch(Prompt.work(d), title: d.name) }
                PillButton(label: "Changelog", icon: "checklist") { showChangelog = true }
            }
            if !finished && hasPage {
                Divider().padding(.vertical, 2)
                Flow {
                    PillButton(label: "Send to testers", icon: "person.2", tint: .warnAmber) { confirm = .testers }
                    PillButton(label: "Keep", icon: "star", tint: .okGreen) { confirm = .keep }
                    PillButton(label: "Shipped", icon: "shippingbox", tint: .shipTeal) { confirm = .shipped }
                    PillButton(label: "Archive", icon: "archivebox", tint: .inkMuted) { confirm = .archive }
                }
            } else if !finished {
                PillButton(label: "Archive", icon: "archivebox", tint: .inkMuted) { confirm = .archive }
            }
        }
    }

    func testerPanel(_ d: Design, _ page: String) -> some View {
        let t = LinkTarget(page: page, name: "Tester copy")
        return Panel {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Tester copy").font(.system(size: 12.5, weight: .semibold))
                    Text("Frozen. Operator controls stripped.").font(.system(size: 11)).foregroundColor(.inkMuted)
                }
                Spacer()
                PillButton(label: "Open", icon: "safari") { store.open(t.netlifyURL) }
                PillButton(label: "Copy link", icon: "link") { store.copy(t.netlifyURL, "Tester link copied") }
            }
        }
    }

    func versionsPanel(_ d: Design) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                SectionTitle(text: "Versions", count: versions.isEmpty ? nil : versions.count)
                if loadingVersions { ProgressView().controlSize(.mini) }
            }
            if !store.hasNetlifyToken { TokenPrompt(kind: .netlify) }
            if versions.isEmpty && !loadingVersions {
                Text("No pushes yet.").font(.system(size: 12)).foregroundColor(.inkMuted)
            }
            ForEach(Array(versions.enumerated()), id: \.element.id) { i, v in
                HStack(spacing: 10) {
                    Text("v\(versions.count - i)").font(.system(size: 11, weight: .bold).monospacedDigit())
                        .foregroundColor(.accentBlue).frame(width: 30, alignment: .leading)
                    Text(v.date).font(.system(size: 11).monospacedDigit()).foregroundColor(.inkMuted)
                    Text(v.subject).font(.system(size: 12)).lineLimit(1)
                    Spacer()
                    if let u = v.url {
                        Button { store.open(u) } label: { Image(systemName: "safari") }.buttonStyle(.plain).help("Open this version")
                        Button { store.copy(u, "Version link copied") } label: { Image(systemName: "link") }.buttonStyle(.plain).help("Copy this version's link")
                    }
                }
                .padding(.vertical, 3)
            }
        }
    }

    // MARK: behaviour

    func explain(_ a: Action) -> String {
        switch a {
        case .testers: return "Claude makes a clean tester copy (demo pills, Dashboard link and other operator controls stripped), freezes it, pushes it, and copies its link."
        case .keep: return "Claude ports this design into the Vision now and shows you the updated Vision link."
        case .shipped: return "Claude copies this design's screens into the Current app so it matches what Brian shipped, and marks it shipped."
        case .archive: return "Moves the design to slices/archive/. Its record and link are kept."
        }
    }

    func run(_ a: Action, _ d: Design) {
        switch a {
        case .testers: store.launch(Prompt.testers(d), title: d.name)
        case .keep: store.launch(Prompt.keep(d), title: d.name)
        case .shipped: store.launch(Prompt.shipped(d), title: d.name)
        case .archive:
            if let err = store.archive(d) { store.toast = err } else { store.toast = "Archived \(d.name)" }
        }
    }

    func loadVersions(_ d: Design) async {
        loadingVersions = true
        versions = await store.versions(for: d)
        loadingVersions = false
    }
}

/// The checklist: tick = goes into the Vision, untick = stays slice-only.
struct ChangelogSheet: View {
    @EnvironmentObject var store: Store
    @Environment(\.dismiss) private var dismiss
    let design: Design
    @State private var rows: [ChecklistRow] = []
    @State private var error: String? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Changelog — \(design.name)").font(.system(size: 17, weight: .bold))
                Text("Tick what goes into the Vision. Untick what stays in this design only. Claude ports ticked items the next time it works, or right away when you press Keep.")
                    .font(.system(size: 11.5)).foregroundColor(.inkMuted)
            }
            if let error { Text(error).font(.system(size: 11.5)).foregroundColor(.dangerRed) }
            if rows.isEmpty {
                Text("Claude hasn't logged any changes for this design yet.")
                    .font(.system(size: 12.5)).foregroundColor(.inkMuted).padding(.vertical, 20)
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(rows) { r in
                            row(r)
                            Divider()
                        }
                    }
                }
            }
            HStack {
                Text("Saved to Roadmap/CHANGELOG.md as you tick.").font(.system(size: 10.5)).foregroundColor(.inkMuted)
                Spacer()
                Button("Done") { dismiss() }.keyboardShortcut(.defaultAction)
            }
        }
        .padding(22)
        .frame(width: 640, height: 560)
        .onAppear { rows = store.checklist(for: design) }
    }

    func row(_ r: ChecklistRow) -> some View {
        let ticked = r.state == .ported || r.state == .queued
        return HStack(alignment: .top, spacing: 10) {
            Button {
                if let e = store.setChecklist(r, ticked: !ticked) { error = e }
                rows = store.checklist(for: design)
            } label: {
                Image(systemName: ticked ? "checkmark.square.fill" : "square")
                    .font(.system(size: 16))
                    .foregroundColor(r.state == .ported ? .okGreen : (ticked ? .accentBlue : .inkMuted))
            }
            .buttonStyle(.plain)
            .disabled(r.state == .ported)
            VStack(alignment: .leading, spacing: 3) {
                Text(inline(r.text)).font(.system(size: 12)).fixedSize(horizontal: false, vertical: true)
                HStack(spacing: 6) {
                    Text(r.date).font(.system(size: 10.5).monospacedDigit()).foregroundColor(.inkMuted)
                    switch r.state {
                    case .ported: Badge(text: "in the Vision", fg: .okGreen, bg: .greenSoft)
                    case .queued: Badge(text: "going to the Vision", fg: .accentBlue, bg: .accentSoft)
                    case .sliceOnly: Badge(text: "this design only", fg: .inkMuted, bg: Color(hex: 0xECECEE))
                    case .pending: Badge(text: "undecided", fg: .warnAmber, bg: .amberSoft)
                    }
                }
            }
        }
        .padding(.vertical, 8)
    }

    func inline(_ s: String) -> AttributedString {
        (try? AttributedString(markdown: s, options: .init(interpretedSyntax: .inlineOnlyPreservingWhitespace))) ?? AttributedString(s)
    }
}
