# Vade: Sözleşme, Sigorta ve Garanti Takibi (pilot)

Kişisel kullanım için iPhone ve Mac uygulaması. Telefon hattı, internet ve abonelik sözleşmelerini; kasko, trafik, konut ve sağlık poliçelerini; cihaz garanti belgelerini tek yerde toplar. Belgeyi tararsın, uygulama metni **cihaz üzerinde** okur, şartları ve tarihleri **cihaz üzerindeki yapay zekâ** ile çıkarır. Bitiş yaklaşınca hatırlatır.

## Ne yapar?

| Özellik | Açıklama |
|---|---|
| Belge tarama | iPhone kamerasıyla çok sayfalı tarama (VisionKit). Mac'te fotoğraf, PDF veya metin ile. |
| Hızlı dijital veri | e-fatura, e-poliçe, e-garanti PDF'leri doğrudan okunur (metin katmanı varsa OCR'a gerek kalmaz). SMS veya e-posta metni yapıştırılabilir. |
| Tür seçimi, içerik otomatik | Sen türü seçersin (Kasko, Mobil hat, Cihaz garantisi…). Başlık, şirket, plaka veya hat no, başlangıç ve bitiş, prim veya ücret, cayma bedeli veya muafiyet, otomatik yenileme ve önemli maddeler otomatik doldurulur. Kaydetmeden önce kontrol edersin. |
| Şartlar | Maddeler Kritik, Önemli ve Bilgi olarak sınıflanır (ör. kaskoda muafiyet ve ikame araç, internette cayma bedeli). |
| Son ödeme | "En son ne kadar ödedim?" sorusunun cevabı: her kayıtta ödeme geçmişi tutulur. |
| Hatırlatma | Bitişten 60/30/14/7/3/1 gün önce (seçilebilir) saat 09:00'da bildirim. Otomatik yenilenen sözleşmede iptal bildirimi son günü için ayrı uyarı. |
| Özet panosu | 30 gün içinde bitecekler, aylık abonelik toplamı, yıllık sigorta toplamı. |
| iPhone ↔ Mac | iCloud (CloudKit) özel veritabanı ile otomatik senkron. Sunucu yok. |
| Gizlilik | OCR ve analiz cihazda yapılır. Belgeler yalnızca senin iCloud hesabında durur. |

## Mimari

```
Vade.xcodeproj                     # Hazır Xcode projesi (çift tıkla, aç)
project.yml                        # Sadece CI testleri için (XcodeGen)
VadeTests/                         # Türkçe çıkarıcı birim testleri
Vade/
├── App/VadeApp.swift              # Giriş noktası, SwiftData + CloudKit konteyneri
├── Models/
│   ├── Categories.swift           # Tür, grup, dönem, önem dereceleri ve türe özel ipuçları
│   ├── Models.swift               # TrackedItem, Clause, Payment, StoredDocument (SwiftData)
│   └── ItemDraft.swift            # Form taslağı; analiz sonucunu birleştirir, modele yazar
├── Services/
│   ├── ImportPipeline.swift       # Tarama/fotoğraf/PDF/metin → düz metin + saklanacak PDF (Vision OCR, PDFKit)
│   ├── DocumentAnalyzer.swift     # Hibrit analiz: önce cihaz üstü model, boşlukları kural tabanlı doldurur
│   ├── OnDeviceModelAnalyzer.swift# Apple Foundation Models ile yapılandırılmış çıkarım (@Generable)
│   ├── HeuristicExtractor.swift   # Türkçe tarih, tutar, plaka, hat no, anahtar madde yakalama (model yoksa)
│   ├── ReminderScheduler.swift    # Yerel bildirimler
│   └── Platform.swift             # UIImage/NSImage farkları
└── Views/                         # SwiftUI: üç sütunlu ana ekran, detay, form, ekleme akışı, belge görüntüleyici
```

### Analiz nasıl çalışır?

1. **OCR**: Vision `RecognizeTextRequest`, Türkçe + İngilizce, yüksek doğruluk modu.
2. **Yoğunlaştırma**: Uzun sözleşmenin başı ile tarih, tutar ve anahtar kelime (cayma, muafiyet, taahhüt…) geçen satırlar seçilir. Cihaz üstü modelin bağlam penceresi küçük olduğu için bu adım gerekli.
3. **Cihaz üstü model** (Apple Intelligence açıksa): Guided generation ile doğrudan `GeneratedAnalysis` yapısı doldurulur. Serbest metin ayrıştırma yok, uydurma değer yasak.
4. **Kural tabanlı yedek**: Model yoksa, Türkçe desteklenmiyorsa veya bir alanı boş bıraktıysa, düzenli ifadelerle tarih, tutar ve kimlik çıkarılır. Sigortada tek tarih bulunursa bitiş +1 yıl, garantide +2 yıl (yasal asgari) tahmin edilir.
5. **Senin onayın**: Form önceden dolu açılır. Sen düzeltip kaydedersin.

## Kurulum (Mac'te)

Gereksinimler: Xcode 26+, iPhone'da iOS 26, Mac'te macOS 26, bir Apple ID. Ek araç gerekmez.

**1. Projeyi indir:** GitHub'da `claude/dreamy-lovelace-orfs99` dalını ZIP olarak indir ya da:

```bash
git clone -b claude/dreamy-lovelace-orfs99 https://github.com/mehmetfg/english-learning-wiki.git
```

**2. Aç:** `apps/vade/Vade.xcodeproj` dosyasına çift tıkla.

**3. İmzala:** Soldaki **Vade** projesi → **Vade** hedefi → **Signing & Capabilities** → **Team** olarak kendi Apple ID'ni seç (listede yoksa: Xcode → Settings → Accounts → + ile ekle). "Bundle identifier kullanılıyor" hatası çıkarsa `com.mehmetfg.vade` kimliğini `com.mehmetfg.vade2` gibi değiştir.

**4. iPhone'a kur:**
1. iPhone'u kabloyla Mac'e bağla, iPhone'da "Bu bilgisayara güven" de.
2. iPhone'da **Ayarlar → Gizlilik ve Güvenlik → Geliştirici Modu**'nu aç (telefon yeniden başlar).
3. Xcode'da üstteki hedef cihaz menüsünden iPhone'unu seç → ▶︎ (Run).
4. Ücretsiz hesapta ilk açılışta "Güvenilmeyen geliştirici" uyarısı çıkar: **Ayarlar → Genel → VPN ve Cihaz Yönetimi** → kendi Apple ID'ne dokun → **Güven**.

**5. Mac'e kur:** Hedef cihazı **My Mac** yap → ▶︎.

> Ücretsiz hesapla kurulan uygulama **7 gün** sonra açılmaz; Xcode'dan tekrar ▶︎ ile kurman yeter (veriler silinmez). Ücretli hesapta bu süre 1 yıldır.

### iCloud senkronunu açmak (ücretli Apple Developer hesabı gerekir)

Hazır proje ücretsiz hesapla imzalanabilsin diye iCloud'suz gelir; veriler her cihazda ayrı tutulur. Senkron için Xcode'da **Vade** hedefi → **Build Settings** → `Code Signing Entitlements` satırını şöyle değiştir:

| Platform | Değer |
|---|---|
| iOS (Any iOS SDK) | `Vade/Support/Vade-iOS.entitlements` |
| macOS (Any macOS SDK) | `Vade/Support/Vade-macOS.entitlements` |

Sonra **Signing & Capabilities** sekmesinde **+ Capability → Background Modes → Remote notifications** ekle. Kod değişikliği gerekmez; uygulama iCloud'u otomatik kullanır.

> Not: Apple Intelligence'ın Türkçe desteği cihaz ve sürüme bağlıdır. Desteklenmiyorsa uygulama kural tabanlı çıkarımla çalışmaya devam eder; sadece özet ve madde açıklamaları daha sade olur.

## Bilinen sınırlar (pilot)

- Kod GitHub Actions'ta (Xcode 26.6) iOS Simulator ve macOS için derleniyor, çıkarıcı birim testleri geçiyor; gerçek cihazda kamera, Apple Intelligence ve iCloud henüz denenmedi.
- Apple Intelligence yalnızca destekleyen iPhone'larda (iPhone 15 Pro ve sonrası) ve açıksa çalışır; diğerlerinde kural tabanlı çıkarım kullanılır.
- Mac'te doğrudan kamera taraması yok. Continuity Camera veya iPhone'da tarayıp senkronla.
- Bildirimler cihaz başınadır. Her cihaz kendi hatırlatmalarını kurar (bu bilinçli bir tercih).

## Yol haritası

1. **Pilot (şimdi)**: Kişisel kullanım, iPhone + Mac, iCloud senkronu.
2. **Genişletme**: Widget (en yakın 3 bitiş), takvime ekle, Siri/Kısayollar ile "kaskom ne zaman bitiyor?", yıllık prim karşılaştırma grafiği, Paylaş menüsünden PDF alma (Share Extension).
3. **Web + sunucu**: Veri modeli (TrackedItem/Clause/Payment/Document) bir REST/GraphQL API'ye ve Postgres'e birebir taşınabilir. Analiz katmanı (DocumentAnalyzer) arayüzden ayrı olduğu için sunucu tarafında farklı bir modelle değiştirilebilir. Çok kullanıcılı yapıda KVKK gereği belgeler şifreli saklanmalıdır.
