import AppKit
import WebKit

/// Card thumbnails. Each page is rendered once per file change in a hidden web view
/// (pages are React + Babel from a CDN, so they need a few seconds to draw) and cached as
/// a PNG in prototype-tmp/shots/. One render at a time keeps 10+ cards cheap.
@MainActor
final class Screenshots: NSObject, ObservableObject, WKNavigationDelegate {
    @Published private(set) var images: [String: NSImage] = [:]   // page → latest shot

    private var queue: [(page: String, key: String)] = []
    private var busy = false
    private var keys: [String: String] = [:]
    private var window: NSWindow?
    private var web: WKWebView?
    private var current: (page: String, key: String)?
    var repoPath = defaultRepoPath

    private var dir: String { repoPath + "/prototype-tmp/shots" }

    func image(for page: String) -> NSImage? { images[page] }

    /// Ask for a page's thumbnail; cheap to call on every refresh.
    func request(_ page: String) {
        let full = repoPath + "/" + page
        guard let attrs = try? FileManager.default.attributesOfItem(atPath: full),
              let mtime = attrs[.modificationDate] as? Date else { return }
        let key = slugify(page) + "-" + String(Int(mtime.timeIntervalSince1970))
        if keys[page] == key { return }
        keys[page] = key
        let png = "\(dir)/\(key).png"
        if let img = NSImage(contentsOfFile: png) {
            images[page] = img
            return
        }
        queue.append((page, key))
        pump()
    }

    private func pump() {
        guard !busy, !queue.isEmpty else { return }
        busy = true
        let job = queue.removeFirst()
        current = job
        if web == nil {
            let w = NSWindow(contentRect: NSRect(x: -4000, y: -4000, width: 430, height: 900),
                             styleMask: [.borderless], backing: .buffered, defer: false)
            let v = WKWebView(frame: NSRect(x: 0, y: 0, width: 430, height: 900))
            v.navigationDelegate = self
            w.contentView = v
            w.orderBack(nil)
            window = w
            web = v
        }
        guard let url = URL(string: "http://localhost:8000/\(job.page)") else { finish(nil); return }
        web?.load(URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData))
    }

    nonisolated func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        Task { @MainActor in
            // Babel compiles in the browser; give React time to paint.
            try? await Task.sleep(nanoseconds: 3_500_000_000)
            let cfg = WKSnapshotConfiguration()
            webView.takeSnapshot(with: cfg) { img, _ in
                Task { @MainActor in self.finish(img) }
            }
        }
    }

    nonisolated func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        Task { @MainActor in self.finish(nil) }
    }

    nonisolated func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        Task { @MainActor in self.finish(nil) }
    }

    private func finish(_ img: NSImage?) {
        if let job = current {
            if let img {
                images[job.page] = img
                try? FileManager.default.createDirectory(atPath: dir, withIntermediateDirectories: true)
                if let tiff = img.tiffRepresentation, let rep = NSBitmapImageRep(data: tiff),
                   let data = rep.representation(using: .png, properties: [:]) {
                    try? data.write(to: URL(fileURLWithPath: "\(dir)/\(job.key).png"))
                }
            } else {
                keys[job.page] = nil   // retry on the next refresh (server may not be up yet)
            }
        }
        current = nil
        busy = false
        pump()
    }
}
