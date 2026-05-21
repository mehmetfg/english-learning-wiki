---
title: Implementation Notes
type: artifact
tags: [engine, docs, decisions, edge-cases]
related: [[english-learning-engine-v1]]
created: 2026-05-18
updated: 2026-05-18
---

# Implementation Notes — Engine v1

`Artifacts/implementation-notes.html` — Faz 1 kurulumunun baş ucundaki not defteri. SPEC'in nasıl yorumlandığı, nereden sapıldığı, hangi alternatiflerin elendiği, hangi edge case'lerin hesaba katıldığı ve hangi soruların kullanıcı onayına açık olduğu.

## Bölümler

1. **Design Decisions** — köprü mekanizması, veri yükleme, rotation, quiz üretimi, SRS algoritması, word-bank köprüsü
2. **Deviations** — tek kaynak yerine iki dosya, "aynı set" cache anahtarı, jeneratif olmayan kapanış metni, TTS sadece B'de
3. **Tradeoffs** — IndexedDB vs localStorage, File System API vs manuel sürükle, FSRS vs SM-2, LLM vs template quiz
4. **Edge Cases** — aynı gün iki kez açma, tıklamasız export, word bank doluluk, leech, saat dilimi, boş seed, dosya adı çakışması, localStorage temizleme
5. **Open Questions** — sabit 7 mi rastgele 6-8 mi? A+B aynı gün zorunlu mu? Boss Battle Day? Faz 2 daily-passage? compressed-galaxy entegrasyonu? Leech eşiği?
6. **Günlük Kullanım Akışı**
7. **Dosya Haritası**

## Faz 2 önerileri (özet)

- Claude Code sabah <code>_engine/daily-passage-YYYY-MM-DD.json</code> üretir (jeneratif metin)
- <code>_engine/daily-questions-YYYY-MM-DD.json</code> zenginleştirilmiş quiz seti
- Tema/font tercihi persisted
- LocalStorage backup/restore aracı
- Leech için otomatik mini-metin tetiği
- Boss Battle Day (pazar)

Detaylar HTML dosyasında, kart-bazında yapılandırılmış.
