import Foundation
import SwiftData

// CloudKit senkronu için: her alanın varsayılanı var, ilişkiler opsiyonel, unique kısıt yok.

@Model
final class TrackedItem {
    var id: UUID = UUID()
    var categoryRaw: String = ItemCategory.otherContract.rawValue
    var title: String = ""
    var provider: String = ""
    var identifier: String = ""
    var startDate: Date?
    var endDate: Date?
    var autoRenews: Bool = false
    var cancellationNoticeDays: Int = 0
    var amount: Double = 0
    var periodRaw: String = BillingPeriod.monthly.rawValue
    var currency: String = "TRY"
    var penaltyNote: String = ""
    var summary: String = ""
    var notes: String = ""
    var reminderDays: [Int] = [30, 7, 1]
    var analysisEngine: String = ""
    var isArchived: Bool = false
    var createdAt: Date = Date()
    var updatedAt: Date = Date()

    @Relationship(deleteRule: .cascade, inverse: \Clause.item)
    var clauses: [Clause]? = []

    @Relationship(deleteRule: .cascade, inverse: \Payment.item)
    var payments: [Payment]? = []

    @Relationship(deleteRule: .cascade, inverse: \StoredDocument.item)
    var documents: [StoredDocument]? = []

    init() {}

    var category: ItemCategory {
        get { ItemCategory(rawValue: categoryRaw) ?? .otherContract }
        set { categoryRaw = newValue.rawValue }
    }

    var period: BillingPeriod {
        get { BillingPeriod(rawValue: periodRaw) ?? .monthly }
        set { periodRaw = newValue.rawValue }
    }
}

@Model
final class Clause {
    var title: String = ""
    var detail: String = ""
    var importanceRaw: String = ClauseImportance.info.rawValue
    var item: TrackedItem?

    init(title: String, detail: String, importance: ClauseImportance) {
        self.title = title
        self.detail = detail
        self.importanceRaw = importance.rawValue
    }

    var importance: ClauseImportance {
        ClauseImportance(rawValue: importanceRaw) ?? .info
    }
}

@Model
final class Payment {
    var date: Date = Date()
    var amount: Double = 0
    var note: String = ""
    var item: TrackedItem?

    init(date: Date, amount: Double, note: String = "") {
        self.date = date
        self.amount = amount
        self.note = note
    }
}

@Model
final class StoredDocument {
    var name: String = ""
    var createdAt: Date = Date()
    /// Taranan sayfalar ve fotoğraflar tek bir PDF'e dönüştürülür; yapıştırılan metinde nil.
    @Attribute(.externalStorage) var pdfData: Data?
    var extractedText: String = ""
    var pageCount: Int = 0
    var item: TrackedItem?

    init(name: String, pdfData: Data?, extractedText: String, pageCount: Int) {
        self.name = name
        self.pdfData = pdfData
        self.extractedText = extractedText
        self.pageCount = pageCount
    }
}

extension TrackedItem {
    var daysLeft: Int? {
        guard let endDate else { return nil }
        let calendar = Calendar.current
        return calendar.dateComponents([.day], from: calendar.startOfDay(for: .now), to: calendar.startOfDay(for: endDate)).day
    }

    var status: ItemStatus {
        guard let days = daysLeft else { return .noDate }
        if days < 0 { return .expired }
        if days <= 7 { return .critical }
        if days <= 30 { return .soon }
        return .active
    }

    /// Otomatik yenilenen sözleşmede iptal için son bildirim günü.
    var cancellationDeadline: Date? {
        guard autoRenews, cancellationNoticeDays > 0, let endDate else { return nil }
        return Calendar.current.date(byAdding: .day, value: -cancellationNoticeDays, to: endDate)
    }

    var sortedPayments: [Payment] {
        (payments ?? []).sorted { $0.date > $1.date }
    }

    var lastPayment: Payment? { sortedPayments.first }

    var sortedClauses: [Clause] {
        let order = ClauseImportance.allCases
        return (clauses ?? []).sorted {
            (order.firstIndex(of: $0.importance) ?? 0) < (order.firstIndex(of: $1.importance) ?? 0)
        }
    }

    var monthlyCost: Double { period.monthlyEquivalent(of: amount) }

    /// Bitişi en yakın olan en üstte; tarihsizler sonda.
    static func urgencyOrder(_ lhs: TrackedItem, _ rhs: TrackedItem) -> Bool {
        switch (lhs.endDate, rhs.endDate) {
        case let (l?, r?): l < r
        case (.some, nil): true
        case (nil, .some): false
        case (nil, nil): lhs.title.localizedCompare(rhs.title) == .orderedAscending
        }
    }
}

extension Double {
    func currencyText(_ code: String = "TRY") -> String {
        formatted(.currency(code: code).locale(Locale(identifier: "tr_TR")))
    }
}

extension String {
    /// Türkçe kurallarıyla büyük harf: "i" → "İ" (standart uppercased() "I" yapar).
    var upperTR: String { uppercased(with: Locale(identifier: "tr_TR")) }
}

extension Date {
    var shortText: String {
        formatted(.dateTime.day().month(.wide).year().locale(Locale(identifier: "tr_TR")))
    }
}
