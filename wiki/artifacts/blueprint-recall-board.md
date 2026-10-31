---
title: Blueprint Recall Board — Kör Hatırla, İskelet Kur, Doldur
type: artifact
tags: [retrieval-practice, active-recall, blueprint, concept-mapping, writing, b1, test]
related: [[blueprint-recall-method]], [[calisma-yontemleri-analizi]], [[narrative-past-tenses-cluster]], [[writing-ladder]], [[_index|Practice Hub]]
created: 2026-10-31
updated: 2026-10-31
file: Artifacts/blueprint-recall-board.html
level: B1
mode: tool
---

# Blueprint Recall Board

[[blueprint-recall-method]] protokolünün çalışan test aracı. Tek dosya HTML, localStorage, açık/koyu tema, telefon uyumlu.

📁 Dosya: `Artifacts/blueprint-recall-board.html`

## Akış (5 sheet + redraw)

| Sheet | Ad | Ne olur |
|---|---|---|
| 01 | Encode | Metin bir kez okunur, okuma süresi sayılır. Örneklerde ana unsurlar gizli. |
| 02 | Blind Recall | Kaynak kapanır; 3 dk geri sayımlı brain dump (zihin boşaltma). |
| 03 | Check | Yazdığın ile kaynak yan yana; ana unsurlar otomatik eşleşme önerisiyle ✓ / ~ / ✗ işaretlenir; recall % + önceki oturuma göre delta; "eksiklerim" notu. |
| 04 | Blueprint | 4 şablon: Claim Map, Event Web, Form-Use Tree, Argument Skeleton. Düğümlere İngilizce anahtar kelime; 6+ kelimede uyarı. Claim Map'te etiketli oklar (opposes, develops...). |
| 05 | Fill | Her düğüm için İngilizce cümle; 7 kısıt (Past Simple, Past Continuous, Past Perfect, contrast, cause, reporting verb, relative clause) canlı algılanır; her cümle ✓ / ~ / ✗ öz değerlendirme. |
| R | Redraw | 1, 3 ve 7 gün sonra iskelet bakmadan yeniden doldurulur; orijinalle karşılaştırılır, delta kaydedilir. |

## Kademeli devir (scaffold)
- **S1**: düğüm adları + ipuçları + örnekler
- **S2**: sadece düğüm adları
- **S3**: boş sayfa; şablonu ve düğüm adlarını kullanıcı belirler
- Geçiş kuralı: üst üste 3 oturum recall ≥ %70.

## Hazır içerik
- *State of Nature: Hobbes, Locke, Hume* (B1, Claim Map, 7 gizli ana unsur)
- *A Rainy Tuesday in Kadıköy* (B1, Event Web, 6 gizli ana unsur; [[narrative-past-tenses-cluster]] pratiği)
- *Kendi metnim / günüm*: metin + ana unsurlar kullanıcıdan; gün sonu mütalaası için metin boş bırakılabilir.

## Wiki köprüsü
Oturum sonunda `log.md` formatında Markdown kaydı üretilir (recall, kısıtlar, hata desenleri, unutulanlar, fill cümleleri). Kopyalanıp Claude'a yapıştırılır → `wiki/practice/` ve `errors/` güncellenir.

## Bilinen sınırlar
- Otomatik eşleşme kelime/kök örtüşmesine dayanır; anlamı ölçmez. Son karar kullanıcının.
- Kısıt algılama regex tabanlı; yanlış pozitif olabilir (örn. "while" zaman anlamında da contrast sayılır).
- Veri tarayıcıya özel (localStorage); cihazlar arası taşınmaz.
