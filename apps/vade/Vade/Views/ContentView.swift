import SwiftUI
import SwiftData

enum SidebarFilter: String, CaseIterable, Identifiable, Hashable {
    case home, upcoming, all, contract, insurance, warranty, archived

    var id: String { rawValue }

    var title: String {
        switch self {
        case .home: "Ana Sayfa"
        case .upcoming: "Yaklaşanlar"
        case .all: "Tümü"
        case .contract: ItemGroup.contract.title
        case .insurance: ItemGroup.insurance.title
        case .warranty: ItemGroup.warranty.title
        case .archived: "Arşiv"
        }
    }

    var symbol: String {
        switch self {
        case .home: "square.grid.2x2"
        case .upcoming: "calendar.badge.exclamationmark"
        case .all: "tray.full"
        case .contract: ItemGroup.contract.symbol
        case .insurance: ItemGroup.insurance.symbol
        case .warranty: ItemGroup.warranty.symbol
        case .archived: "archivebox"
        }
    }

    func includes(_ item: TrackedItem) -> Bool {
        switch self {
        case .archived: return item.isArchived
        case _ where item.isArchived: return false
        case .upcoming: return (item.daysLeft ?? .max) <= 90
        case .home, .all: return true
        case .contract: return item.category.group == .contract
        case .insurance: return item.category.group == .insurance
        case .warranty: return item.category.group == .warranty
        }
    }
}

struct ContentView: View {
    @Query private var allItems: [TrackedItem]
    @State private var filter: SidebarFilter? = .home
    @State private var selection: TrackedItem?
    @State private var showingAdd = false
    @State private var compactColumn = NavigationSplitViewColumn.content
    #if os(iOS)
    @Environment(\.horizontalSizeClass) private var sizeClass
    #endif

    var body: some View {
        NavigationSplitView(preferredCompactColumn: $compactColumn) {
            List(SidebarFilter.allCases, selection: $filter) { filter in
                NavigationLink(value: filter) {
                    if filter == .home {
                        Label(filter.title, systemImage: filter.symbol)
                    } else {
                        Label(filter.title, systemImage: filter.symbol)
                            .badge(allItems.filter(filter.includes).count)
                    }
                }
            }
            .navigationTitle("Vade")
        } content: {
            if (filter ?? .home) == .home {
                DashboardView(selection: $selection, showingAdd: $showingAdd)
            } else {
                ItemListView(filter: filter ?? .all, selection: $selection, showingAdd: $showingAdd)
            }
        } detail: {
            NavigationStack {
                if let selection {
                    ItemDetailView(item: selection, onDelete: { self.selection = nil })
                        .id(selection.id)
                } else {
                    ContentUnavailableView("Bir kayıt seç", systemImage: "doc.text.magnifyingglass",
                                           description: Text("Soldan bir sözleşme, poliçe veya garanti seç."))
                }
            }
        }
        .sheet(isPresented: $showingAdd) {
            AddItemFlow { created in selection = created }
        }
        // iPhone'da ana ekrandan bir kayda dokununca detay sayfasına geç.
        .onChange(of: selection) { _, item in
            if item != nil { compactColumn = .detail }
        }
        #if os(iOS)
        // Detaydan geri dönülünce seçimi bırak; aynı kayda tekrar dokunmak yeniden açsın.
        .onChange(of: compactColumn) { _, column in
            if sizeClass == .compact, column != .detail { selection = nil }
        }
        #endif
        .task {
            guard DemoData.isEnabled else { return }
            if DemoData.opensDetail {
                selection = allItems.sorted(by: TrackedItem.urgencyOrder)
                    .first { !($0.clauses ?? []).isEmpty && ($0.daysLeft ?? -1) >= 0 }
            }
            if DemoData.opensAdd { showingAdd = true }
        }
        .task(id: reminderSignature) {
            guard !DemoData.isEnabled else { return }
            await ReminderScheduler.sync(allItems)
        }
    }

    /// Hatırlatmayı etkileyen alanlardan biri değişince (bu cihazda veya iCloud'dan) bildirimleri yeniden kur.
    private var reminderSignature: String {
        allItems.map {
            "\($0.id)|\($0.title)|\($0.endDate?.timeIntervalSince1970 ?? 0)|\($0.reminderDays)|\($0.isArchived)|\($0.autoRenews)|\($0.cancellationNoticeDays)"
        }
        .sorted()
        .joined(separator: ";")
    }
}
