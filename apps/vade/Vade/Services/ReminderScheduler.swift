import Foundation
import UserNotifications

/// Bildirimler cihaz başınadır; iCloud'dan gelen kayıtlar için her cihaz kendi hatırlatmalarını kurar.
/// Bu yüzden her değişiklikte tüm bekleyen bildirimler silinip yeniden oluşturulur (basit ve tutarlı).
@MainActor
enum ReminderScheduler {
    private static let center = UNUserNotificationCenter.current()

    static func requestAuthorization() async {
        _ = try? await center.requestAuthorization(options: [.alert, .sound, .badge])
    }

    static func sync(_ items: [TrackedItem]) async {
        center.removeAllPendingNotificationRequests()
        var requests: [(Date, UNNotificationRequest)] = []
        let now = Date.now

        for item in items where !item.isArchived {
            guard let endDate = item.endDate else { continue }
            for days in item.reminderDays {
                guard let fire = fireDate(daysBefore: days, of: endDate), fire > now else { continue }
                requests.append((fire, request(id: "\(item.id.uuidString)-\(days)", fire: fire,
                                               title: "\(item.title): \(days) gün kaldı",
                                               body: message(for: item, endDate: endDate))))
            }
            if let deadline = item.cancellationDeadline,
               let fire = fireDate(daysBefore: 3, of: deadline), fire > now {
                requests.append((fire, request(id: "\(item.id.uuidString)-notice", fire: fire,
                                               title: "\(item.title): iptal bildirimi için son 3 gün",
                                               body: "Otomatik yenilenmeyi istemiyorsan \(deadline.shortText) tarihine kadar bildirmelisin.")))
            }
        }

        // iOS en fazla 64 bekleyen bildirim tutar; en yakın olanları önceliklendir.
        for (_, request) in requests.sorted(by: { $0.0 < $1.0 }).prefix(60) {
            try? await center.add(request)
        }
    }

    private static func fireDate(daysBefore days: Int, of date: Date) -> Date? {
        let calendar = Calendar.current
        guard let day = calendar.date(byAdding: .day, value: -days, to: date) else { return nil }
        return calendar.date(bySettingHour: 9, minute: 0, second: 0, of: day)
    }

    private static func request(id: String, fire: Date, title: String, body: String) -> UNNotificationRequest {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: fire)
        return UNNotificationRequest(identifier: id, content: content,
                                     trigger: UNCalendarNotificationTrigger(dateMatching: components, repeats: false))
    }

    private static func message(for item: TrackedItem, endDate: Date) -> String {
        let date = endDate.shortText
        return switch item.category.group {
        case .insurance: "Poliçe \(date) tarihinde bitiyor. Yenilemeden önce teklif karşılaştır."
        case .warranty: "Garanti \(date) tarihinde bitiyor. Bir sorun varsa şimdi yetkili servise başvur."
        case .contract: "Taahhüt/sözleşme \(date) tarihinde bitiyor. Yeni teklif iste veya iptal et."
        }
    }
}
