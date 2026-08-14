import SwiftUI
import AppKit

// Spreadsheet rows: name · ClickUp link · slice tag. Edited in place; every commit
// writes Roadmap/prds.md. Nobody ever opens that file.

private let rowHeight: CGFloat = 30

/// Draggable column widths, remembered across launches. The last column takes the rest.
final class PRDColumns: ObservableObject {
    @AppStorage("prdColName") var name: Double = 340
    @AppStorage("prdColLink") var link: Double = 300
    static let shared = PRDColumns()
}

/// The 6px grabber that sits between two header cells.
struct ColumnDivider: View {
    @Binding var width: Double
    var minWidth: Double = 120
    var maxWidth: Double = 700
    @State private var start: Double? = nil

    var body: some View {
        Rectangle()
            .fill(Color.black.opacity(0.001))
            .frame(width: 7)
            .overlay(Rectangle().frame(width: 1).foregroundColor(.black.opacity(0.10)))
            .onHover { $0 ? NSCursor.resizeLeftRight.push() : NSCursor.pop() }
            .gesture(
                DragGesture(minimumDistance: 1)
                    .onChanged { v in
                        if start == nil { start = width }
                        width = min(maxWidth, max(minWidth, (start ?? width) + v.translation.width))
                    }
                    .onEnded { _ in start = nil }
            )
    }
}

/// Short tag text for a slice: "slices/video-on-demand.html" → "video-on-demand".
func sliceTag(_ page: String) -> String {
    (page as NSString).lastPathComponent.replacingOccurrences(of: ".html", with: "")
}

// MARK: - One editable row

struct PRDRowView: View {
    @EnvironmentObject var repo: Repo
    @ObservedObject var cols = PRDColumns.shared
    let prd: PRDEntry
    let index: Int
    var showSlice = true
    let toast: (String) -> Void

    @State private var name = ""
    @State private var link = ""
    @State private var hovering = false
    @FocusState private var focus: Field?
    private enum Field { case name, link }

    var body: some View {
        HStack(spacing: 0) {
            TextField("", text: $name)
                .textFieldStyle(.plain)
                .font(.system(size: 12.5))
                .focused($focus, equals: .name)
                .onSubmit { commit() }
                .padding(.horizontal, 10)
                .frame(width: cols.name, alignment: .leading)

            Color.clear.frame(width: 7)

            HStack(spacing: 5) {
                TextField("clickup.com/…", text: $link)
                    .textFieldStyle(.plain)
                    .font(.system(size: 11.5))
                    .foregroundColor(prd.hasClickUp ? .accentBlue : .primary)
                    .focused($focus, equals: .link)
                    .onSubmit { commit() }
                    .lineLimit(1)
                if prd.hasClickUp {
                    Button { repo.openURL(prd.clickup) } label: {
                        Image(systemName: "arrow.up.right.square").font(.system(size: 11))
                    }
                    .buttonStyle(.plain).foregroundColor(.accentBlue)
                    .help(prd.clickup)
                }
            }
            .padding(.horizontal, 10)
            .frame(minWidth: showSlice ? cols.link : nil,
                   maxWidth: showSlice ? cols.link : .infinity, alignment: .leading)

            if showSlice {
                Color.clear.frame(width: 7)
                Menu {
                    Button("— none —") { setSlice(nil) }
                    ForEach(repo.pages.filter { !$0.isMain && !$0.archived }) { s in
                        Button(s.pretty) { setSlice(s.page) }
                    }
                } label: {
                    if prd.slice.isEmpty {
                        Text("—").font(.system(size: 11.5)).foregroundColor(.inkMuted)
                    } else {
                        Tag(text: sliceTag(prd.slice))
                    }
                }
                .menuStyle(.button).buttonStyle(.plain).fixedSize()
                .help(prd.slice.isEmpty ? "Pick a slice" : prd.slice)
                .padding(.horizontal, 10)
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            Button { repo.removePRD(prd.name) } label: {
                Image(systemName: "xmark").font(.system(size: 9, weight: .bold))
            }
            .buttonStyle(.plain).foregroundColor(.inkMuted)
            .opacity(hovering ? 1 : 0)
            .frame(width: 26)
        }
        .frame(height: rowHeight)
        .background(hovering ? Color.primary.opacity(0.03) : Color.clear)
        .onHover { hovering = $0 }
        .onAppear { name = prd.name; link = prd.clickup }
        .onChange(of: prd) { _, p in
            if focus == nil { name = p.name; link = p.clickup }
        }
        .onChange(of: focus) { old, new in
            if old != nil && new == nil { commit() }
        }
    }

    func commit() {
        guard name != prd.name || link != prd.clickup else { return }
        if let err = repo.updatePRD(at: index, PRDEntry(name: name, clickup: link, slices: prd.slices)) {
            toast(err)
            name = prd.name; link = prd.clickup
        }
    }

    func setSlice(_ page: String?) {
        repo.updatePRD(at: index, PRDEntry(name: prd.name, clickup: prd.clickup,
                                           slices: page.map { [$0] } ?? []))
    }
}

// MARK: - The table (shared by the tab and the slice detail)

struct PRDTable: View {
    @EnvironmentObject var repo: Repo
    var rows: [PRDEntry]
    var showSlice = true
    var addToSlice: String? = nil
    let toast: (String) -> Void

    var body: some View {
        VStack(spacing: 0) {
            ForEach(rows) { p in
                if let i = repo.prds.firstIndex(of: p) {
                    PRDRowView(prd: p, index: i, showSlice: showSlice, toast: toast)
                    Divider().opacity(0.5)
                }
            }
            Button {
                repo.addBlankPRD(slice: addToSlice)
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "plus").font(.system(size: 9, weight: .bold))
                    Text("New PRD").font(.system(size: 11.5))
                    Spacer()
                }
                .foregroundColor(.inkMuted)
                .padding(.horizontal, 10)
                .frame(height: rowHeight)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        }
        .background(Color(nsColor: .textBackgroundColor))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.black.opacity(0.08), lineWidth: 1))
    }
}

/// Header row with draggable dividers. `showSlice: false` hides the third column.
struct PRDHeader: View {
    @ObservedObject var cols = PRDColumns.shared
    var showSlice = true

    var body: some View {
        HStack(spacing: 0) {
            head("Name").padding(.horizontal, 10).frame(width: cols.name, alignment: .leading)
            ColumnDivider(width: $cols.name)
            head("ClickUp").padding(.horizontal, 10)
                .frame(minWidth: showSlice ? cols.link : nil,
                       maxWidth: showSlice ? cols.link : .infinity, alignment: .leading)
            if showSlice {
                ColumnDivider(width: $cols.link)
                head("Slice").padding(.horizontal, 10).frame(maxWidth: .infinity, alignment: .leading)
            }
            Color.clear.frame(width: 26)
        }
        .frame(height: 20)
    }

    func head(_ s: String) -> some View {
        Text(s.uppercased()).font(.system(size: 9.5, weight: .bold)).kerning(0.5)
            .foregroundColor(Color(hex: 0x98989D))
    }
}

// MARK: - On a slice: name + link only

struct PRDPanel: View {
    @EnvironmentObject var repo: Repo
    let page: String
    let toast: (String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            PRDHeader(showSlice: false)
            PRDTable(rows: repo.prds(for: page), showSlice: false, addToSlice: page, toast: toast)
        }
    }
}

// MARK: - The tab: every PRD

struct PRDsView: View {
    @EnvironmentObject var repo: Repo
    let toast: (String) -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 6) {
                Text("PRDs").font(.system(size: 18, weight: .bold)).padding(.bottom, 2)
                PRDHeader()
                PRDTable(rows: repo.prds, toast: toast)
            }
            .padding(18)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
