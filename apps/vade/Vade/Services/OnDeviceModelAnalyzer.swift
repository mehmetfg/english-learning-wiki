#if canImport(FoundationModels)
import Foundation
import FoundationModels

// Apple'ın cihaz üzerindeki dil modeli (Foundation Models). Belge metni cihazdan çıkmaz.
// Model "guided generation" ile doğrudan aşağıdaki yapıyı doldurur; serbest metin ayrıştırmaya gerek kalmaz.

@Generable
enum GeneratedImportance {
    case critical, important, info
}

@Generable
enum GeneratedPeriod {
    case monthly, yearly, oneTime, unknown
}

@Generable
struct GeneratedClause {
    @Guide(description: "Maddenin kısa Türkçe başlığı, örneğin 'Cayma bedeli' veya 'Muafiyet'")
    var title: String
    @Guide(description: "Maddenin sade Türkçe ile 1-2 cümlelik açıklaması; rakamları ve süreleri koru")
    var detail: String
    @Guide(description: "critical: para veya hak kaybı riski; important: bilinmesi gereken şart; info: genel bilgi")
    var importance: GeneratedImportance
}

@Generable
struct GeneratedAnalysis {
    @Guide(description: "Kayıt için kısa başlık, örneğin 'Turkcell 5xx hattı' veya 'Kasko 34 ABC 123'")
    var title: String
    @Guide(description: "Şirket, operatör, sigortacı veya satıcı adı; yoksa boş")
    var provider: String
    @Guide(description: "Hat numarası, plaka, poliçe no, seri/IMEI no veya abone no; yoksa boş")
    var identifier: String
    @Guide(description: "Başlangıç, poliçe tanzim veya satın alma tarihi, YYYY-MM-DD; yoksa boş")
    var startDate: String
    @Guide(description: "Bitiş, taahhüt sonu, poliçe sonu veya garanti bitiş tarihi, YYYY-MM-DD; yoksa boş")
    var endDate: String
    @Guide(description: "Düzenli ücret veya toplam prim tutarı, sadece sayı; yoksa 0")
    var amount: Double
    var period: GeneratedPeriod
    @Guide(description: "Sözleşme süre sonunda kendiliğinden yenileniyorsa true")
    var autoRenews: Bool
    @Guide(description: "İptal/fesih için bitişten kaç gün önce bildirim gerekiyor; yoksa 0")
    var cancellationNoticeDays: Int
    @Guide(description: "Cayma bedeli, muafiyet veya kapsam dışı şartın kısa açıklaması; yoksa boş")
    var penaltyNote: String
    @Guide(description: "Belgede görünen en son ödenen tutar; yoksa 0")
    var lastPaidAmount: Double
    @Guide(description: "Belgenin kullanıcı için 2-3 cümlelik sade Türkçe özeti")
    var summary: String
    @Guide(description: "En önemli 3-8 madde; önce para/hak kaybı riski olanlar")
    var clauses: [GeneratedClause]
}

enum OnDeviceModelAnalyzer {
    static var isAvailable: Bool {
        if case .available = SystemLanguageModel.default.availability { return true }
        return false
    }

    static func analyze(text: String, category: ItemCategory) async throws -> DocumentAnalysis {
        let session = LanguageModelSession(instructions: """
            You extract structured data from Turkish contracts, subscription agreements, insurance policies \
            and warranty certificates. Write every text field in Turkish. Never invent values: if something \
            is not in the document, leave the string empty or the number 0. Dates must be YYYY-MM-DD. \
            Amounts are plain numbers in Turkish lira (1.234,56 TL means 1234.56).
            """)
        let prompt = """
            Belge türü: \(category.title)
            Özellikle şunlara bak: \(category.analysisHint)
            Bugünün tarihi: \(Date.now.formatted(.iso8601.year().month().day()))

            BELGE METNİ:
            \(text)
            """
        let response = try await session.respond(
            to: prompt,
            generating: GeneratedAnalysis.self,
            options: GenerationOptions(temperature: 0.1)
        )
        return map(response.content)
    }

    private static func map(_ g: GeneratedAnalysis) -> DocumentAnalysis {
        var result = DocumentAnalysis()
        result.engine = .onDevice
        result.title = g.title
        result.provider = g.provider
        result.identifier = g.identifier
        result.startDate = parseDate(g.startDate)
        result.endDate = parseDate(g.endDate)
        result.amount = max(0, g.amount)
        result.period = switch g.period {
        case .monthly: .monthly
        case .yearly: .yearly
        case .oneTime: .oneTime
        case .unknown: nil
        }
        result.autoRenews = g.autoRenews
        result.noticeDays = g.cancellationNoticeDays > 0 ? g.cancellationNoticeDays : nil
        result.penaltyNote = g.penaltyNote
        result.lastPaidAmount = max(0, g.lastPaidAmount)
        result.summary = g.summary
        result.clauses = g.clauses.prefix(10).map { clause in
            let importance: ClauseImportance = switch clause.importance {
            case .critical: .critical
            case .important: .important
            case .info: .info
            }
            return ClauseDraft(title: clause.title, detail: clause.detail, importance: importance)
        }
        return result
    }

    private static func parseDate(_ string: String) -> Date? {
        let parts = string.trimmingCharacters(in: .whitespaces).split(separator: "-").compactMap { Int($0) }
        guard parts.count == 3 else { return nil }
        return HeuristicExtractor.makeDate(year: parts[0], month: parts[1], day: parts[2])
    }
}
#endif
