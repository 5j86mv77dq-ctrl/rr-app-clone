import SwiftUI

/// Designs (home): Waiting in ClickUp · In progress · Reference.
struct HomeView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var shots: Screenshots
    @Binding var path: [String]
    @State private var starting: WaitingTask? = nil
    @State private var startingBlank = false

    private let grid = [GridItem(.adaptive(minimum: 210, maximum: 260), spacing: 16)]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 26) {
                if let e = store.loadError {
                    Panel { Label(e, systemImage: "exclamationmark.triangle").foregroundColor(.dangerRed) }
                }
                waitingSection
                VStack(alignment: .leading, spacing: 12) {
                    SectionTitle(text: "In progress", count: store.live.count)
                    if store.live.isEmpty {
                        Text("Nothing yet. Press Start on a ClickUp item above.")
                            .font(.system(size: 12.5)).foregroundColor(.inkMuted)
                    }
                    LazyVGrid(columns: grid, alignment: .leading, spacing: 16) {
                        ForEach(store.live) { d in
                            DesignCard(design: d).onTapGesture { path.append(d.id) }
                        }
                    }
                }
                VStack(alignment: .leading, spacing: 12) {
                    SectionTitle(text: "Reference")
                    LazyVGrid(columns: grid, alignment: .leading, spacing: 16) {
                        ReferenceCard(target: store.currentApp,
                                      note: "Hand-kept replica of the real app. Changes only when something ships.")
                        ReferenceCard(target: store.vision, note: "The end state. Kept designs port into it.")
                    }
                }
            }
            .padding(24)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .navigationTitle("Designs")
        .toolbar {
            ToolbarItem {
                Button { startingBlank = true } label: { Label("New design", systemImage: "plus") }
                    .help("Start a design that isn't in ClickUp")
            }
            ToolbarItem {
                Button { store.refreshClickUp(); store.refresh() } label: { Label("Refresh", systemImage: "arrow.clockwise") }
            }
        }
        .sheet(item: $starting) { t in NewDesignSheet(task: t) }
        .sheet(isPresented: $startingBlank) { NewDesignSheet(task: nil) }
    }

    @ViewBuilder var waitingSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionTitle(text: "Waiting in ClickUp", count: store.hasClickUpToken ? store.waitingNow.count : nil)
            if !store.hasClickUpToken {
                TokenPrompt(kind: .clickup)
            } else if let e = store.clickupError {
                Label(e, systemImage: "exclamationmark.triangle").font(.system(size: 12)).foregroundColor(.dangerRed)
            } else if store.waitingNow.isEmpty {
                Text("Nothing waiting in the Design list.").font(.system(size: 12.5)).foregroundColor(.inkMuted)
            } else {
                Panel {
                    VStack(spacing: 0) {
                        ForEach(Array(store.waitingNow.enumerated()), id: \.element.id) { i, t in
                            if i > 0 { Divider().padding(.vertical, 8) }
                            HStack(spacing: 10) {
                                Image(systemName: "circle.dashed").foregroundColor(.inkMuted)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(t.name).font(.system(size: 13, weight: .semibold))
                                    Text(t.status.capitalized).font(.system(size: 10.5)).foregroundColor(.inkMuted)
                                }
                                Spacer()
                                Button { store.open(t.url) } label: { Image(systemName: "arrow.up.right.square") }
                                    .buttonStyle(.plain).foregroundColor(.inkMuted).help("Open in ClickUp")
                                PillButton(label: "Start", icon: "play.fill", filled: true) { starting = t }
                            }
                        }
                    }
                }
            }
        }
    }
}

/// One live slice: screenshot, name, stage pill, one status line.
struct DesignCard: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var shots: Screenshots
    let design: Design

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Thumb(page: thumbPage)
            HStack(alignment: .top) {
                Text(design.name).font(.system(size: 13.5, weight: .semibold)).lineLimit(2)
                Spacer(minLength: 4)
                stageBadge(design.stage)
            }
            StatusLine(design: design)
        }
        .padding(10)
        .background(Color(nsColor: .textBackgroundColor))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.black.opacity(0.08), lineWidth: 1))
        .contentShape(Rectangle())
        .contextMenu {
            Button("Open link") { store.open(design.link.netlifyURL) }
            Button("Copy link") { store.copy(design.link.netlifyURL, "Link copied") }
        }
    }

    /// While the 3 looks are out, the card shows look A.
    var thumbPage: String {
        if store.exists.contains(design.page) { return design.page }
        return design.looks?.first(where: { store.exists.contains($0) }) ?? design.page
    }
}

struct StatusLine: View {
    @EnvironmentObject var store: Store
    let design: Design

    var body: some View {
        let (text, color) = status
        Text(text).font(.system(size: 11)).foregroundColor(color).lineLimit(2)
    }

    var status: (String, Color) {
        let d = design
        if d.frozen == "testers" { return ("Frozen for testing", .warnAmber) }
        if d.frozen == "dev" { return ("Frozen for dev", .shipTeal) }
        switch d.stage {
        case .archived: return ("Archived", .inkMuted)
        case .shipped: return ("Shipped — now part of the Current app", .shipTeal)
        case .kept: return ("Kept — ported into the Vision", .okGreen)
        case .looks where !(d.looks ?? []).contains(where: { store.exists.contains($0) }):
            return ("Claude is making 3 looks…", .inkMuted)
        case .looks: return ("3 looks ready — pick one", .revPurple)
        default: break
        }
        if !store.exists.contains(d.page) { return ("Claude is building it…", .inkMuted) }
        if let n = store.behind[d.id], n > 0 {
            return ("\(n) change\(n == 1 ? "" : "s") behind the current app — Claude catches up next time", .warnAmber)
        }
        return ("Up to date with current app", .okGreen)
    }
}

struct Thumb: View {
    @EnvironmentObject var shots: Screenshots
    let page: String
    var height: CGFloat = 300

    var body: some View {
        ZStack {
            Color.phoneDark
            if let img = shots.image(for: page) {
                Image(nsImage: img).resizable().aspectRatio(contentMode: .fit)
            } else {
                Image(systemName: "iphone").font(.system(size: 30)).foregroundColor(.white.opacity(0.25))
            }
        }
        .frame(height: height)
        .frame(maxWidth: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .onAppear { shots.request(page) }
        .onChange(of: page) { _, p in shots.request(p) }
    }
}

struct ReferenceCard: View {
    @EnvironmentObject var store: Store
    let target: LinkTarget
    let note: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Thumb(page: target.page)
            Text(target.name).font(.system(size: 13.5, weight: .semibold))
            Text(note).font(.system(size: 11)).foregroundColor(.inkMuted).lineLimit(2)
            HStack(spacing: 6) {
                PillButton(label: "Open", icon: "safari") { store.open(target.netlifyURL) }
                PillButton(label: "Copy link", icon: "link") { store.copy(target.netlifyURL, "\(target.name) link copied") }
            }
        }
        .padding(10)
        .background(Color(nsColor: .textBackgroundColor))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.black.opacity(0.08), lineWidth: 1))
    }
}

/// Archive (sidebar): archived designs, still openable.
struct ArchiveView: View {
    @EnvironmentObject var store: Store
    @Binding var path: [String]
    private let grid = [GridItem(.adaptive(minimum: 210, maximum: 260), spacing: 16)]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                if store.archived.isEmpty {
                    Text("No archived designs.").font(.system(size: 12.5)).foregroundColor(.inkMuted)
                }
                LazyVGrid(columns: grid, alignment: .leading, spacing: 16) {
                    ForEach(store.archived) { d in
                        DesignCard(design: d).onTapGesture { path.append(d.id) }
                    }
                }
            }
            .padding(24)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .navigationTitle("Archive")
    }
}

/// Inline Keychain entry for a missing token.
struct TokenPrompt: View {
    @EnvironmentObject var store: Store
    let kind: Keychain.Account
    @State private var value = ""

    var body: some View {
        Panel {
            VStack(alignment: .leading, spacing: 8) {
                Text(kind == .clickup ? "Connect ClickUp (read only)" : "Connect Netlify (for versions)")
                    .font(.system(size: 13, weight: .semibold))
                Text(kind == .clickup
                     ? "Paste your personal ClickUp API token (ClickUp → Settings → Apps → API Token). It's kept in the Mac Keychain."
                     : "Paste a Netlify personal access token (Netlify → User settings → Applications). It's kept in the Mac Keychain.")
                    .font(.system(size: 11.5)).foregroundColor(.inkMuted)
                HStack {
                    SecureField(kind == .clickup ? "pk_…" : "nfp_…", text: $value)
                        .textFieldStyle(.roundedBorder)
                        .onSubmit(save)
                    PillButton(label: "Save", filled: true, action: save)
                }
            }
        }
    }

    func save() {
        guard !value.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        store.saveToken(kind, value)
        value = ""
    }
}
