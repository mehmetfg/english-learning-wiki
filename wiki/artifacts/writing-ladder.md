---
title: Writing Ladder — Direkt Yaz, Kademeli Bırak
type: artifact
tags: [writing, daily-practice, scaffolded, production, a1-b2, output, original-voice]
related: [[_index|Practice Hub]], [[daily-writing-loop]], [[writing-atelier-001-bloomsday]], [[Phrasal Verbs Hub]], [[Present Simple]], [[Past Simple]], [[Conditionals Concept]]
created: 2026-05-21
updated: 2026-05-21
file: Artifacts/writing-ladder.html
level: A1-B2
mode: tool
---

# Writing Ladder — Direkt Yaz, Kademeli Bırak

A1'den başlayıp B2'ye uzanan, **kullanıcının kendi orijinal cümlesini** İngilizce kurmasını sağlayan, kademeli scaffold ile yardımı azaltan günlük yazma aracı.

📁 Dosya: `Artifacts/writing-ladder.html` (~104 KB, single file)

---

## Felsefe

> **Boş sayfa = panik · Tam model = ezber. Çözüm: scaffold ladder.**

[[daily-writing-loop]] **taklit + ezberden yaz** drill aracı (model cümleyi kopyala, sonra ezberden tekrar). [[writing-atelier-001-bloomsday]] zengin atölye, tek senaryo (B1, Joyce). **Writing Ladder** ikisinden farklı:

- **Her seviye için aynı arayüz** (A1 → B2)
- **Kullanıcının kendi orijinal düşüncesi** çıkış noktası
- **5 basamaklı scaffold** — yardım giderek azalır
- **Her gün 5–15 dk** — küçük dozda, sürdürülebilir
- **Fake it till you make it** — başta model kopyala, küçük değişiklikle başla

Pedagoji: **Krashen i+1** + **Vygotsky ZPD** (yardımlı → yalnız) + **Swain Output Hypothesis** (üretim = öğrenme motoru) + **Bruner Scaffolding** + **Schmidt Noticing** + **Krashen Affective Filter** (düşük baskı).

---

## 5 Basamak

| Lv | Adı | Yardım % | Akış |
|----|-----|----------|------|
| **L1** | Echo | 80 | TR cümle + tam EN model (yan yana, kopyalanabilir) → küçük değişiklikle kendine uyarla |
| **L2** | Frame | 60 | TR cümle + EN iskelet `I ___ to ___ because ___` → boşlukları doldur |
| **L3** | Hint | 40 | TR cümle + 3–5 anahtar EN kelime (chip → tıkla, textarea'ya ekle) → cümleyi kur |
| **L4** | Sketch | 20 | Sadece TR cümle → tam serbest İngilizce; sıkışınca tek kelime yardımı |
| **L5** | Free | 0 | Sadece tema (TR ya da EN) → tam serbest; TR satırı bile yok |

**Slider** header'da. Manuel ya da **auto-fade** (3 başarılı seans → otomatik level up önerisi).

---

## 25 Hazır Prompt + Custom

**A1 (10):** morning · breakfast · weather · family · work-study · lunch · evening-plan · weekend · my-room · a-friend
**A2 (8):** phone-call · shopping · cafe · small-problem · surprise-news · weekend-recap · learn-today · neighbour-meeting
**B1 (5):** bad-day · childhood · dream-trip · change · opinion
**B2 (2):** ethical-dilemma · deep-reflection

Her prompt 5 satır taşır: `tr_lines[]` · `en_lines[]` (L1 model) · `frames[]` (L2 boşluklu) · `keywords[]` (L3 anahtarlar). L4'te sadece TR, L5'te sadece tema gösterilir.

**Custom mod:** kullanıcı kendi konusunu yazar — scaffold otomatik kapanır (kendisi yazmak zorunda kalır), L4-L5 gibi davranır.

**Random prompt:** seviye-eşleşmeli rastgele seçim (`inferUserCefr`: L1-L2 → A1, L3 → A2, L4 → B1, L5 → B2).

---

## Core Mekanikler

### Sentence-by-sentence yazma
Her cümle ayrı bir `sentence-block` — TR satırı (gri italic) + scaffold (level'a göre) + textarea. Cümle silme, ekleme (Alt+N), inline edit, otomatik kayıt (input event → localStorage).

### Yardım butonları (sol panel)
- **💡 Kelime yardımı:** TR kelime gir → ~110 kelimelik curated seed sözlükten 1-3 EN karşılık. **Tam cümle çevirisi YOK** (bilinçli). Partial match destekli.
- **🔧 Gramer kalıbı:** 20 kalıp (A1 → B2), formula + örnek + level chip. Tıkla → scratchpad'e ekle.
- **🎯 Başlangıç cümlesi:** Seviyeye özel (10 starter/level × 4 level = 40 starter). Tıkla → aktif cümleye ekle.
- **🎤 Voice:** Web Speech API ile sesli giriş (en-US). API yoksa buton otomatik gizlenir.

### TR Scratchpad
Sol panelde küçük textarea — kullanıcı önce Türkçe düşünür, kısa not alır. **Banned TR mode** ile devre dışı bırakılabilir (ileri kullanıcı için).

### Finish & Check (heuristic)
AI çağrısı yok — basit pattern rules:
- Boş/kısa cümle uyarısı
- Capitalisation kontrolü
- Sonda punctuation
- 13 Türk öğrenci klasik hatası regex: `I am go`, `I am have`, `in home`, `go to home`, `more better`, `people is`, `everyone are`, `does not likes`, `advice + s`, vs.
- L1'de model kopya tespiti → "kendi değişikliğini yap" uyarısı

Çıktı: skor (%), 3 öğrenme noktası, cümle başına ✓/⚠️/❌ + not.

### Auto-Fade
3 ardışık seans skor ≥ %70 → modal: "L${n} → L${n+1}'e geçelim mi?" Reddedilebilir. Yükseltildiğinde `successesAtCurrentLevel` sıfırlanır.

### Streak
- Tamamlandı + skor ≥ 30 → streak +1
- **2 gün toleransı:** 1 gün atlandı → streak korunur (warn toast)
- 3+ gün ara → sıfırlanır (warn toast)
- Skor < 30 → streak korunur ama uzamaz

### Recent Sessions (📚)
Son 14 seans listesi. Bir seansın yanındaki "Düzelt" butonu → cümleleri geri yükler, prompt eşleşirse scaffold'u tekrar uygular. **Spaced retrieval** mekaniği.

---

## Edge Case'ler (17 adet)

| # | Senaryo | Davranış |
|---|---------|----------|
| 1 | Boş sayfa korkusu (Blank Page Anxiety) | 30 sn input yok → "Stuck bubble" çıkar, level-uygun starter önerir |
| 2 | Mükemmeliyetçilik | "Ugly first draft" toggle — anlık hata yok, sadece finish'te |
| 3 | Türkçe'ye geri kayma | "Banned TR mode" — scratchpad disable |
| 4 | Akıcısızlık / zaman baskısı | Süre sadece info için (timer warning yok) |
| 5 | Düşüş günü | "🌧️ Kötü gün" toggle → 1 cümle yeter, streak korunur |
| 6 | AI praise inflation | Objektif skor (% + cümle # + hata # + delta), boş övgü yok |
| 7 | Voice modalitesi | Web Speech API, en-US, fallback gizleme |
| 8 | Spaced retrieval | "Düzelt" butonu eski seansı geri yükler |
| 9 | Pre-translation reflex | Sadece tek kelime yardımı, tam cümle çevirisi yok |
| 10 | Aynı seviyede tıkanma | Auto-fade modal: 3 başarı → level up önerisi |
| 11 | Yanlış kelime / Türkçe direkt çeviri | 13 klasik hata regex pattern → kırmızı not |
| 12 | Streak kaybı | 2 gün tolerans, 3+ → sıfırlama (toast warning) |
| 13 | Mobile | Single column < 880px, big touch targets |
| 14 | Web Speech yoksa | `webkitSpeechRecognition` check → buton gizle |
| 15 | LocalStorage corrupt | `try/catch`, default state'e dön |
| 16 | Çok uzun yazma | 15 cümle soft cap → "önce kaydet" uyarısı |
| 17 | Network yok | Tüm operations local — internet bağımsız |

---

## 5 Görsel Tema

CSS variables ile, localStorage'da kalıcı:

| Tema | Vibe |
|------|------|
| **Navy** | Default, mavi-koyu, profesyonel |
| **Forest** | Yeşil, doğa, sakinleştirici |
| **Sunset** | Turuncu-amber, sıcak |
| **Paper** | Krem-bej, light mode, odak |
| **Midnight** | Siyah + sarı, yüksek kontrast |

---

## Klavye Kısayolları

- `Ctrl+Enter` → Finish & Check
- `Alt+N` → Yeni cümle ekle
- `Esc` → Modal kapat

---

## localStorage Şeması

```js
key: "writing_ladder_v1"
{
  firstRun, level (1-5), autoFade, bannedTR, uglyDraft, stuckTimer,
  visualTheme, dailyTarget,
  currentPromptSlug, customPrompt,
  trScratch,
  sentences: [{ text, tr, model, frame, keywords[] }],
  streak, lastCompletedDate, todayCompleted,
  successesAtCurrentLevel,
  sessions: [{ date, level, levelName, prompt, promptSlug, sentences[], score, words, time_minutes, ok, warn, err }],  // cap 50
  badDay, sessionStart, totalCompletions
}
```

---

## Sınıflama / Klasman Uyumu

[[Interactive Reader Template]] ile **kısmi** uyum:
- ✓ Sticky header + theme switcher
- ✓ CSS variables (5 tema)
- ✓ Klavye kısayolları
- ✓ Toast bildirim
- ✓ Modal system
- ✓ Print stylesheet
- ✓ Mobile breakpoint
- ✓ localStorage persistence
- ✗ TTS — çıkarıldı (saf yazma odağı)
- ✗ 5-tab — yerine sol panel + ana yazma
- ✗ XP/level/achievement — sade streak yeterli

**Sapma:** Atölye değil, **daily production engine** — her gün açılıp 5-15 dk'da bir prompt bitirilir.

---

## Vault'a Bağlantılar

- L1 Production Cell aracı: [[_index|Practice Hub]] → kullanıcı cells'e manuel kopyalayabilir (Recent Sessions modal'dan)
- Phrasal Verbs/Vocabulary entegrasyonu: WORD_SEED küçük tutuldu, [[Phrasal Verbs Hub]] ve [[Vocabulary Hub]]'a dolaylı köprü
- Gramer kalıpları: PATTERNS listesi 20 kalıp, [[Present Simple]], [[Past Simple]], [[Conditionals Concept]], [[Reported Speech Concept]], [[Used To Would]] vb. ile köprü kurar
- Sentez: prompt seçimi seviye-eşleşmeli, [[CEFR Curriculum Map]] ruhuyla uyum

---

## Daily Writing Loop ile Karşılaştırma

| Boyut | Daily Writing Loop | Writing Ladder |
|-------|--------------------|----|
| Mantık | Taklit + ezberden yaz | Kendi orijinal cümleni kur |
| Yardım | Karaktere göre diff (mekanik) | 5 basamak scaffold (pedagojik) |
| Seviye | Tek tema = tek seviye | Slider ile değişen seviye |
| Çıktı | Model'e yakınlık skoru | Kendi sesinin gelişimi |
| Görev | "Yaz kası ısınması" | "Kendi sesini bul" |

İkisi tamamlayıcı: Loop = ısınma · Ladder = ana yazma.

---

## Sonraki İterasyonlar (Backlog)

- **v1.1** Vault'a otomatik export — Recent Sessions'dan "Save to wiki/practice/cells" butonu (.md indir)
- **v1.2** Daha geniş kelime sözlüğü (300+ TR-EN seed) ya da open dictionary API
- **v1.3** Spaced retrieval otomatizmi — 7 gün önce yazdığın bir cümleyi rastgele "improve" challenge'ı
- **v1.4** Pattern coaching — kullanıcı 3 seans aynı pattern'i kaçırırsa "Bugün bunu kullan" hint
- **v1.5** Voice transcript output → otomatik analiz (intonation, fillers, pause)
- **v1.6** Çoklu prompt set — meslek/kişisel/akademik/edebi seri seçimi
- **v1.7** Custom prompt bankası — kullanıcının kendi prompt'larını kaydedip seri haline getirmesi
- **v2.0** Chat-style feedback — her cümle için AI inline coaching (opsiyonel, harici API)

---

## Açık Sorular

- Heuristic check 13 regex'ten ibaret — kullanıcı ileri seviyede iken false negatives olabilir. AI hook ileride gerekebilir.
- Auto-fade eşiği (3 seans) deneyimsel — pilot sonrası ayarlanabilir.
- 25 prompt başlangıç için yeterli mi? Pilot kullanım sonrası genişletilebilir.
- Voice modu real-world kullanımda ne kadar verimli — Türk aksanı için Web Speech API ne kadar tutarlı?
