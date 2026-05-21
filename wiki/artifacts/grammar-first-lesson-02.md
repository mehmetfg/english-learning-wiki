---
title: Grammar-First Lesson 02 — Mert's Sunday on the South Bank
type: artifact
tags: [lesson, grammar-first, mert-london, daily-life, B1]
related: [[grammar-first-lesson-01]], [[Past Continuous]], [[Present Perfect Continuous]], [[Relative Clauses]], [[Gerunds and Infinitives]], [[Used To Would]], [[Quantifiers]], [[Conditionals Concept]], [[Reported Speech Concept]]
created: 2026-05-20
updated: 2026-05-20
---

# Grammar-First Lesson 02 — Mert's Sunday on the South Bank

**Dosya:** `Artifacts/lessons/grammar-first-lesson-02.html`
**Seri:** Mert London (Lesson 01'in devamı — pazar günü)
**Hedef süre:** ~30 dakika · **Metin:** ~500 kelime · **Yeni yapı:** 8

## Konsept

Lesson 01'de işlenen 8 yapıyı (Question Formation, Modals, Phrasal Verbs, Articles, Prepositions of Place, Present Perfect, Past Simple, Comparison) **tekrarlamadan**, daily-life rotasından 8 yeni yapı seçildi. Hikâye sürükleyici akıcılığı bozmayacak şekilde örüldü — gramer doğal cümle akışından yükseliyor.

## 8 Yeni Yapı

| # | Yapı | CEFR | Renk |
|---|------|------|------|
| 1 | [[Past Continuous]] | A2 | mavi |
| 2 | [[Present Perfect Continuous]] | B1 | mor |
| 3 | [[Relative Clauses]] | B1 | turuncu |
| 4 | [[Gerunds and Infinitives]] | B1 | teal |
| 5 | [[Used To Would]] | B1 | yeşil |
| 6 | [[Quantifiers]] | A2 | kırmızı |
| 7 | First Conditional ([[Conditionals Concept]]) | A2 | sarı |
| 8 | [[Reported Speech Concept]] | B1 | pembe |

## Hikâye

**Mert's Sunday on the South Bank** — Cumartesi havalimanı koşusundan sonra pazar sabahı. Anne kahvaltıda gazete, Mert mutfakta. Otobüsü kaçırıyorlar; bir yabancı 381 öneriyor. South Bank yürüyüşü, Tate Modern (eski elektrik santrali), 6. kat manzarası, tarçınlı kafede havuçlu kek, ertesi gün Camden planı. ~500 kelime, 10 paragraf.

## Özellikler (spec'e göre 49/92 implementasyonu)

- **Tema & Görsel:** 4 tema (dark/light/forest/sunset), Verdana, kart layout default, max 1100px
- **Sticky header + breadcrumbs + tab nav** (Grammar / Story / Quiz / Practice / Progress)
- **Grammar tab (default):** Card grid ↔ list view toggle, CEFR filter chips (A2/B1/B2/all), search bar, **prev/next ders şeritleri** (Lesson 01 ✓ · Lesson 03 planlanmış)
- **Topic modal:** formula + 3 örnek + edge cases + 5-Q quiz tetiği
- **Story tab:** Renkli gramer vurgu, hover tooltip, click → kart aç, kelime tıkla → 🔊/💾/⭐, **Sade Okuma modu** (vurguları kaldırır, Georgia serif), per-sentence TTS, hız ayarı
- **Quiz:** 4 sekme — **Per-Topic** (her konuya 5-Q bağımsız, MCQ + blank karışık) · **General Mix** (16-Q, 3 can, combo) · **Story-Grammar Combo** (10-Q hikâye bağlamında, matching dahil) · **Comprehension** (8-Q anlama)
- **Practice:** Constraint'li yazma (5 yapı zorunlu), word bank, flashcard
- **Progress:** XP/level, konu bazında accuracy tablosu (sortable), mistake log (last 20), next-lesson reco
- **Data:** localStorage autosave, JSON export (`lesson-progress-1.0` schema → `00_INBOX/`), JSON import
- **Edge & A11y:** Mobile-first, klavye kısayolları (1-5 tab, Esc kapat, Ctrl+F ara), focus mode, print-friendly (sadece metin sekmesi yazdırılır — user_note'a uygun), back-to-top, empty/loading states, long-content truncation

## JSON Export Şeması — `00_INBOX/` köprüsü

`lesson-02-YYYY-MM-DD.json` çıktısı şunları içerir:
- `summary` — XP, level, accuracy, best_combo, bank_size
- `topics{8}` — her konu için attempts/correct/accuracy/done/last_score
- `weak_topics[]` — accuracy < 0.6 & attempts ≥ 3 olanlar
- `mistakes[]` — soru-cevap-tarih ile tam liste
- `bank[]` — kaydedilmiş kelimeler
- `reflect_text` — yazma görevi
- `next_lesson_hint` — `inject_review` (Lesson 03'e enjekte edilecek zayıf konular) + `planned`
- `instructions_for_claude_code` — operatif talimatlar (grammar-coverage.md güncellemesi, weak-topics.md, errors/_index.md, vb.)

## Tüm Lesson 01'den farkı

Lesson 01: 8 yapı havalimanı/Borough bağlamında. Lesson 02: 8 **yeni** yapı pazar sakini bağlamında — tense kaydırması (Past Cont, PPC), clause yapıları (Relative, Reported), conditional + quantifier + used to + ger/inf. Birikimli mantık: hikâye akıcılığı korunarak yapı yoğunluğu artırılıyor.

## Sonraki adımlar (Lesson 03 için planlananlar)

Second Conditional, Wish/If only, Passive Voice, Causative, Future Forms, Adverbs of Frequency, Order of Adjectives, Linking Words — Camden + Regent's Park bağlamında.
