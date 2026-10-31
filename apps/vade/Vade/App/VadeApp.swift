import SwiftUI
import SwiftData

@main
struct VadeApp: App {
    let container: ModelContainer = {
        let schema = Schema([TrackedItem.self, Clause.self, Payment.self, StoredDocument.self])
        if DemoData.isEnabled {
            // Ekran görüntüleri ve deneme için: gerçek veriye dokunmayan bellek içi depo.
            let memory = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
            let container = try! ModelContainer(for: schema, configurations: memory)
            DemoData.seed(container)
            return container
        }
        do {
            // iCloud açıksa iPhone ve Mac aynı özel CloudKit veritabanını paylaşır.
            let config = ModelConfiguration(schema: schema, cloudKitDatabase: .automatic)
            return try ModelContainer(for: schema, configurations: config)
        } catch {
            let local = ModelConfiguration(schema: schema, cloudKitDatabase: .none)
            return try! ModelContainer(for: schema, configurations: local)
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .task { if !DemoData.isEnabled { await ReminderScheduler.requestAuthorization() } }
                .environment(\.locale, Locale(identifier: "tr_TR"))
        }
        .modelContainer(container)
        #if os(macOS)
        .defaultSize(width: 1100, height: 720)
        #endif
    }
}
