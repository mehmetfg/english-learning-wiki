---
title: Les Misérables Ch07 — Paris Intensive Study App
type: artifact
tags: [les-miserables, interactive, vocabulary, study-tool, HTML]
related: [[Les-Miserables-Ch07-Paris]], [[Les-Miserables-A2B1]], [[Vocabulary Hub]]
created: 2026-05-13
updated: 2026-05-13
---

# Les Misérables Ch07 — Paris: Intensive Study App

**Dosya:** `Artifacts/les-miserables-ch07-study.html`  
**Tür:** Tek dosya interaktif HTML/CSS/JS uygulaması  
**İçerik:** Chapter 7 özet metin + 10 hedef kelime odaklı yoğun çalışma

---

## Kapsam

- **Condensed reader:** Chapter 7'nin ~1.400 kelimelik öz anlatımı; TTS uyumlu, A2/B1 seviyesinde
- **10 hedef kelime:** peripheral, sanctuary, brevity, premonition, composure, proximity, methodically, vain, assessing, effusive
- **5 sekme:** Read → Words → Recall → Produce → Score

---

## Sekmeler

| Sekme | İçerik |
|-------|--------|
| 📖 Read | Özet metin; 10 kelime vurgulu, tıklanabilir popover (tanım + Türkçe + örnek + ipucu) |
| 🔤 10 Words | Her kelime için ayrı kart: fonetik, İngilizce tanım, Türkçe, metin cümlesi, hafıza ipucu |
| 🎯 Recall | A: Tanım eşleştirme (10 çift) · B: Boşluk doldurma dropdown (8 cümle) · C: Doğru kullanım T/F (8 cümle) |
| ✏️ Produce | D: Sahne yeniden anlatımı (gece kaçış, hedef kelime sayacı) · E: 5 kelime için kendi cümlen |
| 🏆 Score | A/B/C puanları özeti; tüm tamamlandığında tebrik mesajı |

---

## Tasarım

- Aynı renk sistemi: `--accent: #8b4513` (açık) / `#d4843a` (koyu)
- Açık/koyu tema toggle + `localStorage` kalıcılık
- Verdana fontu
- Tam puan takibi (A/B/C ayrı ayrı)
- Tüm egzersizler Check + Reset düğmeli
- Mobil uyumlu (responsive grid)

---

## İlişkili Sayfalar

- [[Les-Miserables-Ch07-Paris]] — tam metin
- [[Les-Miserables-A2B1]] — seri genel bakış
- [[les-miserables-ch04-workbook.html]] — Ch04 interaktif workbook (aynı stil)
