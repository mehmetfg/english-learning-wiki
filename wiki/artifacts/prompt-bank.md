---
title: Generative Prompt Bank — Constraint Lottery
type: artifact
tags: [writing, prompts, constraint, lottery, b1, grammar, phrasal-verbs]
related: [[calisma-yontemleri-analizi]], [[writing-ladder]], [[daily-writing-loop]], [[Phrasal Verbs Hub]], [[Past Perfect]], [[Conditionals Concept]], [[_index|Practice Hub]]
created: 2026-05-23
updated: 2026-05-23
file: Artifacts/prompt-bank.html
level: B1
mode: tool
---

# Generative Prompt Bank — Constraint Lottery

[[calisma-yontemleri-analizi]] Ö7 önerisinin **v1 örneği**. "Bugün ne yazayım?" sürtünmesini öldüren rastgele constraint kart çekme aracı. Kullanıcı düşünmüyor — sistem rastgele bir zorunluluk seti dağıtıyor.

📁 Dosya: `Artifacts/prompt-bank.html`

---

## Felsefe

> **Özgürlük üretmez. Constraint üretir.**

Boş sayfa = panik. Tam senaryo = ezber. Aradaki çözüm: **rastgele constraint setleri.** Her kart 3-7 zorunluluk taşır: gramer yapısı + phrasal verb + konu + hedef kelime sayısı.

Felsefe [[writing-ladder]] ile aynı (constraint > freedom), ama format farklı:
- **Writing Ladder** → seviye slider (scaffold A1→B2)
- **Prompt Bank** → rastgele constraint enjekte (zorlama variety)

---

## 60 Kart, 5 Kategori

| Kategori | # | Örnek |
|----------|---|-------|
| ⚙️ **Grammar** | 15 | "G01 — Use Past Perfect ×2. 80 words about a moment that surprised you." |
| 🔗 **Phrasal Verbs** | 15 | "P01 — Use: come up with, put off, figure out. 60 words about a project." |
| 💭 **Topic** | 15 | "T09 — What does 'wealth' mean to you? 80 words." |
| ⚡ **Quick** (≤50 kel.) | 10 | "Q03 — Describe today's weather without using 'hot/cold/sunny/rainy'. 40 words." |
| 🧩 **Combined** | 5 | "C01 — Use Past Perfect + 'come up with' + 'figure out'. 90 words about a problem you solved." |

Kategori filtresi pill'lerle: Tümü / Grammar / PV / Topic / Quick / Combined.

---

## Mekanik

### Rastgele çekiliş
- "🎲 Bir kart çek" → filtre'deki pool'dan rastgele 1 kart
- Son 8 çekilişten kaçınma (`drawHistory`)
- "↻ Başka kart" → yeniden çek
- "📋 Kopyala" → kart text'i + chips clipboard'a

### Yazma alanı
- Textarea + canlı kelime sayacı
- Hedef bandı: %80-%120 → yeşil ("ok"), %120 üstü → sarı ("over"), altı → varsayılan
- **✓ Kontrol et** butonu:
  - **Chip presence:** PV/topic chip'leri için substring lookup (`lower.includes(...)`)
  - **Structural chips** (`Past Perfect`, `Passive Voice` vb.) skip edilir (sadece duyurulur, lexical aranmaz)
  - **Word count:** %70 altı → "çok kısa", %150 üstü → "uzun"
  - **Punctuation:** son cümle bitiş işareti
  - Sonuç: warn ya da ok class'lı kontrol kutusu, "Bakılacak N nokta" listesi

### Kayıt
- "💾 Kaydet" → son 10 yazıyı `recent[]` listesinde tutar
- Recent item'a tıklama → "geri yükle?" confirm → cart + content restore

---

## Teknik

- **CARDS:** 60 obje, her biri `{ id, cat, target, chips[], text }`
- **State:** `prompt_bank_v1` → `filter, currentId, drawHistory[30], recent[10]`
- **Filter:** pill button row, ARIA-friendly
- **Tema:** purple/lilac default + paper-purple light
- **Check heuristic:** structural-tag whitelist (gramer yapısı), substring lookup (lexical)

---

## Edge Case'ler

| # | Senaryo | Davranış |
|---|---------|----------|
| 1 | Filter'da kart yok | Boş gösterim — count "0 kart" |
| 2 | İlk açılışta currentId null | "Bir kart çek" CTA, write area pasif |
| 3 | Kelime sayısı hedefin altı | Sarı band yerine default; kontrol warn verir |
| 4 | Structural chip (e.g. "Past Perfect") | Kontrol sadece chip'i yeşil renkte gösterir, substring aramaz |
| 5 | Recent'tan geri yükle | Confirm modal — istek yoksa write area korunur |
| 6 | Clipboard izni yok | catch → "Kopyalanamadı" alert |
| 7 | localStorage corrupt | try/catch + default state |
| 8 | Cart-write-save flow ortada refresh | currentId + writing state geri yüklenir |

---

## v1 Sınırlamaları

- **60 kart** — Ö7 önerisi 200 demişti. v2'de 140 kart daha ekleyebilirim (deeper grammar coverage, B2 cards, advanced PVs).
- **AI check yok** — sadece heuristic. Gramer doğruluğu için harici LLM gerekir.
- **Custom card builder yok** — kullanıcı kendi kartını ekleyemiyor. v2'de "Yeni kart ekle" form.
- **Random ≠ smart** — kart seçimi uniform random + son 8'den kaçınma. "Bu hafta hangi gramer'i kaçırdın" smart match yok. v2'de [[grammar-coverage]] ile bağlanabilir.
- **JSON bridge yok** — yazılan paragraflar vault'a otomatik akmıyor. "Save to wiki/practice/cells" butonu eklenebilir.

---

## Wiki Bağlantıları

- [[calisma-yontemleri-analizi#Ö7 — Generative Prompt Bank (Constraint Lottery)]] — orijinal öneri
- [[writing-ladder]] — komşu üretim aracı (scaffold-based)
- [[daily-writing-loop]] — komşu üretim aracı (imitation-based)
- [[Phrasal Verbs Hub]] — PV chip'lerinin kaynağı
- [[Past Perfect]] · [[Conditionals Concept]] · [[Passive Voice Concept]] · [[Reported Speech Concept]] · [[Used To Would]] · [[Future Will]] · [[Future Going To]] — Grammar chip'lerinin kaynakları
- [[Practice/Grammer Topics/_index|Practice Hub]] L1 Production Cell — bunun "rastgele zorlama" katmanı
