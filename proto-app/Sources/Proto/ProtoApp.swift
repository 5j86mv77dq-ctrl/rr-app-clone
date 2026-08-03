import SwiftUI
import AppKit

@main
@MainActor
struct ProtoApp: App {
    @StateObject private var repo = Repo()

    init() {
        // headless verification: `Proto --dump` prints the parsed model and exits
        if CommandLine.arguments.contains("--dump") {
            let r = Repo()
            r.refresh()
            for p in r.pages {
                print("\(p.page) | \(p.pretty) | stage=\(p.stage) prod=\(p.isProduction) base=\(p.base)@\(p.baseCommit) staleCount=\(p.staleCount) funnel=\(p.funnel) updated=\(p.updated) deps=\(p.dependsOn) mismatches=\(p.fmMismatches)")
            }
            if let e = r.loadError { print("ERROR: \(e)") }
            print("branch=\(r.branch) dirty=\(r.dirty) warnings=\(r.integrityWarnings.count)")
            exit(0)
        }
    }

    var body: some Scene {
        WindowGroup("Proto") {
            RootView()
                .environmentObject(repo)
                .onAppear { repo.refresh() }
                .frame(minWidth: 1050, minHeight: 660)
        }
        .defaultSize(width: 1280, height: 800)
    }
}

struct RootView: View {
    @EnvironmentObject var repo: Repo
    @State private var screen: Screen = .slices
    @State private var selected: SliceEntry? = nil
    @State private var sidebarVisible = true
    @State private var embedVisible = true
    @State private var showSettings = false
    @State private var toastText: String? = nil

    var previewPage: String? {
        if screen == .vision { return "index.html" }
        if selected != nil { return selected!.page }
        return nil
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            HStack(spacing: 0) {
                if sidebarVisible { sidebar.transition(.move(edge: .leading)) }
                content
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .background(Color(nsColor: .windowBackgroundColor))
                if embedVisible, let page = previewPage {
                    RightBar(page: page)
                }
            }

            // floating settings gear
            HStack {
                Button { showSettings = true } label: {
                    Image(systemName: "gearshape")
                        .font(.system(size: 14))
                        .frame(width: 34, height: 34)
                        .background(Color(nsColor: .textBackgroundColor))
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.black.opacity(0.12), lineWidth: 1))
                        .shadow(color: .black.opacity(0.15), radius: 4, y: 2)
                }
                .buttonStyle(.plain)
                .padding(12)
                Spacer()
                if let t = toastText {
                    Text(t)
                        .font(.system(size: 12)).foregroundColor(.white)
                        .padding(.horizontal, 14).padding(.vertical, 8)
                        .background(Color(hex: 0x2C2C2E)).clipShape(RoundedRectangle(cornerRadius: 9))
                        .padding(.bottom, 16)
                        .transition(.opacity)
                    Spacer()
                    Color.clear.frame(width: 58, height: 1)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button { withAnimation(.easeInOut(duration: 0.2)) { sidebarVisible.toggle() } } label: {
                    Image(systemName: "sidebar.left")
                }
                .help("Toggle sidebar")
            }
            ToolbarItem(placement: .primaryAction) {
                Button { withAnimation(.easeInOut(duration: 0.2)) { embedVisible.toggle() } } label: {
                    Image(systemName: "sidebar.right")
                }
                .help("Toggle local embed + history")
            }
        }
        .sheet(isPresented: $showSettings) { SettingsSheet(toast: toast).environmentObject(repo) }
        .onReceive(NotificationCenter.default.publisher(for: NSApplication.didBecomeActiveNotification)) { _ in
            repo.refresh()
        }
    }

    var sidebar: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("WORKSPACE")
                .font(.system(size: 10, weight: .bold)).kerning(0.6)
                .foregroundColor(Color(hex: 0x98989D))
                .padding(.horizontal, 10).padding(.top, 12).padding(.bottom, 4)
            ForEach(Screen.allCases, id: \.self) { s in
                Button {
                    screen = s
                    if s != .slices { selected = nil }
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: s.icon).frame(width: 16)
                        Text(s.rawValue).font(.system(size: 13))
                        Spacer()
                    }
                    .padding(.horizontal, 9).padding(.vertical, 6)
                    .background(isActive(s) ? Color.accentBlue : Color.clear)
                    .foregroundColor(isActive(s) ? .white : .primary)
                    .clipShape(RoundedRectangle(cornerRadius: 7))
                }
                .buttonStyle(.plain)
            }
            Spacer()
        }
        .padding(.horizontal, 10)
        .frame(width: 200)
        .background(Color(nsColor: .windowBackgroundColor).opacity(0.6))
        .overlay(Rectangle().frame(width: 1).foregroundColor(.black.opacity(0.08)), alignment: .trailing)
    }

    func isActive(_ s: Screen) -> Bool {
        if s == .slices { return screen == .slices }
        return screen == s
    }

    @ViewBuilder var content: some View {
        if let sel = selected, screen == .slices {
            DetailView(entry: repo.pages.first(where: { $0.page == sel.page }) ?? sel,
                       back: { selected = nil }, toast: toast)
        } else {
            switch screen {
            case .slices: BoardView(open: { selected = $0 }, toast: toast)
            case .graph: GraphView(open: { selected = $0; screen = .slices })
            case .vision: VisionView(toast: toast)
            case .manual: ManualView()
            case .tasks: TasksView()
            }
        }
    }

    func toast(_ s: String) {
        withAnimation { toastText = s }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.6) {
            withAnimation { toastText = nil }
        }
    }
}
