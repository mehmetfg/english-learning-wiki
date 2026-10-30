import SwiftUI

/// Kayıtların üst grubu: kenar çubuğu filtreleri ve hatırlatma metinleri buna göre değişir.
enum ItemGroup: String, CaseIterable, Identifiable {
    case contract, insurance, warranty

    var id: String { rawValue }

    var title: String {
        switch self {
        case .contract: "Sözleşme & Abonelik"
        case .insurance: "Sigorta"
        case .warranty: "Garanti"
        }
    }

    var symbol: String {
        switch self {
        case .contract: "doc.text"
        case .insurance: "shield.lefthalf.filled"
        case .warranty: "checkmark.seal"
        }
    }
}

/// Kullanıcının seçtiği belge türü. İçerik (tarih, ücret, maddeler) analizden gelir.
enum ItemCategory: String, CaseIterable, Identifiable, Codable {
    case mobileLine, internet, tvStreaming, utility, rental
    case kasko, trafficInsurance, homeInsurance, healthInsurance
    case deviceWarranty
    case otherContract

    var id: String { rawValue }

    var title: String {
        switch self {
        case .mobileLine: "Mobil hat"
        case .internet: "İnternet"
        case .tvStreaming: "TV & dijital abonelik"
        case .utility: "Elektrik / doğalgaz / su"
        case .rental: "Kira"
        case .kasko: "Kasko"
        case .trafficInsurance: "Trafik sigortası"
        case .homeInsurance: "Konut / DASK"
        case .healthInsurance: "Sağlık sigortası"
        case .deviceWarranty: "Cihaz garantisi"
        case .otherContract: "Diğer sözleşme"
        }
    }

    var symbol: String {
        switch self {
        case .mobileLine: "simcard"
        case .internet: "wifi.router"
        case .tvStreaming: "play.tv"
        case .utility: "bolt"
        case .rental: "building.2"
        case .kasko: "car"
        case .trafficInsurance: "steeringwheel"
        case .homeInsurance: "house"
        case .healthInsurance: "cross.case"
        case .deviceWarranty: "laptopcomputer.and.iphone"
        case .otherContract: "doc.text"
        }
    }

    var group: ItemGroup {
        switch self {
        case .mobileLine, .internet, .tvStreaming, .utility, .rental, .otherContract: .contract
        case .kasko, .trafficInsurance, .homeInsurance, .healthInsurance: .insurance
        case .deviceWarranty: .warranty
        }
    }

    var identifierLabel: String {
        switch self {
        case .mobileLine: "Hat numarası"
        case .internet, .tvStreaming, .utility: "Abone / hizmet no"
        case .rental: "Adres"
        case .kasko, .trafficInsurance: "Plaka"
        case .homeInsurance, .healthInsurance: "Poliçe no"
        case .deviceWarranty: "Seri / IMEI no"
        case .otherContract: "Sözleşme no"
        }
    }

    var amountLabel: String {
        switch group {
        case .contract: "Ücret"
        case .insurance: "Prim"
        case .warranty: "Satın alma bedeli"
        }
    }

    var penaltyLabel: String {
        switch group {
        case .contract: "Cayma bedeli / fesih şartı"
        case .insurance: "Muafiyet"
        case .warranty: "Kapsam dışı durumlar"
        }
    }

    var defaultPeriod: BillingPeriod {
        switch group {
        case .contract: .monthly
        case .insurance: .yearly
        case .warranty: .oneTime
        }
    }

    /// Yalnızca tek tarih bulunduğunda bitişi tahmin etmek için (garanti: yasal asgari 2 yıl).
    var defaultDurationMonths: Int? {
        switch group {
        case .insurance: 12
        case .warranty: 24
        case .contract: nil
        }
    }

    /// Yerel modele "bu belgede neye bak" ipucu.
    var analysisHint: String {
        switch self {
        case .mobileLine:
            "taahhüt süresi ve bitişi, aylık ücret, cayma bedeli, paket içeriği (GB/dakika/SMS), kampanya bitince uygulanacak ücret"
        case .internet:
            "taahhüt bitişi, aylık ücret, bağlantı hızı, cayma bedeli, modem iade şartı, kampanya sonrası fiyat"
        case .tvStreaming:
            "yenileme tarihi, ücret, otomatik yenileme, iptal şartı"
        case .utility:
            "abone no, tarife, sözleşme süresi, güvence bedeli"
        case .rental:
            "kira bedeli, yıllık artış oranı, süre, depozito, fesih bildirim süresi, aidat"
        case .kasko:
            "poliçe başlangıç ve bitişi, brüt prim, muafiyet, ikame araç, cam hasarı, anlaşmalı servis şartı, hasarsızlık indirimi, İMM limiti"
        case .trafficInsurance:
            "poliçe başlangıç ve bitişi, brüt prim, basamak (hasarsızlık kademesi), teminat limitleri"
        case .homeInsurance:
            "poliçe bitişi, prim, teminatlar, muafiyet, DASK poliçe no"
        case .healthInsurance:
            "poliçe bitişi, prim, anlaşmalı kurumlar, limitler, katılım payı, bekleme süreleri, istisnalar"
        case .deviceWarranty:
            "satın alma tarihi, garanti süresi ve bitişi, satıcı, marka/model, seri veya IMEI no, garanti kapsamı ve kapsam dışı durumlar, yetkili servis"
        case .otherContract:
            "taraflar, süre, bitiş tarihi, ücret, fesih ve yenileme şartları"
        }
    }
}

enum BillingPeriod: String, CaseIterable, Identifiable, Codable {
    case monthly, yearly, oneTime

    var id: String { rawValue }

    var title: String {
        switch self {
        case .monthly: "Aylık"
        case .yearly: "Yıllık"
        case .oneTime: "Tek seferlik"
        }
    }

    func monthlyEquivalent(of amount: Double) -> Double {
        switch self {
        case .monthly: amount
        case .yearly: amount / 12
        case .oneTime: 0
        }
    }
}

enum ClauseImportance: String, CaseIterable, Identifiable, Codable {
    case critical, important, info

    var id: String { rawValue }

    var title: String {
        switch self {
        case .critical: "Kritik"
        case .important: "Önemli"
        case .info: "Bilgi"
        }
    }

    var symbol: String {
        switch self {
        case .critical: "exclamationmark.octagon.fill"
        case .important: "exclamationmark.triangle.fill"
        case .info: "info.circle.fill"
        }
    }

    var color: Color {
        switch self {
        case .critical: .red
        case .important: .orange
        case .info: .blue
        }
    }
}

enum ItemStatus {
    case noDate, active, soon, critical, expired

    var color: Color {
        switch self {
        case .noDate: .secondary
        case .active: .green
        case .soon: .orange
        case .critical: .red
        case .expired: .gray
        }
    }
}
