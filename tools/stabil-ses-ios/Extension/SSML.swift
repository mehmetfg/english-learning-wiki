import Foundation

/// Sistemin gönderdiği SSML'den düz metni ve hızı çıkarır.
enum SSML {
    static func rate(_ ssml: String) -> Float {
        guard let range = ssml.range(of: #"rate="[0-9.]+%""#, options: .regularExpression) else { return 1 }
        let digits = ssml[range].filter { "0123456789.".contains($0) }
        return (Float(digits) ?? 100) / 100
    }

    static func plainText(_ ssml: String) -> String {
        var text = ssml.replacingOccurrences(of: "<[^>]+>", with: " ", options: .regularExpression)
        for (entity, char) in ["&lt;": "<", "&gt;": ">", "&quot;": "\"", "&apos;": "'", "&amp;": "&"] {
            text = text.replacingOccurrences(of: entity, with: char)
        }
        return text.replacingOccurrences(of: #"\s+"#, with: " ", options: .regularExpression)
            .trimmingCharacters(in: .whitespaces)
    }
}
