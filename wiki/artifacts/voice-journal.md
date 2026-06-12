---
title: Voice Journal — 2 Dakika Monologue
type: artifact
tags: [speaking, voice, monologue, naval-themes, b1, speech-recognition]
related: [[calisma-yontemleri-analizi]], [[_index|Practice Hub]], [[naval-almanack/index]], [[paul-graham/index]], [[Atomic-Habits-Ch01-The-Surprising-Power]]
created: 2026-05-23
updated: 2026-05-23
file: Artifacts/voice-journal.html
level: B1
mode: tool
---

# Voice Journal — 2 Dakika Kesintisiz Monologue

[[calisma-yontemleri-analizi]] Ö4 önerisinin **v1 örneği**. Akıcılığı **monologue** modu üzerinden çalıştıran araç — L3 Conversational Loop'tan farklı olarak diyalog yok, partner yok, sadece sen ve 120 saniye.

📁 Dosya: `Artifacts/voice-journal.html`

---

## Felsefe

> **Akıcılık konfor olmaktır. Konfor sadece tekrarla gelir.**

[[Practice/Grammer Topics/_index|Practice Hub]] L3 (Conversational Loop) konuşma odaklı ama interaktif (Claude/partner ile). **Voice Journal** monologue: sen, prompt, 2 dakika. Durma. Tökezle ama devam et.

- **Günde 1 prompt** (gün-eşleşmeli rotasyon, override edilebilir)
- **2 dk timer** (uyarı → warn 30 sn, error 0 sn)
- **Live transcript** (Web Speech Recognition, en-US, continuous + interim)
- **4 sayaç:** Kelime · Hız (w/dk) · Filler ("uh/um/like/yani/ee") · Tekrar (ardışık aynı kelime)
- **Annotation:** otomatik 5 heuristik (kelime sayısı, hız, filler, tekrar, "solid run")
- **Streak:** ardışık gün (1 gün ara verirsen sıfır)
- **History:** son 14 günün transkript + sayıları

---

## 14 Prompt (Naval/PG/Atomic Habits temalı, B1)

1. Talk about one small habit you want to build this month.
2. What did you learn today that you did not know yesterday?
3. Describe a person who changed how you think.
4. If you had one extra hour today, how would you spend it?
5. Tell me about a time you said no — and you were happy you said it.
6. Name something you used to believe but do not believe anymore.
7. Describe your perfect Sunday morning.
8. Talk about something you read recently and what you took from it.
9. What is a small problem in your daily life that you want to solve?
10. Describe a place that makes you feel calm.
11. Talk about a hobby you would like to try this year.
12. What is the best advice you have ever received?
13. Describe a moment when you felt proud of yourself.
14. If you could send one message to your past self, what would it be?

Gün-of-year mod 14 → otomatik bugünün prompt'u. "Başka prompt" butonu rotate eder.

---

## Teknik

- **SpeechRecognition:** `continuous + interimResults`; `onend` auto-restart (cihaz mikrofonu auto-close yaparsa devam).
- **Filler set:** `uh, um, umm, uhh, er, ehh, eh, like, yani, ee, aa`.
- **Tekrar tespiti:** ardışık aynı normalize token.
- **Stats live:** `tickTimer` her saniye + her transcript update.
- **Annotation:** 5 kural — wc, wpm, filler, rep, "solid run".
- **Fallback:** SR yoksa textarea ile elle yazma (transkript yerine).
- **localStorage:** `voice_journal_v1` (entries[], streak, lastDate, todayPromptIdx).

---

## Edge Case'ler

| # | Senaryo | Davranış |
|---|---------|----------|
| 1 | SR yok | Textarea fallback + badge "text fallback only" |
| 2 | Mikrofon izni yok | "Test" butonu önceden test ettirir |
| 3 | 2 dk dolması | Auto-stop + "over" warna geçer + annotation |
| 4 | "no-speech" hatası | console.warn, sessizce devam (benign) |
| 5 | Aynı gün ikinci kayıt | Önceki gün entry'si silinir (override) |
| 6 | Streak: 1 gün ara | Reset (sadece +1 ardışık) |
| 7 | Çok kısa giriş (<30 ch) | confirm prompt — yine de kaydet? |
| 8 | LocalStorage dolu | try/catch, default state'e dön |
| 9 | History 14+ entry | slice(0, 14) — eski olanlar gizli ama JSON'da var |
| 10 | Refresh ortasında | startedAt yok — manual restart gerekli |

---

## v1 Sınırlamaları

- **Türkçe transcript yok** — `lang: en-US` zorunlu. TR→EN kod-anahtarlama olursa transcript bozulur.
- **Pronunciation evaluation yok** — sadece transcript word count; gerçek telaffuz doğruluğu değerlendirilmez.
- **No actual audio recording** — sadece transcript. v2'de `MediaRecorder` ile blob save + playback.
- **JSON bridge yok** — daily entry vault'a otomatik akmıyor. v2: "Save to wiki/practice/dialogues" butonu.
- **Streak 1 günlük tolerans yok** — `writing-ladder` 2 gün tolere ediyor, voice-journal hassas. Pilot sonrası ayarlanabilir.

---

## Wiki Bağlantıları

- [[calisma-yontemleri-analizi#Ö4 — Voice Journal (Sesli Günlük)]] — orijinal öneri
- [[Practice/Grammer Topics/_index|Practice Hub]] L3 — bunun diyalog kuzeni
- [[naval-almanack/04-happiness]] · [[paul-graham/01-life-is-short]] — prompt esin kaynakları
- [[writing-ladder]] — yazılı muadili; streak mantığı oradan ilham aldı
