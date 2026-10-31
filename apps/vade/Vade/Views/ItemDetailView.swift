import SwiftUI
import SwiftData

struct ItemDetailView: View {
    @Bindable var item: TrackedItem
    var onDelete: () -> Void

    @Environment(\.modelContext) private var context
    @State private var editing = false
    @State private var addingPayment = false
    @State private var attachingDocument = false
    @State private var confirmingDelete = false

    var body: some View {
        List {
            Section { DetailHeader(item: item) }
                .bareListRow()

            Section { facts }
                .bareListRow()

            if !item.penaltyNote.isEmpty {
                Section {
                    Label {
                        VStack(alignment: .leading, spacing: 3) {
                            Text(item.category.penaltyLabel).font(.subheadline.weight(.semibold))
                            Text(item.penaltyNote).font(.subheadline).foregroundStyle(.secondary)
                        }
                    } icon: {
                        Image(systemName: "exclamationmark.shield.fill").foregroundStyle(.red)
                    }
                }
            }

            if !item.summary.isEmpty {
                Section {
                    Text(item.summary)
                } header: {
                    Text("Özet")
                } footer: {
                    if !item.analysisEngine.isEmpty { Text("Kaynak: \(item.analysisEngine)") }
                }
            }

            if !item.sortedClauses.isEmpty {
                Section("Şartlar ve önemli maddeler") {
                    ForEach(item.sortedClauses) { ClauseRow(clause: $0) }
                }
            }

            Section("Ödemeler") {
                if let last = item.lastPayment {
                    LabeledContent("En son ödenen", value: "\(last.amount.currencyText(item.currency)) · \(last.date.shortText)")
                }
                ForEach(item.sortedPayments.dropFirst()) { payment in
                    LabeledContent(payment.date.shortText, value: payment.amount.currencyText(item.currency))
                        .foregroundStyle(.secondary)
                }
                .onDelete { offsets in
                    let rest = Array(item.sortedPayments.dropFirst())
                    offsets.map { rest[$0] }.forEach { context.delete($0) }
                }
                Button { addingPayment = true } label: { Label("Ödeme ekle", systemImage: "plus.circle") }
            }

            Section("Belgeler") {
                ForEach((item.documents ?? []).sorted { $0.createdAt > $1.createdAt }) { document in
                    NavigationLink {
                        DocumentViewer(document: document)
                    } label: {
                        Label(document.name, systemImage: document.pdfData == nil ? "text.alignleft" : "doc.richtext")
                    }
                }
                .onDelete { offsets in
                    let docs = (item.documents ?? []).sorted { $0.createdAt > $1.createdAt }
                    offsets.map { docs[$0] }.forEach { context.delete($0) }
                }
                Button { attachingDocument = true } label: { Label("Belge ekle ve analiz et", systemImage: "doc.viewfinder") }
            }

            Section("Hatırlatmalar") {
                Text(item.endDate == nil
                     ? "Bitiş tarihi olmadığı için hatırlatma kurulmadı."
                     : "Bitişten " + item.reminderDays.map { "\($0)" }.joined(separator: ", ") + " gün önce, saat 09:00")
                    .foregroundStyle(.secondary)
            }

            if !item.notes.isEmpty {
                Section("Notlar") { Text(item.notes) }
            }
        }
        .navigationTitle(item.title)
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        .listSectionSpacing(.compact)
        #endif
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                Button("Düzenle") { editing = true }
                Menu {
                    Button(item.isArchived ? "Arşivden çıkar" : "Arşivle", systemImage: "archivebox") {
                        item.isArchived.toggle()
                    }
                    Button("Sil", systemImage: "trash", role: .destructive) { confirmingDelete = true }
                } label: {
                    Label("Diğer", systemImage: "ellipsis.circle")
                }
            }
        }
        .sheet(isPresented: $editing) { EditItemSheet(item: item) }
        .sheet(isPresented: $addingPayment) { PaymentSheet(item: item) }
        .sheet(isPresented: $attachingDocument) { AttachDocumentSheet(item: item) }
        .confirmationDialog("Bu kayıt ve tüm belgeleri silinsin mi?", isPresented: $confirmingDelete, titleVisibility: .visible) {
            Button("Sil", role: .destructive) {
                onDelete()
                context.delete(item)
            }
        }
    }

    private var facts: some View {
        LazyVGrid(columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)], spacing: 10) {
            if item.amount > 0 {
                FactTile(title: item.category.amountLabel, value: item.amount.currencyText(item.currency),
                         detail: item.period.title, symbol: "turkishlirasign.circle.fill", tint: .indigo)
            }
            if let last = item.lastPayment {
                FactTile(title: "En son ödenen", value: last.amount.currencyText(item.currency),
                         detail: last.date.shortText, symbol: "checkmark.circle.fill", tint: .green)
            }
            if !item.identifier.isEmpty {
                FactTile(title: item.category.identifierLabel, value: item.identifier,
                         detail: item.provider, symbol: "number.circle.fill", tint: .vadeTeal)
            } else if !item.provider.isEmpty {
                FactTile(title: "Şirket", value: item.provider, detail: item.category.title,
                         symbol: "building.2.fill", tint: .vadeTeal)
            }
            if item.autoRenews {
                FactTile(title: "Otomatik yenileme", value: item.cancellationDeadline?.shortText ?? "Açık",
                         detail: item.cancellationDeadline == nil ? "" : "son iptal günü",
                         symbol: "arrow.triangle.2.circlepath.circle.fill", tint: .vadeAmber)
            }
        }
    }
}

/// Kategori renginde başlık kartı: geri sayım halkası, tarih aralığı ve süre çubuğu.
struct DetailHeader: View {
    let item: TrackedItem

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .top, spacing: 16) {
                VStack(alignment: .leading, spacing: 6) {
                    Label(item.category.title, systemImage: item.category.symbol)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.white.opacity(0.85))
                    Text(item.title)
                        .font(.title2.bold())
                        .foregroundStyle(.white)
                        .fixedSize(horizontal: false, vertical: true)
                    if !item.provider.isEmpty {
                        Text(item.provider).font(.subheadline).foregroundStyle(.white.opacity(0.8))
                    }
                }
                Spacer(minLength: 0)
                ZStack {
                    CountdownRing(progress: item.elapsedFraction ?? 0, color: .white, track: .white.opacity(0.25), lineWidth: 9)
                    VStack(spacing: -2) {
                        Text(item.countdown.value).font(.system(size: 26, weight: .bold, design: .rounded))
                        Text(item.countdown.caption).font(.caption2.weight(.medium)).opacity(0.85)
                    }
                    .foregroundStyle(.white)
                }
                .frame(width: 92, height: 92)
            }

            if item.startDate != nil || item.endDate != nil {
                VStack(spacing: 8) {
                    if let elapsed = item.elapsedFraction {
                        GeometryReader { proxy in
                            ZStack(alignment: .leading) {
                                Capsule().fill(.white.opacity(0.25))
                                Capsule().fill(.white).frame(width: max(8, proxy.size.width * elapsed))
                            }
                        }
                        .frame(height: 6)
                    }
                    HStack {
                        dateColumn("Başlangıç", item.startDate, alignment: .leading)
                        Spacer()
                        dateColumn("Bitiş", item.endDate, alignment: .trailing)
                    }
                }
            }
        }
        .padding(20)
        .background(
            LinearGradient(colors: [item.category.color, item.category.color.mix(with: .vadeNavy, by: 0.55)],
                           startPoint: .topLeading, endPoint: .bottomTrailing),
            in: RoundedRectangle(cornerRadius: 24, style: .continuous)
        )
    }

    private func dateColumn(_ title: String, _ date: Date?, alignment: HorizontalAlignment) -> some View {
        VStack(alignment: alignment, spacing: 2) {
            Text(title.upperTR).font(.caption2.weight(.bold)).tracking(0.6).foregroundStyle(.white.opacity(0.7))
            Text(date?.shortText ?? "—").font(.subheadline.weight(.semibold)).foregroundStyle(.white)
        }
    }
}

struct FactTile: View {
    let title: String
    let value: String
    let detail: String
    let symbol: String
    let tint: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Image(systemName: symbol).font(.title3).foregroundStyle(tint)
            Text(title).font(.caption).foregroundStyle(.secondary)
            Text(value).font(.headline).lineLimit(1).minimumScaleFactor(0.7)
            if !detail.isEmpty {
                Text(detail).font(.caption).foregroundStyle(.secondary).lineLimit(1)
            }
        }
        .card(padding: 14)
    }
}

struct ClauseRow: View {
    let clause: Clause

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            RoundedRectangle(cornerRadius: 2, style: .continuous)
                .fill(clause.importance.color)
                .frame(width: 4)
            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .firstTextBaseline) {
                    Text(clause.title).font(.subheadline.weight(.semibold))
                    Spacer(minLength: 8)
                    Pill(text: clause.importance.title, color: clause.importance.color)
                }
                Text(clause.detail).font(.subheadline).foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.vertical, 2)
    }
}

struct PaymentSheet: View {
    let item: TrackedItem
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @State private var amount: Double
    @State private var date = Date.now
    @State private var note = ""

    init(item: TrackedItem) {
        self.item = item
        _amount = State(initialValue: item.lastPayment?.amount ?? item.amount)
    }

    var body: some View {
        NavigationStack {
            Form {
                TextField("Tutar", value: $amount, format: .number).decimalKeyboard()
                DatePicker("Tarih", selection: $date, displayedComponents: .date)
                TextField("Not (isteğe bağlı)", text: $note)
            }
            .navigationTitle("Ödeme ekle")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Vazgeç") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Kaydet") {
                        let payment = Payment(date: date, amount: amount, note: note)
                        context.insert(payment)
                        item.payments = (item.payments ?? []) + [payment]
                        dismiss()
                    }
                    .disabled(amount <= 0)
                }
            }
        }
    }
}

struct EditItemSheet: View {
    let item: TrackedItem
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @State private var draft: ItemDraft

    init(item: TrackedItem) {
        self.item = item
        _draft = State(initialValue: ItemDraft(item: item))
    }

    var body: some View {
        NavigationStack {
            ItemEditorForm(draft: $draft, showsInitialPayment: false)
                .navigationTitle("Düzenle")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) { Button("Vazgeç") { dismiss() } }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Kaydet") {
                            draft.apply(to: item, in: context)
                            dismiss()
                        }
                        .disabled(!draft.isValid)
                    }
                }
        }
        #if os(macOS)
        .frame(minWidth: 520, minHeight: 640)
        #endif
    }
}
