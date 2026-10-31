import Foundation

/// Ana ekrandaki "Dikkat gerektirenler" listesini üreten kural tabanlı analiz.
/// Her kural tek bir kayda (veya kayıt çiftine) bakar ve kullanıcıya ne yapması gerektiğini söyler.
struct Insight: Identifiable {
    enum Severity: Int, Comparable {
        case critical = 0, warning, info

        static func < (lhs: Severity, rhs: Severity) -> Bool { lhs.rawValue < rhs.rawValue }
    }

    let id = UUID()
    let severity: Severity
    let symbol: String
    let title: String
    let message: String
    let item: TrackedItem?
    /// Aynı önemdekiler arasında sıralama için: küçük olan önce.
    let urgency: Int
}

enum InsightEngine {
    static func insights(for items: [TrackedItem], now: Date = .now) -> [Insight] {
        let active = items.filter { !$0.isArchived }
        var result: [Insight] = []

        for item in active {
            let days = item.daysLeft

            if let days, days < 0 {
                result.append(Insight(severity: .critical, symbol: "exclamationmark.octagon.fill",
                                      title: "\(item.title) süresi doldu",
                                      message: "\(-days) gün önce bitti. Yenilediysen yeni belgeyi ekle, kullanmıyorsan arşivle.",
                                      item: item, urgency: days))
            } else if let days, days <= 7 {
                result.append(Insight(severity: .critical, symbol: "clock.badge.exclamationmark.fill",
                                      title: days == 0 ? "\(item.title) bugün bitiyor" : "\(item.title) \(days) gün içinde bitiyor",
                                      message: action(for: item),
                                      item: item, urgency: days))
            } else if let days, days <= 30 {
                result.append(Insight(severity: .warning, symbol: "calendar.badge.clock",
                                      title: "\(item.title) \(days) gün sonra bitiyor",
                                      message: action(for: item),
                                      item: item, urgency: days))
            }

            if let deadline = item.cancellationDeadline {
                let left = Calendar.current.dateComponents([.day], from: Calendar.current.startOfDay(for: now),
                                                           to: Calendar.current.startOfDay(for: deadline)).day ?? 0
                if (0...14).contains(left) {
                    result.append(Insight(severity: left <= 3 ? .critical : .warning, symbol: "arrow.triangle.2.circlepath",
                                          title: "\(item.title) otomatik yenilenecek",
                                          message: "İptal etmek istiyorsan son bildirim günü \(deadline.shortText) (\(left) gün).",
                                          item: item, urgency: left))
                }
            }

            if item.category.group == .warranty, let days, (31...60).contains(days) {
                result.append(Insight(severity: .info, symbol: "wrench.and.screwdriver.fill",
                                      title: "\(item.title) garantisi 2 ay içinde bitiyor",
                                      message: "Garanti bitmeden cihazı kontrol ettir; arıza varsa ücretsiz onarım hakkın sürüyor.",
                                      item: item, urgency: days))
            }

            let payments = item.sortedPayments
            if payments.count >= 2, payments[1].amount > 0 {
                let change = (payments[0].amount - payments[1].amount) / payments[1].amount
                if change >= 0.10 {
                    result.append(Insight(severity: .warning, symbol: "chart.line.uptrend.xyaxis",
                                          title: "\(item.title) ücreti %\(Int((change * 100).rounded())) arttı",
                                          message: "\(payments[1].amount.currencyText(item.currency)) → \(payments[0].amount.currencyText(item.currency)). Yenilemeden önce başka teklif almayı düşün.",
                                          item: item, urgency: 100))
                }
            }

            if item.endDate == nil {
                result.append(Insight(severity: .info, symbol: "calendar.badge.plus",
                                      title: "\(item.title) için bitiş tarihi yok",
                                      message: "Tarih girilmeden hatırlatma kurulamaz.",
                                      item: item, urgency: 1000))
            } else if (item.documents ?? []).isEmpty {
                result.append(Insight(severity: .info, symbol: "doc.badge.plus",
                                      title: "\(item.title) için belge yok",
                                      message: "Sözleşmeyi veya poliçeyi tarayarak şartları da sakla.",
                                      item: item, urgency: 1001))
            }
        }

        // Aynı aracın kasko ve trafik poliçeleri farklı tarihlerde bitiyorsa tek seferde yenilemeyi öner.
        let vehicles = Dictionary(grouping: active.filter {
            ($0.category == .kasko || $0.category == .trafficInsurance) && !$0.identifier.isEmpty && $0.endDate != nil
        }, by: { $0.identifier.replacingOccurrences(of: " ", with: "").uppercased() })
        for (_, policies) in vehicles {
            guard let kasko = policies.first(where: { $0.category == .kasko }),
                  let traffic = policies.first(where: { $0.category == .trafficInsurance }),
                  let a = kasko.endDate, let b = traffic.endDate else { continue }
            let gap = abs(Calendar.current.dateComponents([.day], from: a, to: b).day ?? 0)
            if gap > 14 {
                result.append(Insight(severity: .info, symbol: "car.2.fill",
                                      title: "\(kasko.identifier): kasko ve trafik ayrı tarihlerde",
                                      message: "Aralarında \(gap) gün var. Aynı tarihe çekersen tek seferde teklif toplayıp pazarlık edebilirsin.",
                                      item: kasko, urgency: 500))
            }
        }

        return result.sorted { ($0.severity, $0.urgency) < ($1.severity, $1.urgency) }
    }

    private static func action(for item: TrackedItem) -> String {
        switch item.category.group {
        case .insurance: "Yenilemeden önce en az iki şirketten teklif al."
        case .warranty: "Cihazda bir sorun varsa garanti bitmeden servise götür."
        case .contract: item.autoRenews ? "Otomatik yenilenecek; devam etmek istemiyorsan iptal et." : "Yeni kampanya iste veya taşımayı değerlendir."
        }
    }
}

/// Ana ekrandaki rakamlar.
struct PortfolioSummary {
    let activeCount: Int
    let attentionCount: Int
    let expiringIn30: Int
    let monthlySubscriptions: Double
    let yearlyInsurance: Double
    let yearlyTotal: Double
    /// Aylık maliyete göre kategori dağılımı (büyükten küçüğe).
    let costByCategory: [(category: ItemCategory, monthly: Double)]

    init(items: [TrackedItem], insights: [Insight]) {
        let active = items.filter { !$0.isArchived }
        activeCount = active.count
        attentionCount = Set(insights.filter { $0.severity != .info }.compactMap { $0.item?.id }).count
        expiringIn30 = active.filter { (0...30).contains($0.daysLeft ?? -1) }.count
        monthlySubscriptions = active.filter { $0.category.group == .contract }.reduce(0) { $0 + $1.monthlyCost }
        yearlyInsurance = active.filter { $0.category.group == .insurance }.reduce(0) { $0 + $1.monthlyCost * 12 }
        yearlyTotal = active.reduce(0) { $0 + $1.monthlyCost * 12 }
        costByCategory = Dictionary(grouping: active, by: \.category)
            .map { (category: $0.key, monthly: $0.value.reduce(0) { $0 + $1.monthlyCost }) }
            .filter { $0.monthly > 0 }
            .sorted { $0.monthly > $1.monthly }
    }
}
