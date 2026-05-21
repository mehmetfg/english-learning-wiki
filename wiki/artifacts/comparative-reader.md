---
title: Comparative Reader — Çift Metin
type: artifact
tags: [reader, comparative, parallel-text, cefr, simplification, paul-graham, naval]
related: [[calisma-yontemleri-analizi]], [[Interactive Reader Template]], [[paul-graham/01-life-is-short]], [[naval-almanack/02-specific-knowledge]], [[CEFR Curriculum Map]]
created: 2026-05-20
updated: 2026-05-20
file: Artifacts/comparative-reader.html
level: A2 ↔ C1
mode: reader
---

# Comparative Reader — Çift Metin

📁 Dosya: `Artifacts/comparative-reader.html`

[[calisma-yontemleri-analizi]]'nin **Ö6** önerisinin uygulaması. Aynı içeriğin **orijinal (B2-C1)** ve **A2 uyarlama** sürümlerini yan yana gösterir; tıklanan kelime/yapı **her iki tarafta** vurgulanır. CEFR adımının görsel kanıtı.

---

## Felsefe

> **Seviye atlama soyut bir hedef değildir — gözle görülür bir dönüşümdür.** A2 öğrencisi B2 metnine baktığında ne anladığı değil, **ne kaybettiği** önemli. Çift panel = simplification dönüşümünün röntgeni. "Saying no is a way of saying yes to what matters" (B2) → "Saying no means saying yes to what is important" (A2). Aradaki *a way of*, *to what matters* → öğrencinin **next-step zorluğu**.

---

## Akış

```
1. Metin seç (Naval / Paul Graham — dropdown)
2. Sol panel: orijinal (CEFR rozeti)
3. Sağ panel: A2 uyarlama (CEFR rozeti)
4. Renkli vurgular: g1=structure, g2=vocab, g3=collocation, g4=phrase
5. Bir vurgulu segmente tıkla → karşı tarafta da aktif olur
6. Sync scroll (toggle 🔗) → iki panel oransal kayar
7. Footer'da seçili segmentin TR/EN karşılaştırması + görüntüleme sayacı
```

---

## 9 Standart Prensip Uyumu

| Prensip | Uygulama |
|---------|----------|
| Tek HTML | ✅ ~450 satır vanilla JS |
| localStorage | ✅ `comparative-reader-v1` — metin seçimi, sync, segment click freq |
| Klavye kısayolları | ✅ `S` sync toggle, `T` tema, `E` export, `Esc` active clear |
| TTS | ⚠️ Henüz yok — her panele Web Speech API butonu Faz 2'de eklenebilir |
| Renk kodu | ✅ 4 tag grubu (g1-g4) farklı renk + alt çizgi |
| Edge case | ✅ Sync infinite loop önleyici (`syncing` flag, 50ms), mobil 1-col reflow, tag filter, print stylesheet |
| JSON bridge | ✅ `comparative_reader_session` schema — seg_clicks per text |
| CEFR rozeti | ✅ Her iki panel başında ayrı rozet (örn. C1 ↔ B1) |
| No praise inflation | ✅ Skor yok zaten — keşif aracı, üretim değil |

---

## Veri Yapısı

Her metin için "pair" array'i:
```js
{
  left:  [{ text: "Specific knowledge ", id: 1, tag: "g2" }, { text: "..." }],
  right: [{ text: "Special knowledge ",  id: 1, tag: "g2" }, { text: "..." }]
}
```

**Eşleştirme:** Aynı `id` = paralel segment. Tıklayınca iki tarafta da `data-id="1"` olan tüm `<span>`'ler vurgulanır.

**Tag grupları (metne göre değişir):**
- g1: dilbilgisi yapısı (cleft, inversion, tense)
- g2: anahtar kelime (level-specific vocabulary)
- g3: collocation
- g4: idiom / sabit ifade

Her metin `legend: { g1: "...", g2: "..." }` ile kendi grup adlarını tanımlar.

---

## Mevcut Metinler (Seed)

| Anahtar | Başlık | Sol CEFR | Sağ CEFR | Segment |
|---------|--------|----------|----------|---------|
| `naval` | Naval — Specific Knowledge | C1 | B1 | 24 paralel |
| `pg` | Paul Graham — Life Is Short | B2 | A2 | 21 paralel |

---

## JSON çıktı şeması

```json
{
  "schema_version": "1.0",
  "type": "comparative_reader_session",
  "session_id": "2026-05-20-1530-comparative-reader",
  "payload": {
    "text_key": "naval",
    "seg_clicks": { "naval:1": 4, "naval:7": 2 },
    "tag_filter": "g1"
  }
}
```

Claude Code işlevi:
- En çok tıklanan segmentler → kullanıcının **dikkat çeken zorlukları**
- `tag_filter` istatistiği → kullanıcı en çok hangi tipi (g1=yapı / g2=kelime / g3=collocation) öğreniyor

---

## Tekrar / Genişletme

### Yeni metin ekleme

`TEXTS` objesine yeni anahtar ekle. **Önemli kural:** Sol panelde *id*-li her segmentin sağ panelde de aynı *id*-li bir karşılığı olmalı. Paralelliği bozmak demek user'ı yanıltmak demek.

### Ölçek

Şu an her metin 3 paragraf. Üst sınır: ~10 paragraf (üstüne çıkınca seg_clicks gürültülenir, sync scroll oransızlaşır). Uzun metinler için bölümlere ayır.

### Otomatik üretim (Faz 2)

Claude Code prompt:
> "Şu C1 metnini A2'ye uyarla, segment paralelliğini koru. Her major vocab/structure değişikliği için id ekle. JSON formatında döndür."

Bu, vault'taki tüm Naval/Paul Graham/Compressed Galaxy bölümlerinin otomatik comparative reader'a dönüştürülebileceği anlamına gelir.

---

## Pedagojik Gerekçe

Krashen'in **i+1** hipotezini görselleştirir: A2 öğrencisi A2 metnini okur (anlama), sonra C1 karşılığına bakıp **tam olarak ne değişti** görür (next step). Bu, klasik graded reader'ın yapamadığı şey: graded reader öğrenciye sadece kendi seviyesini gösterir; comparative reader **bir adım ötesini de** gösterir, ama anlaşılır bağlamda.

---

## İlgili sayfalar

- [[calisma-yontemleri-analizi]] — Ö6 önerisinin spec'i
- [[Interactive Reader Template]] — Reader klasmanı standartları
- [[paul-graham/01-life-is-short]] — sağ panel seed kaynağı
- [[naval-almanack/02-specific-knowledge]] — sağ panel seed kaynağı
- [[CEFR Curriculum Map]] — seviye atlamanın çerçevesi
