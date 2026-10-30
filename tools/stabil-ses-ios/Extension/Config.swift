import Foundation

/// Sesin karakterini belirleyen ayarlar. Değiştirip yeniden derle.
enum Config {
    static let voiceName = "Dfki Stabil"
    static let voiceIdentifier = "com.mehmetfg.stabilses.dfki"
    static let sampleRate: Double = 22050

    /// Tonlama rastgeleliği. Düşük = düz, sabit (Piper varsayılanı 0.667).
    static let noiseScale: Float = 0.2
    /// Hece süresi rastgeleliği. Düşük = düzenli ritim (Piper varsayılanı 0.8).
    static let noiseScaleW: Float = 0.1
    /// Cümle/virgül arası sessizlik çarpanı. Düşük = kesintisiz akış.
    static let silenceScale: Float = 0.1

    /// Modelin kendi başına temiz kaldığı en yüksek hız. Üstü, perdeyi
    /// bozmadan zaman esnetmeyle (time-stretch) karşılanır.
    /// 2.0'da model kısa heceleri yutuyordu (cihaz testi); 1.0 ≈ 139, 1.3 ≈ 164 kelime/dk.
    static let maxModelSpeed: Float = 1.3
    /// Uygulamanın gönderdiği hız bu çarpanla ölçeklenir. Voice Dream'deki
    /// hız beklenenden yavaş/hızlı gelirse buradan ayarla.
    static let speedMultiplier: Float = 1.0

    /// Ses gücü dengeleme: hedef seviye ve kompresör.
    static let targetRMS: Float = 0.1
    static let compressorThreshold: Float = 0.06   // ~ -24 dB
    static let compressorRatio: Float = 4
}
