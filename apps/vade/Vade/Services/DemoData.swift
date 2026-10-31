import Foundation
import SwiftData

/// `-VadeDemo` başlatma argümanıyla açılınca bellek içi örnek veri yükler.
/// CI'daki simülatör ekran görüntüleri ve arayüz denemeleri için; gerçek kayıtlara dokunmaz.
enum DemoData {
    private static let arguments = ProcessInfo.processInfo.arguments
    static var isEnabled: Bool { arguments.contains("-VadeDemo") }
    static var opensDetail: Bool { arguments.contains("-VadeDemoDetail") }
    static var opensAdd: Bool { arguments.contains("-VadeDemoAdd") }

    static func seed(_ container: ModelContainer) {
        let context = ModelContext(container)
        defer { try? context.save() }
        func day(_ offset: Int) -> Date {
            Calendar.current.date(byAdding: .day, value: offset, to: .now)!
        }

        func add(_ category: ItemCategory, _ title: String, provider: String, identifier: String = "",
                 start: Int?, end: Int?, amount: Double, period: BillingPeriod,
                 autoRenews: Bool = false, notice: Int = 0, penalty: String = "", summary: String = "",
                 clauses: [(String, String, ClauseImportance)] = [], payments: [(Int, Double)] = [], document: Bool = true) {
            let item = TrackedItem()
            context.insert(item)
            item.category = category
            item.title = title
            item.provider = provider
            item.identifier = identifier
            item.startDate = start.map(day)
            item.endDate = end.map(day)
            item.amount = amount
            item.period = period
            item.autoRenews = autoRenews
            item.cancellationNoticeDays = notice
            item.penaltyNote = penalty
            item.summary = summary
            item.analysisEngine = AnalysisEngine.onDevice.title
            item.clauses = clauses.map {
                let clause = Clause(title: $0.0, detail: $0.1, importance: $0.2)
                context.insert(clause)
                return clause
            }
            item.payments = payments.map {
                let payment = Payment(date: day($0.0), amount: $0.1)
                context.insert(payment)
                return payment
            }
            if document {
                let doc = StoredDocument(name: "\(title).pdf", pdfData: nil, extractedText: summary, pageCount: 2)
                context.insert(doc)
                item.documents = [doc]
            }
        }

        add(.kasko, "Kasko · Toyota Corolla", provider: "Anadolu Sigorta", identifier: "34 ABC 123",
            start: -340, end: 25, amount: 18_450, period: .yearly,
            penalty: "Her hasarda %2 muafiyet; anlaşmasız serviste %20.",
            summary: "Genişletilmiş kasko. Yılda 2 kez 7 güne kadar ikame araç, cam hasarı muafiyetsiz, İMM limiti 5.000.000 TL.",
            clauses: [("Muafiyet", "Her hasarda %2 muafiyet uygulanır; anlaşmasız serviste oran %20'ye çıkar.", .critical),
                      ("Anlaşmalı servis şartı", "Onarım anlaşmalı serviste yapılmazsa hasarın %20'si sigortalıya kalır.", .critical),
                      ("İkame araç", "Yılda 2 kez, her seferinde en fazla 7 gün.", .important),
                      ("Hasarsızlık indirimi", "4. basamak; hasarsız yenilemede %50'ye kadar indirim.", .important),
                      ("Cam hasarı", "Orijinal cam değişimi muafiyetsiz, yılda 1 kez.", .info)],
            payments: [(-340, 18_450), (-705, 15_600)])
        add(.trafficInsurance, "Trafik sigortası · Toyota Corolla", provider: "Sompo Sigorta", identifier: "34 ABC 123",
            start: -300, end: 65, amount: 7_200, period: .yearly,
            clauses: [("Basamak", "5. basamak; hasarsız yenilemede prim düşer.", .important)],
            payments: [(-300, 7_200)])
        add(.mobileLine, "Turkcell hattı", provider: "Turkcell", identifier: "0532 123 45 67",
            start: -500, end: 230, amount: 449.90, period: .monthly, autoRenews: true, notice: 30,
            penalty: "Taahhüt bitmeden iptalde kalan indirimler + 2.400 TL cayma bedeli.",
            clauses: [("Cayma bedeli", "Taahhüt bitmeden ayrılırsan kalan ay indirimleri tahsil edilir.", .critical),
                      ("Paket içeriği", "40 GB internet, 2000 dakika, 1000 SMS.", .info)])
        add(.internet, "Ev interneti", provider: "TurkNet", identifier: "Abone 88231904",
            start: -200, end: 165, amount: 399.90, period: .monthly,
            clauses: [("Kampanya sonrası fiyat", "Taahhüt bitince ücret 549,90 TL'ye çıkar.", .important)])
        add(.tvStreaming, "Netflix Standart", provider: "Netflix", start: -18, end: 12, amount: 229.99,
            period: .monthly, autoRenews: true, notice: 1, document: false)
        add(.homeInsurance, "DASK · Ev", provider: "Türkiye Sigorta", identifier: "DASK 4471-2209",
            start: -360, end: 5, amount: 1_850, period: .yearly, payments: [(-360, 1_850)])
        add(.deviceWarranty, "iPhone 16 Pro", provider: "Apple", identifier: "356789012345678",
            start: -400, end: 330, amount: 74_999, period: .oneTime,
            clauses: [("Yasal hatırlatma", "Garanti süresi en az 2 yıl; azami tamir süresi 20 iş günü.", .info)])
        add(.deviceWarranty, "Samsung TV 55\"", provider: "Samsung", identifier: "Seri TV55Q80C",
            start: -700, end: 45, amount: 32_500, period: .oneTime)
        add(.healthInsurance, "Tamamlayıcı sağlık", provider: "Allianz", start: -100, end: nil,
            amount: 1_150, period: .monthly, document: false)
    }
}
