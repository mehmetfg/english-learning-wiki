import AVFoundation
import CoreAudioKit

public class AudioUnitFactory: NSObject, AUAudioUnitFactory {
    public func beginRequest(with context: NSExtensionContext) {}

    public func createAudioUnit(with componentDescription: AudioComponentDescription) throws -> AUAudioUnit {
        try DfkiSynthesizerAU(componentDescription: componentDescription, options: [])
    }
}
