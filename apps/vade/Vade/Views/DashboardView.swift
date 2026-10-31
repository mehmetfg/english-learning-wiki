import SwiftUI
import SwiftData
import Charts

/// Uygulama açılınca gelen ana ekran: sıradaki bitiş, rakamlar, dikkat gerektirenler, takvim ve maliyet analizi.
struct DashboardView: View {
    @Binding var selection: TrackedItem?
    @Binding var showingAdd: Bool

    @Query private var items: [TrackedItem]

    private var active: [TrackedItem] { items.filter { !$0.isArchived } }
    private var insights: [Insight] { InsightEngine.insights(for: items) }

    private var nextUp: TrackedItem? {
        active.filter { ($0.daysLeft ?? -1) >= 0 }.sorted(by: TrackedItem.urgencyOrder).first
    }

    private var upcoming: [TrackedItem] {
        active.filter { (0...90).contains($0.daysLeft ?? -1) }.sorted(by: TrackedItem.urgencyOrder)
    }

    var body: some View {
        let insights = self.insights
        let summary = PortfolioSummary(items: items, insights: insights)

        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                greeting(summary)

                if active.isEmpty {
                    welcome
                } else {
                    if let nextUp {
                        Button { selection = nextUp } label: { NextUpCard(item: nextUp) }
                            .buttonStyle(.plain)
                    }
                    metrics(summary)
                    if !insights.isEmpty { attention(insights) }
                    if !upcoming.isEmpty { timeline }
                    if !summary.costByCategory.isEmpty { costs(summary) }
                    groups
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
            .frame(maxWidth: 820)
            .frame(maxWidth: .infinity)
        }
        .background(Color.dashboardBackground)
        .navigationTitle("Ana Sayfa")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button { showingAdd = true } label: { Label("Belge ekle", systemImage: "plus") }
                    .keyboardShortcut("n")
            }
        }
    }

    // MARK: - Bölümler

    private func greeting(_ summary: PortfolioSummary) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(Date.now.formatted(.dateTime.weekday(.wide).day().month(.wide).locale(Locale(identifier: "tr_TR"))).uppercased())
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
            Text(greetingText).font(.largeTitle.bold())
            Text(statusLine(summary)).font(.subheadline).foregroundStyle(.secondary)
        }
        .padding(.top, 8)
    }

    private var greetingText: String {
        switch Calendar.current.component(.hour, from: .now) {
        case 5..<12: "Günaydın"
        case 12..<18: "İyi günler"
        default: "İyi akşamlar"
        }
    }

    private func statusLine(_ summary: PortfolioSummary) -> String {
        if summary.activeCount == 0 { return "Henüz kayıt yok." }
        if summary.attentionCount == 0 { return "\(summary.activeCount) kayıt takipte, her şey yolunda." }
        return "\(summary.activeCount) kayıt takipte, \(summary.attentionCount) tanesi dikkat istiyor."
    }

    private var welcome: some View {
        VStack(alignment: .leading, spacing: 14) {
            Image(systemName: "doc.viewfinder")
                .font(.system(size: 34, weight: .semibold))
                .foregroundStyle(.white)
            Text("İlk belgeni ekle").font(.title2.bold()).foregroundStyle(.white)
            Text("Sözleşme, poliçe veya garanti belgesini tara. Tarihleri, ücretleri ve önemli maddeleri Vade senin için çıkarır ve bitmeden hatırlatır.")
                .foregroundStyle(.white.opacity(0.85))
            Button { showingAdd = true } label: {
                Label("Belge tara", systemImage: "plus")
                    .font(.headline)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 10)
                    .background(.white, in: Capsule())
                    .foregroundStyle(Color.vadeNavy)
            }
            .buttonStyle(.plain)
        }
        .padding(22)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(LinearGradient.vadeBrand, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
    }

    private func metrics(_ summary: PortfolioSummary) -> some View {
        LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)], spacing: 12) {
            MetricCard(title: "Takipte", value: "\(summary.activeCount)", symbol: "tray.full.fill", tint: .vadeTeal)
            MetricCard(title: "30 gün içinde biten", value: "\(summary.expiringIn30)", symbol: "hourglass",
                       tint: summary.expiringIn30 > 0 ? .vadeAmber : .green)
            MetricCard(title: "Aylık abonelik", value: summary.monthlySubscriptions.currencyText(), symbol: "arrow.triangle.2.circlepath", tint: .indigo)
            MetricCard(title: "Yıllık sigorta", value: summary.yearlyInsurance.currencyText(), symbol: "shield.lefthalf.filled", tint: .purple)
        }
    }

    private func attention(_ insights: [Insight]) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionTitle(title: "Dikkat gerektirenler", trailing: "\(insights.count)")
            VStack(spacing: 0) {
                ForEach(Array(insights.prefix(6).enumerated()), id: \.element.id) { index, insight in
                    if index > 0 { Divider().padding(.leading, 52) }
                    Button { if let item = insight.item { selection = item } } label: { InsightRow(insight: insight) }
                        .buttonStyle(.plain)
                }
            }
            .card(padding: 0)
        }
    }

    private var timeline: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionTitle(title: "Önümüzdeki 90 gün", trailing: nil)
            VStack(spacing: 0) {
                ForEach(Array(upcoming.prefix(8).enumerated()), id: \.element.id) { index, item in
                    if index > 0 { Divider().padding(.leading, 70) }
                    Button { selection = item } label: { TimelineRow(item: item) }
                        .buttonStyle(.plain)
                }
            }
            .card(padding: 0)
        }
    }

    private func costs(_ summary: PortfolioSummary) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionTitle(title: "Maliyet analizi", trailing: nil)
            HStack(alignment: .center, spacing: 20) {
                Chart(summary.costByCategory, id: \.category) { entry in
                    SectorMark(angle: .value("Aylık", entry.monthly), innerRadius: .ratio(0.64), angularInset: 1.5)
                        .cornerRadius(4)
                        .foregroundStyle(entry.category.color)
                }
                .chartBackground { _ in
                    VStack(spacing: 0) {
                        Text("Yıllık").font(.caption2).foregroundStyle(.secondary)
                        Text(summary.yearlyTotal.formatted(.number.precision(.fractionLength(0)).locale(Locale(identifier: "tr_TR"))))
                            .font(.system(.headline, design: .rounded))
                        Text("₺").font(.caption2).foregroundStyle(.secondary)
                    }
                }
                .frame(width: 130, height: 130)

                VStack(alignment: .leading, spacing: 8) {
                    ForEach(summary.costByCategory.prefix(5), id: \.category) { entry in
                        HStack(spacing: 8) {
                            Circle().fill(entry.category.color).frame(width: 9, height: 9)
                            Text(entry.category.title).font(.subheadline).lineLimit(1)
                            Spacer(minLength: 4)
                            Text(entry.monthly.currencyText()).font(.subheadline.monospacedDigit()).foregroundStyle(.secondary)
                        }
                    }
                    Text("aylık eşdeğer").font(.caption2).foregroundStyle(.tertiary)
                }
            }
            .card()
        }
    }

    private var groups: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionTitle(title: "Kategoriler", trailing: nil)
            HStack(spacing: 12) {
                ForEach(ItemGroup.allCases) { group in
                    let count = active.filter { $0.category.group == group }.count
                    VStack(alignment: .leading, spacing: 6) {
                        Image(systemName: group.symbol).font(.title3).foregroundStyle(Color.vadeTeal)
                        Text("\(count)").font(.system(.title2, design: .rounded).bold())
                        Text(group.title).font(.caption).foregroundStyle(.secondary).lineLimit(2)
                    }
                    .card(padding: 14)
                }
            }
        }
    }
}

// MARK: - Parçalar

extension Color {
    #if os(iOS)
    static let dashboardBackground = Color(uiColor: .systemGroupedBackground)
    #else
    static let dashboardBackground = Color(nsColor: .windowBackgroundColor)
    #endif
}

struct SectionTitle: View {
    let title: String
    let trailing: String?

    var body: some View {
        HStack {
            Text(title).font(.title3.bold())
            Spacer()
            if let trailing { Text(trailing).font(.subheadline.weight(.semibold)).foregroundStyle(.secondary) }
        }
        .padding(.horizontal, 4)
    }
}

struct NextUpCard: View {
    let item: TrackedItem

    var body: some View {
        HStack(spacing: 18) {
            VStack(alignment: .leading, spacing: 8) {
                Text("SIRADAKİ BİTİŞ")
                    .font(.caption.weight(.bold))
                    .tracking(1)
                    .foregroundStyle(.white.opacity(0.7))
                Text(item.title)
                    .font(.title2.bold())
                    .foregroundStyle(.white)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
                Label(item.category.title, systemImage: item.category.symbol)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.85))
                if let end = item.endDate {
                    Text(end.shortText)
                        .font(.subheadline.weight(.semibold))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(.white.opacity(0.18), in: Capsule())
                        .foregroundStyle(.white)
                }
            }
            Spacer(minLength: 0)
            ZStack {
                CountdownRing(remaining: 1 - (item.elapsedFraction ?? 0), color: .vadeAmber, track: .white.opacity(0.2), lineWidth: 10)
                VStack(spacing: -2) {
                    Text(item.countdown.value).font(.system(size: 30, weight: .bold, design: .rounded))
                    Text(item.countdown.caption).font(.caption2.weight(.medium)).opacity(0.8)
                }
                .foregroundStyle(.white)
            }
            .frame(width: 104, height: 104)
        }
        .padding(22)
        .background(LinearGradient.vadeBrand, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: Color.vadeNavy.opacity(0.25), radius: 14, y: 8)
    }
}

struct MetricCard: View {
    let title: String
    let value: String
    let symbol: String
    let tint: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: symbol)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(tint)
                .frame(width: 32, height: 32)
                .background(tint.opacity(0.14), in: RoundedRectangle(cornerRadius: 9, style: .continuous))
            Text(value)
                .font(.system(.title2, design: .rounded).bold())
                .lineLimit(1)
                .minimumScaleFactor(0.6)
            Text(title).font(.footnote).foregroundStyle(.secondary)
        }
        .card(padding: 14)
    }
}

struct InsightRow: View {
    let insight: Insight

    private var color: Color {
        switch insight.severity {
        case .critical: .red
        case .warning: .vadeAmber
        case .info: .blue
        }
    }

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: insight.symbol)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(color)
                .frame(width: 30, height: 30)
                .background(color.opacity(0.14), in: Circle())
            VStack(alignment: .leading, spacing: 3) {
                Text(insight.title).font(.subheadline.weight(.semibold)).foregroundStyle(.primary)
                Text(insight.message).font(.footnote).foregroundStyle(.secondary).fixedSize(horizontal: false, vertical: true)
            }
            Spacer(minLength: 0)
            if insight.item != nil {
                Image(systemName: "chevron.right").font(.caption.weight(.semibold)).foregroundStyle(.tertiary).padding(.top, 8)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 12)
        .contentShape(Rectangle())
    }
}

struct TimelineRow: View {
    let item: TrackedItem

    var body: some View {
        HStack(spacing: 12) {
            if let end = item.endDate {
                VStack(spacing: 0) {
                    Text(end.formatted(.dateTime.day())).font(.system(.title3, design: .rounded).bold())
                    Text(end.formatted(.dateTime.month(.abbreviated).locale(Locale(identifier: "tr_TR"))).uppercased())
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(.secondary)
                }
                .frame(width: 46)
            }
            CategoryIcon(category: item.category, size: 34)
            VStack(alignment: .leading, spacing: 2) {
                Text(item.title).font(.subheadline.weight(.semibold)).foregroundStyle(.primary).lineLimit(1)
                Text(item.provider.isEmpty ? item.category.title : item.provider)
                    .font(.footnote).foregroundStyle(.secondary).lineLimit(1)
            }
            Spacer(minLength: 4)
            Pill(text: item.countdown.value == "Bugün" ? "Bugün" : "\(item.countdown.value) gün", color: item.status.color)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .contentShape(Rectangle())
    }
}
