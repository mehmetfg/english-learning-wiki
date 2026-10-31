import SwiftUI
import SwiftData

/// Yeni kayıt: 1) türü seç → 2) kaynağı seç (tara, fotoğraf, dosya, metin, elle) → 3) cihazda oku + analiz et → 4) kontrol et, kaydet.
struct AddItemFlow: View {
    var onCreated: (TrackedItem) -> Void

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @State private var step: Step = .category
    @State private var draft = ItemDraft()

    enum Step {
        case category, source, processing(ImportInput), review
    }

    var body: some View {
        NavigationStack {
            Group {
                switch step {
                case .category:
                    CategoryPicker { category in
                        draft = ItemDraft(category: category)
                        step = .source
                    }
                    .navigationTitle("Ne ekliyorsun?")
                case .source:
                    SourcePickerView(allowsManual: true,
                                     onInput: { step = .processing($0) },
                                     onManual: { step = .review })
                        .navigationTitle(draft.category.title)
                case .processing(let input):
                    ProcessingView(input: input, category: draft.category) { content, analysis in
                        draft.newDocuments = [content.document]
                        draft.merge(analysis, overwrite: true)
                        step = .review
                    } onFailure: {
                        step = .source
                    }
                    .navigationTitle("Okunuyor")
                case .review:
                    ItemEditorForm(draft: $draft)
                        .navigationTitle("Kontrol et")
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Vazgeç") { dismiss() } }
                if isReviewing {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Kaydet") { save() }.disabled(!draft.isValid)
                    }
                }
            }
        }
        #if os(macOS)
        .frame(minWidth: 560, minHeight: 640)
        #endif
    }

    private var isReviewing: Bool {
        if case .review = step { return true }
        return false
    }

    private func save() {
        let item = TrackedItem()
        context.insert(item)
        draft.apply(to: item, in: context)
        onCreated(item)
        dismiss()
    }
}

struct CategoryPicker: View {
    var onSelect: (ItemCategory) -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                ForEach(ItemGroup.allCases) { group in
                    VStack(alignment: .leading, spacing: 10) {
                        Text(group.title.uppercased())
                            .font(.caption.weight(.bold))
                            .tracking(0.8)
                            .foregroundStyle(.secondary)
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 140), spacing: 10)], spacing: 10) {
                            ForEach(ItemCategory.allCases.filter { $0.group == group }) { category in
                                Button { onSelect(category) } label: {
                                    VStack(alignment: .leading, spacing: 10) {
                                        CategoryIcon(category: category, size: 38)
                                        Text(category.title)
                                            .font(.subheadline.weight(.semibold))
                                            .foregroundStyle(.primary)
                                            .lineLimit(2)
                                            .multilineTextAlignment(.leading)
                                    }
                                    .frame(maxWidth: .infinity, minHeight: 92, alignment: .topLeading)
                                    .card(padding: 14)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .background(Color.dashboardBackground)
    }
}

struct ProcessingView: View {
    let input: ImportInput
    let category: ItemCategory
    var onSuccess: (ExtractedContent, DocumentAnalysis) -> Void
    var onFailure: () -> Void

    @State private var stage = "Metin okunuyor…"
    @State private var errorMessage: String?

    var body: some View {
        VStack(spacing: 16) {
            if let errorMessage {
                ContentUnavailableView {
                    Label("Okunamadı", systemImage: "exclamationmark.triangle")
                } description: {
                    Text(errorMessage)
                } actions: {
                    Button("Geri dön", action: onFailure)
                }
            } else {
                ProgressView()
                Text(stage).foregroundStyle(.secondary)
                Text("Belge cihazından çıkmıyor.").font(.caption).foregroundStyle(.tertiary)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .task {
            do {
                let content = try await ImportPipeline.extract(input)
                stage = "Şartlar analiz ediliyor…"
                let analysis = await DocumentAnalyzer.analyze(text: content.text, category: category)
                onSuccess(content, analysis)
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
}

/// Mevcut bir kayda yeni belge ekler (ör. yenilenen poliçe); analiz yalnızca boş alanları doldurur, maddeleri ekler.
struct AttachDocumentSheet: View {
    let item: TrackedItem
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @State private var input: ImportInput?
    @State private var overwrite = false

    var body: some View {
        NavigationStack {
            Group {
                if let input {
                    ProcessingView(input: input, category: item.category) { content, analysis in
                        var draft = ItemDraft(item: item)
                        draft.newDocuments = [content.document]
                        draft.merge(analysis, overwrite: overwrite)
                        draft.apply(to: item, in: context)
                        dismiss()
                    } onFailure: {
                        self.input = nil
                    }
                } else {
                    VStack(spacing: 0) {
                        Toggle("Yeni belgedeki tarih ve tutarlar eskisinin yerine geçsin (ör. yenilenen poliçe)", isOn: $overwrite)
                            .padding()
                        SourcePickerView(allowsManual: false, onInput: { input = $0 })
                    }
                }
            }
            .navigationTitle("Belge ekle")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Vazgeç") { dismiss() } }
            }
        }
        #if os(macOS)
        .frame(minWidth: 520, minHeight: 520)
        #endif
    }
}
