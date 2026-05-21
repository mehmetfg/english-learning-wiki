---
title: Interactive Reader Template — Klasman / Yeniden Kullanım Şablonu (v2.0)
type: synthesis
tags: [template, klasman, reader, html, css, js, methodology, reusable, gamification, v2]
related: [[compressed-galaxy-001-loss-aversion]], [[compressed-galaxy-002-cogito]], [[iphone-18-ios27-b1-reader]]
created: 2026-05-15
updated: 2026-05-15
version: 2.0
---

# Interactive Reader Template — Klasman v2.0

Bu doküman, tüm İngilizce makalelerinin / non-fiction parçalarının **tek dosya HTML interaktif çalışma sayfasına** dönüştürülmesi için kullanılan standardı tanımlar.

**v2.0 yenilikleri:** Oyunlaştırma (XP/Level/Combo/Lives), 3 yeni mini-oyun (Speed Round / Hangman / Word Builder), bookmark, mastery tracking, theme switcher, sound effects, confetti, achievements, auto-save.

---

## 1. Genel Mimari

- **Format:** Tek dosya HTML (CSS + JS gömülü). Bağımlılık yok, offline çalışır
- **Hedef boyut:** 95–120 KB (v2.0 ile genişledi)
- **Font:** Verdana, Geneva, sans-serif (sabit)
- **Tema:** 3 seçenek — Navy (default) / Forest / Sunset
- **Min-width:** 320px (mobile-first)

---

## 2. Sayfa Yapısı

```
<sticky-top>
  ├─ header-bar (badge + title + meta + XP bar + level + toolbar)
  ├─ level-bar (CEFR pill + grammar legend)
  └─ tabs (5 sekme + klavye kısayolları)
<content>
  ├─ Reading (progress bar + TTS + passage)
  ├─ Vocabulary (XP panel + 7 modes)
  ├─ Grammar (accordion + mini tests)
  ├─ Exercises (FIB + Error + TR→EN)
  └─ Explore (Craft + Philosophy + Translation + Writing)
<scroll-top> / <toast> / <g-tooltip> / <confetti-canvas> / <achievement-popup>
```

---

## 3. CSS Değişken Sistemi

```css
:root{
  /* Theme: Navy (default) */
  --bg:#070b18; --surface:#0d1527; --card:#1a2540;
  --accent:#3b82f6; --accent2:#60a5fa;
  /* Grammar colors */
  --g1..g8: 8 pastel renk
  --fs:15px;
}
body.theme-forest{ --bg:#0a1410; --accent:#10b981; ... }
body.theme-sunset{ --bg:#1a0a14; --accent:#f59e0b; ... }
```

---

## 4. Beş Sekme — v2.0 Spec

### 📖 Reading
- ~400–500 kelime pasaj, 8 gramer yapısı `data-g` tag
- **Reading progress bar** (sayfa scroll'una bağlı)
- TTS controller: Play/Pause/Stop + 0.6–1.4× hız

### 📚 Vocabulary — 7 MOD
1. **🃏 Flashcards** — flip + 🔊 listen + ⭐ bookmark + ● mastery dot
2. **❓ Quiz** — ♥♥♥ lives, 🔥 combo, +XP, shake animation
3. **🔗 Match** — 8 pair, confetti on complete
4. **✍️ Write** — auto-save with debounce (1.5s)
5. **⚡ Speed Round** — 60s timer, count correct, best score saved
6. **🎯 Hangman** — TR tanım göster, EN kelimeyi harf bul, 6 yanlış hakkı
7. **🧩 Word Builder** — karıştırılmış harfler, click to build

### 🔧 Grammar
8 yapı accordion + mini test (her yapıda 2 soru).

### ✏️ Exercises
- FIB (8-10) + Find Error (5-8) + TR→EN (5-8)
- Üst panel: Correct / Answered / Rate / XP gained

### 🌍 Explore
- ✍️ Writing Craft (4 kart)
- 🧠 Philosophy Connection (3 kart)
- 🌐 Translation Notes (6 satır tablo)
- ✏️ Writing Task (5-8 cümle, **auto-save**)

---

## 5. XP / Level Sistemi

```js
LEVELS = [
  { min: 0,    title: 'Apprentice' },
  { min: 100,  title: 'Student'    },
  { min: 300,  title: 'Scholar'    },
  { min: 600,  title: 'Master'     },
  { min: 1000, title: 'Philosopher'}
]

XP_REWARDS = {
  flashView: 1,     quizCorrect: 5,    comboBonus: 2,    // × combo
  matchPair: 3,     speedAnswer: 5,    hangmanWin: 20,
  builderSolve: 15, exerciseCorrect: 10, achievement: 25
}
```

**Level up:**
- Toast + confetti + sound chime
- Achievement popup: "Level Up! You are now a Scholar"

---

## 6. Combo / Streak Sistemi (Quiz)

- Her ardışık doğru → combo +1
- Yanlış → combo sıfırlanır + heart kaybı
- Bonus XP: `5 + (combo × 2)` puan
- 5+ combo'da 🔥 emoji animasyon
- 10+ combo achievement unlock

---

## 7. Lives (Hearts) Sistemi

- Quiz başlangıcı: ♥♥♥ (3 can)
- Her yanlış → ♥ kaybeder
- 0 → quiz biter, "Try Again" butonu
- Tam can ile bitirme → "Perfect" achievement

---

## 8. Mastery Tracking

Her kelime için durum:
- `new` — gri nokta · hiç görülmedi
- `learning` — sarı nokta · 1-2 kez doğru
- `familiar` — mavi nokta · 3-4 kez doğru
- `mastered` — yeşil nokta · 5+ kez doğru

Quiz/Speed Round/Hangman/Builder doğru cevap → mastery güncellenir.

Vocab tab üst panelde: "Mastered: 12/20"

---

## 9. Bookmark (⭐ Star)

- Flashcard üzerindeki yıldız ikonuna tıkla → bookmark
- localStorage'da liste tutulur
- Quiz mode'da "Bookmarked only" filtresi (opsiyonel)

---

## 10. Achievements (Başarımlar)

Sabit liste, kazanıldığında popup + XP bonus:

| Achievement | Şart |
|-------------|------|
| 🎯 First Quiz | İlk quiz tamamlama |
| 🔥 Combo 5 | 5'li seri |
| 🔥🔥 Combo 10 | 10'lu seri |
| ❤️ Perfect Quiz | Hiç heart kaybetmeden bitir |
| ⚡ Speed Demon | Speed Round'da 15+ |
| 🎯 Hangman Hero | Hangman zaferi (≤3 yanlış) |
| 🧩 Master Builder | Word Builder hatasız çözüm |
| 📚 Scholar | 10 kelime mastered |
| 🏆 Master | 20 kelime mastered (tüm liste) |
| 📖 Bookworm | Reading TTS tam dinleme |

---

## 11. Theme Switcher

3 tema, toolbar'dan 🎨 butonuyla geçiş, localStorage'da kaydedilir:

```js
themes = ['navy', 'forest', 'sunset']
```

CSS değişkenleri tema sınıfı ile değişir.

---

## 12. Sound Effects (Web Audio API)

Toolbar'da 🔇/🔊 toggle. Beep'ler external dosya değil, programatik tonlar:

```js
function beep(freq, duration, type='sine'){
  if(!soundOn) return;
  const ctx = new (AudioContext||webkitAudioContext)();
  const osc = ctx.createOscillator();
  osc.type = type; osc.frequency.value = freq;
  // ... gain envelope
}
SOUNDS = {
  correct: () => beep(880, 100),
  wrong:   () => beep(220, 200, 'sawtooth'),
  levelUp: () => [523, 659, 784].forEach((f,i)=> setTimeout(()=>beep(f, 150), i*100)),
  combo:   () => beep(1320, 60)
}
```

---

## 13. Confetti (Canvas)

`<canvas id="confetti">` üst katmanda. Tetiklenir:
- Quiz tamamlama (perfect ise daha yoğun)
- Speed Round bitiş (skor 10+ ise)
- All matched
- Hangman zaferi
- Level up
- Tüm kelimeler mastered

100-150 parçacık, kütle çekim + rastgele renkler.

---

## 14. Auto-Save Writing

```js
const debounce = (fn, ms) => { let t; return (...a)=>{clearTimeout(t); t=setTimeout(()=>fn(...a), ms)} }
textarea.addEventListener('input', debounce(()=>{
  prog.writingDraft = textarea.value;
  saveProg(prog);
  toast('💾 Saved');
}, 1500));
```

Sayfa açıldığında draft varsa restore et.

---

## 15. Klavye Kısayolları

| Tuş | Eylem |
|-----|-------|
| `1`-`5` | Sekme geçişi |
| `F` | Font size cycle |
| `T` | Theme cycle |
| `M` | Sound mute toggle |
| `Shift+R` | Reset progress (onay alır) |

⚠️ Input/textarea içinde devre dışı.

---

## 16. localStorage Schema (v2.0)

```js
{
  // v1 alanları
  fs: 1,
  exC: 0, exA: 0,
  writingDraft: '',
  // v2 yenilikler
  xp: 0,
  level: 0,            // index into LEVELS array
  mastery: {},          // { word: 'new'|'learning'|'familiar'|'mastered' }
  bookmarks: [],
  bestSpeedRound: 0,
  bestStreak: 0,
  totalQuizzes: 0,
  achievements: [],
  theme: 'navy',
  sound: true,
  draftWriting: '',
}
```

Anahtar: `cg<NNN>_progress_v2` — eski v1 anahtarları korunur, geriye uyumluluk.

---

## 17. Edge Cases Master Checklist (35 madde)

### v1 (Korunan)
- [ ] TTS controller (play/pause/stop/rate)
- [ ] Font size cycler
- [ ] localStorage persistence
- [ ] Reset progress
- [ ] Klavye kısayolları
- [ ] Scroll-to-top
- [ ] Toast notifications
- [ ] Print stylesheet
- [ ] Mobile breakpoint
- [ ] Voice selection (Google atla)
- [ ] Grammar legend → kart atlama
- [ ] Word speak button
- [ ] TTS cleanup
- [ ] Fade-in animations

### v2 (Yeni)
- [ ] XP bar in header
- [ ] Level + title display
- [ ] Streak/combo counter in Quiz
- [ ] Lives (3 hearts) in Quiz
- [ ] Mastery tracking per word
- [ ] Bookmark stars
- [ ] **Speed Round** mini-game
- [ ] **Hangman** mini-game
- [ ] **Word Builder** mini-game
- [ ] Theme switcher (Navy/Forest/Sunset)
- [ ] Sound toggle + Web Audio beeps
- [ ] Confetti canvas animation
- [ ] Achievement system + popups
- [ ] Auto-save writing draft
- [ ] Reading progress bar (scroll-based)
- [ ] Mastery summary panel
- [ ] Reverse mode flashcards (TR→EN toggle)
- [ ] Shake animation on wrong
- [ ] Best score display per mini-game
- [ ] Daily visit streak (optional)
- [ ] Backward compat with v1 localStorage

---

## 18. Vocabulary Data Structure (v2.0)

```js
const VD = [
  {
    w: 'word',
    pos: 'n/v/adj',
    tr: 'Türkçe karşılık',
    ex: 'Example sentence.',
    street: '🗣️ Resmi vs günlük not',
    // v2 additions (computed at runtime, not static):
    // mastery, bookmark stored in prog.mastery / prog.bookmarks
  },
  // ... 20 items
];
```

---

## 19. Mini-Game Specs

### Speed Round
- 60 saniye süre
- Soru: kelimenin Türkçesini ya da örnek cümlede yerini bulma
- Her cevap → bir sonraki soru hemen
- Skor sayacı + "Best: 14" görünür
- Bitince: skor + best ile karşılaştırma + retry

### Hangman
- Rastgele 1 kelime seç (3+ harf)
- TR tanım göster: "Tehlikeli, riskli"
- Alfabe butonları: A-Z
- 6 yanlış hakkı (ASCII gallows aşamalı)
- Kazanma: confetti + achievement
- Kaybetme: kelime göster + "Try Another"

### Word Builder
- Rastgele 1 kelime seç
- Harfler karıştırılır, tile olarak gösterilir
- Tıklayarak yerleştir (geri al butonu var)
- Doğru → confetti + XP
- Yanlış → shake, otomatik geri sıfırla

---

## 20. Dosya Adlandırma (değişmedi)

```
Artifacts/<seri>-<no>-<slug>.html
wiki/artifacts/<seri>-<no>-<slug>.md
```

---

## 21. Yayın Öncesi Test (v2.0 ek kontroller)

- [ ] XP doğru artıyor (her aksiyondan sonra)
- [ ] Level up bildirimi tetikleniyor
- [ ] 3 yeni vocab modu çalışıyor (Speed/Hangman/Builder)
- [ ] Theme switcher 3 temayı geziyor
- [ ] Sound toggle gerçekten sesi açıp kapatıyor
- [ ] Confetti tıkanmadan çalışıyor
- [ ] Achievement popup açılıyor + kapanıyor
- [ ] Auto-save 1.5s sonra tetikleniyor (toast görünüyor)
- [ ] Mastery dot renkleri doğru (gri/sarı/mavi/yeşil)
- [ ] Bookmark star toggle çalışıyor
- [ ] Reading progress bar scroll ile doluyor
- [ ] Reset progress tüm v2 verisini de temizliyor

---

## Sürüm Geçmişi

- **v1.0 (2026-05-15)** — İlk klasman, 14 edge case, 4 vocab mode
- **v2.0 (2026-05-15)** — Oyunlaştırma katmanı: XP/Level/Combo/Lives, 3 yeni mini-game (Speed/Hangman/Builder), theme switcher, sound, confetti, achievements, auto-save, mastery tracking, bookmarks. 35 edge case toplamı.
