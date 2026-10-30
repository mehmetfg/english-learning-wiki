import AVFoundation

/// Metin → dfki → (gerekirse) perdeyi bozmadan hızlandırma → ses gücü dengeleme.
enum Pipeline {
    static func render(text: String, rate: Float) -> [Float] {
        guard !text.isEmpty else { return [] }
        let target = max(0.5, rate * Config.speedMultiplier)
        let modelSpeed = min(target, Config.maxModelSpeed)

        var audio = DfkiEngine.shared.synthesize(text, speed: modelSpeed)
        let stretch = target / modelSpeed
        if stretch > 1.01, let stretched = TimeStretch.apply(audio, rate: stretch) {
            audio = stretched
        }
        Loudness.level(&audio)
        return audio
    }
}

final class DfkiEngine {
    static let shared = DfkiEngine()
    private var tts: SherpaOnnxOfflineTtsWrapper?
    private let lock = NSLock()

    func synthesize(_ text: String, speed: Float) -> [Float] {
        lock.lock()
        defer { lock.unlock() }
        guard let tts = loadIfNeeded() else { return [] }
        return tts.generate(text: text, sid: 0, speed: speed).samples
    }

    private func loadIfNeeded() -> SherpaOnnxOfflineTtsWrapper? {
        if let tts { return tts }
        let bundle = Bundle(for: DfkiEngine.self)
        guard let model = bundle.path(forResource: "tr_TR-dfki-medium", ofType: "onnx"),
              let tokens = bundle.path(forResource: "tokens", ofType: "txt"),
              let resources = bundle.resourcePath else { return nil }

        let vits = sherpaOnnxOfflineTtsVitsModelConfig(
            model: model, tokens: tokens, dataDir: resources + "/espeak-ng-data",
            noiseScale: Config.noiseScale, noiseScaleW: Config.noiseScaleW, lengthScale: 1.0)
        let modelConfig = sherpaOnnxOfflineTtsModelConfig(vits: vits, numThreads: 2)
        var config = sherpaOnnxOfflineTtsConfig(model: modelConfig, silenceScale: Config.silenceScale)
        tts = SherpaOnnxOfflineTtsWrapper(config: &config)
        return tts
    }
}

enum TimeStretch {
    /// AVAudioUnitTimePitch ile çevrimdışı hızlandırma; perde korunur.
    static func apply(_ input: [Float], rate: Float) -> [Float]? {
        guard !input.isEmpty,
              let format = AVAudioFormat(standardFormatWithSampleRate: Config.sampleRate, channels: 1) else { return nil }
        let engine = AVAudioEngine()
        let player = AVAudioPlayerNode()
        let timePitch = AVAudioUnitTimePitch()
        timePitch.rate = rate
        engine.attach(player)
        engine.attach(timePitch)
        engine.connect(player, to: timePitch, format: format)
        engine.connect(timePitch, to: engine.mainMixerNode, format: format)

        let padded = input + [Float](repeating: 0, count: Int(Config.sampleRate * 0.1))
        guard let source = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: AVAudioFrameCount(padded.count)) else { return nil }
        source.frameLength = source.frameCapacity
        padded.withUnsafeBufferPointer { source.floatChannelData![0].update(from: $0.baseAddress!, count: padded.count) }

        do {
            try engine.enableManualRenderingMode(.offline, format: format, maximumFrameCount: 4096)
            try engine.start()
        } catch {
            return nil
        }
        player.scheduleBuffer(source)
        player.play()

        let expected = Int(Float(input.count) / rate)
        guard let chunk = AVAudioPCMBuffer(pcmFormat: engine.manualRenderingFormat, frameCapacity: 4096) else { return nil }
        var output: [Float] = []
        output.reserveCapacity(expected)
        while output.count < expected {
            let frames = AVAudioFrameCount(min(4096, expected - output.count))
            guard (try? engine.renderOffline(frames, to: chunk)) == .success else { break }
            output.append(contentsOf: UnsafeBufferPointer(start: chunk.floatChannelData![0], count: Int(chunk.frameLength)))
        }
        engine.stop()
        return output.isEmpty ? nil : output
    }
}

enum Loudness {
    /// Kompresör + sabit hedef seviye + yumuşak sınırlayıcı: cümleden cümleye aynı güç.
    static func level(_ x: inout [Float]) {
        guard !x.isEmpty else { return }
        let sr = Float(Config.sampleRate)
        let attack = expf(-1 / (0.005 * sr))
        let release = expf(-1 / (0.06 * sr))
        var envelope: Float = 0
        for i in x.indices {
            let a = abs(x[i])
            envelope = a > envelope ? attack * envelope + (1 - attack) * a : release * envelope + (1 - release) * a
            if envelope > Config.compressorThreshold {
                x[i] *= powf(envelope / Config.compressorThreshold, 1 / Config.compressorRatio - 1)
            }
        }

        var sum: Float = 0
        var voiced = 0
        for v in x where abs(v) > 0.005 {
            sum += v * v
            voiced += 1
        }
        guard voiced > 0 else { return }
        let gain = min(Config.targetRMS / (sum / Float(voiced)).squareRoot(), 10)
        for i in x.indices { x[i] = tanhf(x[i] * gain) }
    }
}
