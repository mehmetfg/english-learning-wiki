import AVFoundation

/// Sesin karakterini belirleyen ayarlar. Değiştirip yeniden derle.
enum Config {
    static let voiceName = "Dfki Stabil"
    static let voiceIdentifier = "com.mehmetfg.stabilses.dfki"
    static let sampleRate: Double = 22050

    /// Tonlama canlılığı. 0.2 fazla renksizdi; 0.55 renkli ama sabit (Piper varsayılanı 0.667).
    static let noiseScale: Float = 0.55
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

    /// Virgülde Piper sesi yukarı kaldırıp "yarım kalmışlık" veriyor; kaldırınca akış bütünleşir.
    static let removeCommas = true
    /// Cümle sonu işareti. "!" ölçümde daha tutarlı ve kesin düşüşle kapattı
    /// (ort. −4,6 yarım ton; "." ile ilk cümle yükselerek bitiyordu).
    static let sentenceEnding = "!"

    /// Perde kaydırma (cent; 100 = 1 yarım ton). Örnek C: -150 (kalın), D: +100 (ince).
    static let pitchCents: Float = 0

    /// Netlik EQ: 90 Hz altını kes, 170 Hz gövde +2.5, 350 Hz boğukluk −3, 1.2 kHz varlık +2, 3 kHz ünsüz +4, 6.5 kHz hava +1.5 dB.
    static let eqBands: [(type: AVAudioUnitEQFilterType, frequency: Float, octaves: Float, gain: Float)] = [
        (.highPass, 90, 0.5, 0),
        (.parametric, 170, 1, 2.5),      // gövde, kararlı duruş
        (.parametric, 350, 1, -3),
        (.parametric, 1200, 1, 2),       // varlık, "doğrudan konuşma"
        (.parametric, 3000, 1, 4),
        (.parametric, 6500, 1.5, 1.5),
    ]

    /// Ses gücü dengeleme: hedef seviye ve kompresör.
    static let targetRMS: Float = 0.1
    static let compressorThreshold: Float = 0.06   // ~ -24 dB
    static let compressorRatio: Float = 4
}
