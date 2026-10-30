import SwiftUI
import SwiftData

enum SidebarFilter: String, CaseIterable, Identifiable, Hashable {
    case upcoming, all, contract, insurance, warranty, archived

    var id: String { rawValue }

    var title: String {
        switch self {
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
        case .all: return true
        case .contract: return item.category.group == .contract
        case .insurance: return item.category.group == .insurance
        case .warranty: return item.category.group == .warranty
        }
    }
}

struct ContentView: View {
    @Query private var allItems: [TrackedItem]
    @State private var filter: SidebarFilter? = .upcoming
    @State private var selection: TrackedItem?
    @State private var showingAdd = false
    @State private var compactColumn = NavigationSplitViewColumn.content

    var body: some View {
        NavigationSplitView(preferredCompactColumn: $compactColumn) {
            List(SidebarFilter.allCases, selection: $filter) { filter in
                NavigationLink(value: filter) {
                    Label(filter.title, systemImage: filter.symbol)
                        .badge(allItems.filter(filter.includes).count)
                }
            }
            .navigationTitle("Vade")
        } content: {
            ItemListView(filter: filter ?? .all, selection: $selection, showingAdd: $showingAdd)
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
        .task(id: reminderSignature) {
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
