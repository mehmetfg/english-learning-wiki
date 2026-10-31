import Foundation

/// Dil modeli yokken (veya Türkçe desteklenmediğinde) çalışan, tamamen kural tabanlı çıkarıcı.
/// Model varken de boş kalan alanları doldurmak için kullanılır.
enum HeuristicExtractor {
    static let turkish = Locale(identifier: "tr_TR")

    struct KeyTerm {
        let term: String
        let title: String
        let importance: ClauseImportance
    }

    static func keyTerms(for category: ItemCategory) -> [KeyTerm] {
        switch category.group {
        case .contract where category == .rental:
            return [
                KeyTerm(term: "artış", title: "Kira artışı", importance: .critical),
                KeyTerm(term: "tahliye", title: "Tahliye", importance: .critical),
                KeyTerm(term: "fesih", title: "Fesih şartı", importance: .critical),
                KeyTerm(term: "depozito", title: "Depozito", importance: .important),
                KeyTerm(term: "aidat", title: "Aidat", importance: .info),
            ]
        case .contract:
            return [
                KeyTerm(term: "cayma", title: "Cayma bedeli", importance: .critical),
                KeyTerm(term: "taahhüt", title: "Taahhüt süresi", importance: .critical),
                KeyTerm(term: "fesih", title: "Fesih şartı", importance: .critical),
                KeyTerm(term: "otomatik", title: "Otomatik yenileme", importance: .important),
                KeyTerm(term: "kampanya", title: "Kampanya koşulu", importance: .important),
                KeyTerm(term: "iade", title: "İade şartı", importance: .important),
                KeyTerm(term: "mbps", title: "Bağlantı hızı", importance: .info),
                KeyTerm(term: "gb", title: "Paket içeriği", importance: .info),
            ]
        case .insurance:
            return [
                KeyTerm(term: "muafiyet", title: "Muafiyet", importance: .critical),
                KeyTerm(term: "istisna", title: "İstisnalar", importance: .critical),
                KeyTerm(term: "teminat", title: "Teminatlar", importance: .important),
                KeyTerm(term: "ikame", title: "İkame araç", importance: .important),
                KeyTerm(term: "hasarsızlık", title: "Hasarsızlık indirimi", importance: .important),
                KeyTerm(term: "basamak", title: "Basamak", importance: .important),
                KeyTerm(term: "anlaşmalı", title: "Anlaşmalı servis/kurum", importance: .important),
                KeyTerm(term: "ihtiyari mali", title: "İMM limiti", importance: .important),
                KeyTerm(term: "katılım payı", title: "Katılım payı", importance: .important),
                KeyTerm(term: "cam", title: "Cam hasarı", importance: .info),
            ]
        case .warranty:
            return [
                KeyTerm(term: "garanti süresi", title: "Garanti süresi", importance: .critical),
                KeyTerm(term: "kapsam dışı", title: "Kapsam dışı durumlar", importance: .critical),
                KeyTerm(term: "yetkili servis", title: "Yetkili servis", importance: .important),
                KeyTerm(term: "tamir süresi", title: "Azami tamir süresi", importance: .important),
                KeyTerm(term: "değişim", title: "Değişim hakkı", importance: .important),
                KeyTerm(term: "imei", title: "IMEI", importance: .info),
                KeyTerm(term: "seri no", title: "Seri no", importance: .info),
            ]
        }
    }

    static func analyze(_ text: String, category: ItemCategory) -> DocumentAnalysis {
        let lines = text.components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
        let lowerLines = lines.map { $0.lowercased(with: turkish) }
        let lowerText = lowerLines.joined(separator: "\n")

        var result = DocumentAnalysis()
        result.engine = .heuristic
        result.period = category.defaultPeriod

        // Tarihler: etiketli satırlar önce, sonra en erken/en geç tarih.
        let endWords = ["bitiş", "vade sonu", "son geçerlilik", "sona er", "geçerlilik sonu", "bitis"]
        let startWords = ["başlangıç", "tanzim", "satın alma", "satış tarihi", "fatura tarihi", "düzenleme", "baslangic"]
        var starts: [Date] = [], ends: [Date] = [], all: [Date] = []
        for (index, line) in lowerLines.enumerated() {
            let dates = findDates(in: lines[index])
            all += dates
            guard !dates.isEmpty else { continue }
            let isStart = startWords.contains { line.contains($0) }
            let isEnd = endWords.contains { line.contains($0) }
            if dates.count >= 2, isStart || isEnd {
                starts.append(dates.first!)
                ends.append(dates.last!)
            } else if isEnd {
                ends += dates
            } else if isStart {
                starts += dates
            }
        }
        let sorted = Array(Set(all)).sorted()
        result.startDate = starts.first ?? sorted.first
        result.endDate = ends.last ?? (sorted.count >= 2 ? sorted.last : nil)

        if result.endDate == nil, let start = result.startDate,
           let months = firstInt(in: lowerText, pattern: #"(\d{1,2})\s*ay(?:lık)?\s*taahh"#) {
            result.endDate = Calendar.current.date(byAdding: .month, value: months, to: start)
        }
        result = result.withDefaultEnd(for: category)

        // Tutar: türe uygun anahtar kelimeli satırdaki ilk tutar, yoksa belgedeki ilk tutar.
        let amountWords: [String] = switch category.group {
        case .insurance: ["brüt prim", "toplam prim", "ödenecek", "prim"]
        case .warranty: ["toplam", "tutar", "fiyat", "bedel"]
        case .contract: ["aylık", "ücret", "tarife", "kira bedeli", "tutar"]
        }
        var amount: Double?
        for word in amountWords {
            if let index = lowerLines.firstIndex(where: { $0.contains(word) && !$0.contains("cayma") }),
               let value = findAmounts(in: lines[index] + " " + (lines[safe: index + 1] ?? "")).first {
                amount = value
                break
            }
        }
        result.amount = amount ?? findAmounts(in: text).first ?? 0
        if lowerText.contains("yıllık") && category.group == .contract && !lowerText.contains("aylık") {
            result.period = .yearly
        }
        if category.group != .contract { result.lastPaidAmount = result.amount }

        // Kelime sınırıyla ara: "HP" veya "Apple" başka kelimelerin içinde geçince eşleşmesin.
        result.provider = knownProviders.first { name in
            !lowerText.regexMatches(#"\b"# + NSRegularExpression.escapedPattern(for: name.lowercased(with: turkish)) + #"\b"#).isEmpty
        } ?? ""
        result.identifier = identifier(in: text, category: category)

        if lowerText.contains("otomatik olarak yenilen") || lowerText.contains("kendiliğinden yenilen") {
            result.autoRenews = true
        }
        result.noticeDays = firstInt(in: lowerText, pattern: #"(\d{1,3})\s*gün\s*(?:önce|öncesinden|evvel)"#)

        let penaltyWord = category.group == .insurance ? "muafiyet" : (category.group == .warranty ? "kapsam dışı" : "cayma")
        if let index = lowerLines.firstIndex(where: { $0.contains(penaltyWord) }) {
            result.penaltyNote = snippet(lines, at: index, maxLength: 200)
        }

        for term in keyTerms(for: category) {
            guard let index = lowerLines.firstIndex(where: { $0.contains(term.term) }) else { continue }
            result.clauses.append(ClauseDraft(title: term.title, detail: snippet(lines, at: index, maxLength: 280), importance: term.importance))
            if result.clauses.count >= 8 { break }
        }
        if category == .deviceWarranty {
            result.clauses.append(ClauseDraft(
                title: "Yasal hatırlatma",
                detail: "6502 sayılı Kanun'a göre garanti süresi en az 2 yıldır; azami tamir süresi 20 iş günüdür. Süre aşılırsa değişim veya iade talep edebilirsin.",
                importance: .info
            ))
        }

        let found = [result.startDate != nil || result.endDate != nil ? "tarih" : nil,
                     result.amount > 0 ? "tutar" : nil,
                     result.clauses.isEmpty ? nil : "\(result.clauses.count) madde"].compactMap { $0 }
        result.summary = found.isEmpty
            ? "Belgeden otomatik bilgi çıkarılamadı; alanları elle doldur."
            : "Kural tabanlı okuma: \(found.joined(separator: ", ")) bulundu. Lütfen değerleri kontrol et."
        return result
    }

    // MARK: - Yardımcılar

    static let monthNames = ["ocak": 1, "şubat": 2, "mart": 3, "nisan": 4, "mayıs": 5, "haziran": 6,
                             "temmuz": 7, "ağustos": 8, "eylül": 9, "ekim": 10, "kasım": 11, "aralık": 12]

    static let knownProviders = [
        "Turkcell", "Vodafone", "Türk Telekom", "Superonline", "TurkNet", "Millenicom", "Kablonet", "D-Smart",
        "Digiturk", "Tivibu", "Netflix", "Spotify", "YouTube", "Disney", "Amazon", "Apple",
        "Allianz", "AXA", "Anadolu Sigorta", "Sompo", "HDI", "Mapfre", "Aksigorta", "Türkiye Sigorta",
        "Ray Sigorta", "Quick Sigorta", "Neova", "Groupama", "Zurich", "Bereket Sigorta", "Doğa Sigorta",
        "Samsung", "Xiaomi", "Huawei", "Arçelik", "Beko", "Vestel", "Bosch", "Siemens", "Dyson", "Philips",
        "Lenovo", "HP", "Asus", "MediaMarkt", "Teknosa", "Vatan Bilgisayar", "Hepsiburada", "Trendyol",
    ]

    static func findDates(in text: String) -> [Date] {
        var dates: [Date] = []
        for m in text.regexMatches(#"\b(\d{1,2})[./-](\d{1,2})[./-](\d{4})\b"#) {
            if let d = makeDate(year: Int(m[3]), month: Int(m[2]), day: Int(m[1])) { dates.append(d) }
        }
        for m in text.regexMatches(#"\b(\d{4})-(\d{2})-(\d{2})\b"#) {
            if let d = makeDate(year: Int(m[1]), month: Int(m[2]), day: Int(m[3])) { dates.append(d) }
        }
        let names = monthNames.keys.joined(separator: "|")
        for m in text.regexMatches(#"\b(\d{1,2})\s+("# + names + #")\s+(\d{4})\b"#) {
            let month = monthNames[m[2].lowercased(with: turkish)]
            if let d = makeDate(year: Int(m[3]), month: month, day: Int(m[1])) { dates.append(d) }
        }
        return dates
    }

    static func makeDate(year: Int?, month: Int?, day: Int?) -> Date? {
        guard let year, let month, let day, (1990...2100).contains(year), (1...12).contains(month), (1...31).contains(day) else { return nil }
        return Calendar(identifier: .gregorian).date(from: DateComponents(year: year, month: month, day: day, hour: 12))
    }

    static func findAmounts(in text: String) -> [Double] {
        let number = #"(\d{1,3}(?:[.\s]\d{3})+(?:,\d{1,2})?|\d+(?:[.,]\d{1,2})?)"#
        var values: [Double] = []
        for m in text.regexMatches(number + #"\s*(?:TL|TRY|₺)"#) { if let v = parseAmount(m[1]) { values.append(v) } }
        for m in text.regexMatches(#"₺\s*"# + number) { if let v = parseAmount(m[1]) { values.append(v) } }
        return values.filter { $0 > 0 }
    }

    /// "1.234,56" → 1234.56 · "1234.56" → 1234.56 · "1 234" → 1234
    static func parseAmount(_ raw: String) -> Double? {
        var s = raw.replacingOccurrences(of: " ", with: "")
        if s.contains(",") {
            s = s.replacingOccurrences(of: ".", with: "").replacingOccurrences(of: ",", with: ".")
        } else if let dot = s.lastIndex(of: "."), s.distance(from: dot, to: s.endIndex) != 3 {
            s = s.replacingOccurrences(of: ".", with: "")
        }
        return Double(s)
    }

    static func identifier(in text: String, category: ItemCategory) -> String {
        let patterns: [String] = switch category {
        case .mobileLine: [#"\b(0?5\d{2}\s?\d{3}\s?\d{2}\s?\d{2})\b"#]
        case .kasko, .trafficInsurance: [#"\b((?:0[1-9]|[1-7]\d|8[01])\s?[A-ZÇĞİÖŞÜ]{1,3}\s?\d{2,4})\b"#]
        case .deviceWarranty: [#"IMEI\s*(?:no)?\s*[:.]?\s*(\d{15})"#, #"Seri\s*No\s*[:.]?\s*([A-Z0-9-]{5,})"#]
        case .homeInsurance, .healthInsurance: [#"Poli[çc]e\s*No\s*[:.]?\s*([A-Z0-9/-]{4,})"#]
        default: [#"(?:Abone|Müşteri|Hizmet|Sözleşme)\s*No\s*[:.]?\s*([A-Z0-9/-]{4,})"#]
        }
        // Plaka büyük harf olmalı; aksi halde "12 ay 2025" gibi ifadeler plaka sanılır.
        let caseInsensitive = category != .kasko && category != .trafficInsurance
        for pattern in patterns {
            if let match = text.regexMatches(pattern, caseInsensitive: caseInsensitive).first { return match[1].trimmingCharacters(in: .whitespaces) }
        }
        return ""
    }

    static func firstInt(in text: String, pattern: String) -> Int? {
        text.regexMatches(pattern).first.flatMap { Int($0[1]) }
    }

    static func snippet(_ lines: [String], at index: Int, maxLength: Int) -> String {
        var text = lines[index]
        if text.count < 60, let next = lines[safe: index + 1] { text += " " + next }
        return text.count > maxLength ? String(text.prefix(maxLength)) + "…" : text
    }
}

extension String {
    /// Her eşleşme için [tam eşleşme, grup1, grup2, …]; büyük/küçük harf duyarsız.
    func regexMatches(_ pattern: String, caseInsensitive: Bool = true) -> [[String]] {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: caseInsensitive ? [.caseInsensitive] : []) else { return [] }
        let ns = self as NSString
        return regex.matches(in: self, range: NSRange(location: 0, length: ns.length)).map { match in
            (0..<match.numberOfRanges).map { i in
                let range = match.range(at: i)
                return range.location == NSNotFound ? "" : ns.substring(with: range)
            }
        }
    }
}

extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
