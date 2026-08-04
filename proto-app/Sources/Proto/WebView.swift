import SwiftUI
import WebKit

struct WebView: NSViewRepresentable {
    let url: URL?
    var pageZoom: CGFloat = 1.0

    func makeNSView(context: Context) -> WKWebView {
        let cfg = WKWebViewConfiguration()
        let wv = WKWebView(frame: .zero, configuration: cfg)
        wv.setValue(false, forKey: "drawsBackground")
        return wv
    }

    func updateNSView(_ wv: WKWebView, context: Context) {
        if abs(wv.pageZoom - pageZoom) > 0.01 { wv.pageZoom = pageZoom }
        guard let url else { return }
        if wv.url != url {
            wv.load(URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData))
        }
    }
}

/// Right-hand sidebar: history scrubber + local phone embed.
struct RightBar: View {
    @EnvironmentObject var repo: Repo
    let page: String            // page path to preview
    @State private var selectedSha: String? = nil
    @State private var entries: [HistoryEntry] = []

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("PREVIEW · LOCAL EMBED")
                .font(.system(size: 10, weight: .bold)).kerning(0.5)
                .foregroundColor(Color(hex: 0x8A8A90))

            Picker("", selection: $selectedSha) {
                Text("Latest — working tree").tag(String?.none)
                ForEach(entries) { h in
                    Text("\(h.date) · \(h.sha) — \(h.subject.prefix(38))").tag(String?.some(h.sha))
                }
            }
            .labelsHidden()

            // phone frame — the page is zoomed to fit so the FULL app is visible
            GeometryReader { g in
                // the prototype renders an iPhone frame ~420 CSS px wide, ~880 tall
                let zoom = max(0.25, min((g.size.width - 16) / 420, (g.size.height - 16) / 880))
                WebView(url: repo.previewURL(page: page, sha: selectedSha), pageZoom: zoom)
                    .clipShape(RoundedRectangle(cornerRadius: 22))
                    .padding(8)
                    .background(Color(hex: 0x0A1929))
                    .clipShape(RoundedRectangle(cornerRadius: 30))
            }
            .frame(maxHeight: .infinity)

            Text(selectedSha == nil
                 ? "Live from localhost:8000/\(page)"
                 : "Viewing \(selectedSha!) — rendered via git show")
                .font(.system(size: 10)).foregroundColor(.inkMuted)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(14)
        .background(Color(nsColor: .windowBackgroundColor))
        .onAppear { entries = repo.history(for: page); selectedSha = nil }
        .onChange(of: page) { _, newPage in
            entries = repo.history(for: newPage); selectedSha = nil
        }
    }
}
