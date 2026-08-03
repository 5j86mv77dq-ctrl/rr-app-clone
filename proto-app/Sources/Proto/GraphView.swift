import SwiftUI

struct PlannedCard: Identifiable, Codable, Equatable {
    var id: String
    var name: String
}

struct GraphView: View {
    @EnvironmentObject var repo: Repo
    let open: (SliceEntry) -> Void
    let toast: (String) -> Void
    @AppStorage("plannedCards") private var plannedRaw = "[]"
    @State private var newName = ""

    var planned: [PlannedCard] {
        (try? JSONDecoder().decode([PlannedCard].self, from: Data(plannedRaw.utf8))) ?? []
    }
    func savePlanned(_ cards: [PlannedCard]) {
        if let d = try? JSONEncoder().encode(cards) { plannedRaw = String(data: d, encoding: .utf8) ?? "[]" }
    }

    var prod: [SliceEntry] { repo.pages.filter { $0.isProduction } }
    var inFlight: [SliceEntry] {
        repo.pages.filter { !$0.isMain && !$0.isProduction && ["draft", "in-review", "in-dev"].contains($0.stage) }
    }

    let cardW: CGFloat = 200
    let cardH: CGFloat = 96
    let topY: CGFloat = 96

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // add-card entry
            HStack(spacing: 8) {
                TextField("Add a planned card — a feature you intend to build…", text: $newName)
                    .textFieldStyle(.roundedBorder)
                    .frame(maxWidth: 420)
                    .onSubmit(addCard)
                Button("Add card", action: addCard)
                    .disabled(newName.trimmingCharacters(in: .whitespaces).isEmpty)
                Spacer()
            }

            GeometryReader { geo in
                let pos = positions(in: geo.size)
                ZStack(alignment: .topLeading) {
                    Color(nsColor: .textBackgroundColor)

                    // lane headers
                    laneHeader("SHIPPING NOW", x: colX(0, geo), sub: "current production")
                    laneHeader("IN FLIGHT", x: colX(1, geo), sub: "draft · in review · in dev")
                    laneHeader("PLANNED", x: colX(2, geo), sub: "the build sequence — top first")

                    // edges
                    Canvas { ctx, _ in
                        // dependsOn: amber dashed, dependent → needed
                        for e in repo.pages {
                            guard let from = pos[e.page] else { continue }
                            for d in e.dependsOn {
                                if let to = pos[d] { edge(ctx, from, to, .warnAmber, dashed: true) }
                            }
                        }
                        // basis (only when the base is another slice — otherwise it's the chip)
                        for e in prod + inFlight {
                            guard !e.basePath.isEmpty, e.basePath != "index.html",
                                  let from = pos[e.page], let to = pos[e.basePath] else { continue }
                            edge(ctx, from, to, .accentBlue, dashed: false, thin: true)
                        }
                        // planned sequence: grey arrows top → down
                        let ps = planned
                        for i in 1..<max(ps.count, 1) {
                            if let a = pos["planned:" + ps[i-1].id], let b = pos["planned:" + ps[i].id] {
                                edge(ctx, a, b, Color(hex: 0xB6B6BC), dashed: false)
                            }
                        }
                    }

                    // real cards
                    ForEach(prod + inFlight) { e in
                        realCard(e)
                            .frame(width: cardW)
                            .position(pos[e.page] ?? .zero)
                            .onTapGesture { open(e) }
                    }
                    // planned cards
                    ForEach(planned) { c in
                        plannedCardView(c)
                            .frame(width: cardW)
                            .position(pos["planned:" + c.id] ?? .zero)
                    }

                    if planned.isEmpty {
                        Text("No planned cards yet — add the next things you intend to build, in order.")
                            .font(.system(size: 11)).foregroundColor(.inkMuted)
                            .position(x: colX(2, geo), y: topY + 40)
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 11))
                .overlay(RoundedRectangle(cornerRadius: 11).stroke(Color.black.opacity(0.08), lineWidth: 1))
            }

            HStack(spacing: 18) {
                legendSwatch(Color.warnAmber, dashed: true, label: "depends on (must ship first)")
                legendSwatch(Color.accentBlue, dashed: false, label: "based on another slice (off the Vision shows as a chip)")
                legendSwatch(Color(hex: 0xB6B6BC), dashed: false, label: "planned sequence")
                Text("Planned cards live in Proto until ⧉ creates the real slice via Claude Code.")
            }
            .font(.system(size: 11)).foregroundColor(.inkMuted)
        }
        .padding(18)
    }

    // MARK: layout

    func colX(_ i: Int, _ geo: GeometryProxy) -> CGFloat {
        let fractions: [CGFloat] = [0.17, 0.5, 0.83]
        return geo.size.width * fractions[i]
    }

    func positions(in size: CGSize) -> [String: CGPoint] {
        var pos: [String: CGPoint] = [:]
        let fractions: [CGFloat] = [0.17, 0.5, 0.83]
        for (i, e) in prod.enumerated() {
            pos[e.page] = CGPoint(x: size.width * fractions[0], y: topY + CGFloat(i) * (cardH + 40) + cardH / 2)
        }
        for (i, e) in inFlight.enumerated() {
            pos[e.page] = CGPoint(x: size.width * fractions[1], y: topY + CGFloat(i) * (cardH + 34) + cardH / 2)
        }
        for (i, c) in planned.enumerated() {
            pos["planned:" + c.id] = CGPoint(x: size.width * fractions[2], y: topY + CGFloat(i) * (cardH + 34) + cardH / 2)
        }
        return pos
    }

    func laneHeader(_ title: String, x: CGFloat, sub: String) -> some View {
        VStack(spacing: 2) {
            Text(title).font(.system(size: 10.5, weight: .bold)).kerning(0.6).foregroundColor(Color(hex: 0x98989D))
            Text(sub).font(.system(size: 10)).foregroundColor(Color(hex: 0xB6B6BC))
        }
        .position(x: x, y: 34)
    }

    // MARK: cards

    func realCard(_ e: SliceEntry) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(e.pretty).font(.system(size: 12.5, weight: .semibold)).lineLimit(2)
            HStack(spacing: 4) {
                stageBadge(e.stage)
                if e.isProduction { prodBadge }
                if e.isStale { staleBadge }
            }
            if !e.base.isEmpty {
                Text("off \(e.base)")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(Color(hex: 0x2C567E))
                    .padding(.horizontal, 7).padding(.vertical, 2)
                    .background(Color(hex: 0xEEF3F8))
                    .clipShape(Capsule())
            }
        }
        .padding(10)
        .frame(width: cardW, alignment: .leading)
        .background(Color(nsColor: .textBackgroundColor))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(RoundedRectangle(cornerRadius: 10)
            .stroke(e.isProduction ? Color.okGreen : Color.black.opacity(0.12), lineWidth: 1.5))
        .shadow(color: .black.opacity(0.08), radius: 4, y: 2)
        .contentShape(Rectangle())
    }

    func plannedCardView(_ c: PlannedCard) -> some View {
        VStack(alignment: .leading, spacing: 7) {
            Text(c.name).font(.system(size: 12.5, weight: .semibold)).lineLimit(2)
            Badge(text: "planned", fg: Color(hex: 0x8A8A90), bg: Color(hex: 0xECECEF))
            HStack(spacing: 6) {
                Button {
                    repo.copyToClipboard("New slice: \(c.name). Walk me through the ritual: one-off (copy current production — default), a piece of a bigger feature (copy the piece it depends on), or off the Vision? Confirm basis and any dependsOn with me, then create it as draft with front matter + MANIFEST entry.")
                    toast("Create-slice prompt copied — paste into Claude Code")
                } label: {
                    Label("Create slice", systemImage: "doc.on.doc").font(.system(size: 10.5, weight: .semibold))
                }
                Button {
                    savePlanned(planned.filter { $0.id != c.id })
                } label: {
                    Image(systemName: "xmark").font(.system(size: 9, weight: .bold)).foregroundColor(.inkMuted)
                }
            }
        }
        .padding(10)
        .frame(width: cardW, alignment: .leading)
        .background(Color(nsColor: .textBackgroundColor).opacity(0.7))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(RoundedRectangle(cornerRadius: 10)
            .stroke(style: StrokeStyle(lineWidth: 1.5, dash: [5, 4]))
            .foregroundColor(Color(hex: 0xB6B6BC)))
    }

    func addCard() {
        let name = newName.trimmingCharacters(in: .whitespaces)
        guard !name.isEmpty else { return }
        savePlanned(planned + [PlannedCard(id: UUID().uuidString, name: name)])
        newName = ""
        toast("Card added — ⧉ on it when you're ready to make it a slice")
    }

    // MARK: edges

    func edge(_ ctx: GraphicsContext, _ a: CGPoint, _ b: CGPoint, _ color: Color, dashed: Bool, thin: Bool = false) {
        let dx = b.x - a.x, dy = b.y - a.y
        let len = max(sqrt(dx * dx + dy * dy), 1)
        let ux = dx / len, uy = dy / len
        let start = CGPoint(x: a.x + ux * (cardW / 2 - 30), y: a.y + uy * (cardH / 2))
        let end = CGPoint(x: b.x - ux * (cardW / 2 + 8), y: b.y - uy * (cardH / 2 + 8))
        var path = Path()
        path.move(to: start)
        path.addLine(to: end)
        ctx.stroke(path, with: .color(color), style: StrokeStyle(lineWidth: thin ? 1.5 : 2, dash: dashed ? [6, 5] : []))
        var head = Path()
        let angle = atan2(end.y - start.y, end.x - start.x)
        head.move(to: end)
        head.addLine(to: CGPoint(x: end.x - 8 * cos(angle - 0.42), y: end.y - 8 * sin(angle - 0.42)))
        head.addLine(to: CGPoint(x: end.x - 8 * cos(angle + 0.42), y: end.y - 8 * sin(angle + 0.42)))
        head.closeSubpath()
        ctx.fill(head, with: .color(color))
    }

    func legendSwatch(_ c: Color, dashed: Bool, label: String) -> some View {
        HStack(spacing: 6) {
            Rectangle().fill(c).frame(width: 24, height: 2)
                .mask(dashed ? AnyView(HStack(spacing: 3) { ForEach(0..<4, id: \.self) { _ in Rectangle().frame(width: 4) } }) : AnyView(Rectangle()))
            Text(label)
        }
    }
}
