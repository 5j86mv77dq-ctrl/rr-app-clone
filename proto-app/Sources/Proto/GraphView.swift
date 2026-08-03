import SwiftUI

struct GraphView: View {
    @EnvironmentObject var repo: Repo
    let open: (SliceEntry) -> Void
    @State private var positions: [String: CGPoint] = [:]
    @State private var dragStart: [String: CGPoint] = [:]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            GeometryReader { geo in
                ZStack {
                    Color(nsColor: .textBackgroundColor)
                    edgesCanvas
                    ForEach(repo.pages) { e in
                        nodeCard(e)
                            .position(position(e, in: geo.size))
                            .gesture(dragGesture(e, in: geo.size))
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 11))
                .overlay(RoundedRectangle(cornerRadius: 11).stroke(Color.black.opacity(0.08), lineWidth: 1))
            }
            HStack(spacing: 20) {
                HStack(spacing: 6) {
                    Rectangle().fill(Color.accentBlue).frame(width: 26, height: 2)
                    Text("based on (lineage)")
                }
                HStack(spacing: 6) {
                    Line(dashed: true).stroke(style: StrokeStyle(lineWidth: 2, dash: [6, 5])).foregroundColor(.warnAmber).frame(width: 26, height: 2)
                    Text("depends on (ship order)")
                }
                Text("Drag cards to arrange · click a card to open it")
            }
            .font(.system(size: 11)).foregroundColor(.inkMuted)
        }
        .padding(18)
    }

    struct Line: Shape {
        var dashed = false
        func path(in rect: CGRect) -> Path {
            var p = Path()
            p.move(to: CGPoint(x: 0, y: rect.midY))
            p.addLine(to: CGPoint(x: rect.width, y: rect.midY))
            return p
        }
    }

    // MARK: layout

    func defaultPosition(_ e: SliceEntry, in size: CGSize) -> CGPoint {
        let w = max(size.width, 600), h = max(size.height, 400)
        if e.isMain { return CGPoint(x: w * 0.5, y: h * 0.12) }
        let others = repo.pages.filter { !$0.isMain }
        let idx = others.firstIndex(where: { $0.page == e.page }) ?? 0
        let cols = max(1, others.count)
        let x = w * (0.5 + (CGFloat(idx) - CGFloat(cols - 1) / 2) * (0.8 / CGFloat(max(cols - 1, 1))))
        let y = h * (idx % 2 == 0 ? 0.5 : 0.72)
        return CGPoint(x: min(max(x, 90), w - 90), y: y)
    }

    func position(_ e: SliceEntry, in size: CGSize) -> CGPoint {
        positions[e.page] ?? defaultPosition(e, in: size)
    }

    func dragGesture(_ e: SliceEntry, in size: CGSize) -> some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { v in
                let start = dragStart[e.page] ?? position(e, in: size)
                if dragStart[e.page] == nil { dragStart[e.page] = start }
                positions[e.page] = CGPoint(x: start.x + v.translation.width, y: start.y + v.translation.height)
            }
            .onEnded { v in
                dragStart[e.page] = nil
                if abs(v.translation.width) + abs(v.translation.height) < 4 {
                    if !e.isMain { open(e) }
                }
            }
    }

    // MARK: drawing

    var edgesCanvas: some View {
        GeometryReader { geo in
            Canvas { ctx, _ in
                let byPage = Dictionary(uniqueKeysWithValues: repo.pages.map { ($0.page, $0) })
                for e in repo.pages {
                    // based-on edge → base page node (if it exists as a page)
                    if !e.basePath.isEmpty, byPage[e.basePath] != nil {
                        drawEdge(ctx, from: position(e, in: geo.size),
                                 to: position(byPage[e.basePath]!, in: geo.size),
                                 color: Color.accentBlue, dashed: false)
                    }
                    for d in e.dependsOn {
                        if let target = byPage[d] {
                            drawEdge(ctx, from: position(e, in: geo.size),
                                     to: position(target, in: geo.size),
                                     color: Color.warnAmber, dashed: true, bow: 40)
                        }
                    }
                }
            }
        }
    }

    func drawEdge(_ ctx: GraphicsContext, from a: CGPoint, to b: CGPoint, color: Color, dashed: Bool, bow: CGFloat = 0) {
        let dx = b.x - a.x, dy = b.y - a.y
        let len = max(sqrt(dx * dx + dy * dy), 1)
        let ux = dx / len, uy = dy / len
        let start = CGPoint(x: a.x + ux * 45, y: a.y + uy * 45)
        let end = CGPoint(x: b.x - ux * 70, y: b.y - uy * 70)
        var path = Path()
        path.move(to: start)
        if bow != 0 {
            let mid = CGPoint(x: (start.x + end.x) / 2 - uy * bow, y: (start.y + end.y) / 2 + ux * bow)
            path.addQuadCurve(to: end, control: mid)
        } else {
            path.addLine(to: end)
        }
        let style = StrokeStyle(lineWidth: 2, dash: dashed ? [6, 5] : [])
        ctx.stroke(path, with: .color(color), style: style)
        // arrowhead
        var head = Path()
        let angle = atan2(end.y - start.y, end.x - start.x)
        head.move(to: end)
        head.addLine(to: CGPoint(x: end.x - 9 * cos(angle - 0.42), y: end.y - 9 * sin(angle - 0.42)))
        head.addLine(to: CGPoint(x: end.x - 9 * cos(angle + 0.42), y: end.y - 9 * sin(angle + 0.42)))
        head.closeSubpath()
        ctx.fill(head, with: .color(color))
    }

    func nodeCard(_ e: SliceEntry) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(e.isMain ? "The Vision" : e.pretty)
                .font(.system(size: 12, weight: .semibold))
                .lineLimit(2)
            VStack(alignment: .leading, spacing: 3) {
                stageBadge(e.stage)
                if e.isProduction { prodBadge }
                if e.isStale { staleBadge }
            }
        }
        .padding(10)
        .frame(width: 150, alignment: .leading)
        .background(e.isMain ? Color.accentSoft : Color(nsColor: .textBackgroundColor))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(RoundedRectangle(cornerRadius: 10)
            .stroke(e.isMain ? Color.accentBlue : e.isProduction ? Color.okGreen : Color.black.opacity(0.12), lineWidth: 1.5))
        .shadow(color: .black.opacity(0.09), radius: 4, y: 2)
    }
}
