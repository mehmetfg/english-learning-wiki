---
title: Çalışma Yöntemleri Analizi — Artifact'lardan Çıkarılan Pedagojik Mantık
type: synthesis
tags: [methodology, study-methods, artifacts-analysis, pedagogy, output-system]
related: [[english-learning-engine-v1]], [[_index|Practice Hub]], [[Interactive Reader Template]], [[daily-writing-loop]], [[writing-atelier-001-bloomsday]], [[vocab-srs]]
created: 2026-05-20
updated: 2026-05-20
---

# Çalışma Yöntemleri Analizi

Vault'taki 82+ artifact ve wiki kayıtları taranarak çıkarılan **çalışma biçimleri kataloğu**. Amaç: hangi mantıkla üretildiklerini anlamak, benzerlerini tekrar edebilmek, en işe yarayanı seçebilmek.

---

## 0. Üst Mantık — Vault'un Üç Akışı

Vault'ta üç paralel ana akış var. Bütün artifact'lar bu üçünden birine (veya birden fazlasına) hizmet eder:

| Akış | Soru | Çıktı |
|------|------|-------|
| **Ingest** | "Yeni kaynak geldi, ne yapayım?" | Reader / Reader-app / Source sayfası |
| **Query** | "Şu konuyu açıkla / karşılaştır" | Concept kartı / Synthesis sayfası |
| **Practice** | "Üretmek istiyorum" | Cell / Drill / Dialogue / Portfolio |

Tek bir cümleyle vault felsefesi:
> **Constraint > Freedom. Input C1, output B1 — gap'i sınırlandırılmış üretim kapatır.**

---

## 1. Çalışma Yöntemleri Kataloğu (10 Format)

### M1 — Interactive Reader (5-Sekme Standardı)
**Örnek:** [[compressed-galaxy-001-loss-aversion]], [[les-miserables-cart-scene-b1]], [[les-miserables-ch07-study]]

**Mantık:** Tek bir kısa pasaj (~470–1000 kelime) → aynı içerik **5 farklı bilişsel filtreden** geçirilir.

```
📖 Read     → Renk kodlu gramer + hover tooltip + TTS
📚 Vocab    → Flashcard / Quiz / Match / Write (4 mod)
🔧 Grammar  → Accordion (formül + örnek + edge case + mini test)
✏️ Exercises → FIB (10) + Find Error (8) + TR→EN (8)
🌍 Explore  → Writing craft + felsefe + çeviri notları + writing task
```

**Tekrar reçetesi:** Yeni bir metin geldiğinde "5 sekme şablonuna oturt" demek yeterli. [[Interactive Reader Template]] zaten spec'i tutuyor.

**Pedagojik gerekçe:** Aynı kelime/yapı 5 farklı modaliteden geçince **encoding variability** sağlanıyor; hafızada tek bir tetikleyiciye bağlı kalmıyor.

---

### M2 — Daily Engine (Üç Motorlu Sistem)
**Örnek:** [[english-learning-engine-v1]] = [[grammar-first-daily]] + [[text-first-daily]] + [[vocab-srs]]

**Mantık:** Tek bir gün için 6–8 konu rotation; iki motor **aynı seti** farklı sırada görür → **çapraz teyit**.

```
Motor A (Grammar-First):  Kavram kartı → modal → mini quiz → metin
Motor B (Text-First):     Metin → renkli vurgu → kavram açılır → reflect
Motor C (Vocab SRS):      SM-2 algoritması → again/hard/good/easy
```

**Borç skoru formülü:**
`(gün_farkı × (100 − güç_skoru)) / 100`
→ Hangi konunun bugün gelmesi gerektiğine matematik karar veriyor; kullanıcı seçmiyor.

**Pedagojik gerekçe:** Spaced repetition + interleaving + retrieval practice; üçü de kanıta dayalı en güçlü öğrenme prensipleri.

**Tekrar reçetesi:** Yeni bir domain'e (örn. iş İngilizcesi) genişletmek için sadece `topics.json` ve `profile.json`'a yeni seed eklemek yeterli; mimari aynı.

---

### M3 — Writing Atelier (Senaryo Tabanlı Yazma)
**Örnek:** [[writing-atelier-001-bloomsday]]

**Mantık:** Edebi/kültürel bir **çapa** (Joyce/Bloomsday) + sıkı bir gramer **kümesi** (5 narrative past tense) → üç farklı yazma modu.

```
1. Sentence Builder    → Karışık kelimelerden cümle (click-to-pick + hint -5 XP)
2. Rewrite Challenge   → Aynı cümleyi 2-3 farklı yapıya dönüştür
3. Story Continuation  → Pause-aware ghost text (Tab kabul, Esc reddet)
```

**Yenilik:** **Ghost text** — kullanıcı 1.5 sn duraklarsa öneri belirir; ama backspace cooldown'u 3 sn aktifse belirmez (kullanıcı düzenliyor demektir).

**Pedagojik gerekçe:** Kültürel çapa motivasyon; constraint (5 yapı) zorlama; ghost text iskele (scaffolding) → ileri seviyede kaldırılabilir.

---

### M4 — Daily Writing Loop (Taklit + Blind Recall)
**Örnek:** [[daily-writing-loop]]

**Mantık:** Atölye = senaryo. Loop = günlük rutin. **Dar, disiplinli, 15-20 dk.**

```
1. Tema seç (16 hazır / Custom)
2. TR referans gör
3. Box A (Mirror Diff)    → Karaktere göre taklit; yanlış harf KIRMIZI
4. Box B (Blind Recall)   → Hibrit TR preview eşliğinde hafızadan yaz
5. Check                  → Word-level LCS diff; %70 ↑ → "Bugün ✓" Streak +1
```

**Pedagojik gerekçe:** **Copy → cover → recall** klasik mnemonic ilkesinin sayısal versiyonu. Çıktı zorunlu üretim; "anladım" diyemezsin, yazmak zorundasın.

---

### M5 — Compressed Galaxy (Sticky Sentence Yazısı)
**Örnek:** [[001-loss-aversion]], [[002-cogito]], [[naval-almanack/01-how-to-get-rich-tweetstorm]]

**Mantık:** ~950 kelime / 8 dk TTS pasajı + **sticky sentence** çekirdek + 20-30 terim glossary.

Her bölümün omurgası:
- 1 kanca cümle (concrete hook)
- 7 sticky sentence (akılda kalıcı tek-satır)
- 25-40 terim sözlüğü
- Tek bir kavramı açan paragraflar

**Pedagojik gerekçe:** Heath kardeşler'in *Made to Stick* prensibi. Tek bir kavram + somut örnek + duygu = uzun süreli hatırda kalma.

---

### M6 — 5-Lane Practice System (Output Rotation)
**Örnek:** [[Practice/Grammer Topics/_index|Practice Hub]] — L1 Cell, L2 Shadow, L3 Dialogue, L4 Drill, L5 Retrieval

**Mantık:** Tek bir "yazma" yerine **5 farklı üretim modu** rotasyonu; her gün en az 1 lane.

| Lane | Mod | Süre |
|------|-----|------|
| L1 | Production Cell — kısa paragraf, anlık üretim | 15-20 |
| L2 | Shadow Author — bir yazarın stilinde yaz | 25-30 |
| L3 | Conversational Loop — sohbet/voice | 30-45 |
| L4 | Error Drill — recurring hatalara odaklı | 20-30 |
| L5 | Retrieval Carnival — eski malzemeyi geri çağır | 15-20 |

**Pedagojik gerekçe:** Tek modaliteye saplanma yok. **Error Constellation** ile fossilization'a karşı agresif savunma.

---

### M7 — Extended Reading (Klasik Roman Serileri)
**Örnek:** Les-Misérables (10 bölüm), Don Quixote, Crime and Punishment, Decameron

**Mantık:** Klasik romanın A2/B1 uyarlaması; her bölüm ~10.000 kelime; **TTS-uyumlu** anlatım.

**Avantaj:** Sürekli aynı karakter/dünya → bağlamsal kelime tekrarı zorunlu olarak gerçekleşir; kullanıcı farkında olmadan SRS'in yaptığını alır.

**Pedagojik gerekçe:** **Narrow reading** — Krashen'in input hipotezi: aynı domain'de bolca i+1 input.

---

### M8 — Essay / Aphorism Studies (Sticky English)
**Örnek:** [[naval-almanack/index]], [[paul-graham/index]]

**Mantık:** Düşünür/yazarın **kristal berraklık** İngilizcesi → 40 aforizma + 30 terim glossary + 7 sticky sentence formatı.

**Pedagojik gerekçe:** Kısa, taşınabilir cümleler; tweet ölçeği; kelime ekonomisi yüksek model metinler → kullanıcının üretiminde "az kelimeyle çok şey" hedefi.

---

### M9 — Grammar Concept Cards (56 Konu)
**Örnek:** [[Present Perfect]], [[Subjunctive]], [[Inversion]], [[Word Formation]] vb.

**Mantık:** Her gramer kavramı için **standart wiki kartı**: formül + örnekler + yaygın hatalar + ilgili kavramlar + CEFR seviyesi.

**Pedagojik gerekçe:** **Reference layer** — engine'lerden ve reader'lardan bağlantı verilen "hakikat kaynağı". Sapma olduğunda buraya bakılır.

---

### M10 — Vocabulary/PV Hub (Trackable Lists)
**Örnek:** [[vocabulary-hub]] (260 → 3000), [[phrasal-verbs-hub]] (200 → 1000)

**Mantık:** Filtrelenebilir, takip edilebilir liste + ses + EN-EN tanım + örnek + sinonim/antonim + morfoloji ipucu.

**Pedagojik gerekçe:** Liste-tabanlı çalışmanın tek kabul edilebilir formu: **anlamlı filtreleme + aktif tetikleyici + takip**.

---

## 2. Ortak Mimari Prensipler (Tekrar İçin Reçete)

Tüm artifact'lardan damıttığım **9 değişmez kural**:

1. **Tek dosya HTML.** Bağımlılık yok; offline çalışır; mobile-responsive.
2. **localStorage zorunlu.** Skor, font tercihi, tema, ilerleme — hepsi kalıcı.
3. **Klavye kısayolları.** `1-5` sekme, `F` font, `Shift+R` reset.
4. **TTS controller.** Play/Pause/Stop + hız (0.6×–1.4×) + voice selection (Chrome quirk: Google ses yerine sistem sesi).
5. **Renk kodlu gramer.** Her yapı kendi rengi; hover tooltip; legend'a tıkla → kart aç.
6. **Edge case checklist.** TTS race, confetti throttle, mobile breakpoint, print stylesheet, reset güvenliği.
7. **JSON bridge.** Çıktı `00_INBOX/*.json` → Claude Code → `wiki/tracking/*.md` → `_archive/`.
8. **CEFR rozeti.** A1→C2 her parçada görünür; seviyeyi sapmadan tut.
9. **No praise inflation.** Skor + hata sayısı + delta zorunlu; "harika!" yasak.

**Reçete:** Yeni bir artifact tasarlarken bu 9 prensibe karşı checklist çek; eksik olan varsa eksiklik gerekçesini yaz.

---

## 3. Çeşitlilik Haritası — Hangi Format Neye Hizmet Eder

| İhtiyaç | Format | Süre |
|---------|--------|------|
| Sabah ısınma, kavram tekrarı | M2 Daily Engine | 45 dk |
| Yeni bir metin geldi, derinleşmek | M1 Interactive Reader | 60-90 dk |
| Yazma kasını günlük çalıştırmak | M4 Daily Writing Loop | 15-20 dk |
| Edebi/kültürel atmosferde derin yazma | M3 Writing Atelier | 60-90 dk |
| Kelime kalıcılığı | M2'nin SRS bileşeni veya M10 Hub | 10-15 dk |
| Üretim çeşitliliği, fossilization önleme | M6 5-Lane System | 30-45 dk/gün |
| Geniş input, bağlam tekrarı | M7 Extended Reading | 20-40 dk |
| Stil ve "sticky English" | M5 Compressed Galaxy + M8 Essays | 20-30 dk |
| Konu referansı / hakem | M9 Concept Cards | 5-10 dk |

---

## 4. Sence En İşe Yarar Olan Hangisi?

**Birinci sıra: M2 — Daily Engine v1.** Gerekçe:

1. **Tek aracı tek günde 3 farklı bilişsel girişle çalıştırır** (grammar-first ↔ text-first ↔ SRS). Tek modaliteye saplanmayı yapısal olarak imkânsız kılar.
2. **Borç skoru** sayesinde kullanıcı seçim yapmıyor; sistem en zayıf/eski konuyu otomatik öne çıkarıyor. Bu, çoğu insanın çalışmayı bıraktığı en büyük nedeni (next-action belirsizliği) ortadan kaldırıyor.
3. **JSON bridge** Claude Code ile vault'u senkronize tutuyor — yani çalışma sadece o günü değil, **wiki sayfalarını** da büyütüyor.
4. **Aylık kapsam garantisi:** 56 konu × 7 günlük rotation → 4 hafta içinde her konu en az 1×.

**İkinci sıra (üretim tarafı): M4 — Daily Writing Loop.** Çünkü:
- 15-20 dk → her gün yapılabilir.
- Taklit → blind recall → diff döngüsü, "anladım ama yazamıyorum" gap'inin doğrudan ilacı.
- Streak + 16 hazır tema → tetikleme sürtünmesi sıfır.

**Birleşik öneri:** Sabah M2 Daily Engine (45 dk) + akşam M4 Daily Writing Loop (15 dk) = günde 1 saat, input + output dengeli.

---

## 5. Eklenebilecek Yeni Çalışma Yöntemleri (Öneriler)

Vault'ta **eksik** veya **eklenmesi yüksek getirili** gördüğüm formatlar:

### Ö1 — Listening Ladder (Dinleme Tırmanışı)
**Boşluk:** Vault'ta TTS var ama **gerçek insan sesi** yok. Listening hâlâ output kadar zayıf kalabilir.
**Format:** Aynı kısa pasaj (60-90 sn) için 3 hız (0.75× / 1× / 1.25×) + 3 dinleyiş (gist → detail → shadowing). Çıktı: kullanıcı son turda 1:1 shadowing yapar, kayıt alır, kendi sesini orijinalle karşılaştırır.
**Tetik:** "L6 listening" / "shadow audio"

### Ö2 — Translation Pendulum (TR ↔ EN Salınımı)
**Boşluk:** TR→EN var ama **EN→TR→EN tekrar** (back-translation) yok.
**Format:** EN cümle → kapat → TR'ye çevir → 24 saat bekle → TR'den geri EN'ye çevir → orijinal ile diff. Kayıp olan kelimeler otomatik [[errors]]'a düşer.
**Pedagojik gerekçe:** Kapsamlı çift-yönlü kodlama; profesyonel çevirmen eğitiminin core drill'i.

### Ö3 — Minimal Pair / Confusable Drill
**Boşluk:** *say/tell, much/many, since/for, in/on/at* gibi sürekli karıştırılanlara özel drill yok.
**Format:** 20 cümle, her birinde 2 seçenek; 5 sn'de seç; yanlışlar [[errors/confusables]]'a yığılır. Frekansı yüksek olanlar M2'nin rotation'ına otomatik enjekte olur.

### Ö4 — Voice Journal (Sesli Günlük)
**Boşluk:** L3 Conversational Loop var ama **monologue** modu yok. Akıcılık için her gün 2 dk kesintisiz konuşma.
**Format:** Günün prompt'u (1 cümle) → kullanıcı 2 dk konuşur → transkript çıkar → Claude annotate eder (✅/⚠️/❌) → frekanslı hatalar errors'a → haftalık delta grafiği.

### Ö5 — Collocation Heatmap
**Boşluk:** Kelime var, PV var, ama **collocation** (make a decision, strong coffee, heavy rain) ayrı bir katman değil.
**Format:** Verb+Noun, Adj+Noun, Adv+Adj matrislerinden 50 yüksek-frekans collocation seed. Reader'lara entegre (renkli vurgu olarak).

### Ö6 — Comparative Reader (Çift Metin)
**Boşluk:** Aynı içeriğin iki farklı yazar / iki farklı seviyede sürümünü yan yana koymak yok.
**Format:** Sol panelde orijinal (örn. Naval'in tweet'i), sağ panelde A2 uyarlaması; tıklanan kelime/yapı iki tarafta da vurgulanır. CEFR adımının görsel kanıtı.

### Ö7 — Generative Prompt Bank (Constraint Lottery)
**Boşluk:** Kullanıcı her gün "bugün ne yazayım" sürtünmesiyle karşılaşabilir.
**Format:** 200 constraint kart (örn. "Bu 5 PV'yi kullan, geçmişten bir an anlat, 80 kelime, 2 cümlede Past Perfect zorunlu"). Rastgele çek, M4 Loop'a feed et.

---

## 6. Tekrar Edilebilirlik Özeti

Benzer bir çalışma biçimi üretmek istediğinde sor:

1. **Hangi akıştan?** (Ingest / Query / Practice)
2. **Hangi 9 prensibe sadık?** (bkz. Bölüm 2 checklist)
3. **Constraint nedir?** (Hangi yapı/kelime/süre zorunlu)
4. **Hangi 5 sekme veya 3 mod?** (M1 veya M3 şablonu)
5. **localStorage'da ne kalıcı?** (Skor, streak, tema)
6. **JSON bridge'e ne yazıyor?** (`session_*`, `word_bank_add`, `srs_review`)
7. **Hangi wiki concept'leriyle bağlı?** (related: alanı doldur)
8. **Hangi pedagojik prensipi koruyor?** (Spaced rep / interleaving / retrieval / encoding variability / narrow reading / sticky)

Bu 8 sorunun cevabı varsa artifact "vault uyumlu" demektir.

---

## İlgili Sayfalar

- [[english-learning-engine-v1]] — M2 sistem dokümantasyonu
- [[Practice/Grammer Topics/_index|Practice Hub]] — M6 5-Lane System
- [[Interactive Reader Template]] — M1 standart spec'i
- [[daily-writing-loop]] — M4 detayları
- [[writing-atelier-001-bloomsday]] — M3 örneği
- [[CEFR Curriculum Map]] — M9 referans haritası
