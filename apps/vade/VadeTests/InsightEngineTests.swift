import Foundation
import Testing

@Suite("Ana ekran analizi")
struct InsightEngineTests {
    private func item(_ title: String, _ category: ItemCategory = .internet, endIn days: Int?, archived: Bool = false) -> TrackedItem {
        let item = TrackedItem()
        item.title = title
        item.category = category
        item.endDate = days.flatMap { Calendar.current.date(byAdding: .day, value: $0, to: .now) }
        item.isArchived = archived
        return item
    }

    @Test func expiredAndSoonAreCriticalAndSortedFirst() {
        let insights = InsightEngine.insights(for: [
            item("Uzak", endIn: 200),
            item("Yakın", endIn: 20),
            item("Çok yakın", endIn: 3),
            item("Bitmiş", endIn: -4),
        ])
        let titles = insights.filter { $0.severity != .info }.map(\.title)
        #expect(titles.first == "Bitmiş süresi doldu")
        #expect(titles.contains("Çok yakın 3 gün içinde bitiyor"))
        #expect(titles.contains("Yakın 20 gün sonra bitiyor"))
        #expect(!titles.contains { $0.hasPrefix("Uzak") })
        #expect(insights.first?.severity == .critical)
    }

    @Test func archivedItemsAreIgnored() {
        #expect(InsightEngine.insights(for: [item("Eski", endIn: -10, archived: true)]).isEmpty)
    }

    @Test func missingEndDateIsReported() {
        let insights = InsightEngine.insights(for: [item("Sağlık", .healthInsurance, endIn: nil)])
        #expect(insights.map(\.title) == ["Sağlık için bitiş tarihi yok"])
        #expect(insights.first?.severity == .info)
    }

    @Test func kaskoAndTrafficOnDifferentDatesAreFlagged() {
        let kasko = item("Kasko", .kasko, endIn: 25)
        kasko.identifier = "34 ABC 123"
        let traffic = item("Trafik", .trafficInsurance, endIn: 65)
        traffic.identifier = "34ABC123"
        let titles = InsightEngine.insights(for: [kasko, traffic]).map(\.title)
        #expect(titles.contains("34 ABC 123: kasko ve trafik ayrı tarihlerde"))
    }

    @Test func summaryTotals() {
        let line = item("Hat", .mobileLine, endIn: 100)
        line.amount = 450
        line.period = .monthly
        let kasko = item("Kasko", .kasko, endIn: 10)
        kasko.amount = 12_000
        kasko.period = .yearly
        let summary = PortfolioSummary(items: [line, kasko], insights: InsightEngine.insights(for: [line, kasko]))
        #expect(summary.activeCount == 2)
        #expect(summary.expiringIn30 == 1)
        #expect(summary.monthlySubscriptions == 450)
        #expect(summary.yearlyInsurance == 12_000)
        #expect(summary.yearlyTotal == 450 * 12 + 12_000)
        #expect(summary.costByCategory.first?.category == .kasko)
    }
}
