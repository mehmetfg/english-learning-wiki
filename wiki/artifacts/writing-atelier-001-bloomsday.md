---
title: Writing Atelier 001 — Ulysses & Bloomsday
type: artifact
tags: [writing, narrative-tenses, joyce, ulysses, bloomsday, B1, ghost-text, gamification, atelier]
related: [[Past Simple]], [[Past Continuous]], [[Past Perfect]], [[Used To Would]], [[ulysses-bloomsday-b1]], [[narrative-past-tenses-cluster]], [[Interactive Reader Template]]
created: 2026-05-15
updated: 2026-05-15
file: Artifacts/writing-atelier-001-bloomsday.html
level: B1
series: Writing Atelier
episode: '001'
---

# Writing Atelier 001 — Ulysses & Bloomsday

Aktif **yazma** odaklı yeni klasman pilotu. Joyce'un *Ulysses*'inden uyarlanan B1 düzeyinde 280-kelimelik bir Bloomsday senaryosu üzerinden **5 narrative past tense**'i öğretir; üç ayrı yazma modu, pause-aware ghost text ve gamification ile öğrenciyi pasif okuyucu konumundan üretici konumuna geçirir.

📁 Dosya: `Artifacts/writing-atelier-001-bloomsday.html` (~62 KB)

---

## Kapsam

### 5 Gramer Yapısı ("Narrative Past Tenses" kümesi)

1. **Past Simple** — anlatı omurgası
2. **Past Continuous** — arka plan, eş zamanlı eylem
3. **Past Perfect** — flashback / önceki olay
4. **Used to / Would** — geçmiş alışkanlık
5. **Time Adverbials** — when / while / as / before / after / by

Tam küme açıklaması: [[narrative-past-tenses-cluster]]

### Kaynak

[[ulysses-bloomsday-b1]] — Joyce/Ulysses B1 uyarlaması, TED-Ed (Sam Slote) referansı.

---

## 5 Sekme Yapısı

1. **📖 Story** — 280 kelimelik Bloomsday model paragrafı, 5 yapı renk-kodlu, hover vocabulary tooltip (14 kelime), TTS controller (0.6-1.4× hız), Türkçe çeviri toggle, "Why Bloomsday?" kültürel kutusu (Odyssey paraleli, stream of consciousness, modernizm).

2. **🔧 Grammar** — 5 yapı accordion: formül + 4 örnek (story metninden) + edge case + 2 soruluk mini-test her yapı için.

3. **✍️ Practice** — Üç alt mod:
   - **Sentence Builder (10 cümle):** Karışık kelimelerden cümle kur, click-to-pick, çoklu valid permütasyon desteği, hint butonu (-5 XP), shake animation yanlış için.
   - **Rewrite Challenge (6 cümle, 14 hedef varyant):** Past Simple cümlesini başka yapıya dönüştür (Past Continuous / Past Perfect / Used to / Would / While+Past Continuous), regex-based kontrol, hedef yapı seçim butonu.
   - **Story Continuation (4 prompt):** Bloom'un günü nasıl devam etti? Pause-aware ghost text (1.5s debounce, mirror div overlay, Tab=kabul/Esc=reddet), hint butonu, auto-save on blur.

4. **🎯 Exercises** — FIB (10) + Find Error (8) + TR→EN (8). Token-overlap toleranslı TR→EN kontrolü.

5. **🌍 Explore** — Writing Craft (4 kart: Time-jumping, Habitual past, Background detail, Time adverbials), Joyce & Modernism (3 kart: Odyssey, Stream of Consciousness, Modernism), Translation Notes (6 satır), açık-uçlu "Your Bloomsday" yazma görevi (auto-save).

---

## Vault'ta İlk Olan Özellikler

- **Pause-aware Ghost Text** (textarea overlay mirror) — kullanıcı 1.5 sn duraklayınca pre-authored öneri ghost olarak belirir; Tab kabul, Esc reddet (3 sn cooldown).
- **Backspace cooldown** — son 3 sn'de backspace varsa ghost gösterilmez (kullanıcı düzenliyor).
- **Active Hint Button** — her writing prompt için model cümleyi gramer renkli açar (-5 XP).
- **Rewrite Challenge** — aynı temel cümleyi 2-3 farklı hedef yapıya dönüştürme egzersizi.
- **Streak çoklu confetti tier'ı** — 3 streak (altın), 5 streak (flash), 10 streak (Bloomsday Master achievement).
- **Çoklu valid permütasyon** — sentence builder'da bazı sıralar tolere edilir (gelecekte genişler).

---

## Edge Case'ler Uygulandı

| # | Edge case | Uygulama |
|---|-----------|----------|
| 1 | Ghost text güvenliği | Kursor textarea sonunda değilse veya seçim varsa **gösterilmez** |
| 2 | Backspace cooldown | Son 3 sn'de backspace varsa ghost timer iptal |
| 3 | Confetti throttle | 800 ms minimum aralık |
| 4 | Sentence builder permütasyonları | `valid` array, çoklu kabul desteği (şimdilik 1 permütasyon / cümle) |
| 5 | Auto-save on blur | textarea blur'da localStorage'a yazılır |
| 6 | Mobile drag yok | Click-to-pick tabanlı; küçük ekranda da çalışır |
| 7 | Reset güvenliği | İlk tıkta toast + 2.5 sn pencere; ikinci tıkta sıfırla |
| 8 | TTS race | Sekme değiştirilince `ttsStop()` çağrılır |
| 9 | Print sadeleştirme | `@media print` ile toolbar, confetti canvas, butonlar gizli |
| 10 | TTS cleanup | `beforeunload` event'inde TTS iptal |

---

## XP / Level Sistemi

- **Levels:** Apprentice (0) → Storyteller (120) → Chronicler (300) → Bloomsday Wanderer (600) → Joycean Master (1000)
- **XP olayları:**
  - Sentence builder doğru: +15 (no hint) / +10 (hint kullanıldı)
  - Rewrite doğru: +20 (no hint) / +10 (hint kullanıldı)
  - Mini-test doğru: +15
  - FIB perfect: +30, partial: +3/correct
  - Error find perfect: +25, partial: +3/correct
  - TR→EN perfect: +35, partial: +4/correct
  - Hint kullanıldı: -5
  - Ghost text kabul: -2

## Achievements

- **First Sentence** (+20) — İlk sentence builder doğrusu
- **On a Roll** (+25) — 3 streak
- **Streak Master** (+50) — 5 streak
- **Bloomsday Master** (+100) — 10 streak
- **Ghost Taster** (+15) — İlk ghost text kabulü
- **No Hints Needed** (+30) — Hintsiz rewrite tamamlama
- **Master Builder** (+75) — Tüm 10 sentence builder
- **Master Rewriter** (+75) — Tüm rewrite varyantları

---

## localStorage Şeması

```
key: writing_atelier_001_v1
{
  xp, level, streak, bestStreak,
  completed: { builder:[], rewrite:[], fib:bool, err:bool, tr:bool },
  hintsUsed: {}, ghostStats: { shown, accepted, rejected },
  draft: { cc1, cc2, cc3, cc4 }, openDraft: '',
  theme, sound, fs, ttsRate, achievements:[]
}
```

---

## Sınıflama / Klasman Uyumu

[[Interactive Reader Template]] v2.0 spec'i ile uyumlu:
- 5-tab yapısı ✓
- Sticky header + XP bar + level + toolbar ✓
- CEFR pill + grammar legend ✓
- Theme switcher (Navy/Forest/Sunset) ✓
- Font cycler (A−/A/A+/A++) ✓
- Klavye kısayolları (1-5 sekme, Shift+R reset, Tab/Esc ghost) ✓
- TTS controller (0.6-1.4× hız) ✓
- localStorage XP/level/streak ✓
- Confetti canvas + achievement popup ✓
- Toast bildirim ✓
- Print stylesheet ✓
- Mobile breakpoint 540px ✓

**Sapma (Atelier'e özel):** "Vocabulary" sekmesi yerine **"Practice"** sekmesi (3 yazma modu); reader artifact'larında olan 7 vocabulary modu burada glossary tooltip + open writing task'a sıkıştırıldı. Atelier'in odak noktası **üretim** olduğu için kelime drill'i pasifleştirildi.

---

## Sonraki Bölümler (Backlog)

- **Writing Atelier 002 — Kafka / Metamorphosis Opening** (modals of certainty + passive voice + while/when)
- **Writing Atelier 003 — Camus / The Stranger Opening** (Present Perfect for recent past + emotionless tone)
- **Writing Atelier 004 — Borges short fiction** (Conditionals + hypothetical narrative)
- **Writing Atelier 005 — Marie Curie laboratory day** (Past Simple + Past Continuous + Passive in science)

Her bölüm aynı 5-sekme yapısını kullanır; sadece konu, gramer kümesi ve senaryo değişir.
