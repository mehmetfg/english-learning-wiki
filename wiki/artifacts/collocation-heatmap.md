---
title: Collocation Heatmap
type: artifact
tags: [collocation, heatmap, matrix, drill, vocabulary, chunks]
related: [[calisma-yontemleri-analizi]], [[Vocabulary Hub]], [[Phrasal Verbs Hub]], [[Word Formation]]
created: 2026-05-20
updated: 2026-05-20
file: Artifacts/collocation-heatmap.html
level: A2-B2
mode: reference + drill
---

# Collocation Heatmap

📁 Dosya: `Artifacts/collocation-heatmap.html`

[[calisma-yontemleri-analizi]]'nin **Ö5** önerisinin uygulaması. Verb+Noun, Adj+Noun, Adv+Adj matrislerini **görsel heatmap** olarak gösterir; hangi kombinasyonun doğal olduğu, hangisinin olmadığı tek bakışta görülür.

---

## Felsefe

> **Kelime tek başına anlam üretmez, çevresiyle üretir.** *make a decision* ✓ ama *do a decision* ✗. *strong coffee* ✓ ama *powerful coffee* ✗. Türkçe konuşan kafa bu farkları sürekli yanlış kurar çünkü TR collocation kuralları farklı. Heatmap = collocation strength'in görselleştirilmiş hali; matrix tıklamaya elveriyor.

---

## İki Sekme

### 🔥 Heatmap (referans + keşif)

3 matris:

| Matris | Satır | Sütun |
|--------|-------|-------|
| Verb + Noun | make, do, take, have, give, pay | decision, homework, shower, fun, attention, favor |
| Adjective + Noun | heavy, strong, deep, fast, high, broad | rain, coffee, sleep, food, price, smile |
| Adverb + Adjective | highly, deeply, bitterly, perfectly, utterly, fully | likely, sorry, disappointed, clear, ridiculous, aware |

Hücre renkleri (strength):
- ⬛ **yok** — kullanılmaz / yanlış (örn. *do a decision*)
- 🟫 **zayıf** — bazen / nadiren
- 🟧 **orta** — bağlama göre olur
- 🟨 **güçlü** — yüksek frekanslı doğal kombinasyon

Hücre tıklanınca alt panelde **örnek cümle (EN + TR)** + CEFR + görüntüleme sayacı gösterilir.

### ✍️ Drill (zorla aktif üretim)

10 cümle, boşluğa doğru collocation kelimesi yazılır. Yanlış input → kırmızı border + doğru cevap. Streak takibi.

---

## 9 Standart Prensip Uyumu

| Prensip | Uygulama |
|---------|----------|
| Tek HTML | ✅ ~520 satır vanilla JS |
| localStorage | ✅ `collocation-heatmap-v1` — hücre görüntüleme freq, drill skoru |
| Klavye kısayolları | ✅ `1`/`2` sekme, `→` next drill, `T` tema, `E` export, `Shift+R` reset |
| TTS | ⚠️ Yok (görsel matrix odaklı; örnek cümlelerde ileride eklenebilir) |
| Renk kodu | ✅ Strength gradient (none → strong); hücre seçimi accent outline |
| Edge case | ✅ Boş input ignore, mobile reflow (kart-küçük), tema persistance |
| JSON bridge | ✅ `collocation_session` schema — cell_views + drill_reviews |
| CEFR rozeti | ✅ Hem matrix filtresi hem örnek cümle başında |
| No praise inflation | ✅ Çıplak skor (doğru/hata/streak) |

---

## JSON çıktı şeması

```json
{
  "schema_version": "1.0",
  "type": "collocation_session",
  "session_id": "2026-05-20-1500-collocation",
  "payload": {
    "cell_views": { "vn:0:0": 3, "an:1:1": 1 },
    "drill_reviews": [
      { "sentence": "She had to ___ a quick decision...", "answer": "make", "user": "do", "correct": false }
    ],
    "counts": { "correct": 7, "wrong": 3 }
  }
}
```

Claude Code işlevi:
- Drill'de yanlış olan kelimeler → [[errors/collocations]]'a düşer
- En çok tıklanan "yok" hücreler → kullanıcının kafasındaki **yanlış varsayım** sinyali
- `cell_views` üst dilimi (top 10) → kullanıcının ilgi alanı haritası

---

## Tekrar / Genişletme

### Yeni matris eklemek

`MATRICES` objesine yeni anahtar ekle:
```js
businessVN: {
  label: "Business Verb + Noun",
  rows: ["close", "launch", "land", ...],
  cols: ["deal", "product", "client", ...],
  data: [[3,0,0,...], ...],
  examples: { "close+deal": { cefr: "B2", ex: [...] } }
}
```

### Boyut büyütme

Şu an 6×6 = 36 hücre. Yüksek frekans için bu yeterli; **8×8 = 64** üst sınır (üstüne çıkınca heatmap renkleri ayırt edilmez olur, bilişsel yük artar).

### Tematik setler

Sırada şunlar var:
1. Business collocations (close deal, launch product, land client…)
2. Travel collocations (book flight, catch train, miss connection…)
3. Emotion adverb+adjective (deeply moved, completely shocked…)
4. Academic verb+noun (conduct research, draw conclusion, raise question…)

---

## İlgili sayfalar

- [[calisma-yontemleri-analizi]] — Ö5 önerisinin spec'i
- [[Vocabulary Hub]] — kelime kartlarında collocation'lar atomik gösteriliyor
- [[Phrasal Verbs Hub]] — chunk sentence setleri = de facto collocation listeleri
- [[Word Formation]] — morfoloji + collocation birlikte öğrenilmeli
