import SwiftUI
import AppKit

// MARK: - Panel shown on a slice's detail page, above the changelog

struct PRDPanel: View {
    @EnvironmentObject var repo: Repo
    let page: String
    let toast: (String) -> Void
    @State private var editing: PRDEntry? = nil
    @State private var adding = false

    var mine: [PRDEntry] { repo.prds(for: page) }
    var others: [PRDEntry] { repo.prds.filter { !$0.slices.contains(page) } }

    var body: some View {
        PanelBox(title: "PRDs · from Roadmap/prds.md") {
            if mine.isEmpty {
                Text("No PRD linked to this slice yet.")
                    .font(.system(size: 12)).foregroundColor(.inkMuted)
            } else {
                ForEach(mine) { p in
                    PRDRow(prd: p, contextPage: page, toast: toast, edit: { editing = p })
                    if p.id != mine.last?.id { Divider() }
                }
            }
            HStack(spacing: 8) {
                Button("+ Add PRD…") { adding = true }
                if !others.isEmpty {
                    Menu("Link existing…") {
                        ForEach(others) { p in
                            Button(p.name) {
                                if let err = repo.setPRD(p.name, attached: true, to: page) { toast(err) }
                                else { toast("Linked “\(p.name)” — Roadmap/prds.md updated") }
                            }
                        }
                    }
                    .frame(width: 130)
                }
                Spacer()
                Button("Open prds.md") { repo.openFile(Repo.prdsPath) }.font(.system(size: 11))
            }
            .padding(.top, 2)
            Text("A PRD can cover several slices, and a slice can carry several PRDs. Editing here writes Roadmap/prds.md — the one file Proto touches, kept separate so a Claude Code session can't collide with it.")
                .font(.system(size: 11)).foregroundColor(.inkMuted)
        }
        .sheet(isPresented: $adding) {
            PRDSheet(existing: nil, presetSlice: page, toast: toast).environmentObject(repo)
        }
        .sheet(item: $editing) { p in
            PRDSheet(existing: p, presetSlice: nil, toast: toast).environmentObject(repo)
        }
    }
}

// MARK: - One PRD row (shared by the panel and the tab)

struct PRDRow: View {
    @EnvironmentObject var repo: Repo
    let prd: PRDEntry
    var contextPage: String? = nil      // non-nil inside a slice detail → offer "Unlink"
    let toast: (String) -> Void
    let edit: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Text(prd.name).font(.system(size: 13, weight: .semibold))
                Spacer()
                if prd.hasDoc {
                    PillButton(label: "doc") {
                        if repo.fileExists(prd.doc) { repo.openFile(prd.doc) }
                        else { toast("\(prd.doc) isn't in the repo (yet)") }
                    }
                }
                if prd.hasClickUp {
                    PillButton(label: "ClickUp", filled: true) { repo.openURL(prd.clickup) }
                }
                PillButton(label: "edit", action: edit)
            }

            if prd.hasDoc || prd.hasClickUp {
                HStack(spacing: 10) {
                    if prd.hasDoc {
                        Text(prd.doc).font(.system(size: 10.5, design: .monospaced))
                            .foregroundColor(repo.fileExists(prd.doc) ? .inkMuted : .dangerRed)
                            .help(repo.fileExists(prd.doc) ? prd.doc : "No such file in the repo")
                    }
                    if prd.hasClickUp {
                        Text(prd.clickup).font(.system(size: 10.5)).foregroundColor(.inkMuted)
                            .lineLimit(1).truncationMode(.middle)
                    }
                }
            }

            if !prd.notes.isEmpty {
                Text(prd.notes).font(.system(size: 11.5)).foregroundColor(.inkMuted)
                    .fixedSize(horizontal: false, vertical: true)
            }

            let shown = prd.slices.filter { $0 != contextPage }
            if !shown.isEmpty {
                HStack(spacing: 5) {
                    Text(contextPage == nil ? "covers" : "also covers")
                        .font(.system(size: 10)).foregroundColor(.inkMuted)
                    ForEach(shown, id: \.self) { s in
                        Chip(text: repo.pages.first(where: { $0.page == s })?.pretty ?? s)
                    }
                }
            }

            if let page = contextPage {
                Button("Unlink from this slice") {
                    if let err = repo.setPRD(prd.name, attached: false, to: page) { toast(err) }
                    else { toast("Unlinked — Roadmap/prds.md updated") }
                }
                .font(.system(size: 10.5))
                .buttonStyle(.plain)
                .foregroundColor(.inkMuted)
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - The PRDs tab: every PRD, and which slices each one covers

struct PRDsView: View {
    @EnvironmentObject var repo: Repo
    let toast: (String) -> Void
    @State private var adding = false
    @State private var editing: PRDEntry? = nil

    var orphans: [SliceEntry] {
        repo.pages.filter { !$0.isMain && !$0.archived && repo.prds(for: $0.page).isEmpty }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                HStack(alignment: .firstTextBaseline) {
                    Text("PRDs").font(.system(size: 18, weight: .bold))
                    Text("\(repo.prds.count) in the register").font(.system(size: 12)).foregroundColor(.inkMuted)
                    Spacer()
                    Button("+ Add PRD…") { adding = true }.buttonStyle(.borderedProminent).tint(.accentBlue)
                }
                Text("The register lives in Roadmap/prds.md — markdown in the repo is the source of truth, and the ClickUp link is the pointer for the team. Proto reads and writes this one file; nothing else in the repo moves when you edit here.")
                    .font(.system(size: 12)).foregroundColor(.inkMuted)

                if repo.prds.isEmpty {
                    PanelBox(title: "Empty") {
                        Text("No PRDs registered yet. Add one — name it, point it at a markdown doc and/or a ClickUp URL, and tick the slices it specs.")
                            .font(.system(size: 12)).foregroundColor(.inkMuted)
                    }
                } else {
                    PanelBox(title: "Register") {
                        ForEach(repo.prds) { p in
                            PRDRow(prd: p, toast: toast, edit: { editing = p })
                            if p.id != repo.prds.last?.id { Divider() }
                        }
                    }
                }

                if !orphans.isEmpty {
                    PanelBox(title: "Live slices with no PRD") {
                        ForEach(orphans) { s in
                            HStack(spacing: 8) {
                                Text(s.pretty).font(.system(size: 12))
                                Text(s.page).font(.system(size: 10, design: .monospaced)).foregroundColor(.inkMuted)
                                Spacer()
                            }
                        }
                        Text("Not a problem by itself — a slice can be its own spec. Worth knowing before a handoff.")
                            .font(.system(size: 11)).foregroundColor(.inkMuted)
                    }
                }

                Button("Open Roadmap/prds.md") { repo.openFile(Repo.prdsPath) }.font(.system(size: 11))
            }
            .padding(18)
            .frame(maxWidth: 860, alignment: .leading)
        }
        .sheet(isPresented: $adding) { PRDSheet(existing: nil, presetSlice: nil, toast: toast).environmentObject(repo) }
        .sheet(item: $editing) { p in PRDSheet(existing: p, presetSlice: nil, toast: toast).environmentObject(repo) }
    }
}

// MARK: - Add / edit sheet

struct PRDSheet: View {
    @EnvironmentObject var repo: Repo
    @Environment(\.dismiss) var dismiss
    let existing: PRDEntry?
    let presetSlice: String?
    let toast: (String) -> Void

    @State private var name = ""
    @State private var doc = ""
    @State private var clickup = ""
    @State private var notes = ""
    @State private var slices: Set<String> = []
    @State private var error: String? = nil
    @State private var confirmingDelete = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(existing == nil ? "Add a PRD" : "Edit PRD").font(.system(size: 15, weight: .bold))
            Text("Written to Roadmap/prds.md. The doc path is repo-relative; the ClickUp link is optional.")
                .font(.system(size: 11.5)).foregroundColor(.inkMuted)
            Divider()

            field("Name") { TextField("Video On Demand + User Accounts", text: $name) }
            field("Doc") {
                HStack(spacing: 6) {
                    TextField("Roadmap/prd-….md", text: $doc)
                    Button("Choose…") { pickDoc() }
                }
            }
            field("ClickUp") { TextField("https://app.clickup.com/…", text: $clickup) }
            field("Notes") { TextField("optional — what's current, what's behind", text: $notes) }

            Text("SLICES THIS PRD SPECS").font(.system(size: 9.5, weight: .bold)).kerning(0.5)
                .foregroundColor(Color(hex: 0x8A8A90)).padding(.top, 4)
            ScrollView {
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(repo.pages.filter { !$0.isMain }) { s in
                        Toggle(isOn: Binding(
                            get: { slices.contains(s.page) },
                            set: { on in if on { slices.insert(s.page) } else { slices.remove(s.page) } }
                        )) {
                            HStack(spacing: 6) {
                                Text(s.pretty).font(.system(size: 12))
                                if s.archived { archivedBadge }
                            }
                        }
                        .toggleStyle(.checkbox)
                    }
                }
            }
            .frame(maxHeight: 120)

            if let e = error {
                Text(e).font(.system(size: 11.5)).foregroundColor(.dangerRed)
            }

            Divider()
            HStack {
                if existing != nil {
                    Button(confirmingDelete ? "Really remove?" : "Remove from register", role: .destructive) {
                        if confirmingDelete {
                            if let err = repo.removePRD(existing!.name) { error = err }
                            else { toast("Removed from the register — the doc itself is untouched"); dismiss() }
                        } else { confirmingDelete = true }
                    }
                    .font(.system(size: 11))
                }
                Spacer()
                Button("Cancel") { dismiss() }
                Button("Save") { save() }.buttonStyle(.borderedProminent).tint(.accentBlue)
            }
        }
        .padding(20)
        .frame(width: 560)
        .onAppear {
            if let e = existing {
                name = e.name; doc = e.doc; clickup = e.clickup; notes = e.notes
                slices = Set(e.slices)
            } else if let p = presetSlice {
                slices = [p]
            }
        }
    }

    func field(_ label: String, @ViewBuilder _ content: () -> some View) -> some View {
        HStack(alignment: .firstTextBaseline) {
            Text(label).font(.system(size: 12)).foregroundColor(.inkMuted)
                .frame(width: 70, alignment: .leading)
            content().textFieldStyle(.roundedBorder)
        }
    }

    /// Pick a markdown file inside the repo; stored as a repo-relative path.
    func pickDoc() {
        let p = NSOpenPanel()
        p.canChooseFiles = true
        p.canChooseDirectories = false
        p.allowedContentTypes = [.plainText]
        p.directoryURL = URL(fileURLWithPath: repo.repoPath + "/Roadmap")
        guard p.runModal() == .OK, let u = p.url else { return }
        let root = repo.repoPath.hasSuffix("/") ? repo.repoPath : repo.repoPath + "/"
        doc = u.path.hasPrefix(root) ? String(u.path.dropFirst(root.count)) : u.path
    }

    func save() {
        let clean = name.trimmingCharacters(in: .whitespaces)
        guard !clean.isEmpty else { error = "A PRD needs a name."; return }
        let sorted = repo.pages.map(\.page).filter { slices.contains($0) }   // keep board order
        if let e = existing {
            var list = repo.prds
            guard let i = list.firstIndex(where: { $0.name == e.name }) else { error = "PRD not found."; return }
            if clean.lowercased() != e.name.lowercased(),
               list.contains(where: { $0.name.lowercased() == clean.lowercased() }) {
                error = "“\(clean)” is already in the register."; return
            }
            list[i] = PRDEntry(name: clean, slices: sorted,
                               doc: doc.trimmingCharacters(in: .whitespaces),
                               clickup: clickup.trimmingCharacters(in: .whitespaces),
                               notes: notes.trimmingCharacters(in: .whitespaces))
            if let err = repo.savePRDs(list) { error = err; return }
        } else {
            if let err = repo.addPRD(name: clean, slices: sorted, doc: doc, clickup: clickup, notes: notes) {
                error = err; return
            }
        }
        toast("Roadmap/prds.md updated — commit it at close session")
        dismiss()
    }
}
