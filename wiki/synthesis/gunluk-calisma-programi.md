---
title: Günlük Çalışma Programı — 20 Günlük Döngü
type: synthesis
tags: [program, schedule, grammar, vocabulary, practice, rotation]
related: [[CEFR Curriculum Map]], [[_index|Practice Hub]], [[grammar-coverage]]
created: 2026-05-23
updated: 2026-05-23
---

# Günlük Çalışma Programı — 20 Günlük Döngü

> 🤖 **Otomasyon:** Bu program Personal OS'ta canlı çalışıyor. Bugünün gününü ve konularını görmek için: **`/english/program`**. ROTATION verisi `src/lib/program.ts`'te tanımlı; gün hesabı `computePosition()`'da (cycle_start event'inden + takvim farkı mod 20). Tamamlama: `program_day_complete` event'i.

**Felsefe:** Her gün 4 blok, ~75 dakika. Gramer + vocabulary + okuma + üretim. 20 günde 56 gramer konusunun tamamı dönüşümlü geçilir; ardından döngü yeniden başlar — ama ikinci turda konular daha derin ele alınır.

---

## ⏱ Günlük Blok Yapısı

| Blok | Süre | İçerik |
|------|------|--------|
| 🔥 **A — Açılış** | 5 dk | Önceki günün hataları (`wiki/practice/errors/`) · SRS zamanlaması kontrol |
| 📚 **B — Gramer** | 20-25 dk | Günün 2-3 konusu · Personal OS'ta wiki sayfasını oku → quiz çöz |
| 🃏 **C — Vocabulary** | 15 dk | Personal OS SRS kartları (flashcard + match game) |
| 📖 **D — Okuma** | 15-20 dk | Günün okuma kaynağı (aşağıda kaynak tablosu) |
| ✍️ **E — Üretim** | 10-15 dk | Practice lane rotasyonu (aşağıda) |

**Toplam:** ~65-80 dakika

> 💡 Zamanın kısıtlıysa: B + C blokları zorunlu. D + E esnek.  
> Hiç zamanın yoksa: yalnızca C (SRS kartları, 10 dk).

---

## 📅 20 Günlük Gramer Rotasyonu

Her turda 56 konu — 20 günde tamamlanır. Gün 20 yeni konu almaz, o haftanın zayıf noktaları tekrar edilir.

| Gün | Konu 1 | Konu 2 | Konu 3 |
|-----|--------|--------|--------|
| **1** | [[Present Simple]] | [[Past Simple]] | [[Articles]] |
| **2** | [[Present Continuous]] | [[Past Continuous]] | [[Pronouns]] |
| **3** | [[Present Perfect]] | [[Past Perfect]] | [[Quantifiers]] |
| **4** | [[Present Perfect Continuous]] | [[Past Perfect Continuous]] | [[Countable and Uncountable Nouns]] |
| **5** | [[Future Will]] | [[Future Going To]] | [[Plural Nouns]] |
| **6** | [[Future Continuous]] | [[Future Perfect]] | [[Future Perfect Continuous]] |
| **7** | [[Passive Voice Concept]] | [[Causative]] | [[Passive Infinitives and Gerunds]] |
| **8** | [[Reported Speech Concept]] | [[Indirect Questions]] | [[Question Tags]] |
| **9** | [[Conditionals Concept]] | [[Mixed Conditionals]] | [[Wish If Only]] |
| **10** | [[Relative Clauses]] | [[Noun Clauses]] | [[Adverbial Clauses]] |
| **11** | [[Gerunds and Infinitives]] | [[Participle Clauses]] | [[Subjunctive]] |
| **12** | [[Modal Verbs Concept]] | [[Used To Would]] | [[Be Used To Get Used To]] |
| **13** | [[Phrasal Verbs]] | [[Emphasis]] | [[Cleft Sentences Concept]] |
| **14** | [[Inversion]] | [[Ellipsis and Substitution]] | [[Negation]] |
| **15** | [[Question Formation]] | [[Adjectives]] | [[Order of Adjectives]] |
| **16** | [[Adverbs]] | [[Comparison]] | [[Word Formation]] |
| **17** | [[Possessives]] | [[Determiners]] | [[Fixed Prepositions]] |
| **18** | [[Prepositions of Time]] | [[Prepositions of Place and Movement]] | *(2 konu)* |
| **19** | [[Coordinating Conjunctions]] | [[Subordinating Conjunctions]] | [[Linking Words]] |
| **20** | 🔄 **Review** — Personal OS'ta en düşük skoru alan 2-3 konuya geri dön | | |

**Konu çalışma protokolü (Blok B):**
1. Personal OS → English → ilgili konu sayfasına git
2. Wiki sayfasını oku (varsa `wiki/concepts/` altında)
3. Personal OS quiz sorularını çöz (varsa)
4. Aklında kalan 1 örnek cümle üret ve `log.md`'ye not düş

---

## 🃏 Vocabulary Rotasyonu (Blok C)

Her gün SRS kartları çalışılır. Aktivite gün numarasına göre değişir:

| Günler | Aktivite | Platform |
|--------|----------|----------|
| 1, 4, 7, 10, 13, 16, 19 | Flashcard **+** Match Game | Personal OS |
| 2, 5, 8, 11, 14, 17 | Flashcard (SRS due kartları) | Personal OS |
| 3, 6, 9, 12, 15, 18 | Flashcard **+** Confusable Drill | Personal OS + `Artifacts/confusable-drill-v2.html` |
| 20 | Flashcard **+** Translation Pendulum | Personal OS + `Artifacts/translation-pendulum.html` |

**Hedef:** Günde minimum 10 kart. Match Game'de 8/8 eşleştirme.

---

## 📖 Okuma Rotasyonu (Blok D)

Kaynak türleri 5 kategoride dönüşümlü gelir:

| Gün tipi | Kaynak | Seviye |
|----------|--------|--------|
| **Gün 1, 3, 5** | Les Misérables serisi (Ch03→Ch10 sırayla) | A2-B1 |
| **Gün 7, 9, 11** | Crime and Punishment / Don Quixote / Decameron | A2-B1 |
| **Gün 2, 4, 6** | Atomic Habits / Thinking Fast and Slow / Rich Dad Poor Dad | A2-B1 Non-fiction |
| **Gün 8, 10, 12** | Naval Almanack (07→01 bölümler) | B1 Aphorism |
| **Gün 13, 14, 15** | Paul Graham Essays (sırayla) | B1-B2 |
| **Gün 16, 17, 18** | Compressed Galaxy serisi (001→005) | A2-B1 |
| **Gün 19** | Seçim serbest — en çok beğenilen kaynaktan 1 bölüm | — |
| **Gün 20** | Önceki turdan en çok kelime öğrenilen bölümü yeniden oku | — |

**Okuma protokolü:**
- İlk geçiş: anlamak için oku, durma
- Bilinmeyen kelimeyi gör → tahmin et → Personal OS'ta ara
- Okuma sonrası: 1 cümleyi sesli oku (SpeakButton veya kendi sesin)

---

## ✍️ Üretim / Practice Lane Rotasyonu (Blok E)

| Günler | Lane | Tetik | Çıktı |
|--------|------|-------|-------|
| 3, 6, 9, 12, 15, 18 | **L1 Production Cell** | "cell" | `wiki/practice/cells/YYYY-MM-DD.md` |
| 2, 5, 8, 11, 17 | **L5 Retrieval Carnival** | "retrieval" | `wiki/practice/retrieval/YYYY-MM-DD.md` |
| 7, 14 | **L3 Conversational Loop** | "sohbet" | `wiki/practice/dialogues/YYYY-MM-DD_topic.md` |
| 10 | **L2 Shadow Author** | "shadow" | `wiki/practice/shadow/YYYY-MM-DD_author.md` |
| 20 | **L4 Error Drill** | "error drill" | `wiki/practice/drills/YYYY-MM-DD_pattern.md` |
| 1, 4, 13, 16, 19 | *Üretim yok* — Blok B+C'ye ekstra süre | — | — |

> ⚠️ **Boss Battle kuralı:** Errors klasöründe 3+ tekrar eden pattern varsa → o gün L4 ile başla, planı ertele.

---

## 📊 Haftalık Hız Göstergesi

Her 5 günde bir (gün 5, 10, 15, 20) şunu kontrol et:

- [ ] Kaç konu tam çalışıldı? (hedef: 3/gün × 5 = 15)
- [ ] SRS kartları: missed streak var mı?
- [ ] Errors klasöründe yeni pattern oluştu mu?
- [ ] Okuma: ilerleme yerinde mi?

---

## 🔄 İkinci Tur Farkı

20 günlük döngü tamamlandıktan sonra:

| Tur | Odak | Değişen şey |
|-----|------|-------------|
| 1. tur | Tanıma — kavramı anlamak | Quiz sorularını cevaplamak yeterli |
| 2. tur | Kullanım — üretmek | Her konuda 2 özgün cümle yaz |
| 3. tur | Otomatikleştirme | L1 Cell'de o günün konusunu constraint olarak zorla |
| 4. tur+ | Derinlik | Zayıf kalan konuya `wiki/concepts/` altında derinlemesine not ekle |

---

## 🗒 Günlük Log Şablonu

Her çalışma gününün sonunda `log.md`'ye şunu ekle:

```
## [YYYY-MM-DD] practice L? | Gün N — [Konu1 · Konu2 · Konu3]
Gramer: [ne çalışıldı, ne anlaşıldı]
Vocabulary: [kaç kart, match game skoru]
Okuma: [kaynak, bölüm, öğrenilen kelime sayısı]
Üretim: [lane, konu, hata sayısı]
Notlar: [öne çıkan şey, yarına not]
```

---

## 🏁 Hızlı Başlangıç

**Bugün Gün 1 ise:**
1. Personal OS'ta [[Present Simple]], [[Past Simple]], [[Articles]] sayfalarını ziyaret et
2. Her konudan 1 örnek cümle aklında yap
3. SRS kartlarını çalış + Match Game oyna
4. Les Misérables Ch03'ten 1-2 sayfa oku
5. Bugün üretim yok (Gün 1)

**Döngüyü takip etmek için:** Bugünün tarihinden başla. `(bugünün günü - başlangıç günü) mod 20 + 1` = kaçıncı gün olduğun.
