import SwiftUI
import WebKit

extension Color {
    init(hex: UInt32) {
        self.init(.sRGB,
                  red: Double((hex >> 16) & 0xFF) / 255,
                  green: Double((hex >> 8) & 0xFF) / 255,
                  blue: Double(hex & 0xFF) / 255)
    }
    static let accentBlue = Color(hex: 0x3B6FA0)
    static let accentSoft = Color(hex: 0xEAF1F7)
    static let okGreen = Color(hex: 0x2E7D32)
    static let greenSoft = Color(hex: 0xE7F3E8)
    static let warnAmber = Color(hex: 0xC77700)
    static let amberSoft = Color(hex: 0xFBECCD)
    static let revPurple = Color(hex: 0x7B3FA0)
    static let purpleSoft = Color(hex: 0xF3E8F7)
    static let shipTeal = Color(hex: 0x1A6B78)
    static let tealSoft = Color(hex: 0xE3F0F2)
    static let dangerRed = Color(hex: 0xC94F42)
    static let inkMuted = Color(hex: 0x6E6E73)
    static let phoneDark = Color(hex: 0x0A1929)
}

struct Badge: View {
    let text: String
    let fg: Color
    let bg: Color
    var body: some View {
        Text(text.uppercased())
            .font(.system(size: 9, weight: .bold))
            .kerning(0.4)
            .padding(.horizontal, 7).padding(.vertical, 2.5)
            .background(bg)
            .foregroundColor(fg)
            .clipShape(Capsule())
    }
}

func stageBadge(_ s: Stage) -> Badge {
    switch s {
    case .looks: return Badge(text: s.label, fg: .revPurple, bg: .purpleSoft)
    case .building: return Badge(text: s.label, fg: .accentBlue, bg: .accentSoft)
    case .testing: return Badge(text: s.label, fg: .warnAmber, bg: .amberSoft)
    case .kept: return Badge(text: s.label, fg: .okGreen, bg: .greenSoft)
    case .shipped: return Badge(text: s.label, fg: .shipTeal, bg: .tealSoft)
    case .archived: return Badge(text: s.label, fg: Color(hex: 0x77777C), bg: Color(hex: 0xECECEE))
    }
}

struct PillButton: View {
    let label: String
    var icon: String? = nil
    var filled = false
    var tint: Color = .accentBlue
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                if let icon { Image(systemName: icon).font(.system(size: 10, weight: .semibold)) }
                Text(label).font(.system(size: 11.5, weight: .semibold)).lineLimit(1).fixedSize()
            }
            .padding(.horizontal, 11).padding(.vertical, 5)
            .background(filled ? tint : Color(hex: 0xF4F8FB))
            .foregroundColor(filled ? .white : tint)
            .overlay(Capsule().stroke(filled ? tint : Color(hex: 0xC9D9E8), lineWidth: 1))
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

struct SectionTitle: View {
    let text: String
    var count: Int? = nil
    var body: some View {
        HStack(spacing: 6) {
            Text(text.uppercased())
                .font(.system(size: 10.5, weight: .bold)).kerning(0.6)
                .foregroundColor(Color(hex: 0x8A8A90))
            if let count { Text("\(count)").font(.system(size: 10.5, weight: .semibold)).foregroundColor(.inkMuted) }
        }
    }
}

struct Panel<Content: View>: View {
    @ViewBuilder var content: Content
    var body: some View {
        content
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(nsColor: .textBackgroundColor))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.black.opacity(0.08), lineWidth: 1))
    }
}

struct WebView: NSViewRepresentable {
    let url: URL?
    var pageZoom: CGFloat = 1.0

    func makeNSView(context: Context) -> WKWebView {
        let wv = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        wv.setValue(false, forKey: "drawsBackground")
        return wv
    }

    func updateNSView(_ wv: WKWebView, context: Context) {
        if abs(wv.pageZoom - pageZoom) > 0.01 { wv.pageZoom = pageZoom }
        guard let url, wv.url != url else { return }
        wv.load(URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData))
    }
}

/// A live, zoomed-to-fit render of a page inside a dark phone surround.
struct PhonePreview: View {
    let url: URL?
    var body: some View {
        GeometryReader { g in
            // prototype pages draw an iPhone frame ~420 CSS px wide, ~880 tall
            let zoom = max(0.25, min((g.size.width - 16) / 420, (g.size.height - 16) / 880))
            WebView(url: url, pageZoom: zoom)
                .clipShape(RoundedRectangle(cornerRadius: 22))
                .padding(8)
                .background(Color.phoneDark)
                .clipShape(RoundedRectangle(cornerRadius: 30))
        }
    }
}

/// Lays children left to right and wraps to a new line when the row is full.
struct Flow: Layout {
    var spacing: CGFloat = 6

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let rows = arrange(width: proposal.width ?? .infinity, subviews)
        return CGSize(width: rows.map(\.width).max() ?? 0,
                      height: rows.map(\.height).reduce(0, +) + spacing * CGFloat(max(rows.count - 1, 0)))
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var y = bounds.minY
        for row in arrange(width: bounds.width, subviews) {
            var x = bounds.minX
            for i in row.items {
                let s = subviews[i].sizeThatFits(.unspecified)
                subviews[i].place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(s))
                x += s.width + spacing
            }
            y += row.height + spacing
        }
    }

    private func arrange(width: CGFloat, _ subviews: Subviews) -> [(items: [Int], width: CGFloat, height: CGFloat)] {
        var rows: [(items: [Int], width: CGFloat, height: CGFloat)] = []
        var cur: (items: [Int], width: CGFloat, height: CGFloat) = ([], 0, 0)
        for i in subviews.indices {
            let s = subviews[i].sizeThatFits(.unspecified)
            let needed = cur.items.isEmpty ? s.width : cur.width + spacing + s.width
            if needed > width, !cur.items.isEmpty {
                rows.append(cur)
                cur = ([i], s.width, s.height)
            } else {
                cur = (cur.items + [i], needed, max(cur.height, s.height))
            }
        }
        if !cur.items.isEmpty { rows.append(cur) }
        return rows
    }
}
