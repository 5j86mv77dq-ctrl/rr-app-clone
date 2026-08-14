import SwiftUI

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

/// The designation badge. The slice is the mirror of the real app either way —
/// the label says whether that mirror is shipped ("prod") or in beta ("beta").
func prodBadge(_ label: String = "prod") -> Badge {
    Badge(text: label == "beta" ? "beta" : "prod",
          fg: .white,
          bg: label == "beta" ? .warnAmber : .okGreen)
}
var visionBadge: Badge { Badge(text: "vision", fg: .accentBlue, bg: .accentSoft) }
var staleBadge: Badge { Badge(text: "stale", fg: .white, bg: .dangerRed) }
var archivedBadge: Badge { Badge(text: "archived", fg: Color(hex: 0x77777C), bg: Color(hex: 0xECECEE)) }

struct Chip: View {
    let text: String
    var body: some View {
        Text(text)
            .font(.system(size: 11, weight: .semibold))
            .foregroundColor(Color(hex: 0x2C567E))
            .padding(.horizontal, 10).padding(.vertical, 3)
            .background(Color(hex: 0xEEF3F8))
            .overlay(Capsule().stroke(Color(hex: 0xD7E3EE), lineWidth: 1))
            .clipShape(Capsule())
    }
}

struct PillButton: View {
    let label: String
    var filled = false
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: 11, weight: .semibold))
                .padding(.horizontal, 11).padding(.vertical, 4)
                .background(filled ? Color.accentBlue : Color(hex: 0xF4F8FB))
                .foregroundColor(filled ? .white : .accentBlue)
                .overlay(Capsule().stroke(filled ? Color.accentBlue : Color(hex: 0xC9D9E8), lineWidth: 1))
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

struct PanelBox<Content: View>: View {
    let title: String
    @ViewBuilder var content: Content
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title.uppercased())
                .font(.system(size: 10, weight: .bold))
                .kerning(0.5)
                .foregroundColor(Color(hex: 0x8A8A90))
            content
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(nsColor: .textBackgroundColor))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black.opacity(0.08), lineWidth: 1))
    }
}

/// Minimal markdown-ish renderer for vision.md / decisions.md
struct MarkdownLite: View {
    let text: String
    var body: some View {
        VStack(alignment: .leading, spacing: 7) {
            ForEach(Array(text.components(separatedBy: "\n").enumerated()), id: \.offset) { _, raw in
                lineView(raw)
            }
        }
    }
    @ViewBuilder func lineView(_ raw: String) -> some View {
        let line = raw.trimmingCharacters(in: .whitespaces)
        if line.isEmpty {
            Spacer().frame(height: 2)
        } else if line.hasPrefix("# ") {
            Text(inline(String(line.dropFirst(2)))).font(.system(size: 17, weight: .bold))
        } else if line.hasPrefix("## ") {
            Text(inline(String(line.dropFirst(3)))).font(.system(size: 14, weight: .bold)).padding(.top, 4)
        } else if line.hasPrefix("> ") {
            Text(inline(String(line.dropFirst(2)))).font(.system(size: 11.5)).foregroundColor(.inkMuted)
        } else if line.hasPrefix("- ") {
            HStack(alignment: .top, spacing: 6) {
                Text("•").font(.system(size: 12))
                Text(inline(String(line.dropFirst(2)))).font(.system(size: 12.5))
            }
        } else if let n = line.first, n.isNumber, line.dropFirst().hasPrefix(". ") {
            Text(inline(line)).font(.system(size: 12.5))
        } else if line == "---" {
            Divider()
        } else {
            Text(inline(line)).font(.system(size: 12.5))
        }
    }
    func inline(_ s: String) -> AttributedString {
        (try? AttributedString(markdown: s, options: .init(interpretedSyntax: .inlineOnlyPreservingWhitespace))) ?? AttributedString(s)
    }
}
