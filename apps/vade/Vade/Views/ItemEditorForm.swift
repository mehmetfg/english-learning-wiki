import SwiftUI

/// Hem yeni kayıt (analiz sonrası gözden geçirme) hem düzenleme için ortak form.
struct ItemEditorForm: View {
    @Binding var draft: ItemDraft
    var showsInitialPayment = true

    private static let reminderOptions = [60, 30, 14, 7, 3, 1]

    var body: some View {
        Form {
            if !draft.analysisEngine.isEmpty {
                Section {
                    Label("Alanlar otomatik dolduruldu (\(draft.analysisEngine)). Kaydetmeden önce kontrol et.",
                          systemImage: "sparkles")
                        .font(.callout)
                }
            }

            Section("Tür") {
                Picker("Tür", selection: $draft.category) {
                    ForEach(ItemCategory.allCases) { category in
                        Label(category.title, systemImage: category.symbol).tag(category)
                    }
                }
            }

            Section("Temel bilgiler") {
                TextField("Başlık", text: $draft.title)
                TextField("Şirket / satıcı", text: $draft.provider)
                TextField(draft.category.identifierLabel, text: $draft.identifier)
            }

            Section("Tarihler") {
                OptionalDateRow(title: "Başlangıç", date: $draft.startDate)
                OptionalDateRow(title: "Bitiş", date: $draft.endDate)
                if draft.category.group == .contract {
                    Toggle("Otomatik yenilenir", isOn: $draft.autoRenews)
                    if draft.autoRenews {
                        Stepper("İptal bildirimi: \(draft.noticeDays) gün önce", value: $draft.noticeDays, in: 0...180)
                    }
                }
            }

            Section(draft.category.amountLabel) {
                TextField("Tutar", value: $draft.amount, format: .number).decimalKeyboard()
                Picker("Dönem", selection: $draft.period) {
                    ForEach(BillingPeriod.allCases) { Text($0.title).tag($0) }
                }
                TextField(draft.category.penaltyLabel, text: $draft.penaltyNote, axis: .vertical)
            }

            if showsInitialPayment {
                Section {
                    TextField("En son ödenen tutar", value: $draft.paymentAmount, format: .number).decimalKeyboard()
                    if draft.paymentAmount > 0 {
                        DatePicker("Ödeme tarihi", selection: $draft.paymentDate, displayedComponents: .date)
                    }
                } header: {
                    Text("Son ödeme")
                } footer: {
                    Text("Ör. kasko/trafik için bu yıl ödediğin prim. Sonraki yıllarda karşılaştırmak için saklanır.")
                }
            }

            Section("Özet") {
                TextField("Kısa özet", text: $draft.summary, axis: .vertical).lineLimit(3...8)
            }

            Section("Şartlar ve maddeler") {
                ForEach($draft.clauses) { $clause in
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            TextField("Başlık", text: $clause.title).font(.headline)
                            Picker("Önem", selection: $clause.importance) {
                                ForEach(ClauseImportance.allCases) { Text($0.title).tag($0) }
                            }
                            .labelsHidden()
                            .fixedSize()
                        }
                        TextField("Açıklama", text: $clause.detail, axis: .vertical)
                            .foregroundStyle(.secondary)
                    }
                }
                .onDelete { draft.clauses.remove(atOffsets: $0) }
                Button {
                    draft.clauses.append(ClauseDraft(title: "", detail: "", importance: .important))
                } label: {
                    Label("Madde ekle", systemImage: "plus")
                }
            }

            Section("Hatırlatma (bitişten önce)") {
                ForEach(Self.reminderOptions, id: \.self) { days in
                    Toggle("\(days) gün önce", isOn: Binding(
                        get: { draft.reminderDays.contains(days) },
                        set: { on in
                            if on { draft.reminderDays.append(days) } else { draft.reminderDays.removeAll { $0 == days } }
                        }
                    ))
                }
            }

            Section("Notlar") {
                TextField("Notlar", text: $draft.notes, axis: .vertical).lineLimit(2...10)
            }
        }
        .formStyle(.grouped)
    }
}

struct OptionalDateRow: View {
    let title: String
    @Binding var date: Date?

    var body: some View {
        Toggle(title, isOn: Binding(
            get: { date != nil },
            set: { date = $0 ? (date ?? .now) : nil }
        ))
        if let value = date {
            DatePicker(title, selection: Binding(get: { value }, set: { date = $0 }), displayedComponents: .date)
        }
    }
}
