import SwiftUI
import PhotosUI
import UniformTypeIdentifiers
#if os(iOS)
import VisionKit
#endif

struct SourcePickerView: View {
    var allowsManual: Bool
    var onInput: (ImportInput) -> Void
    var onManual: () -> Void = {}

    @State private var showingScanner = false
    @State private var showingFiles = false
    @State private var showingPaste = false
    @State private var photoItems: [PhotosPickerItem] = []
    @State private var pastedText = ""
    @State private var errorMessage: String?

    var body: some View {
        List {
            Section {
                #if os(iOS)
                if VNDocumentCameraViewController.isSupported {
                    Button { showingScanner = true } label: {
                        SourceRow(title: "Belge tara", subtitle: "Kamerayla çok sayfalı tarama", symbol: "doc.viewfinder")
                    }
                }
                #endif
                PhotosPicker(selection: $photoItems, maxSelectionCount: 10, matching: .images) {
                    SourceRow(title: "Fotoğraflardan seç", subtitle: "Daha önce çektiğin belge fotoğrafları", symbol: "photo.on.rectangle")
                }
                Button { showingFiles = true } label: {
                    SourceRow(title: "Dosyadan aktar", subtitle: "PDF (e-fatura, e-poliçe, e-garanti) veya görsel", symbol: "folder")
                }
                Button { showingPaste = true } label: {
                    SourceRow(title: "Metin yapıştır", subtitle: "SMS, e-posta veya web sayfasındaki metin", symbol: "doc.on.clipboard")
                }
                if allowsManual {
                    Button(action: onManual) {
                        SourceRow(title: "Elle gir", subtitle: "Belge olmadan sadece bilgileri yaz", symbol: "square.and.pencil")
                    }
                }
            } footer: {
                Text("Okuma ve analiz tamamen cihazında yapılır; belge hiçbir sunucuya gönderilmez. Kayıtlar yalnızca kendi iCloud hesabında senkronlanır.")
            }
            if let errorMessage {
                Section { Text(errorMessage).foregroundStyle(.red) }
            }
        }
        .buttonStyle(.plain)
        .onChange(of: photoItems) { _, items in
            guard !items.isEmpty else { return }
            Task { await loadPhotos(items) }
        }
        .fileImporter(isPresented: $showingFiles, allowedContentTypes: [.pdf, .image]) { result in
            handleFile(result)
        }
        .sheet(isPresented: $showingPaste) {
            PasteTextSheet(text: $pastedText) { onInput(.text(pastedText)) }
        }
        #if os(iOS)
        .fullScreenCover(isPresented: $showingScanner) {
            DocumentScannerView { images in
                showingScanner = false
                if !images.isEmpty { onInput(.images(images)) }
            }
            .ignoresSafeArea()
        }
        #endif
    }

    private func loadPhotos(_ items: [PhotosPickerItem]) async {
        var images: [PlatformImage] = []
        for item in items {
            if let data = try? await item.loadTransferable(type: Data.self), let image = PlatformImage(data: data) {
                images.append(image)
            }
        }
        photoItems = []
        if images.isEmpty { errorMessage = "Fotoğraflar yüklenemedi." } else { onInput(.images(images)) }
    }

    private func handleFile(_ result: Result<URL, Error>) {
        do {
            let url = try result.get()
            let scoped = url.startAccessingSecurityScopedResource()
            defer { if scoped { url.stopAccessingSecurityScopedResource() } }
            let data = try Data(contentsOf: url)
            if UTType(filenameExtension: url.pathExtension)?.conforms(to: .pdf) == true {
                onInput(.pdf(data, name: url.lastPathComponent))
            } else if let image = PlatformImage(data: data) {
                onInput(.images([image]))
            } else {
                errorMessage = ImportError.unreadableFile.localizedDescription
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

struct SourceRow: View {
    let title: String
    let subtitle: String
    let symbol: String

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: symbol)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 40, height: 40)
                .background(LinearGradient.vadeBrand, in: RoundedRectangle(cornerRadius: 11, style: .continuous))
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.headline)
                Text(subtitle).font(.subheadline).foregroundStyle(.secondary)
            }
            Spacer()
        }
        .contentShape(Rectangle())
        .padding(.vertical, 4)
    }
}

struct PasteTextSheet: View {
    @Binding var text: String
    var onDone: () -> Void
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            TextEditor(text: $text)
                .padding()
                .navigationTitle("Metni yapıştır")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) { Button("Vazgeç") { dismiss() } }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Analiz et") {
                            dismiss()
                            onDone()
                        }
                        .disabled(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                }
        }
        #if os(macOS)
        .frame(minWidth: 480, minHeight: 400)
        #endif
    }
}
