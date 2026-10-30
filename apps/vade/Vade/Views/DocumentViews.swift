import SwiftUI
import PDFKit
#if os(iOS)
import VisionKit
#endif

struct DocumentViewer: View {
    let document: StoredDocument
    @State private var showsText = false

    var body: some View {
        Group {
            if let data = document.pdfData, !showsText {
                PDFKitView(data: data)
            } else {
                ScrollView {
                    Text(document.extractedText.isEmpty ? "Metin yok." : document.extractedText)
                        .textSelection(.enabled)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                }
            }
        }
        .navigationTitle(document.name)
        .toolbar {
            if document.pdfData != nil {
                ToolbarItem(placement: .primaryAction) {
                    Picker("Görünüm", selection: $showsText) {
                        Text("Belge").tag(false)
                        Text("Metin").tag(true)
                    }
                    .pickerStyle(.segmented)
                }
            }
            if let data = document.pdfData {
                ToolbarItem(placement: .primaryAction) {
                    ShareLink(item: PDFFile(data: data, name: document.name),
                              preview: SharePreview(document.name))
                }
            }
        }
    }
}

struct PDFFile: Transferable {
    let data: Data
    let name: String

    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(exportedContentType: .pdf) { $0.data }
            .suggestedFileName("Vade belgesi.pdf")
    }
}

#if os(iOS)
struct PDFKitView: UIViewRepresentable {
    let data: Data

    func makeUIView(context: Context) -> PDFView {
        let view = PDFView()
        view.autoScales = true
        view.document = PDFDocument(data: data)
        return view
    }

    func updateUIView(_ view: PDFView, context: Context) {}
}

struct DocumentScannerView: UIViewControllerRepresentable {
    var onFinish: ([UIImage]) -> Void

    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let controller = VNDocumentCameraViewController()
        controller.delegate = context.coordinator
        return controller
    }

    func updateUIViewController(_ controller: VNDocumentCameraViewController, context: Context) {}

    func makeCoordinator() -> Coordinator { Coordinator(onFinish: onFinish) }

    final class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        let onFinish: ([UIImage]) -> Void

        init(onFinish: @escaping ([UIImage]) -> Void) { self.onFinish = onFinish }

        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            onFinish((0..<scan.pageCount).map { scan.imageOfPage(at: $0) })
        }

        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            onFinish([])
        }

        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
            onFinish([])
        }
    }
}
#else
struct PDFKitView: NSViewRepresentable {
    let data: Data

    func makeNSView(context: Context) -> PDFView {
        let view = PDFView()
        view.autoScales = true
        view.document = PDFDocument(data: data)
        return view
    }

    func updateNSView(_ view: PDFView, context: Context) {}
}
#endif
