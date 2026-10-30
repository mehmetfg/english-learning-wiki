import AVFoundation
import SwiftUI

@main
struct StabilSesApp: App {
    var body: some Scene {
        WindowGroup { ContentView() }
    }
}

final class Speaker: ObservableObject {
    private let synthesizer = AVSpeechSynthesizer()
    static let voiceIdentifier = "com.mehmetfg.stabilses.dfki"

    var voice: AVSpeechSynthesisVoice? { AVSpeechSynthesisVoice(identifier: Self.voiceIdentifier) }

    func speak(_ text: String, rate: Float) {
        synthesizer.stopSpeaking(at: .immediate)
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = voice
        utterance.rate = rate
        synthesizer.speak(utterance)
    }
}

struct ContentView: View {
    @StateObject private var speaker = Speaker()
    @State private var text = "Bağdat'ın çevirmenleri bir dil kurdu. Kindî, hakikatin kaynağının onun değerini belirlemediğini söyledi. Fârâbî, dini felsefenin halk için yapılmış bir benzetmesi olarak düşündü."
    @State private var rate: Float = AVSpeechUtteranceDefaultSpeechRate
    @State private var status = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("1. Sesi sisteme tanıt") {
                    Button("Dfki Stabil'i etkinleştir") {
                        AVSpeechSynthesisProviderVoice.updateSpeechVoices()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            status = speaker.voice == nil
                                ? "Henüz görünmüyor. Birkaç saniye sonra tekrar dene."
                                : "✓ Ses sistemde: Ayarlar → Erişilebilirlik → Seslendirilen İçerik → Sesler → Türkçe"
                        }
                    }
                    if !status.isEmpty { Text(status).font(.footnote) }
                }
                Section("2. Dene") {
                    TextEditor(text: $text).frame(minHeight: 120)
                    VStack(alignment: .leading) {
                        Text("Hız: \(rate, specifier: "%.2f")")
                        Slider(value: $rate, in: AVSpeechUtteranceMinimumSpeechRate...AVSpeechUtteranceMaximumSpeechRate)
                    }
                    Button("Dinle") { speaker.speak(text, rate: rate) }
                }
            }
            .navigationTitle("Stabil Ses")
        }
    }
}
