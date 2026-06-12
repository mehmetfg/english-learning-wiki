---
title: Listening Ladder — 3 hız × 3 dinleyiş
type: artifact
tags: [listening, tts, b1, atomic-habits, gist-detail-shadow, ladder]
related: [[calisma-yontemleri-analizi]], [[Atomic-Habits-Ch01-The-Surprising-Power]], [[_index|Practice Hub]], [[CEFR Curriculum Map]]
created: 2026-05-23
updated: 2026-05-23
file: Artifacts/listening-ladder.html
level: B1
mode: tool
---

# Listening Ladder — 3 Hız × 3 Dinleyiş

[[calisma-yontemleri-analizi]] Ö1 önerisinin **v1 örneği**. Tek bir kısa B1 pasajını üç hızda ve üç bilişsel filtreden geçirerek dinleme kasını kademeli tırmandıran araç.

📁 Dosya: `Artifacts/listening-ladder.html`

---

## Felsefe

> **Vault'ta TTS var, ama listening hâlâ output kadar zayıf kalabilir.**

Aynı pasaj, üç farklı işle:
- **Pass 1 — Gist** (0.75×, metin gizli): büyük resim. Tek cümleyle özetle.
- **Pass 2 — Detail** (1.0×, metin gizli): 3 anlama sorusu.
- **Pass 3 — Shadow** (1.0×, metin görünür): birlikte konuş, transkript-eşleşme.

Adım kilitleri var — biri tamamlanmadan sonraki açılmaz. Pasaj metni ancak Pass 3'te açılır → "okumadan dinle" zorunluluğu.

---

## Pasaj (B1 uyarlama, 95 kelime)

[[Atomic-Habits-Ch01-The-Surprising-Power]]'dan damıtılmış 1% kuralı pasajı:

> Most people think small changes do not matter. They want big results, and they want them now. But small things grow. If you get one percent better every day for a year, you will be thirty‑seven times better at the end. The British cycling team showed this in real life. For years, they won almost nothing. Then they started to look at every tiny detail: pillows, bike seats, even how riders washed their hands. In ten years, they became the best team in the world.

---

## Teknik

- **TTS:** Web Speech API (`SpeechSynthesisUtterance`). Voice picker `en` + `localService` öncelikli.
- **Speed pill:** 0.75× / 1.0× / 1.25× — pass değişiminde otomatik set.
- **Recognition:** `webkitSpeechRecognition` ile shadow eşleşme; yoksa "kendini değerlendir" prompt'una düşer.
- **Score:** kelime kümesi kesişimi → %. Yeşil = yakaladığın, kırmızı üstü çizgi = atladığın.
- **localStorage:** `listening_ladder_v1__atomic_habits_ch1` (pass durumu, skor, notlar, hız).
- **Tema:** Navy default + light fallback. ☾/☀ toggle.

---

## Edge Case'ler

| # | Senaryo | Davranış |
|---|---------|----------|
| 1 | TTS yok | Play butonu uyarı verir |
| 2 | Voices daha yüklenmedi | `onvoiceschanged` retry |
| 3 | SpeechRecognition yok | Recognition butonu disable + self-rate prompt |
| 4 | Pass 1'i atlamaya çalış | Step 2 `.locked` — pointer-events: none |
| 5 | Pasaj metni Pass 1-2'de | `.hidden` filter blur(7px), user-select: none |
| 6 | Adım atlama (manuel) | Lock CSS + state validation |
| 7 | LocalStorage corrupt | try/catch → default state |
| 8 | Tarayıcı kapatma | startedAt persist, dakika sayacı doğru kalır |

---

## v1 Sınırlamaları

- **Gerçek insan sesi yok** — TTS fallback. v2'de `<audio>` ile pre-recorded voice (Naval/PG ses dosyaları?) düşünülebilir.
- **Tek pasaj** — 95 kelimelik Atomic Habits. v2'de pasaj seçici (Naval aphorisms / Paul Graham micro-passage).
- **Shadow skoru tek seferlik** — geçmiş skor delta'sı yok. v2'de "aynı pasajı tekrar yaparsan delta görürsün."
- **Heuristic eşleşme** — sıralama dikkate alınmıyor (kelime kümesi). Phonemic match (Levenshtein on transcript word vs expected word) eklenebilir.

---

## Wiki Bağlantıları

- [[calisma-yontemleri-analizi#Ö1 — Listening Ladder (Dinleme Tırmanışı)]] — orijinal öneri
- [[Atomic-Habits-Ch01-The-Surprising-Power]] — kaynak
- [[Practice/Grammer Topics/_index|Practice Hub]] — listening şu an L1-L5 dışında, ileride **L6 Listening Lane** olabilir
- [[Interactive Reader Template]] — sticky header + theme switcher uyumu (kısmi)
