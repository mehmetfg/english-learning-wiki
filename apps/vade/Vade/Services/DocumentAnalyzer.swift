import Foundation

enum AnalysisEngine {
    case onDevice, heuristic

    var title: String {
        switch self {
        case .onDevice: "Apple Intelligence (cihaz üzerinde)"
        case .heuristic: "Kural tabanlı çıkarım"
        }
    }
}

struct DocumentAnalysis {
    var title = ""
    var provider = ""
    var identifier = ""
    var startDate: Date?
    var endDate: Date?
    var amount: Double = 0
    var period: BillingPeriod?
    var autoRenews: Bool?
    var noticeDays: Int?
    var penaltyNote = ""
    var lastPaidAmount: Double = 0
    var summary = ""
    var clauses: [ClauseDraft] = []
    var engine: AnalysisEngine = .heuristic

    /// Model bir alanı boş bıraktıysa kural tabanlı sonuçla tamamlar.
    func filled(from fallback: DocumentAnalysis) -> DocumentAnalysis {
        var result = self
        if result.title.isEmpty { result.title = fallback.title }
        if result.provider.isEmpty { result.provider = fallback.provider }
        if result.identifier.isEmpty { result.identifier = fallback.identifier }
        if result.startDate == nil { result.startDate = fallback.startDate }
        if result.endDate == nil { result.endDate = fallback.endDate }
        if result.amount == 0 { result.amount = fallback.amount }
        if result.period == nil { result.period = fallback.period }
        if result.autoRenews == nil { result.autoRenews = fallback.autoRenews }
        if (result.noticeDays ?? 0) == 0 { result.noticeDays = fallback.noticeDays }
        if result.penaltyNote.isEmpty { result.penaltyNote = fallback.penaltyNote }
        if result.lastPaidAmount == 0 { result.lastPaidAmount = fallback.lastPaidAmount }
        let titles = Set(result.clauses.map { $0.title.lowercased() })
        result.clauses += fallback.clauses.filter { !titles.contains($0.title.lowercased()) }
        return result
    }
}

enum DocumentAnalyzer {
    static func analyze(text: String, category: ItemCategory) async -> DocumentAnalysis {
        let heuristic = HeuristicExtractor.analyze(text, category: category)
        #if canImport(FoundationModels)
        if OnDeviceModelAnalyzer.isAvailable,
           let ai = try? await OnDeviceModelAnalyzer.analyze(
               text: TextCondenser.condense(text, category: category),
               category: category
           ) {
            return ai.filled(from: heuristic).withDefaultEnd(for: category)
        }
        #endif
        return heuristic
    }
}

extension DocumentAnalysis {
    /// Yalnızca başlangıç bulunduysa türün tipik süresinden bitişi tahmin eder (sigorta 1 yıl, garanti 2 yıl).
    func withDefaultEnd(for category: ItemCategory) -> DocumentAnalysis {
        guard endDate == nil, let startDate, let months = category.defaultDurationMonths else { return self }
        var copy = self
        copy.endDate = Calendar.current.date(byAdding: .month, value: months, to: startDate)
        return copy
    }
}

/// Uzun sözleşmeyi modelin bağlam penceresine sığacak şekilde kısaltır:
/// belgenin başı + anahtar kelime, tarih veya tutar içeren satırlar.
enum TextCondenser {
    static func condense(_ text: String, category: ItemCategory, limit: Int = 3000) -> String {
        let lines = text.components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
        let keywords = HeuristicExtractor.keyTerms(for: category).map(\.term)
            + ["tarih", "başlangıç", "bitiş", "süre", "tutar", "ücret", "prim", "toplam", "tl", "₺", "poliçe", "no"]

        var picked: [String] = []
        var seen = Set<String>()
        func add(_ line: String) {
            guard !seen.contains(line) else { return }
            seen.insert(line)
            picked.append(line)
        }
        lines.prefix(20).forEach(add)
        for line in lines {
            let lower = line.lowercased(with: HeuristicExtractor.turkish)
            if keywords.contains(where: { lower.contains($0) }) || line.contains(where: \.isNumber) {
                add(line)
            }
        }
        var result = ""
        for line in picked {
            guard result.count + line.count + 1 <= limit else { break }
            result += line + "\n"
        }
        return result
    }
}
