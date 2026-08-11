import SwiftUI

struct BoardView: View {
    @EnvironmentObject var repo: Repo
    let open: (SliceEntry) -> Void
    let toast: (String) -> Void

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

                listBox(rows: repo.pages)

                Text("Read live from the repo — front matter, the MANIFEST, the changelog, and git. Proto stores nothing. Workflow status lives in ClickUp.")
                    .font(.system(size: 11)).foregroundColor(.inkMuted)
            }
            .padding(18)
        }
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
            head("Links").frame(width: 168, alignment: .trailing)
        }
        .padding(.horizontal, 16).padding(.vertical, 8)
        .background(Color(hex: 0xFAFAFC))
        .overlay(Divider(), alignment: .bottom)
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
                        if e.isProduction { prodBadge }
                        if e.isStale { staleBadge.help("Base \(e.basePath) has \(e.staleCount) commit(s) since pin \(e.baseCommit) — assess before working on it") }
                    }
                    Text(e.page).font(.system(size: 10, design: .monospaced)).foregroundColor(.inkMuted)
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
            }
            .frame(width: 168, alignment: .trailing)
        }
        .padding(.horizontal, 16).padding(.vertical, 11)
        .contentShape(Rectangle())
        .background(e.isProduction ? Color.okGreen.opacity(0.06) : Color.clear)
        .overlay(alignment: .leading) {
            if e.isProduction { Rectangle().fill(Color.okGreen).frame(width: 3) }
            else if e.isMain { Rectangle().fill(Color.accentBlue).frame(width: 3) }
        }
        .onTapGesture { open(e) }
    }
}
