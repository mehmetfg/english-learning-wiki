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
        HStack(spacing: 14) {
            CategoryIcon(category: item.category, size: 42)
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title).font(.body.weight(.semibold)).lineLimit(1)
                Text([item.provider, item.identifier].filter { !$0.isEmpty }.joined(separator: " · "))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                if let elapsed = item.elapsedFraction {
                    ProgressView(value: elapsed)
                        .tint(item.status.color)
                        .padding(.top, 2)
                }
            }
            Spacer(minLength: 8)
            VStack(alignment: .trailing, spacing: 0) {
                Text(item.countdown.value)
                    .font(.system(.title3, design: .rounded).weight(.bold))
                    .foregroundStyle(item.status.color)
                Text(item.countdown.caption)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 6)
    }
}
