---
title: Text-First Daily
type: artifact
tags: [engine, motor-b, text, daily, tts]
related: [[english-learning-engine-v1]], [[grammar-first-daily]]
created: 2026-05-18
updated: 2026-05-18
---

# Text-First Daily — Motor B

`Artifacts/text-first-daily.html` · ~470 satır vanilla JS.

**Akış:** Önce metin (bugünün 6-8 konusu renk kodlu olarak içine örülmüş), sonra her vurgulu kelime/yapının grameri açılır, kelime bankası beslenir, kendi yansımanı yazarsın. Aynı 6-8 konu Motor A'yla **çapraz teyit**.

**Mimari kaynak:** [[compressed-galaxy-002-cogito|002 Cogito — The Man Who Burned Everything]] — sticky tabs + colored grammar highlights + tooltip + TTS pattern'i.

## Sekme yapısı

| Tab | İçerik |
|-----|--------|
| **📖 Read** | Bugünün dokuması (paragraph) + gloss list (renk → konu mapping) + TTS |
| **📐 Grammar** | Her konu için detay kart (TR köprü, formül, örnekler, hatalar — collapsible) |
| **📚 Vocab** | Metinden çıkarılan chunk'lar + manuel ekleme + "💾 Save to Bank" |
| **🎯 Quiz** | Cross-quiz: her konudan 2 soru, karışık |
| **✍️ Reflect** | Constraint'li yazım önerisi + textarea (localStorage'a kayıt) |

## JSON çıktı şeması

```json
[
  {
    "schema_version": "1.0",
    "type": "session_text_first",
    "session_id": "2026-05-18-1530-text-first",
    "tabs_visited": ["read", "vocab", "quiz", "reflect"],
    "reflect_text": "Bugün bileşik faiz üzerine düşündüm. ...",
    "payload": [ {slug, correct, total, errors, ...}, ... ]
  },
  { "type": "word_bank_add", "payload": [...] }
]
```

## Reflect prompt

Her gün constraint'li bir yazma önerisi gelir: günün ilk 4 konusunu en az birer kez kullanan 3-5 cümle, kullanıcı profilindeki bir anchor (philosophy/writing/finance/AI/psychology/literature) etrafında. AI praise inflation yok; sadece kelime sayısı ve constraint kontrolü.

## TTS

`Read` sekmesinde "🔊 Sesli oku" butonu Web Speech API kullanır. Hız: `profile.json` → `default_tts_rate` (0.95). Tıkrar tıklamak durdurur.

İlgili: [[implementation-notes]]
