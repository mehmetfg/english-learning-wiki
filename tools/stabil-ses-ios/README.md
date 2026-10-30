# Stabil Ses — iPhone için Türkçe stabil erkek sistem sesi

Piper **dfki** Türkçe erkek sesini, iPhone'da **sistem sesi** olarak kurar.
Erişilebilirlik → Seslendirilen İçerik → Sesler → Türkçe altında görünür;
Voice Dream dahil sistem sesini kullanan her uygulamada seçilebilir.

Hedef profil, yıllardır dinlenen Yelda kaydından ölçüldü:
dar tonlama aralığı (~7 yarım ton), duraklamasız akış, sabit ses gücü, 330 kelime/dk.

## Sesi stabil yapan ayarlar (`Extension/Config.swift`)

| Ayar | Değer | Etkisi |
|---|---|---|
| `noiseScale` | 0.2 (varsayılan 0.667) | Tonlama rastgeleliği düşük → düz, sabit ses |
| `noiseScaleW` | 0.1 (varsayılan 0.8) | Hece süresi rastgeleliği düşük → düzenli ritim |
| `silenceScale` | 0.1 | Cümle arası sessizlik kısa → kesintisiz akış |
| `maxModelSpeed` | 2.0 | Model bu hızın üstüne zorlanmaz; fazlası perdeyi bozmadan zaman esnetmeyle yapılır |
| `speedMultiplier` | 1.0 | Voice Dream hızı beklenenden farklı gelirse buradan ayarlanır |
| Kompresör + hedef seviye | −24 dB, 4:1 | Cümleden cümleye aynı ses gücü |

## Kurulum (Mac M1 + iPhone)

Gerekenler: Xcode (App Store'dan, ücretsiz), Homebrew, iPhone'u Mac'e bağlayan kablo.

1. Depoyu Mac'e çek ve bu klasöre gir:
   ```bash
   git clone -b claude/loving-gauss-ssihip https://github.com/mehmetfg/english-learning-wiki.git ~/english-learning-wiki
   ```
   ```bash
   cd ~/english-learning-wiki/tools/stabil-ses-ios
   ```
2. Kurulum betiğini çalıştır (motoru ve dfki sesini kendisi indirir, Xcode projesini açar):
   ```bash
   ./setup.sh
   ```
3. Xcode'da: Settings → Accounts → Apple ID'ni ekle.
4. Sol panelde **StabilSes** projesi → **StabilSes** ve **DfkiVoice** hedeflerinin her birinde
   *Signing & Capabilities* → **Team** olarak kendi adını seç.
5. iPhone'u kabloyla bağla, üstteki cihaz menüsünden iPhone'u seç, ▶ (Run).
6. iPhone'da ilk seferde: Ayarlar → Genel → VPN ve Cihaz Yönetimi → geliştirici uygulamasına **Güven**.
   Gerekirse Ayarlar → Gizlilik ve Güvenlik → **Geliştirici Modu**'nu aç.
7. Stabil Ses uygulamasını aç → **Dfki Stabil'i etkinleştir** → **Dinle** ile dene.
8. Voice Dream → 🔊 → Voice → **Dfki Stabil**.

## Bilinmesi gerekenler

- Ücretsiz Apple ID ile yüklenen uygulama **7 günde bir** yeniden yüklenmeli (Xcode'da tekrar ▶).
  Yıllık ücretli geliştirici hesabında bu süre 1 yıl.
- Ayar değiştirmek için `Extension/Config.swift`'i düzenle ve tekrar ▶.
- Motor: [sherpa-onnx](https://github.com/k2-fsa/sherpa-onnx) v1.12.40 (Apache-2.0).
  Ses: Piper `tr_TR-dfki-medium`.
