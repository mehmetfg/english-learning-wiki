---
title: Grammar-First Daily
type: artifact
tags: [engine, motor-a, grammar, daily]
related: [[english-learning-engine-v1]], [[text-first-daily]]
created: 2026-05-18
updated: 2026-05-18
---

# Grammar-First Daily — Motor A

`Artifacts/grammar-first-daily.html` · ~480 satır vanilla JS.

**Akış:** Önce kavram, sonra metin. Bugünün 6-8 konusu kart olarak listelenir; her karta dokunmak modal açar (TR köprü → formül → örnekler → yaygın hatalar → mini quiz). Sayfanın altında konuların hepsini ören kısa bir bağlam paragrafı (hover tooltip ile).

**Mimari kaynak:** [[İngilizce Rehber Serisi|english_rehber2.html]] — kart grid + modal + quiz pattern'i.

## Akış adım adım

1. Sayfa açılır → `engine.js` rotation çalışır → 7 konu seçilir, localStorage'a cache'lenir
2. Her karta dokun → modal açılır → mini quiz (3 soru: MCQ + fill + errspot)
3. Quiz tamamlandığında o konu için skor `localStorage`'a kaydedilir (`elv1_topic_progress`)
4. "💾 Save chunk" butonu örneklerden anlamlı parçayı word bank'a ekler
5. "📥 Vault'a İndir" butonu → JSON dump → `00_INBOX/`

## JSON çıktı şeması

```json
[
  {
    "schema_version": "1.0",
    "type": "session_grammar_first",
    "timestamp": "2026-05-18T14:32:00+03:00",
    "engine": "grammar-first",
    "session_id": "2026-05-18-1432-grammar-first",
    "duration_sec": 1240,
    "payload": [
      { "slug": "present-perfect", "name": "Present Perfect", "cefr": "A2",
        "category": "tenses", "correct": 2, "total": 3, "score_pct": 67,
        "errors": [...], "subpatterns_touched": ["experience"] }
    ]
  },
  {
    "type": "word_bank_add",
    "payload": [ {item, type, definition_tr, example, source}, ... ]
  }
]
```

## Kullanım ipucu

- Bir karta dokunduktan sonra modal'ın altındaki "Quiz'i Başlat" — atlama, çıkacak süre ~2 dk
- Mini quiz cevapsız bırakılırsa skor kaydedilmez (örnek görülmüş sayılır ama strength'e işlemez)
- Reroll 🎲 butonu yeni 7'li set verir — aynı gün içinde fikir değiştirmek için

İlgili: [[implementation-notes]]
