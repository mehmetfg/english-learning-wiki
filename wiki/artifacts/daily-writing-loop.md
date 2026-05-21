---
title: Daily Writing Loop — Tek HTML Üretim Döngüsü
type: artifact
tags: [writing, daily-practice, production-cell, loop, drill, phrasal-verbs, taklit, blind-recall, output]
related: [[_index|Practice Hub]], [[writing-atelier-001-bloomsday]], [[Phrasal Verbs Hub]], [[Vocabulary Hub]], [[Interactive Reader Template]], [[Past Simple]], [[Present Perfect Continuous]]
created: 2026-05-18
updated: 2026-05-18
file: Artifacts/daily-writing-loop.html
level: A1-B1
mode: tool
---

# Daily Writing Loop — Tek HTML Üretim Döngüsü

Kod öğrenirken **basit pilot uygulamalar** ile öğrendiğini tatbik etme yönteminden uyarlanmış, **her gün açılıp tekrar edilen** bir İngilizce yazma aracı. Pasif öğrenmeden aktif üretime köprü — taklit → ezberden yazma → check döngüsü.

📁 Dosya: `Artifacts/daily-writing-loop.html` (~50 KB)

---

## Felsefe

> **Constraint > Freedom.** Anladığını üretmeye zorlama.

[[writing-atelier-001-bloomsday]] gibi atölye artifact'ları **5 sekmeli zengin senaryolar** sunarken, Daily Writing Loop tam tersi: **dar, disiplinli, hızlı tekrar edilebilir**. Her gün açıp 15-20 dakikada bir tema bitirilir; haftada 5+ "Production Cell" üretmek için ideal.

[[_index|Practice Hub]]'taki **L1 Production Cell** lane'inin interaktif HTML karşılığı. Atölye = senaryo; Loop = günlük rutin.

---

## Akış (4 Aşama)

```
1. Setup → Tema seç (16 hazır) veya Custom (kendi TR+EN'in)
2. TR referans → Her cümle vurgulu, aktif olan bold
3. Box A — Rehberli Yazma (real-time diff)
   • Hedef metni karaktere göre taklit et
   • Yanlış harf KIRMIZI olur — düzeltmezsen sonrası da kırmızı kalır
   • "Show sentence with placeholder" → bulunduğun cümleyi placeholder olarak gör
4. Box B — Hafızadan Yazma (TR preview eşliğinde)
   • Üstte aktif cümlenin Türkçesi (otomatik, ← → ile manuel override)
   • Hiçbir şeye bakmadan EN yaz
5. Check → cümle cümle word-level diff raporu
   • Skor ≥ %70 → "Bugün ✓" → Streak +1
```

---

## 16 Hazır Tema

A1-A2: morning · shopping · cinema · rainy-day · weekend-plans
B1: picnic · first-day · childhood · mom-call · new-recipe · gym · lost-keys · favorite-book · bad-day · dream-trip · new-language

Her tema:
- 4-5 cümle (TR + EN hizalı array)
- 4-6 hedef phrasal verb (regex ile Box A/B'de takip)
- Seviye + tag + gramer yapısı

**Custom mod:** Yan yana 2 textarea, her satır bir cümle. Opsiyonel hedef PV'ler.

---

## Core Mekanikler

### Box A — Mirror Div Real-time Diff

`position: absolute` mirror div, textarea transparent text. Karakter karakter karşılaştırma; ilk hatadan itibaren tüm sonraki karakterler kırmızı (offset bozulduğu için). Apostrofik karakterler normalize (`'` ↔ `'`).

### Show Sentence with Placeholder

Butona basınca: `boxA.length` pozisyonundan **mevcut cümlenin sonuna kadar** placeholder olarak gösterilir (faded). Yazdıkça erir. Cümle sonunda otomatik kapanır.

**Edge cases:**
- Hata varsa: "Önce kırmızı işaretli hataları düzelt"
- Cümle zaten bittiyse: "Bu cümleyi tamamladın"
- Sayaç tutulur (session başına)

### Box B — Hibrit TR Preview

**Otomatik (default):** Box B'deki nokta/ünlem/soru işareti sayısı → bir sonraki cümlenin TR'si gösterilir.

**Manuel override:** ← → tıklayınca veya TR paragrafta bir cümleye click → o cümleye sabitlenir; "Otomatiğe dön" linki ile geri.

### Check Button — Word-level LCS Diff

Her cümle ayrı tokenize edilir (`[^\w'\s]` → space). LCS hesaplanır, skor = `LCS/target * 100`. Eksik ve fazla kelimeler frekans bazlı raporlanır. 4 özet stat: genel skor · ≥%70 cümle sayısı · PV kullanım · cümle Δ.

### Phrasal Verb Tracking

**Tema-bağlantılı:** Her PV için regex (separable: `pick X up` formu desteklenir, 2 kelimeli için max 4 token arada). Box A ve Box B ayrı kontrol → ✓ A · ✓ B · ✓✓ both chip'i.

**Bağımsız drill:** 30 PV havuzu, günlük rotasyon (date hash). "Bu PV'ü içeren cümle yaz" + min 6 kelime + regex kontrolü. Skip = yeni PV.

---

## 5 Görsel Tema

| Tema | Vibe |
|------|------|
| Navy | Default — Bloomsday standardı |
| Forest | Doğa, yeşil |
| Sunset | Sıcak, turuncu |
| Paper | Krem kağıt görünümü — odak için |
| Midnight | Siyah/sarı, yüksek kontrast |

CSS variables ile, localStorage'da kalıcı.

---

## Streak / Daily Completion

- Check skor ≥ %70 → `Save & Complete` butonu → bugün ✓
- Skor <%70 → confirm dialog: "Yine de tamamlansın mı?"
- Yeni gün: dün ✓ → streak+1; 2+ gün boşsa streak=0 + toast uyarısı
- Pazar günü tamamlama → portfolio reminder toast
- Tüm 16 tema tamamlandı → "Loop Master" toast

---

## Klavye Kısayolları

- `Ctrl+Enter` (Box B aktifken) → Check
- `Ctrl+/` (Box A aktifken) → Show sentence with placeholder
- `Esc` → modal/setup kapat
- `Alt + ← / →` (Box B aktifken) → manuel TR preview gezinme
- TR paragrafta cümleye click → o cümleye preview override

---

## localStorage Şeması

```js
key: "daily_writing_loop_v1"
{
  visualTheme, activeTheme, customContent,
  boxA, boxB, placeholderUntil, manualTRIndex, showPlaceholderCount,
  streak, lastCompletedDate, todayCompleted, totalCompletions,
  themesCompleted: [],            // hangi sluglar bitti
  completedDates: { "YYYY-MM-DD": {score, theme} },
  pvMastered: { "pick up": {count, lastUsed} },
  pvDrillToday, pvDrillCompletedToday, pvDrillDate,
  pvWorkshopOpen, trBodyOpen
}
```

---

## Edge Case'ler Uygulandı

| # | Senaryo | Davranış |
|---|---------|----------|
| 1 | Box A boş, "Show placeholder" tıklandı | İlk cümlenin tamamı placeholder |
| 2 | Box A'da hata var, placeholder tıklandı | Toast: hataları düzelt |
| 3 | Cümle sonunda placeholder tıklandı | Toast: cümleyi tamamladın |
| 4 | Paste yapıldı | Input event tetiklenir, diff anında |
| 5 | Smart quote apostrof (' / ') | Normalize edilir, eşit kabul |
| 6 | Box B'de cümle ayracı eksik | TR preview son cümlede kalır |
| 7 | Box B'de fazla/eksik cümle | Check'te +/− δ raporu |
| 8 | Tema değişikliği (Box A/B dolu) | Modal confirm |
| 9 | Reset all (modal danger) | Visual tema korunur |
| 10 | localStorage corrupt | try/catch, default state'e dön |
| 11 | Custom mod: TR/EN satır eşitsiz | Validate hata |
| 12 | Custom mod: 30+ satır | Cap, uyarı |
| 13 | PV separable: "pick the basket up" | Regex max 4 token arada |
| 14 | PV drill: tek kelime cevap | Min 6 kelime uyarısı |
| 15 | Mobile (450px) | Custom textarea tek sütun, header etiketleri gizli |
| 16 | Print | Header/setup/butonlar/mirror gizli |
| 17 | Pazar tamamlama | Portfolio reminder toast |
| 18 | Tüm 16 tema bitti | "Loop Master" toast |
| 19 | 2+ gün gap | Streak 0 + toast |
| 20 | TR cümlesine click | Manuel TR preview override |

---

## Sınıflama / Klasman Uyumu

[[Interactive Reader Template]] ile **kısmi** uyum:
- ✓ Sticky header + theme switcher
- ✓ CSS variables (5 tema)
- ✓ Klavye kısayolları
- ✓ Toast bildirim
- ✓ Modal confirm
- ✓ Print stylesheet
- ✓ Mobile breakpoint
- ✓ localStorage persistence
- ✗ TTS — çıkarıldı (saf yazma odağı)
- ✗ XP/level/achievement — minimal streak yeterli
- ✗ 5-tab yapısı — single-flow layout

**Sapma:** Atölye değil **drill aracı** — her gün açılıp 15-20 dk'da bir tema bitirilir, ertesi gün başka tema.

---

## Vault'a Bağlantılar

- L1 lane aracı: [[_index|Practice Hub]] → cells/ klasörüne çıktı yazımı uygulamadan değil, kullanıcıdan beklenir (HTML araç, vault'a yazmaz; sonuçlar kullanıcı tarafından log.md/cells'e taşınır)
- PV havuzu ile uyum: [[Phrasal Verbs Hub]]'taki 200 PV'den bir alt küme (30) PV pool olarak gömülü
- Tema gramerleri: her tema bir veya iki gramer yapısı hedefler — [[Past Simple]], [[Used To Would]], [[Present Perfect Continuous]], [[Conditionals Concept]], [[Reported Speech Concept]] vb.

---

## Sonraki İterasyonlar (Backlog)

- **v1.1** Sentence-level voice recording (Web Speech API) — opsiyonel modül
- **v1.2** Vault'a otomatik cell yazma (download .md butonu)
- **v1.3** Spaced repetition — geçmiş 7 günün tamamlanmış temalarından rastgele 2 cümle revisit
- **v1.4** "Boss battle" modu — `errors/` klasöründeki top pattern'e özel drill
- **v1.5** TR→EN reverse mod (Box A'da TR cümle, kullanıcı EN yazar; sentence builder tarzı)
- **v2.0** Multi-day tema serisi (örn. "5-day picnic story" — her gün bir bölüm)
