import SwiftUI

extension Color {
    #if os(iOS)
    static let cardBackground = Color(uiColor: .secondarySystemGroupedBackground)
    #else
    static let cardBackground = Color(nsColor: .controlBackgroundColor)
    #endif
}

extension LinearGradient {
    static let vadeBrand = LinearGradient(colors: [.vadeNavy, .vadeTeal], startPoint: .topLeading, endPoint: .bottomTrailing)
}

extension ItemCategory {
    var color: Color {
        switch self {
        case .mobileLine: .purple
        case .internet: .blue
        case .tvStreaming: .pink
        case .utility: .yellow
        case .rental: .brown
        case .kasko: .indigo
        case .trafficInsurance: .orange
        case .homeInsurance: .green
        case .healthInsurance: .red
        case .deviceWarranty: .vadeTeal
        case .otherContract: .gray
        }
    }
}

extension TrackedItem {
    /// Başlangıçtan bitişe geçen sürenin oranı (0…1); süre bilinmiyorsa nil.
    var elapsedFraction: Double? {
        guard let startDate, let endDate else { return nil }
        let total = endDate.timeIntervalSince(startDate)
        guard total > 0 else { return nil }
        return min(1, max(0, Date.now.timeIntervalSince(startDate) / total))
    }

    /// Satırda ve kartlarda gösterilen kalan süre: büyük değer + küçük açıklama.
    var countdown: (value: String, caption: String) {
        guard let days = daysLeft else { return ("—", "süresiz") }
        if days < 0 { return ("Bitti", "\(-days) gün önce") }
        if days == 0 { return ("Bugün", "bitiyor") }
        if days > 365 { return ("\(days / 365)+", "yıl kaldı") }
        return ("\(days)", "gün kaldı")
    }
}

/// Kategori renginde, yuvarlak köşeli ikon karosu.
struct CategoryIcon: View {
    let category: ItemCategory
    var size: CGFloat = 40

    var body: some View {
        Image(systemName: category.symbol)
            .font(.system(size: size * 0.44, weight: .semibold))
            .foregroundStyle(.white)
            .frame(width: size, height: size)
            .background(category.color.gradient, in: RoundedRectangle(cornerRadius: size * 0.28, style: .continuous))
    }
}

/// İkondaki halka: kalan sürenin oranı kadar dolu.
struct CountdownRing: View {
    let remaining: Double
    var color: Color = .vadeAmber
    var track: Color = .secondary.opacity(0.2)
    var lineWidth: CGFloat = 8

    var body: some View {
        ZStack {
            Circle().stroke(track, lineWidth: lineWidth)
            Circle()
                .trim(from: 0, to: max(0.02, min(1, remaining)))
                .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
        }
    }
}

/// Sistem grubu arka planında yükseltilmiş kart.
struct CardStyle: ViewModifier {
    var padding: CGFloat = 16

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.cardBackground, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

extension View {
    func card(padding: CGFloat = 16) -> some View { modifier(CardStyle(padding: padding)) }

    /// Liste içinde kenarsız, arka plansız satır (kart ve başlık blokları için).
    func bareListRow() -> some View {
        listRowInsets(EdgeInsets(top: 6, leading: 0, bottom: 6, trailing: 0))
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
    }
}

/// Küçük, renkli durum etiketi.
struct Pill: View {
    let text: String
    let color: Color

    var body: some View {
        Text(text)
            .font(.caption2.weight(.bold))
            .padding(.horizontal, 7)
            .padding(.vertical, 3)
            .background(color.opacity(0.15), in: Capsule())
            .foregroundStyle(color)
    }
}
