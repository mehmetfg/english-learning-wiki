import AVFoundation

/// iOS'un sistem sesi olarak gördüğü konuşma sentezleyici.
public class DfkiSynthesizerAU: AVSpeechSynthesisProviderAudioUnit {
    private var outputBus: AUAudioUnitBus
    private var _outputBusses: AUAudioUnitBusArray!

    private let lock = NSLock()
    private var samples: [Float] = []
    private var position = 0

    public override init(componentDescription: AudioComponentDescription,
                         options: AudioComponentInstantiationOptions = []) throws {
        let format = AVAudioFormat(standardFormatWithSampleRate: Config.sampleRate, channels: 1)!
        outputBus = try AUAudioUnitBus(format: format)
        try super.init(componentDescription: componentDescription, options: options)
        _outputBusses = AUAudioUnitBusArray(audioUnit: self, busType: .output, busses: [outputBus])
    }

    public override var outputBusses: AUAudioUnitBusArray { _outputBusses }

    public override var speechVoices: [AVSpeechSynthesisProviderVoice] {
        get {
            [AVSpeechSynthesisProviderVoice(name: Config.voiceName,
                                            identifier: Config.voiceIdentifier,
                                            primaryLanguages: ["tr-TR"],
                                            supportedLanguages: ["tr-TR"])]
        }
        set {}
    }

    public override func synthesizeSpeechRequest(_ request: AVSpeechSynthesisProviderRequest) {
        let ssml = request.ssmlRepresentation
        let audio = Pipeline.render(text: SSML.plainText(ssml), rate: SSML.rate(ssml))
        lock.lock()
        samples = audio
        position = 0
        lock.unlock()
    }

    public override func cancelSpeechRequest() {
        lock.lock()
        samples = []
        position = 0
        lock.unlock()
    }

    public override var internalRenderBlock: AUInternalRenderBlock {
        return { [unowned self] actionFlags, _, frameCount, _, outputData, _, _ in
            let buffers = UnsafeMutableAudioBufferListPointer(outputData)
            guard let out = buffers[0].mData?.assumingMemoryBound(to: Float.self) else { return noErr }

            self.lock.lock()
            defer { self.lock.unlock() }

            let count = min(Int(frameCount), max(self.samples.count - self.position, 0))
            self.samples.withUnsafeBufferPointer { src in
                for i in 0..<count { out[i] = src[self.position + i] }
            }
            for i in count..<Int(frameCount) { out[i] = 0 }
            buffers[0].mDataByteSize = UInt32(count * MemoryLayout<Float>.size)
            self.position += count

            if self.position >= self.samples.count {
                actionFlags.pointee = .offlineUnitRenderAction_Complete
                self.samples = []
                self.position = 0
            }
            return noErr
        }
    }
}
