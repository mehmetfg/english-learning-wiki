---
title: Compressed Galaxy 001 — Loss Aversion (Interactive Study App)
type: artifact
tags: [reader, interactive, A2-B1, psychology, loss-aversion, compressed-galaxy, tts]
related: [[001-loss-aversion]], [[compressed-galaxy/index]], [[Interactive Reader Template]]
created: 2026-05-15
updated: 2026-05-15
---

# Compressed Galaxy 001 — Loss Aversion (Interactive Study App)

İlk Compressed Galaxy bölümü için **tek dosya HTML** interaktif çalışma sayfası. Markdown sürümü TTS okumak için sade; bu sürüm aktif çalışma içindir.

**Dosya:** `Artifacts/compressed-galaxy-001-loss-aversion.html`
**Boyut:** 75.8 KB
**Seviye:** A2-B1 (kesinlikle B1 üstüne çıkmıyor)
**İlgili markdown:** [[001-loss-aversion]]

---

## Beş Sekme

### 📖 Reading
- ~470 kelime A2-B1 pasaj
- 8 gramer yapısı renk kodlu vurgu (tıklayınca tooltip)
- Tooltip'ten ilgili gramer kartına atlama
- **TTS controller:** Play / Pause / Stop + hız ayarı (0.6×–1.4×) — sayfa içinde Web Speech API ile

### 📚 Vocabulary (20 kelime)
- **Flashcards:** çevirme + 🔊 listen butonu (kelime sesletim)
- **Quiz:** rastgele 12 soru, çoktan seçmeli, skor kaydı
- **Match:** 8 çift, sol kelime → sağ Türkçe karşılığı
- **Write:** kelimeyi cümlede kullan, "Show Example" butonu
- Her kelimede 🗣️ "Street Note": resmi vs günlük kullanım farkı

### 🔧 Grammar (8 yapı)
1. Zero / First Conditional
2. Comparatives (-er than / as...as / twice as)
3. Present Perfect (Experience: have you ever...)
4. Passive Voice (Present Simple — is called)
5. Defining Relative Clauses (who/that/which)
6. Modal Verbs (might/could/may — possibility)
7. Adverbs of Degree (much/slightly/completely)
8. Phrasal Verbs (hold onto, give up, look after)

Her kart: formül + açıklama + 4 örnek (EN/TR) + 3-5 edge case + 2-soruluk mini test.

### ✏️ Exercises
- **Fill in the Blanks:** 10 soru, kelime bankası, ilerleme çubuğu
- **Find the Error:** 8 cümle, anlık geri bildirim + açıklama
- **Turkish → English:** 8 çeviri, ipucu + örnek cevap butonu
- Üst bilgi: Correct / Answered / Rate (skor takibi, localStorage)

### 🌍 Explore
- **Writing Craft:** Concrete Hook · Inclusive "You" · Contrast Beats · Twist Paragraph
- **Philosophy:** Platon (atlı araba) · Aristoteles (phronesis) · Kahneman (System 1/2)
- **Translation Notes:** psikoloji terimleri (loss aversion, bias, cognitive, stakes...)
- **Writing Task:** "A Time I Was Afraid to Lose" — 5-8 cümle kişisel paragraf

---

## Edge Cases — Spec'in Üstüne Eklenenler

Kullanıcı isteği üzerine, mevcut reader şablonunda eksik olan veya ihmal edilen unsurlar:

1. **TTS Controller** — sayfa içinde, hız ayarlı; sabah/akşam dinleme ihtiyacı için kritik
2. **Font Size Cycler** (A−/A/A+/A++) — toolbar'dan veya `F` tuşu
3. **localStorage Persistence** — egzersiz skoru, font tercihi sayfa yenilense de kalır
4. **Reset Progress Button** — tüm ilerleme tek tıkla sıfırlanır (toolbar ↺ veya Shift+R)
5. **Keyboard Shortcuts** — `1-5` sekmeler arası geçiş, `F` font, `Shift+R` reset
6. **Scroll-to-Top Button** — uzun sayfada sağ alt köşeden zirveye dön
7. **Toast Notifications** — quiz tamamlama, reset, vb. kısa bildirimler
8. **Print Stylesheet** — `@media print` ile temiz çıktı (toolbar/TTS/butonlar gizlenir, kontrast yüksek)
9. **Voice Selection** — Google sesi yerine sistem İngilizce sesi tercih edilir (Chrome quirk)
10. **Grammar Legend → Card Jump** — başlıktaki renkli noktaya tıklayınca direkt o kartı açar
11. **Mobile-First Breakpoints** — 600px altında daha kompakt layout, klavye kısayolu rozetleri gizli
12. **Word Speak Button** — vocab flashcard'larında her kelime tek başına seslendirilebilir
13. **Fade-in Animation** — sekme geçişleri yumuşak
14. **TTS Cleanup** — sayfa kapanırken / sekme değişirken konuşma durdurulur (memory leak yok)

---

## Klasman Bağlantısı

Bu sayfa, [[Interactive Reader Template]] klasmanına göre üretilmiştir. Aynı şablon Compressed Galaxy serisinin diğer 4 bölümü ve gelecekteki herhangi bir non-fiction makale için yeniden kullanılabilir.
