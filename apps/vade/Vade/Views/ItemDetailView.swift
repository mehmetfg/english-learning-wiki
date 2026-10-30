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
            Section { header }

            Section("Bilgiler") {
                LabeledContent("Tür", value: item.category.title)
                if !item.provider.isEmpty { LabeledContent("Şirket", value: item.provider) }
                if !item.identifier.isEmpty { LabeledContent(item.category.identifierLabel, value: item.identifier) }
                if let start = item.startDate { LabeledContent("Başlangıç", value: start.shortText) }
                if let end = item.endDate { LabeledContent("Bitiş", value: end.shortText) }
                if item.amount > 0 {
                    LabeledContent(item.category.amountLabel, value: "\(item.amount.currencyText(item.currency)) · \(item.period.title)")
                }
                if item.autoRenews {
                    LabeledContent("Otomatik yenileme", value: item.cancellationDeadline.map { "Son iptal: \($0.shortText)" } ?? "Evet")
                }
                if !item.penaltyNote.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.category.penaltyLabel).font(.caption).foregroundStyle(.secondary)
                        Text(item.penaltyNote)
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

    private var header: some View {
        HStack(spacing: 16) {
            Image(systemName: item.category.symbol)
                .font(.largeTitle)
                .foregroundStyle(item.status.color)
            VStack(alignment: .leading, spacing: 4) {
                Text(countdownText).font(.title2.bold())
                if let end = item.endDate {
                    Text("Bitiş: \(end.shortText)").foregroundStyle(.secondary)
                }
            }
            Spacer()
        }
        .padding(.vertical, 6)
    }

    private var countdownText: String {
        guard let days = item.daysLeft else { return "Bitiş tarihi yok" }
        if days < 0 { return "\(-days) gün önce bitti" }
        if days == 0 { return "Bugün bitiyor" }
        return "\(days) gün kaldı"
    }
}

struct ClauseRow: View {
    let clause: Clause

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: clause.importance.symbol).foregroundStyle(clause.importance.color)
            VStack(alignment: .leading, spacing: 2) {
                Text(clause.title).font(.subheadline.weight(.semibold))
                Text(clause.detail).font(.subheadline).foregroundStyle(.secondary)
            }
        }
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
