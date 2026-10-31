import SwiftUI
import ImageIO

#if canImport(UIKit)
import UIKit
typealias PlatformImage = UIImage

extension Image {
    init(platformImage: PlatformImage) { self.init(uiImage: platformImage) }
}

extension UIImage {
    /// Vision'a verilecek görüntü + yön bilgisi (telefon fotoğrafları çoğu zaman döndürülmüş gelir).
    var ocrInput: (image: CGImage, orientation: CGImagePropertyOrientation)? {
        guard let cg = cgImage else { return nil }
        let orientation: CGImagePropertyOrientation = switch imageOrientation {
        case .up: .up
        case .down: .down
        case .left: .left
        case .right: .right
        case .upMirrored: .upMirrored
        case .downMirrored: .downMirrored
        case .leftMirrored: .leftMirrored
        case .rightMirrored: .rightMirrored
        @unknown default: .up
        }
        return (cg, orientation)
    }
}

extension View {
    func decimalKeyboard() -> some View { keyboardType(.decimalPad) }
}

#elseif canImport(AppKit)
import AppKit
typealias PlatformImage = NSImage

extension Image {
    init(platformImage: PlatformImage) { self.init(nsImage: platformImage) }
}

extension NSImage {
    var ocrInput: (image: CGImage, orientation: CGImagePropertyOrientation)? {
        guard let cg = cgImage(forProposedRect: nil, context: nil, hints: nil) else { return nil }
        return (cg, .up)
    }
}

extension View {
    func decimalKeyboard() -> some View { self }
}
#endif
