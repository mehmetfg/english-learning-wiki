import Foundation
import Testing

// Gerçek belgelere benzeyen OCR çıktılarıyla kural tabanlı çıkarıcının testleri.

private func ymd(_ date: Date?) -> String? {
    guard let date else { return nil }
    let c = Calendar(identifier: .gregorian).dateComponents([.year, .month, .day], from: date)
    return String(format: "%04d-%02d-%02d", c.year!, c.month!, c.day!)
}

@Suite("Kural tabanlı çıkarıcı")
struct HeuristicExtractorTests {
    @Test func kaskoPolicy() {
        let text = """
            ANADOLU SİGORTA
            KASKO SİGORTA POLİÇESİ
            Poliçe No: 123456789
            Plaka: 34 ABC 123
            Başlangıç Tarihi: 01.11.2026
            Bitiş Tarihi: 01.11.2027
            Brüt Prim: 18.450,00 TL
            Muafiyet: Her hasarda %2 muafiyet uygulanır.
            İkame araç: Yılda 2 kez, 7 gün süreyle.
            """
        let a = HeuristicExtractor.analyze(text, category: .kasko)
        #expect(a.provider == "Anadolu Sigorta")
        #expect(a.identifier == "34 ABC 123")
        #expect(ymd(a.startDate) == "2026-11-01")
        #expect(ymd(a.endDate) == "2027-11-01")
        #expect(a.amount == 18450)
        #expect(a.lastPaidAmount == 18450)
        #expect(a.period == .yearly)
        #expect(a.penaltyNote.contains("%2"))
        #expect(a.clauses.contains { $0.title == "Muafiyet" && $0.importance == .critical })
        #expect(a.clauses.contains { $0.title == "İkame araç" })
    }

    @Test func policyWithDateRangeOnOneLine() {
        let text = "Trafik Sigortası\nBaşlangıç - Bitiş: 15.06.2026 - 15.06.2027\nPrim: 7.200 TL"
        let a = HeuristicExtractor.analyze(text, category: .trafficInsurance)
        #expect(ymd(a.startDate) == "2026-06-15")
        #expect(ymd(a.endDate) == "2027-06-15")
        #expect(a.amount == 7200)
    }

    @Test func mobileLineWithCommitment() {
        let text = """
            Turkcell Abonelik Sözleşmesi
            Hat No: 0532 123 45 67
            Sözleşme Tarihi: 15.03.2026
            24 ay taahhüt süresince aylık 449,90 TL ödenecektir.
            Taahhüt bitiminden önce iptal halinde cayma bedeli 2.400 TL'dir.
            """
        let a = HeuristicExtractor.analyze(text, category: .mobileLine)
        #expect(a.provider == "Turkcell")
        #expect(a.identifier == "0532 123 45 67")
        #expect(ymd(a.startDate) == "2026-03-15")
        #expect(ymd(a.endDate) == "2028-03-15")
        #expect(a.amount == 449.90)
        #expect(a.period == .monthly)
        #expect(a.lastPaidAmount == 0)
        #expect(a.penaltyNote.contains("2.400"))
        #expect(a.clauses.contains { $0.title == "Cayma bedeli" })
        #expect(a.clauses.contains { $0.title == "Taahhüt süresi" })
    }

    @Test func autoRenewAndNoticePeriod() {
        let text = """
            Sözleşme süre sonunda otomatik olarak yenilenir.
            Fesih için bitişten 30 gün önce yazılı bildirim gerekir.
            """
        let a = HeuristicExtractor.analyze(text, category: .internet)
        #expect(a.autoRenews == true)
        #expect(a.noticeDays == 30)
    }

    @Test func deviceWarrantyDefaultsToTwoYears() {
        let text = """
            GARANTİ BELGESİ
            Ürün: Samsung Galaxy S25
            IMEI: 356789012345678
            Satış Tarihi: 10 Ocak 2026
            """
        let a = HeuristicExtractor.analyze(text, category: .deviceWarranty)
        #expect(a.provider == "Samsung")
        #expect(a.identifier == "356789012345678")
        #expect(ymd(a.startDate) == "2026-01-10")
        #expect(ymd(a.endDate) == "2028-01-10")
        #expect(a.clauses.contains { $0.title == "Yasal hatırlatma" })
    }

    @Test func providerNeedsWholeWord() {
        let a = HeuristicExtractor.analyze("Cihaz: Telefon\nchpro model", category: .deviceWarranty)
        #expect(a.provider.isEmpty)
    }

    @Test func plateIsNotConfusedWithDuration() {
        #expect(HeuristicExtractor.identifier(in: "Süre 12 ay 2025", category: .kasko).isEmpty)
    }

    @Test(arguments: [
        ("1.234,56", 1234.56),
        ("1234.56", 1234.56),
        ("2.400", 2400.0),
        ("1 234", 1234.0),
        ("449,90", 449.90),
    ])
    func parsesTurkishAmounts(raw: String, expected: Double) {
        #expect(HeuristicExtractor.parseAmount(raw) == expected)
    }

    @Test func findsAmountsWithLiraSign() {
        #expect(HeuristicExtractor.findAmounts(in: "Toplam ₺1.299,00") == [1299])
        #expect(HeuristicExtractor.findAmounts(in: "Ücret 250 TRY") == [250])
    }

    @Test func findsAllDateFormats() {
        let dates = HeuristicExtractor.findDates(in: "01/02/2026, 2026-03-04 ve 5 Şubat 2027").map { ymd($0)! }
        #expect(Set(dates) == ["2026-02-01", "2026-03-04", "2027-02-05"])
    }

    @Test func rejectsImpossibleDates() {
        #expect(HeuristicExtractor.findDates(in: "32.13.2026 ve 01.01.1850").isEmpty)
    }

    @Test func turkishUppercase() {
        #expect("Bitiş".upperTR == "BİTİŞ")
        #expect("31 ekim cumartesi".upperTR == "31 EKİM CUMARTESİ")
    }

    @Test func condenserRespectsLimit() {
        let long = (1...500).map { "Satır \($0): cayma bedeli 100 TL" }.joined(separator: "\n")
        let condensed = TextCondenser.condense(long, category: .internet, limit: 3000)
        #expect(condensed.count <= 3000)
        #expect(condensed.hasPrefix("Satır 1:"))
    }
}

@Suite("Taslak birleştirme")
struct ItemDraftMergeTests {
    @Test func mergeKeepsUserValuesWhenNotOverwriting() {
        var draft = ItemDraft(category: .kasko)
        draft.title = "Arabam"
        draft.amount = 10000
        var analysis = DocumentAnalysis()
        analysis.title = "Kasko 34 ABC 123"
        analysis.amount = 18450
        analysis.period = .yearly
        analysis.clauses = [ClauseDraft(title: "Muafiyet", detail: "%2", importance: .critical)]
        draft.merge(analysis, overwrite: false)
        #expect(draft.title == "Arabam")
        #expect(draft.amount == 10000)
        #expect(draft.clauses.count == 1)

        draft.merge(analysis, overwrite: true)
        #expect(draft.title == "Kasko 34 ABC 123")
        #expect(draft.amount == 18450)
        #expect(draft.clauses.count == 1, "Aynı başlıklı madde iki kez eklenmemeli")
    }
}
