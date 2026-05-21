---
title: Confusable Drill — Minimal Pair
type: artifact
tags: [drill, confusables, minimal-pair, timer, errors, fossilization]
related: [[calisma-yontemleri-analizi]], [[_index|Practice Hub]], [[errors/_index|Error Constellation]]
created: 2026-05-20
updated: 2026-05-20
file: Artifacts/confusable-drill.html
level: A2-B2
mode: drill
---

# Confusable Drill — Minimal Pair

📁 Dosya: `Artifacts/confusable-drill.html`

[[calisma-yontemleri-analizi]]'nin **Ö3** önerisinin tek-amaç uygulaması. Sık karıştırılan ikilileri 8 sn timer altında zorunlu seçim drill'iyle hızlandırır. Pasif tanıma yerine refleks üretim.

---

## Felsefe

> **Confusable = fossilization adayı.** *say/tell, much/many, fewer/less, since/for…* — yıllarca yanlış kullanılabilecek hatalar. Her saniye düşünme süresi, yanlış kullanım refleksini güçlendirir. 8 sn timer + zorunlu seçim → karar verme süresini sıkıştırarak doğru refleksi yerleştirir.

---

## Akış

```
1. Cümle göster (içinde ___ boşluğu)
2. İki seçenek (örn. "said" / "told")
3. 8 sn timer (görsel bar, son %25 kırmızı)
4. Cevap → Feedback (kural açıklaması, ✓ / ✗)
5. Enter → Sonraki
6. 20 soru sonunda özet: hata frekansı + Δ önceki oturum
```

**Timeout = hata.** Cevaplamazsan yanlış sayılır → confusable refleks zayıf demek.

---

## 20 Pair (Seed)

| # | Pair | CEFR | Tetikleyici hata |
|---|------|------|------------------|
| 1 | say / tell | A2 | TELL + person object |
| 2 | much / many | A2 | countable vs uncountable |
| 3 | since / for | A2 | start point vs duration |
| 4 | in / on (time) | A1 | days vs months |
| 5 | fewer / less | B1 | countable vs uncountable |
| 6 | make / do | A2 | do favor vs make decision |
| 7 | lend / borrow | B1 | TR "ödünç" tek kelime |
| 8 | bring / take | A2 | yön (buraya vs oradan) |
| 9 | remember / remind | B1 | self vs başkasına |
| 10 | other / another | B1 | tekil vs çoğul |
| 11 | used to / be used to | B1 | eskiden vs alışkın |
| 12 | affect / effect | B2 | verb vs noun |
| 13 | win / beat | B1 | game vs opponent |
| 14 | during / while | B1 | isim vs S+V |
| 15 | still / yet | B1 | soru/negatif vs olumlu |
| 16 | see / watch | A2 | dikkat vs ilişme |
| 17 | rise / raise | B2 | transitive vs intransitive |
| 18 | lay / lie | B2 | nesneli vs nesnesiz |
| 19 | few / a few | B1 | negatif vs pozitif tını |
| 20 | speak / talk | A2 | formal vs informal |

---

## 9 Standart Prensip Uyumu

| Prensip | Uygulama |
|---------|----------|
| Tek HTML | ✅ Vanilla JS, ~480 satır, offline |
| localStorage | ✅ `confusable-drill-v1` — skor, hata freq, son oturum delta |
| Klavye kısayolları | ✅ `1`/`2` seçim, `Enter` next, `T` tema, `Shift+R` reset, `E` export |
| TTS | ⚠️ Yok (drill formatına gereksiz; ileride seslendirme eklenebilir) |
| Renk kodu | ✅ doğru=yeşil, yanlış=kırmızı, timer=accent → danger |
| Edge case | ✅ timeout=hata, double-click disable, theme switch, reset confirm |
| JSON bridge | ✅ `confusable_drill_session` schema → `00_INBOX/*.json` |
| CEFR rozeti | ✅ Her soruda görünür |
| No praise inflation | ✅ Sadece skor + hata + Δ; "harika!" yok |

---

## JSON çıktı şeması

```json
{
  "schema_version": "1.0",
  "type": "confusable_drill_session",
  "session_id": "2026-05-20-1430-confusable-drill",
  "timestamp": "2026-05-20T14:30:00+03:00",
  "payload": {
    "reviews": [
      { "pair": "say / tell", "correct": true, "ms": 3200, "ts": "..." }
    ],
    "counts": { "correct": 17, "wrong": 3 },
    "error_freq": { "fewer / less": 2, "affect / effect": 1 },
    "pairs_seen": ["say / tell", ...]
  }
}
```

Claude Code bu JSON'u okuduğunda:
- `error_freq` yüksek olanlar → [[errors/confusables]]'a yığılır
- 3+ tekrar eden → [[_index|Practice Hub]] L4 "Boss Battle" tetiği
- M2 Daily Engine'in `weak_topics`'ine otomatik enjekte (Faz 2)

---

## Tekrar / Genişletme

Yeni pair eklemek için `PAIRS` array'inin tek bir entry'sini takip et:
```js
{ pair: "isim", cefr: "B1",
  sentence: "Cümle ile ___ boşluk.", options: ["a", "b"], correct: 0,
  rule: "Kısa TR/EN kural açıklaması." }
```

Hedef: 100+ pair (her CEFR seviyesinden 20+). NotebookLM prompt:
> "B1 confusable pair'leri listele: pair, örnek cümle, doğru cevap, kısa kural — JSON formatında."

---

## İlgili sayfalar

- [[calisma-yontemleri-analizi]] — Ö3 önerisinin orijinal spec'i
- [[_index|Practice Hub]] — L4 Error Drill lane bağlantısı
- [[Phrasal Verbs Hub]] — benzer takip-based liste mantığı
