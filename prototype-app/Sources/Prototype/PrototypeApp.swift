import SwiftUI
import AppKit

@main
@MainActor
struct PrototypeApp: App {
    @StateObject private var store = Store()
    @StateObject private var shots = Screenshots()

    init() {
        // headless verification: `Prototype --dump` prints what the app would show and exits
        if CommandLine.arguments.contains("--dump") {
            let path = UserDefaults.standard.string(forKey: "prototypeRepoPath") ?? defaultRepoPath
            let snap = Store.load(repoPath: path)
            print("current app: \(snap.currentApp.page)")
            print("designs: \(snap.designs.count)")
            for d in snap.designs {
                print("  \(d.id) | \(d.stage.rawValue) | frozen=\(d.frozen ?? "-") | page=\(d.page) exists=\(snap.exists.contains(d.page)) | behind=\(snap.behind[d.id].map(String.init) ?? "-") | clickup=\(d.clickupTaskId ?? "-")")
            }
            if let e = snap.loadError { print("ERROR: \(e)") }
            print("claude: \(ClaudeLauncher.binary ?? "NOT FOUND")")
            print("tokens: clickup=\(Keychain.get(.clickup) != nil) netlify=\(Keychain.get(.netlify) != nil)")
            exit(0)
        }
        // `Prototype --checklist <page>` prints a design's checklist as Prototype reads it
        if let i = CommandLine.arguments.firstIndex(of: "--checklist"), CommandLine.arguments.count > i + 1 {
            let path = UserDefaults.standard.string(forKey: "prototypeRepoPath") ?? defaultRepoPath
            let page = CommandLine.arguments[i + 1]
            let rows = Store.checklist(log: Store.slurp(path, Store.changelogPath) ?? "", pages: [page])
            for r in rows { print("[\(r.state)] \(r.date) \(r.text.prefix(90))") }
            if let r = rows.first(where: { $0.state != .ported }),
               let out = Store.replacingStatus(in: Store.slurp(path, Store.changelogPath) ?? "", line: r.line, with: "\(Store.queuedMark) (dry run)") {
                let back = Store.checklist(log: out, pages: [page]).first { $0.text == r.text }
                print("write-back dry run: \(r.state) → \(back.map { "\($0.state)" } ?? "LOST ROW")")
            }
            print("\(rows.count) row(s)")
            exit(0)
        }
        // `Prototype --prompts` prints every prompt the buttons send, for a sample design
        if CommandLine.arguments.contains("--prompts") {
            let d = Design(id: "tmb-content-library", name: "TMB Content Library", request: "TMB Content Library",
                           start: "looks", clickupTaskId: "868j39epf", clickupURL: "https://app.clickup.com/t/868j39epf",
                           page: "slices/tmb-content-library.html", stage: .looks, frozen: nil, baseCommit: nil,
                           looks: nil, pickedLook: nil, testerPage: nil, created: Store.today)
            for p in [Prompt.start(d), Prompt.pick(d, look: "b"), Prompt.work(d), Prompt.testers(d), Prompt.keep(d), Prompt.shipped(d)] {
                print(p); print("---")
            }
            let path = UserDefaults.standard.string(forKey: "prototypeRepoPath") ?? defaultRepoPath
            print("launch script: " + ClaudeLauncher.launch(prompt: Prompt.start(d), repoPath: path, title: "Fr. Rocky's \"test\"", open: false))
            exit(0)
        }
    }

    var body: some Scene {
        WindowGroup("Prototype") {
            RootView()
                .environmentObject(store)
                .environmentObject(shots)
                .frame(minWidth: 980, minHeight: 640)
                .onAppear {
                    shots.repoPath = store.repoPath
                    store.refresh()
                    selfshotIfAsked()
                }
                .onReceive(NotificationCenter.default.publisher(for: NSApplication.didBecomeActiveNotification)) { _ in
                    store.refresh()
                }
                .onReceive(Timer.publish(every: 15, on: .main, in: .common).autoconnect()) { _ in
                    store.refresh()
                }
        }
        .windowToolbarStyle(.unified)
        Settings {
            SettingsView().environmentObject(store).environmentObject(shots)
        }
    }
}

/// `Prototype --selfshot <png> [seconds]` writes the main window to a PNG and quits —
/// a visual check that needs no Screen Recording permission.
@MainActor
func selfshotIfAsked() {
    let args = CommandLine.arguments
    guard let i = args.firstIndex(of: "--selfshot"), args.count > i + 1 else { return }
    let out = args[i + 1]
    let wait = args.count > i + 2 ? Double(args[i + 2]) ?? 8 : 8
    DispatchQueue.main.asyncAfter(deadline: .now() + wait) {
        guard let view = NSApp.windows.first(where: { $0.isVisible && $0.frame.width > 600 })?.contentView,
              let rep = view.bitmapImageRepForCachingDisplay(in: view.bounds) else { exit(1) }
        view.cacheDisplay(in: view.bounds, to: rep)
        try? rep.representation(using: .png, properties: [:])?.write(to: URL(fileURLWithPath: out))
        exit(0)
    }
}

enum SidebarItem: String, CaseIterable, Identifiable {
    case designs = "Designs", archive = "Archive"
    var id: String { rawValue }
    var icon: String { self == .designs ? "square.grid.2x2" : "archivebox" }
}

struct RootView: View {
    @EnvironmentObject var store: Store
    @State private var section: SidebarItem? = .designs
    @State private var path: [String] = []
    @State private var askToken = false

    var body: some View {
        NavigationSplitView {
            List(selection: $section) {
                ForEach(SidebarItem.allCases) { s in
                    Label(s.rawValue, systemImage: s.icon)
                        .badge(s == .archive ? store.archived.count : store.live.count)
                        .tag(s)
                }
            }
            .navigationSplitViewColumnWidth(min: 170, ideal: 190)
            .safeAreaInset(edge: .bottom) {
                SettingsLink { Label("Settings", systemImage: "gearshape") }
                    .buttonStyle(.plain).foregroundColor(.inkMuted)
                    .padding(12).frame(maxWidth: .infinity, alignment: .leading)
            }
        } detail: {
            NavigationStack(path: $path) {
                Group {
                    if section == .archive { ArchiveView(path: $path) } else { HomeView(path: $path) }
                }
                .navigationDestination(for: String.self) { id in DesignDetail(id: id) }
            }
        }
        .onChange(of: section) { _, _ in path = [] }
        .overlay(alignment: .bottom) { ToastView() }
        .onAppear {
            // `--open <id>` lands on a design's detail page (used with --selfshot)
            let args = CommandLine.arguments
            if let i = args.firstIndex(of: "--open"), args.count > i + 1 { path = [args[i + 1]]; return }
            askToken = !store.hasClickUpToken
        }
        .sheet(isPresented: $askToken) {
            VStack(alignment: .leading, spacing: 14) {
                Text("Welcome to Prototype").font(.system(size: 18, weight: .bold))
                Text("Prototype reads ClickUp's Design list to show what's waiting. It never changes anything in ClickUp.")
                    .font(.system(size: 12)).foregroundColor(.inkMuted)
                TokenPrompt(kind: .clickup)
                HStack { Spacer(); Button(store.hasClickUpToken ? "Done" : "Later") { askToken = false }.keyboardShortcut(.defaultAction) }
            }
            .padding(22).frame(width: 480)
        }
    }
}

struct ToastView: View {
    @EnvironmentObject var store: Store
    var body: some View {
        if let t = store.toast {
            Text(t)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.white)
                .padding(.horizontal, 14).padding(.vertical, 9)
                .background(Capsule().fill(Color.black.opacity(0.82)))
                .padding(.bottom, 18)
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .task(id: t) {
                    try? await Task.sleep(nanoseconds: 3_200_000_000)
                    withAnimation { store.toast = nil }
                }
        }
    }
}

struct SettingsView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var shots: Screenshots
    @State private var repo = ""

    var body: some View {
        Form {
            Section("Repository") {
                HStack {
                    TextField("rr-app-clone folder", text: $repo)
                    Button("Choose…") {
                        let p = NSOpenPanel()
                        p.canChooseDirectories = true
                        p.canChooseFiles = false
                        if p.runModal() == .OK, let u = p.url { repo = u.path; apply() }
                    }
                }
                .onSubmit(apply)
            }
            Section("ClickUp (read only)") {
                tokenRow(.clickup, has: store.hasClickUpToken)
            }
            Section("Netlify (versions)") {
                tokenRow(.netlify, has: store.hasNetlifyToken)
            }
            Section("Claude Code") {
                Text(ClaudeLauncher.binary.map { "Using \($0)" } ?? "Not found — buttons will copy the request instead.")
                    .font(.system(size: 11.5)).foregroundColor(.inkMuted)
            }
        }
        .formStyle(.grouped)
        .frame(width: 520, height: 460)
        .onAppear { repo = store.repoPath }
    }

    @ViewBuilder func tokenRow(_ kind: Keychain.Account, has: Bool) -> some View {
        if has {
            HStack {
                Label("Saved in Keychain", systemImage: "checkmark.seal.fill").foregroundColor(.okGreen)
                Spacer()
                Button("Remove") { store.saveToken(kind, "") }
            }
        } else {
            TokenPrompt(kind: kind)
        }
    }

    func apply() {
        store.repoPath = repo
        shots.repoPath = repo
    }
}
