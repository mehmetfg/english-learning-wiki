import Foundation
import SwiftData

struct ClauseDraft: Identifiable, Hashable {
    var id = UUID()
    var title: String
    var detail: String
    var importance: ClauseImportance
}

struct DocumentDraft {
    var name: String
    var pdfData: Data?
    var text: String
    var pageCount: Int
}

/// Formun üzerinde çalıştığı değer kopyası. Kaydedilene kadar veritabanına dokunmaz.
struct ItemDraft {
    var category: ItemCategory = .otherContract
    var title = ""
    var provider = ""
    var identifier = ""
    var startDate: Date?
    var endDate: Date?
    var autoRenews = false
    var noticeDays = 0
    var amount: Double = 0
    var period: BillingPeriod = .monthly
    var currency = "TRY"
    var penaltyNote = ""
    var summary = ""
    var notes = ""
    var reminderDays: [Int] = [30, 7, 1]
    var clauses: [ClauseDraft] = []
    var paymentAmount: Double = 0
    var paymentDate: Date = .now
    var newDocuments: [DocumentDraft] = []
    var analysisEngine = ""

    init(category: ItemCategory = .otherContract) {
        self.category = category
        self.period = category.defaultPeriod
    }

    init(item: TrackedItem) {
        category = item.category
        title = item.title
        provider = item.provider
        identifier = item.identifier
        startDate = item.startDate
        endDate = item.endDate
        autoRenews = item.autoRenews
        noticeDays = item.cancellationNoticeDays
        amount = item.amount
        period = item.period
        currency = item.currency
        penaltyNote = item.penaltyNote
        summary = item.summary
        notes = item.notes
        reminderDays = item.reminderDays
        analysisEngine = item.analysisEngine
        clauses = item.sortedClauses.map {
            ClauseDraft(title: $0.title, detail: $0.detail, importance: $0.importance)
        }
    }

    /// Analiz sonucunu taslağa işler. `overwrite` false ise yalnızca boş alanlar doldurulur.
    mutating func merge(_ analysis: DocumentAnalysis, overwrite: Bool) {
        func fill(_ field: inout String, _ value: String) {
            let value = value.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !value.isEmpty, overwrite || field.isEmpty else { return }
            field = value
        }
        fill(&title, analysis.title)
        fill(&provider, analysis.provider)
        fill(&identifier, analysis.identifier)
        fill(&penaltyNote, analysis.penaltyNote)
        fill(&summary, analysis.summary)

        if let start = analysis.startDate, overwrite || startDate == nil { startDate = start }
        if let end = analysis.endDate, overwrite || endDate == nil { endDate = end }
        if analysis.amount > 0, overwrite || amount == 0 {
            amount = analysis.amount
            if let p = analysis.period { period = p }
        }
        if let renews = analysis.autoRenews, overwrite || !autoRenews { autoRenews = renews }
        if let notice = analysis.noticeDays, notice > 0, overwrite || noticeDays == 0 { noticeDays = notice }
        if analysis.lastPaidAmount > 0, paymentAmount == 0 {
            paymentAmount = analysis.lastPaidAmount
            paymentDate = analysis.startDate ?? .now
        }

        let existing = Set(clauses.map { $0.title.lowercased() })
        clauses += analysis.clauses.filter { !existing.contains($0.title.lowercased()) }
        if title.isEmpty { title = [provider, category.title].filter { !$0.isEmpty }.joined(separator: " · ") }
        analysisEngine = analysis.engine.title
    }

    var isValid: Bool { !title.trimmingCharacters(in: .whitespaces).isEmpty }

    func apply(to item: TrackedItem, in context: ModelContext) {
        item.category = category
        item.title = title.trimmingCharacters(in: .whitespaces)
        item.provider = provider
        item.identifier = identifier
        item.startDate = startDate
        item.endDate = endDate
        item.autoRenews = autoRenews
        item.cancellationNoticeDays = noticeDays
        item.amount = amount
        item.period = period
        item.currency = currency
        item.penaltyNote = penaltyNote
        item.summary = summary
        item.notes = notes
        item.reminderDays = reminderDays.sorted(by: >)
        item.analysisEngine = analysisEngine
        item.updatedAt = .now

        for old in item.clauses ?? [] { context.delete(old) }
        item.clauses = clauses
            .filter { !$0.title.isEmpty || !$0.detail.isEmpty }
            .map { draft in
                let clause = Clause(title: draft.title, detail: draft.detail, importance: draft.importance)
                context.insert(clause)
                return clause
            }

        if paymentAmount > 0 {
            let payment = Payment(date: paymentDate, amount: paymentAmount)
            context.insert(payment)
            item.payments = (item.payments ?? []) + [payment]
        }

        for doc in newDocuments {
            let stored = StoredDocument(name: doc.name, pdfData: doc.pdfData, extractedText: doc.text, pageCount: doc.pageCount)
            context.insert(stored)
            item.documents = (item.documents ?? []) + [stored]
        }
    }
}
