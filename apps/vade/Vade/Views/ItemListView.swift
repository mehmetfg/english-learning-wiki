import SwiftUI
import SwiftData

struct ItemListView: View {
    let filter: SidebarFilter
    @Binding var selection: TrackedItem?
    @Binding var showingAdd: Bool

    @Environment(\.modelContext) private var context
    @Query private var items: [TrackedItem]
    @State private var search = ""

    private var filtered: [TrackedItem] {
        let query = search.lowercased()
        return items
            .filter(filter.includes)
            .filter {
                query.isEmpty
                    || $0.title.lowercased().contains(query)
                    || $0.provider.lowercased().contains(query)
                    || $0.identifier.lowercased().contains(query)
            }
            .sorted(by: TrackedItem.urgencyOrder)
    }

    var body: some View {
        List(selection: $selection) {
            if filter == .upcoming || filter == .all {
                Section {
                    SummaryHeader(items: items.filter { !$0.isArchived })
                }
            }
            Section {
                ForEach(filtered) { item in
                    NavigationLink(value: item) { ItemRow(item: item) }
                }
                .onDelete { offsets in
                    for index in offsets {
                        let item = filtered[index]
                        if selection == item { selection = nil }
                        context.delete(item)
                    }
                }
            }
        }
        .overlay {
            if filtered.isEmpty {
                ContentUnavailableView {
                    Label(search.isEmpty ? "Kayıt yok" : "Sonuç yok", systemImage: filter.symbol)
                } description: {
                    Text(search.isEmpty ? "Bir sözleşme, poliçe veya garanti belgesi tarayarak başla." : "Aramayı değiştir.")
                } actions: {
                    if search.isEmpty { Button("Belge ekle") { showingAdd = true } }
                }
            }
        }
        .searchable(text: $search, prompt: "Başlık, şirket, plaka, hat…")
        .navigationTitle(filter.title)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button { showingAdd = true } label: { Label("Ekle", systemImage: "plus") }
                    .keyboardShortcut("n")
            }
        }
    }
}

struct ItemRow: View {
    let item: TrackedItem

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: item.category.symbol)
                .font(.title3)
                .foregroundStyle(item.status.color)
                .frame(width: 32)
            VStack(alignment: .leading, spacing: 2) {
                Text(item.title).font(.headline).lineLimit(1)
                Text([item.provider, item.identifier].filter { !$0.isEmpty }.joined(separator: " · "))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            Spacer()
            StatusBadge(item: item)
        }
        .padding(.vertical, 2)
    }
}

struct StatusBadge: View {
    let item: TrackedItem

    var body: some View {
        Text(text)
            .font(.caption.weight(.semibold))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(item.status.color.opacity(0.15), in: Capsule())
            .foregroundStyle(item.status.color)
    }

    private var text: String {
        guard let days = item.daysLeft else { return "Süresiz" }
        if days < 0 { return "Bitti" }
        if days == 0 { return "Bugün" }
        if days > 365 { return "\(days / 365) yıl+" }
        return "\(days) gün"
    }
}

struct SummaryHeader: View {
    let items: [TrackedItem]

    private var expiringSoon: Int { items.filter { (0...30).contains($0.daysLeft ?? -1) }.count }
    private var monthlySubscriptions: Double {
        items.filter { $0.category.group == .contract }.reduce(0) { $0 + $1.monthlyCost }
    }
    private var yearlyInsurance: Double {
        items.filter { $0.category.group == .insurance }.reduce(0) { $0 + $1.monthlyCost * 12 }
    }

    var body: some View {
        HStack(spacing: 12) {
            tile("30 gün içinde", "\(expiringSoon)", expiringSoon > 0 ? .orange : .green)
            tile("Aylık abonelik", monthlySubscriptions.currencyText(), .blue)
            tile("Yıllık sigorta", yearlyInsurance.currencyText(), .purple)
        }
        .listRowInsets(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
    }

    private func tile(_ title: String, _ value: String, _ color: Color) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title).font(.caption).foregroundStyle(.secondary)
            Text(value).font(.headline).foregroundStyle(color).minimumScaleFactor(0.6).lineLimit(1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .background(color.opacity(0.08), in: RoundedRectangle(cornerRadius: 10))
    }
}
