import Foundation
import PDFKit
import Vision

enum ImportInput {
    case images([PlatformImage])
    case pdf(Data, name: String)
    case text(String)
}

struct ExtractedContent {
    var text: String
    var document: DocumentDraft
}

enum ImportError: LocalizedError {
    case unreadableFile
    case noTextFound

    var errorDescription: String? {
        switch self {
        case .unreadableFile: "Dosya açılamadı."
        case .noTextFound: "Belgede okunabilir metin bulunamadı. Daha aydınlık bir ortamda yeniden taramayı dene."
        }
    }
}

/// Girdiyi (tarama, fotoğraf, PDF, metin) düz metne ve saklanacak PDF'e çevirir. Tamamı cihazda çalışır.
enum ImportPipeline {
    static func extract(_ input: ImportInput) async throws -> ExtractedContent {
        switch input {
        case .images(let images):
            var pages: [String] = []
            for image in images {
                guard let ocr = image.ocrInput else { continue }
                pages.append(try await OCRService.recognizeText(in: ocr.image, orientation: ocr.orientation))
            }
            let text = pages.joined(separator: "\n\n")
            guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { throw ImportError.noTextFound }
            let document = DocumentDraft(
                name: "Tarama \(Date.now.formatted(date: .numeric, time: .shortened)).pdf",
                pdfData: PDFBuilder.makePDF(from: images),
                text: text,
                pageCount: images.count
            )
            return ExtractedContent(text: text, document: document)

        case .pdf(let data, let name):
            let (text, pageCount) = try await PDFTextExtractor.text(from: data)
            guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { throw ImportError.noTextFound }
            return ExtractedContent(text: text, document: DocumentDraft(name: name, pdfData: data, text: text, pageCount: pageCount))

        case .text(let text):
            guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { throw ImportError.noTextFound }
            return ExtractedContent(text: text, document: DocumentDraft(name: "Yapıştırılan metin", pdfData: nil, text: text, pageCount: 0))
        }
    }
}

enum OCRService {
    static func recognizeText(in image: CGImage, orientation: CGImagePropertyOrientation = .up) async throws -> String {
        var request = RecognizeTextRequest()
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true
        request.recognitionLanguages = [Locale.Language(identifier: "tr-TR"), Locale.Language(identifier: "en-US")]
        let observations = try await request.perform(on: image, orientation: orientation)
        return observations
            .compactMap { $0.topCandidates(1).first?.string }
            .joined(separator: "\n")
    }
}

enum PDFTextExtractor {
    /// Metin katmanı olan PDF'i (e-fatura, e-garanti) doğrudan okur; taranmış PDF'i sayfa sayfa OCR'dan geçirir.
    static func text(from data: Data) async throws -> (String, Int) {
        guard let document = PDFDocument(data: data) else { throw ImportError.unreadableFile }
        let embedded = document.string ?? ""
        if embedded.trimmingCharacters(in: .whitespacesAndNewlines).count > 80 {
            return (embedded, document.pageCount)
        }
        var pages: [String] = []
        for index in 0..<min(document.pageCount, 30) {
            guard let page = document.page(at: index), let image = render(page) else { continue }
            pages.append(try await OCRService.recognizeText(in: image))
        }
        return (pages.joined(separator: "\n\n"), document.pageCount)
    }

    private static func render(_ page: PDFPage, scale: CGFloat = 2) -> CGImage? {
        let bounds = page.bounds(for: .mediaBox)
        let width = Int(bounds.width * scale), height = Int(bounds.height * scale)
        guard width > 0, height > 0,
              let context = CGContext(
                data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: 0,
                space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
              ) else { return nil }
        context.setFillColor(CGColor(gray: 1, alpha: 1))
        context.fill(CGRect(x: 0, y: 0, width: width, height: height))
        context.scaleBy(x: scale, y: scale)
        page.draw(with: .mediaBox, to: context)
        return context.makeImage()
    }
}

enum PDFBuilder {
    static func makePDF(from images: [PlatformImage]) -> Data? {
        let document = PDFDocument()
        for image in images {
            guard let page = PDFPage(image: image) else { continue }
            document.insert(page, at: document.pageCount)
        }
        return document.pageCount > 0 ? document.dataRepresentation() : nil
    }
}
