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
| 03 | Check | Yazdığın ile kaynak yan yana; ana unsurlar ✓ / ~ / ✗; recall % + delta; "eksiklerim" notu. |
| 04 | **Draw** | Gerçek çizim tuvali (canvas). 4 diyagram tipi: **Mind Map**, **Flowchart**, **Entity Map** (varlık-ilişki), **Free Canvas**. Araçlar: fikir (elips), kutu, karar (eşkenar dörtgen), başla/bitir, varlık (başlık + attribute satırları), not, **Bağla** (etiketli ok: opposes, causes, has, yes/no, 1 : N…), **Kalem** (serbest çizim). Sürükle, boyutlandır, renk ver, "+ Bağlı düğüm", kaydır/yakınlaştır. |
| 05 | Fill | Haritadaki her şekil **ve her ok** için İngilizce cümle (ok cümleleri ilişki kurmayı çalıştırır); 7 kısıt canlı algılanır; ✓ / ~ / ✗ öz değerlendirme. |
| R | Redraw | 1, 3 ve 7 gün sonra harita tuvale bakmadan yeniden çizilir; şekil ve ok eşleşmesiyle puanlanır, iki harita yan yana gösterilir. |

## Kademeli devir (scaffold)
- **S1**: şekiller ve oklar yerleşik, içleri boş (ipucu yazılarıyla). Redraw'da yapı yerinde, yazılar boş.
- **S2**: sadece merkez şekil hazır. Redraw boş tuvalde.
- **S3**: boş tuval; diyagram tipini kullanıcı seçer.
- Geçiş kuralı: üst üste 3 oturum recall ≥ %70.

## Hazır içerik
- *State of Nature: Hobbes, Locke, Hume* (B1, Entity Map, 7 gizli ana unsur)
- *A Rainy Tuesday in Kadıköy* (B1, Mind Map, 6 gizli ana unsur; [[narrative-past-tenses-cluster]] pratiği)
- *Kendi metnim / günüm*: metin + ana unsurlar kullanıcıdan; gün sonu mütalaası için metin boş bırakılabilir.

## Wiki köprüsü
Oturum sonunda `log.md` formatında Markdown kaydı üretilir (recall, kısıtlar, hata desenleri, unutulanlar, fill cümleleri). Harita **Mermaid** kodu olarak eklenir; Obsidian'a yapıştırınca diyagram olarak çizilir. Kopyalanıp Claude'a yapıştırılır → `wiki/practice/` ve `errors/` güncellenir.

## Bilinen sınırlar
- Otomatik eşleşme kelime/kök örtüşmesine dayanır; anlamı ölçmez. Son karar kullanıcının.
- Kısıt algılama regex tabanlı; yanlış pozitif olabilir (örn. "while" zaman anlamında da contrast sayılır).
- Redraw puanı şekil yazılarının kelime örtüşmesine ve okların aynı şekilleri bağlamasına bakar; yerleşim (konum) puanlanmaz.
- Veri tarayıcıya özel (localStorage); cihazlar arası taşınmaz.
