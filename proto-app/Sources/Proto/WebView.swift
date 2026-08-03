import SwiftUI
import WebKit

struct WebView: NSViewRepresentable {
    let url: URL?

    func makeNSView(context: Context) -> WKWebView {
        let cfg = WKWebViewConfiguration()
        let wv = WKWebView(frame: .zero, configuration: cfg)
        wv.setValue(false, forKey: "drawsBackground")
        return wv
    }

    func updateNSView(_ wv: WKWebView, context: Context) {
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

            // phone frame
            VStack(spacing: 0) {
                WebView(url: repo.previewURL(page: page, sha: selectedSha))
                    .clipShape(RoundedRectangle(cornerRadius: 22))
            }
            .padding(8)
            .background(Color(hex: 0x0A1929))
            .clipShape(RoundedRectangle(cornerRadius: 30))
            .frame(maxHeight: .infinity)

            Text(selectedSha == nil
                 ? "Live from localhost:8000/\(page)"
                 : "Viewing \(selectedSha!) — rendered via git show")
                .font(.system(size: 10)).foregroundColor(.inkMuted)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(14)
        .frame(width: 430)
        .background(Color(nsColor: .windowBackgroundColor))
        .overlay(Rectangle().frame(width: 1).foregroundColor(.black.opacity(0.08)), alignment: .leading)
        .onAppear { entries = repo.history(for: page); selectedSha = nil }
        .onChange(of: page) { _, newPage in
            entries = repo.history(for: newPage); selectedSha = nil
        }
    }
}
