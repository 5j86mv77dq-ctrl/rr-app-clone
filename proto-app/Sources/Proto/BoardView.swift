import SwiftUI

struct BoardView: View {
    @EnvironmentObject var repo: Repo
    let open: (SliceEntry) -> Void
    let toast: (String) -> Void
    @AppStorage("archiveExpanded") private var archiveExpanded = false
    @State private var archiving: SliceEntry? = nil
    @State private var hoveredRow: String? = nil

    var live: [SliceEntry] { repo.pages.filter { !$0.archived } }
    var archived: [SliceEntry] { repo.pages.filter { $0.archived } }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                if let err = repo.loadError {
                    Text(err).font(.system(size: 12)).foregroundColor(.dangerRed)
                        .padding(12).frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(hex: 0xFDECEA)).clipShape(RoundedRectangle(cornerRadius: 8))
                }
                if !repo.integrityWarnings.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("⚠ UNRECORDED CHANGES — front matter ⇄ MANIFEST mismatch")
                            .font(.system(size: 10, weight: .bold)).foregroundColor(.dangerRed)
                        ForEach(repo.integrityWarnings, id: \.self) { w in
                            Text(w).font(.system(size: 11)).foregroundColor(.inkMuted)
                        }
                    }
                    .padding(12).frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(hex: 0xFDECEA)).clipShape(RoundedRectangle(cornerRadius: 8))
                }

                listBox(rows: live)

                if !archived.isEmpty { archiveSection }
            }
            .padding(18)
        }
        .sheet(item: $archiving) { e in
            ArchiveSheet(entry: e, toast: toast).environmentObject(repo)
        }
    }

    /// Archived slices, collapsed. Archive = no longer a live workspace — shipped
    /// and done, merged into another slice, or abandoned. One state; the note says why.
    var archiveSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Button {
                withAnimation(.easeInOut(duration: 0.18)) { archiveExpanded.toggle() }
            } label: {
                HStack(spacing: 7) {
                    Image(systemName: archiveExpanded ? "chevron.down" : "chevron.right")
                        .font(.system(size: 10, weight: .bold))
                    Image(systemName: "archivebox").font(.system(size: 11))
                    Text("Archived (\(archived.count))").font(.system(size: 12, weight: .semibold))
                    Spacer()
                }
                .foregroundColor(.inkMuted)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            if archiveExpanded { listBox(rows: archived) }
        }
        .padding(.top, 4)
    }

    func listBox(rows: [SliceEntry]) -> some View {
        VStack(spacing: 0) {
            header
            ForEach(rows) { e in
                row(e)
                if e.id != rows.last?.id { Divider() }
            }
        }
        .background(Color(nsColor: .textBackgroundColor))
        .clipShape(RoundedRectangle(cornerRadius: 11))
        .overlay(RoundedRectangle(cornerRadius: 11).stroke(Color.black.opacity(0.08), lineWidth: 1))
    }

    var header: some View {
        HStack(spacing: 12) {
            head("Slice").frame(minWidth: 210, maxWidth: .infinity, alignment: .leading)
            head("Based on").frame(width: 150, alignment: .leading)
            head("Depends on").frame(width: 130, alignment: .leading)
            head("Funneled").frame(width: 70, alignment: .leading)
            head("Updated").frame(width: 78, alignment: .leading)
            head("Links").frame(width: 192, alignment: .trailing)
        }
        .padding(.horizontal, 16).padding(.vertical, 8)
        .background(Color(hex: 0xFAFAFC))
        .overlay(Divider(), alignment: .bottom)
    }

    func designationTint(_ e: SliceEntry) -> Color {
        e.productionLabel == "beta" ? .warnAmber : .okGreen
    }

    func head(_ s: String) -> some View {
        Text(s.uppercased()).font(.system(size: 9.5, weight: .bold)).kerning(0.5)
            .foregroundColor(Color(hex: 0x98989D))
    }

    func row(_ e: SliceEntry) -> some View {
        HStack(spacing: 12) {
            // Slice
            HStack(spacing: 7) {
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 7) {
                        Text(e.pretty).font(.system(size: 13.5, weight: .semibold))
                        if e.isMain { visionBadge }
                        if e.isProduction {
                            prodBadge(e.productionLabel)
                                .help(e.productionLabel == "beta"
                                      ? "The mirror of the real app today — in beta, not shipped to everyone. Default base for one-off slices. Tell Claude “X is now production” when it ships."
                                      : "The mirror of the real app today — shipped. Default base for one-off slices.")
                        }
                        if e.archived { archivedBadge.help(e.archivedNote) }
                        if e.isStale { staleBadge.help("Base \(e.basePath) has \(e.staleCount) commit(s) since pin \(e.baseCommit) — assess before working on it") }
                    }
                    Text(e.page).font(.system(size: 10, design: .monospaced)).foregroundColor(.inkMuted)
                    if e.archived, !e.archivedNote.isEmpty {
                        Text(e.archivedNote).font(.system(size: 10.5)).foregroundColor(.inkMuted)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
            .frame(minWidth: 210, maxWidth: .infinity, alignment: .leading)

            // Based on
            Group {
                if e.base.isEmpty { Text("—").foregroundColor(.inkMuted) }
                else { Chip(text: e.base) }
            }
            .frame(width: 150, alignment: .leading)

            // Depends on
            Group {
                if e.dependsOn.isEmpty { Text("—").font(.system(size: 12)).foregroundColor(.inkMuted) }
                else {
                    VStack(alignment: .leading, spacing: 3) {
                        ForEach(e.dependsOn, id: \.self) { d in
                            Chip(text: repo.pages.first(where: { $0.page == d })?.pretty ?? d)
                        }
                    }
                }
            }
            .frame(width: 130, alignment: .leading)

            // Funneled
            Group {
                if e.isMain { Text("—").foregroundColor(.inkMuted) }
                else if e.funnelOpen { Badge(text: "open", fg: .warnAmber, bg: .amberSoft) }
                else if e.funnel.isEmpty { Text("—").font(.system(size: 12)).foregroundColor(.inkMuted) }
                else { Badge(text: "done", fg: .okGreen, bg: .greenSoft) }
            }
            .frame(width: 70, alignment: .leading)

            // Updated
            Text(e.updated.isEmpty ? "—" : e.updated)
                .font(.system(size: 11, design: .monospaced)).foregroundColor(.inkMuted)
                .frame(width: 78, alignment: .leading)

            // Links (all copy — Peter pastes into Claude Code / messages, never opens here)
            HStack(spacing: 6) {
                PillButton(label: "local") {
                    repo.copyToClipboard(e.localURL)
                    toast("Local URL copied — paste into Claude Code's browser")
                }
                PillButton(label: "Netlify", filled: true) {
                    repo.copyToClipboard(e.netlifyURL)
                    toast("Netlify URL copied — ready to share")
                }
                PillButton(label: "⧉") {
                    repo.copyToClipboard(sessionPrompt(page: e.page, pretty: e.pretty))
                    toast("Session prompt copied — paste into Claude Code")
                }
                Button { archiving = e } label: {
                    Image(systemName: "archivebox").font(.system(size: 11))
                }
                .buttonStyle(.plain).foregroundColor(.inkMuted)
                .opacity(hoveredRow == e.page && !e.isMain && !e.archived ? 1 : 0)
                .help("Archive this slice")
                .frame(width: 16)
            }
            .frame(width: 192, alignment: .trailing)
        }
        .padding(.horizontal, 16).padding(.vertical, 11)
        .contentShape(Rectangle())
        .background(e.isProduction ? designationTint(e).opacity(0.06) : Color.clear)
        .overlay(alignment: .leading) {
            if e.isProduction { Rectangle().fill(designationTint(e)).frame(width: 3) }
            else if e.isMain { Rectangle().fill(Color.accentBlue).frame(width: 3) }
        }
        .opacity(e.archived ? 0.72 : 1)
        .onHover { hoveredRow = $0 ? e.page : (hoveredRow == e.page ? nil : hoveredRow) }
        .onTapGesture { open(e) }
        .contextMenu {
            if !e.isMain && !e.archived {
                Button("Archive…") { archiving = e }
            }
        }
    }
}

/// Archiving moves the file and rewrites two records, so it asks for the one thing
/// a future reader will want: why. Everything it does is git-tracked.
struct ArchiveSheet: View {
    @EnvironmentObject var repo: Repo
    @Environment(\.dismiss) var dismiss
    let entry: SliceEntry
    let toast: (String) -> Void

    @State private var note = ""
    @State private var error: String? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Archive “\(entry.pretty)”").font(.system(size: 15, weight: .bold))
            Text("It leaves the board, keeps its URL, and stops going stale. Reversible — everything here is in git.")
                .font(.system(size: 11.5)).foregroundColor(.inkMuted)

            TextField("Why? e.g. shipped · merged into VOD · no longer applicable", text: $note)
                .textFieldStyle(.roundedBorder)
                .onSubmit { go() }

            if let e = error {
                Text(e).font(.system(size: 11.5)).foregroundColor(.dangerRed)
                    .fixedSize(horizontal: false, vertical: true)
            }

            HStack {
                Spacer()
                Button("Cancel") { dismiss() }
                Button("Archive") { go() }.buttonStyle(.borderedProminent).tint(.accentBlue)
            }
        }
        .padding(20)
        .frame(width: 520)
    }

    func go() {
        let dated = "\(Repo.today) — \(note.trimmingCharacters(in: .whitespaces))"
        if let err = repo.archive(entry, note: dated) { error = err; return }
        toast("Archived — say “close session” to log it")
        dismiss()
    }
}
