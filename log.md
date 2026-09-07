# log.md — Kronolojik Kayıt

Append-only. Her giriş `## [YYYY-MM-DD] tip | başlık` formatında.

---

## [2026-09-04] build | English Grammar Docs — Laravel dokümantasyon formatında tam gramer referansı

Özet: Kullanıcı isteği: laravel.com/docs sayfasının görsel tasarımı, navigasyon yapısı ve mobil responsive davranışı birebir taklit edilsin; içerik ise tüm İngilizce gramer konuları olsun, sadece doküman amaçlı (etkileşim/quiz yok).

Üretilen: `Artifacts/english-grammar-docs.html` (tek dosya, ~215 KB) + Artifact yayını (https://claude.ai/code/artifact/ac14becb-df9e-462c-816a-2570975cb6fb).

Kapsam: 60 sayfa (4 giriş + 56 gramer konusu), 13 nav kategorisi, 306 içerik bölümü, 354 örnek cümle (EN sol / TR sağ), 224 yanlış-doğru hata çifti. Nav taksonomisi doğrudan vault'un mevcut 56 concept sayfası gruplamasından alındı; seviyelendirme [[CEFR Curriculum Map]] ile hizalandı.

Tasarım: sol sticky katlanabilir kategori menüsü + sağ "On this page" TOC (IntersectionObserver) + koyu kod blokları + Laravel kırmızısı (#f9322c) + Instrument Sans/JetBrains Mono. Hash routing (`#/present-perfect`), canlı arama filtresi, açık/koyu tema (localStorage), mobil hamburger drawer, klavye kısayolları (`/`, Esc, ←/→). Chromium ile masaüstü/koyu tema/mobil (390px) doğrulandı: JS hatası yok, yatay taşma yok.

Dokunulan sayfalar (4): `wiki/artifacts/english-grammar-docs.md` (yeni kayıt), `Artifacts/_dashboard.html` (ref kategorisine kart), `index.md` (Grammar Reference bölümü), `log.md`.

## [2026-06-10] build | Felsefe Kurs Mikro-Uygulama Sistemi (çapraz vault çalışması)

Özet: Philosophy vault'taki 16 ders serisi (felsefedersleri.com, 137+ ders) HTML mikro-uygulamalara derlendi. Yeni boru hattı: vault markdown (tek doğruluk kaynağı) → personal-os `npm run build-courses` → `Philosophy/Artifacts/courses/` (16 kurs HTML + manifest.json + bağımsız panel). Personal OS'e `/philosophy/dersler` sayfası eklendi (durum bazlı öğrenme kuyruğu: active/queued/backlog/done; kuyruk dosyası `wiki/dersler/kurs-durumu.json`). Quiz pilotu Önsokratik Dönem'de (3 ders × 4 soru). Kitaplar bölümü vault ile eşgüdümlendi: PDM vault'tan 84 kitap sync edildi (.env eksikti), kitap detayında okuma notu artık vault'tan canlı gösteriliyor + Obsidian deep-link. Detay: Philosophy vault log.md aynı tarihli giriş. Bu vault'ta içerik değişikliği yok.

## [2026-06-10] lint | Personal OS devamlılık denetimi + yeniden yapılandırma

Özet: "Sürekliliği sağlayamadım" şikâyeti üzerine Personal OS (`~/Documents/projects/personal-os/`) uçtan uca denetlendi. Teşhis: 18 günde 6 program günü; gün kilidi 5 zorunlu aşama istiyordu (4'ü placeholder); transform/translate soruları exact-match yüzünden son oturumlarda 0 doğru vermişti; 843 kelimenin 710'unda TR karşılık yoktu; 748 vocab MCQ çeldiricisi POS uyumsuzdu; 15 soruda cevap prompt içinde sızıyordu; due az olunca kuyruğa sınırsız yeni kelime doluyordu.

Yapılan (kod + veri):
- **Çekirdek Gün** (KR-009): ders+quiz → günü kilitle banner'ı; bonus aşamalar opsiyonel (TodaySession.tsx)
- **Self-grade** (KR-010): transform/translate'te model cevapla karşılaştır + "Doğru saydım/Yanlıştı" (ReviewSession.tsx, submitAttempt'e selfCorrect)
- **710 TR karşılık** dolduruldu (`scripts/fill-tr-definitions.ts` + `scripts/data/tr-definitions.json`)
- **748 çeldirici** POS-eşleşmeli yenilendi (`scripts/regen-vocab-distractors.ts`, KR-011)
- **15 sızıntılı prompt** yeniden yazıldı; mükerrer görünenler zaten deaktifti
- **Günlük yeni kelime tavanı 8** + CEFR-öncelikli sıralama (KR-012)
- Takvim-bazlı `computePosition` deprecated; "Gün X / 20" → 28 düzeltildi
- `npx tsc --noEmit` + `next build` temiz; değişiklikler personal-os repo'sunda commit'lenmedi (kullanıcı onayı bekliyor)

Dokunulan vault sayfaları: [[personal-os-design-decisions]] (§7 denetim + KR-009..013 + günlük protokol), index.md, log.md.

Sonraki 3 soru: (1) Kelime başına 2-3 soru tipi ne zaman? (2) Review dağı otomatik freni (due>40) Faz 2'ye girsin mi? (3) Üretim aşaması L1-L5 lane'leri placeholder'dan gerçek bileşene ne zaman dönecek?

---

## [2026-06-08] practice A1-01 | Subject Pronouns — Değerlendirme

Özet: A1 Ders 1 (Subject Pronouns + to be) tamamlandı ve değerlendirildi. Bölüm 1: 10/15, Bölüm 3: 10/12. Toplam 10 ayrı hata tespit edildi; 5 kategoride dağılıyor: preposition (at home), yazım (tired/funny/situation), anlam (friend≠brother, always≠already, You are fine≠Who are you), noktalama (soru işareti), article (a kind person). Durum: 🔁 Tekrar önerilir. `00 - İlerleme ve Referans.md` güncellendi; Hata Kütüphanesi oluşturuldu.

---

## [2026-06-04] ingest | Decameron Serisi — Day 1 Story 2–10 + Day 2 Story 1 (10 hikâye)

Özet: Decameron serisine 10 yeni hikâye eklendi. Hepsi A2-B1 seviyesinde, aynı format (TR özet + EN hikâye bölümlere ayrılmış + 10-kelime EN-EN sözlük + ilişkili sayfalar). Toplam Decameron arşivi: 11 hikâye.

**Eklenen dosyalar:**
- `Decameron-Day01-Story02-Abraham.md` — Yahudi Abraham Roma'yı görür, Hristiyan olur
- `Decameron-Day01-Story03-Three-Rings.md` — Saladin + Melchizedek; üç din, üç yüzük
- `Decameron-Day01-Story04-The-Monk.md` — genç rahip, güzel kız, Abbot'un sırrı
- `Decameron-Day01-Story05-Marchioness.md` — tavuk sofrasıyla Fransa Kralı'nı durduran Markiz
- `Decameron-Day01-Story06-Inquisitor.md` — şarap iltifatı → sapkınlık suçlaması → ters köşe
- `Decameron-Day01-Story07-Bergamino.md` — hikâye içinde hikâye; Can Grande'ye ayna tutmak
- `Decameron-Day01-Story08-Ermino.md` — "Cömertliği çiz" diyerek cimriyi değiştiren tek cümle
- `Decameron-Day01-Story09-King-of-Cyprus.md` — korkak kralı cesaretlendiren kadın
- `Decameron-Day01-Story10-Master-Alberto.md` — pırasa metaforu; Gün 1'in kapanış hikâyesi
- `Decameron-Day02-Story01-Martellino.md` — sakat taklidi, linç, kurtarış; Gün 2 açılışı (tema: Talih)

**Güncellenen:** `index.md` — Decameron bölümü 11 hikâyeye genişletildi.

**Seviye notu:** Tüm hikâyeler A2-B1 sınırında tutuldu. Kısa cümleler, Past Simple baskın, bağlam açıklayıcı. Türkçe özetler İngilizce bölümden önce geliyor (kullanıcı tercihi).

---

## [2026-05-23] feature | Personal OS — Program otomasyon sayfası

Özet: 20 günlük çalışma programı Personal OS'a yazılım olarak gömüldü. Yeni rota `/english/program` — bugünün gününü otomatik hesaplar (cycle_start event'inden + takvim farkı mod 20), günün 3 gramer konusunu güç skorlarıyla birlikte gösterir, vocabulary/okuma/üretim bloklarını canlı linklerle açar. 20 günlük döngü grid'i hangi günün tamamlandığını/bugün olduğunu/beklediğini görsel olarak işaretler.

**Mimari:**
- `src/lib/program.ts` — ROTATION sabiti (20 gün × topic slugs + vocab + reading + lane), `computePosition()` günü hesaplar.
- `events` tablosu kullanılarak iki yeni kind: `program_cycle_start` (en yeni = aktif tur başlangıcı) ve `program_day_complete` (her gün için 1 kayıt).
- Yeni queries: `getProgramState()` → `{active, position, today, cycleDays[20], totalCompletedInCycle}`.
- Yeni actions: `startProgramCycle`, `markDayComplete`, `undoDayComplete`, `resetProgram`.

**UI:**
- Bugün kartı: gün numarası + tur, 4 blok (B Gramer / C Vocab / D Okuma / E Üretim), her konu için link + güç skoru + bugün dokunuldu mu işareti, "✓ Bugünü tamamlandı işaretle" butonu.
- 20 günlük grid: her gün için topic listesi mini-kartı, durum rengi (tamamlandı/bugün/bekliyor).
- `/english` ana sayfasına "📅 Günlük Program" linki eklendi.

**Yeni:** `src/app/english/program/page.tsx`, `src/components/ProgramControls.tsx`, `src/lib/program.ts`  
**Güncellenen:** `src/lib/queries.ts`, `src/lib/actions.ts`, `src/app/english/page.tsx`

---

## [2026-05-23] query | Günlük çalışma programı oluşturuldu

Özet: 20 günlük döngü programı oluşturuldu. 56 gramer konusu günlere dağıtıldı (gün 1-17 ve 19: 3 konu/gün; gün 18: 2 konu; gün 20: review). Her günde 4 blok: Açılış → Gramer → Vocabulary SRS → Okuma → Üretim (~75 dk toplam). Vocabulary aktiviteleri (Flashcard / Match Game / Confusable Drill / Translation Pendulum) gün numarasına göre döngüsel atandı. Okuma kaynakları 5 kategoriye ayrıldı (fiction, non-fiction, aphorism, Compressed Galaxy, serbest). Practice lane rotasyonu da günlere yerleştirildi (L1/L3/L5 ağırlıklı). 4 turda derinleşen spiral yaklaşım tanımlandı.

**Yeni:** `wiki/synthesis/gunluk-calisma-programi.md`  
**Güncellenen:** `index.md` (Synthesis bölümü)

---

## [2026-05-23] artifact | 4 pilot artifact — Çalışma Yöntemleri Analizi Önerilerinden v1

[[calisma-yontemleri-analizi]]'nin "Bölüm 5 — Eklenebilecek Yeni Çalışma Yöntemleri" altındaki **Ö1, Ö2, Ö4, Ö7** önerileri için birer çalışan B1 HTML örneği üretildi. Hepsi tek-dosya, dark/light tema, localStorage, içerik vault kaynaklarından (Atomic Habits Ch1, Naval Almanack 1/4/5/6, Paul Graham — Life Is Short).

**Yeni dosyalar:**
- `Artifacts/listening-ladder.html` — Ö1: 3 hız × 3 dinleyiş (gist/detail/shadow); Atomic Habits 1% kuralı pasajı (95 kelime); Web Speech TTS + SpeechRecognition shadow
- `Artifacts/translation-pendulum.html` — Ö2: EN→TR→(20s gecikme)→EN back-translation; word-level LCS diff; 6 Naval/PG aforizması; kayıp kelimeler defteri
- `Artifacts/voice-journal.html` — Ö4: 2 dk monologue; live transcript; filler/tekrar tespiti; 14 prompt (daily rotation); streak + history
- `Artifacts/prompt-bank.html` — Ö7: 60 constraint kart, 5 kategori (Grammar 15 / PV 15 / Topic 15 / Quick 10 / Combined 5); rastgele çekiliş + recent 10 yazı

**Yeni wiki sayfaları:**
- `wiki/artifacts/listening-ladder.md` · `wiki/artifacts/translation-pendulum.md` · `wiki/artifacts/voice-journal.md` · `wiki/artifacts/prompt-bank.md`

**Güncellenen:** `index.md` Writing bölümüne 🧪 Pilot v1 başlığı eklendi (4 satır).

**Açık konular:**
- `_dashboard.html` kartları henüz eklenmedi (manuel ya da v2'de eklenecek)
- Hiçbiri JSON bridge (`00_INBOX/`) yazmıyor — pilot v1 kapsamı dışı
- Listening Ladder gerçek insan sesi değil, TTS fallback — Ö1'in tam çözümü için audio asset gerekli

---

## [2026-05-23] feature | Personal OS — TTS seslendirme özelliği

**Web Speech API entegrasyonu** — sıfır maliyet, API key yok, tarayıcı native.

Yeni dosya: `src/components/SpeakButton.tsx`
- `SpeakButton` React bileşeni: size xs/sm/md/lg, speaking state ile pulse animasyonu
- `speakText()` imperative util fonksiyonu: MatchGame'den çağrılır
- Ses tercihi: `en-US` + localService (macOS'ta Samantha) → fallback zinciri

Entegrasyon noktaları:
1. **VocabFilter / VocabCard** — her kartta sağ alt köşede `xs` boyut buton (link tıklamasını engellemiyor, `stopPropagation` var)
2. **vocabulary/[slug]/page.tsx** — lemma h1 yanında `lg` buton + örnek cümle yanında `sm` buton
3. **FlashcardDeck** — kart lemması yanında `md` buton + progress bar yanında "🔊 auto" toggle (useEffect ile kart geçişinde otomatik seslendirir)
4. **MatchGame** — EN tile seçildiğinde `speakText()` çağrısı → eşleştirirken telaffuzu duyarsın

TypeScript clean, next build ✓ (11 route)

---

## [2026-05-23] feature | Personal OS — Gramer konu detay sayfası yeniden tasarım + 56 örnek güncelleme

**Sayfa yeniden tasarımı** (`/english/topics/[slug]`):
- Breadcrumb navigasyonu + hero section (başlık, CEFR badge, FSRS durum badge)
- İstatistik satırı: tekrar sayısı, vadeli gün, son deneme doğruluğu
- **📌 Türkçe'deki Yeri** — amber/sarı kartla öne çıkarılmış, ilk içerik bloğu
- **📐 Yapı (Formül)** — "S + V / S + not + V / V + S?" formatı ayrıştırılıp ✅ Olumlu / ❌ Olumsuz / ❓ Soru satırlarına bölündü, renk kodlu
- **✏️ Örnekler** — İngilizce büyük/kalın font, Türkçe altta küçük/gri; numaralı kartlar
- **⚠️ Sık Yapılan Hatalar** — kırmızı bordered bölüm, her hata ayrı satır
- **🏷 Kullanım Alanları** — subpattern pill badge'leri
- Son denemeler: geçmiş tablo + doğru/yanlış renkli gösterim

**Örnek güncelleme** (`scripts/update-topic-examples.ts`):
- 56/56 konu güncellendi
- Önceki örnekler: akademik/felsefi ("Descartes argues...", "Loss aversion has shaped...")
- Yeni örnekler: kısa, günlük, anlaşılır ("She drinks coffee every morning.", "I called my mum yesterday.")
- Her konu için 2 örnek, her zaman dilimi/yapı için tipik kullanım gösterildi

---

## [2026-05-23] feature | Personal OS — Anki flash kartlar + eşleştirme + gramer CEFR filtre

**Flashcard sistemi** (`/english/vocabulary/study`):
- Anki mantığı: ön yüz İngilizce tanım + örnek cümle, arka yüz Türkçe gizli
- "Türkçeyi Gör" butonu zorunlu — önce İngilizce üzerinden kavramayı sağlar
- 4 derecelendirme: Tekrar(1) / Zor(2) / İyi(3) / Kolay(4) → FSRS `rateVocabCard` action
- Klavye kısayolları: Space=göster/İyi, 1-4=dereceler
- Oturum özeti: breakdown by rating, "Tekrar" kartlarını yeniden çalışma
- Streak için `sessions` tablosuna `kind="flashcard"` kayıt açılıyor

**Eşleştirme oyunu** (`/english/vocabulary/match`):
- 8 çift (İngilizce kelime ↔ Türkçe anlam), 16 karo grid
- Yanlış eşleşme: kırmızı flash animasyonu, 600ms sonra deselect
- Süre, hamle sayısı, doğruluk skoru
- "Yeni Tur" ile yeniden başlama

**Gramer konuları filtresi** (`/english` sayfası):
- `EnglishTopics` client component — CEFR badge multi-select filtresi (A1-C2)
- Grid / Liste görünüm toggle
- Liste görünümü: kompakt satır (dot + başlık + strength bar + CEFR + durum + rep sayısı)

**Yeni dosyalar:** FlashcardDeck.tsx, MatchGame.tsx, EnglishTopics.tsx, study/page.tsx, match/page.tsx
**Yeni queries:** getVocabStudyQueue, getVocabMatchPairs
**Yeni actions:** rateVocabCard, startStudySession, endStudySession

---

## [2026-05-23] feature | Personal OS — Vocabulary hub arama + filtre UI (H)

`src/components/VocabFilter.tsx` oluşturuldu, `/english/vocabulary` sayfasına entegre edildi.

**Eklenen özellikler:**
- 🔍 **Arama çubuğu** — lemma'ya göre anlık client-side filtreleme
- **Subtype sekmeleri** — Tümü / 📖 Kelimeler / 🧩 Chunks / 🔗 Phrasal Verbs
- **Durum filtresi** — Tüm Durum / Görülmemiş / Öğreniliyor / Sürüyor
- **CEFR badge filtresi** — A1–C2 + bilinmiyor (?), multi-select, aktif renk ile görsel
- **🇹🇷 TR filtre** — sadece TR tanımı olan öğeleri göster (çevirisiz ~700 öğeyi izole etmek için)
- **Kaynak dropdown** — atomic-habits / naval-almanack / paul-graham vb. 9 kaynak
- **Sonuç sayacı** — "X öğe gösteriliyor / 1046 toplam"
- Tüm filtreler sıfırlama düğmesi
- Filtreler kombinlenebilir (AND mantığı)

**Teknik:** Tamamen client-side (`useState` + `useMemo`), ekstra DB sorgusu yok, mevcut `getVocabulary()` çıktısı props olarak geçiliyor.
Sayfalar: 2 dosya değişti (`vocabulary/page.tsx` → basitleşti, `VocabFilter.tsx` → yeni)

---

## [2026-05-22] ingest | Personal OS — Vault sources'tan toplu vocabulary ingest (1002 yeni öğe, 873 soru)

`scripts/ingest-vocab-from-sources.ts` ile `wiki/sources/` altındaki tüm md dosyaları tarandı, iki ayrı vocabulary formatı parse edildi.

**Parse edilen formatlar:**
- **Pattern A** (literary/non-fiction chapter vocab — Atomic Habits, Crime and Punishment, Les Misérables, Don Quixote, Decameron, Thinking Fast Slow, Rich Dad Poor Dad):
  ```
  ### 📖 Vocabulary Part 1
  **injury** *(noun)*
  Physical damage to a person's body...
  *"The ball hit him in the face..."*
  ```
- **Pattern B** (Naval Almanack + Paul Graham glossary):
  ```
  ## Glossary
  - **specific knowledge** unique expertise built through curiosity | *kişiye özgü bilgi*
  ```

**Sonuçlar:**
- 55 md dosyası tarandı
- 1180 ham vocabulary entry parse edildi
- 1010 unique slug (170 duplicate aynı kelime farklı kaynakta)
- 8 zaten DB'de (önceki seed ile çakışma)
- **1002 yeni item insert edildi**
- **873 soru otomatik üretildi** (cloze + translation)

**Subtype classifier (heuristic):**
- Phrasal verb: multi-word + first word verb-like + içinde phrasal particle (up/down/in/out/on/off/over/into/through/along/across/by/back/away/around/about)
- Chunk: multi-word + ilk kelime article veya prep (at the end of the day, in light of, by and large)
- Word: tek kelime
- Sonuç dağılım: 827 word + 162 chunk + 13 phrasal verb (Pattern A çoğu kelime ağırlıklı, beklenen)

**Soru üretimi:**
- Cloze: example cümlesinde lemma → `___`, 4 şık (3 distractor same-subtype'tan)
- Translation: definition_en prompt + 4 TR şık (yalnız Pattern B'de TR var, ~150-200 entry)
- Pattern A entries için TR yok → sadece cloze üretildi (~700 entry için 1 soru)
- Pattern B entries için hem cloze hem translation (~150 için 2 soru)

**DB son durumu:**
- `items`: 56 grammar_topic + 843 vocab_word + 174 vocab_chunk + 29 phrasal_verb + 6 (philosophy seed) = **1108 item**
- `questions`: 280 grammar + 947 vocab = **1227 soru**

**Performans:**
- `getVocabulary()` artık strength hesaplamadan döner (N+1 önleme), 1108 öğe için ~700ms
- `/english/vocabulary` page load ~1.4s — Faz 3'te pagination/search filter eklenecek

**Cross-source örnekleri:**
- "injury", "recovery", "consistently" → Atomic Habits Ch01
- "garret", "plaster", "frayed" → Crime and Punishment Ch01
- "specific knowledge", "apprenticeship", "calling" → Naval 02
- "Marius", "humble", "redemption" → Les Misérables (karakter ismi de geçmiş; lint'te elenmeli)

**Bilinen kalite sorunları:**
- Bazı parse'lar özel isim (Marius, Cosette) veya yer ismi olabilir — admin'de filtrelenmeli
- Distractor kalitesi same-subtype rastgele, semantik benzerlik yok
- TR olmayan ~700 vocab için sadece cloze sorusu var
- 1108 item bir sayfada — performans için search filter şart

**Sonraki adımlar:**
- Search/filter UI vocabulary hub'da (CEFR + subtype + source + status)
- Vocab admin sayfası (özel isimleri sil, TR ekle)
- LLM ile TR çevirisi (Pattern A için)
- Semantic distractor'lar (kategori bazlı pool)

---

## [2026-05-22] build | Personal OS — Vocabulary entegrasyonu (44 öğe, 74 soru, FSRS 0.90 retention)

Kullanıcı talebi: "bağlamsal kelime, chunk ve phrasal verb öğrenme sistemini entegre et, hepsini Anki mantığıyla bağla."

**Schema değişikliği yok** — `items` tablosu generic olduğu için yeni `type` değerleri eklemek yeterli oldu: `vocab_word`, `vocab_chunk`, `phrasal_verb`.

**FSRS scheduler ikiye bölündü** (`src/lib/fsrs.ts`):
- `schedulerGrammar` — request_retention = **0.85** (grammar tek-bir konsept, esnek)
- `schedulerVocab` — request_retention = **0.90** (vocab single-fact, sıkı retention)
- `schedulerForType(itemType)` helper, `submitAttempt` doğru scheduler'ı seçer
- Aynı `reviews` tablosu hem grammar hem vocab için (item.type ile ayrılır)

**Seed (`scripts/seed-vocabulary.ts`):**
- **44 vocabulary item** (16 word + 12 chunk + 16 phrasal verb)
- Kaynaklar: word-bank-master.md, Naval Almanack, Paul Graham, Compressed Galaxy, literary sources (Les Misérables, Crime and Punishment), klasik B1+ phrasal verbs ve chunks
- Her item metadata: lemma, pos (part of speech), definition_en, definition_tr, example (BAĞLAM CÜMLESİ), source citation, related_grammar (cross-domain link to grammar topics)
- CEFR dağılımı: A2-C1 dengeli
- **Otomatik 2 soru/item üretildi** (toplam 74 soru):
  - **Cloze** — example cümlesinde lemma → `___`, 4 şık (lemma + 3 same-subtype distractor)
  - **Translation** — `lemma` + `definition_en` prompt, 4 TR şık (definition_tr + 3 same-subtype distractor)
- Cross-link örneği: "give up", "look forward to" → `phrasal-verbs` grammar topic'iyle bağlı; "scarcity" → `countable-uncountable`

**Yeni sayfalar:**
- `/english/vocabulary` — hub: 3 tab (Phrasal Verbs · Kelimeler · Chunks), stat cards (due/sürüyor/öğreniliyor/görülmemiş), her item CEFR-renkli kart (lemma + TR tanım + state dot + rep count)
- `/english/vocabulary/[slug]` — detay sayfası:
  - Hero: lemma (büyük), type/pos/cefr badges, FSRS state
  - Definition kartları (EN + TR side-by-side)
  - **Bağlamda** kartı — accent-renkli, italic, kitap/makale referansı altında
  - İlgili gramer chips (clickable linkler topic page'lere)
  - **İnteraktif quiz inline** — aynı `ReviewSession` component, intro: lemma-spesifik mesaj
  - Son denemeler listesi

**Review batch güncellendi (`getReviewBatch`):**
- ~60% grammar + ~40% vocab dengesi
- Her havuzda: due > weak > unseen önceliği, item başına max 2 soru
- Karışım shuffled — aynı tipte iki soru art arda gelmesin

**`/english` zenginleşti:**
- Üstte sağda "📖 Vocabulary" butonu (Bugünkü Review'in yanında)
- Yeni satır: vocabulary havuzu özet kartı (count by type + due/unseen badges + "Hepsini gör →" linki)

**Header nav** — "Life · English · **Vocab** · Review"

**Build:** ✓ TypeScript hatasız. 7 dinamik route:
- `/`, `/english`, `/english/review`, `/english/topics/[slug]`, `/english/topics/[slug]/admin`, `/english/vocabulary`, `/english/vocabulary/[slug]`

**Smoke test:** Tüm vocab route'ları HTTP 200. Detay sayfasında "voracious", "Definition", "Bağlamda", "İlgili gramer", "Kelimeyi test et", "doymak bilmez" render ediliyor.

**Pedagojik notlar:**
- **Bağlamsal öğrenme** — her vocab item bir gerçek cümlede yaşıyor (kitap/makale citation ile), boş kelime kartı değil
- **Cross-link** — vocab item'lar grammar topic'lere `related_grammar` ile bağlı (örn. "give up" → `phrasal-verbs`); gelecekte bu link `links` tablosuna taşınabilir
- **Anki mantığı** — FSRS scheduler hem grammar hem vocab için aynı reviews tablosunda; vocab daha yüksek retention (%90) çünkü "give up = vazgeçmek" tek-bir-fact, unutmaya tahammülü düşük
- **Source-as-context** — Naval Almanack'tan "voracious", Paul Graham'dan "junk/prestige" gibi öğeler kitap notlarıyla bağlı; review'da yaşıyor

**Sonraki adımlar:**
- Vocab admin CRUD (manuel yeni vocab ekleme, soru düzenleme — şu an seed üzerinden ekleniyor)
- LLM-assisted distractor üretimi (mevcut distractor'lar same-subtype rastgele, çok güçlü değil)
- Vault sources'tan toplu ingest (her kitap chapter'ında vocab listesi → DB)
- "Save to bank" gibi runtime ekleme mekanizması (reading sırasında bilinmeyen kelime yakalama)

---

## [2026-05-22] build | Personal OS — Dashboard zenginleştirme (streak + heatmap + week summary)

Üst dashboard'a motivasyon arttırıcı görsel veriler eklendi. Hem `/` (Life Layer) hem `/english` zenginleşti.

**Yeni queries (`src/lib/queries.ts`):**
- `activityDayKey(date)` — KR-007'deki **04:00 cutoff** uygulayan helper. Gece 02:00'da yapılan çalışma "önceki gün" sayılır.
- `todayKey()`, `shiftDayKey(key, delta)` — gün anahtarı manipülasyonu
- `getDailyActivity(days=90)` — son N gün için günlük session/attempt/correct/accuracy/duration. Boş günler 0 ile doldurulur (densified).
- `getStreak(window=365)` — current streak (bugün veya dün aktiflik kabul), longest streak, todayActive, lastActiveDate
- `getWeekSummary()` — son 7 gün: sessions, attempts, correct, accuracy, duration, uniqueTopics, newMasteries, daysActive

**Yeni componentler:**
- `ActivityHeatmap.tsx` — server component, SVG GitHub-vari grid (13 sütun × 7 satır = 91 gün). Activity level renk skalası: 0 (boş), 1 (1-3), 2 (4-9), 3 (10-19), 4 (20+). Hover'da `title` tooltip (tarih + attempt count + accuracy). Ay etiketleri sütun başında. Tema-aware (CSS variables ile).
- `StreakBadge.tsx` — büyük rakam + flame emoji (≥7 🔥, ≥3 ✨, ≥1 ·), "rekor", son 7 günlük mini bar chart sağda
- `WeekSummary.tsx` — 4 cell grid: oturum, soru (accuracy alt-satırda), süre (saniye→sa/dk format), konu (newMasteries alt-satırda)

**Pages güncelleme:**
- `src/app/page.tsx` (Life Layer):
  - Üst: 2 kartlı row (StreakBadge + WeekSummary)
  - Orta: tek kartlı 91-gün heatmap
  - Alt: mevcut Domains grid
  - Tüm sorgular `Promise.all` ile paralel
- `src/app/english/page.tsx`:
  - Üst row: StreakBadge (sol) + 4 pill (sağ 3 kolon, due/upcoming/weak/unseen)
  - Sonrası eskisi gibi (CEFR-renkli kategori grid)

**Build:** ✓ TypeScript hatasız, 5 dinamik route

**Smoke test:** "Streak", "Bu hafta", "Aktivite — son", "gün aktif", "aktif gün" hepsi render. `/` ve `/english` HTTP 200.

**Pedagojik not:** Heatmap = visible progress = motivasyon. CLAUDE.md'deki edge case #10'a (motivation collapse) doğrudan müdahale. Cold start için ilk 1-2 hafta heatmap dolmayacak — bu normal, baseline kuruluyor.

---

## [2026-05-22] build | Personal OS — Soru CRUD UI (/english/topics/[slug]/admin)

Soruların manuel editlenmesi/eklenmesi/silinmesi için admin sayfası eklendi.

**Yeni dosyalar:**
- `src/components/QuestionAdmin.tsx` — client component, üç alt component:
  - `QuestionRow` — read mode (prompt+answer+distractors+context görünür) + edit/pasifleştir/sil butonları
  - `EditForm` — inline expand, tüm alanları güncelle
  - `NewQuestionForm` — "+" butonu ile expand, yeni soru ekle
  - Paylaşılan `QuestionFields` field set (kind switch'e göre dinamik: MC için 3 distractor input, TF için iki buton, fill-blank/transform için sadece answer)
- `src/app/english/topics/[slug]/admin/page.tsx` — server component, topic info + QuestionAdmin

**Server action değişiklikleri (`src/lib/actions.ts`):**
- `createQuestion` artık `topicSlug` parametresi alıyor → `revalidatePath` ile o topic'in hem detay hem admin sayfasını yeniliyor
- `updateQuestion` zenginleşti: kind, contextSentence, difficulty güncelleyebiliyor; distractors null da kabul ediyor (kind değişince temizlenir)
- `deleteQuestion` artık **hard delete** (önceden soft idi, artık gerçekten siler). Aktif/pasif ayrı action.
- `toggleQuestionActive` eklendi — pasifleştirme ayrı bir aksiyon

**UX:**
- Topic detay sayfasının sağ üstüne "⚙ Soruları yönet" linki eklendi
- Admin sayfasında her soru kartı: read mode + üst sağda 3 buton (Düzenle / Pasif / Sil)
- "Sil" iki adımlı (Sil → Sil! / İptal) — kazara silmeyi önler
- "Pasif" soruyu DB'de tutar ama quiz'e dahil etmez (`questions.active = false`)
- Yeni soru: en altta dashed border'lı "+ Yeni soru ekle" butonu, basınca form açılır
- TF için cevap iki büyük buton (true/false), distractor otomatik (diğer değer)
- MC için 3 distractor input zorunlu; fill-blank/transform için runtime'da üretilir (mevcut quiz mantığı)

**Build durumu:** `next build` ✓. 5 dinamik route: `/`, `/english`, `/english/review`, `/english/topics/[slug]`, `/english/topics/[slug]/admin`

**Smoke test:** Admin sayfası HTTP 200, "Soru Yönetimi", "Yeni soru ekle", "Pasifleştir", "MC için 3 distractor" hepsi render.

**Not:** Dev server'ı yeniden başlatmak gerekti (eski background process düşmüş). Yeni process aynı port 3000'de.

---

## [2026-05-22] build | Personal OS — Topic interaktif quiz + tüm 56 konu seed (280 soru)

Phase 2 sonrası iki büyük ekleme:

**1) Kalan 46 konu için soru seed (230 yeni soru, toplam 280)** — `scripts/seed-questions-batch2.ts`. Her konuda 4 tip karışım (~2 fill_blank + 1 true_false + 1 multiple_choice + 1 transform). Distractor'lar yaygın Türk öğrenci hataları üzerine kurulu. Stative verb tuzakları (continuous tense'lerde "I am knowing", "He had been owning"), double comparative ("more taller"), indirect question word order ("Do you know what time is it?"), "despite + clause" hatası, mixed conditional ("If I would have known"), subjunctive ("demand that she returns"), phrasal verb separability ("picked up it"), "used to" vs "be used to + -ing", causative misinterpretation kapsanan başlıca pattern'ler.

CEFR dağılımı: A1 ~16, A2 ~15, B1 ~15, B2 ~8, C1 ~4 (Avrupa Çerçevesi'ne yakın dağılım).

**2) Topic detayında interaktif quiz** — Kullanıcı isteği: "her konu için altta görünen soru bankasını interaktif yap, gerçek bir test gibi, sadece çoktan seçmeli olsun, cevabı önceden gösterme."

- Eski "Soru havuzu · 5" listesi (prompt + answer + distractor görünür) **kaldırıldı**
- Yerine `ReviewSession` component'i topic'in tüm sorularını çoktan seçmeli formatında render ediyor
- `src/lib/queries.ts` içine `getTopicQuizQuestions(itemId)` eklendi:
  - Tüm aktif soruları çek
  - Fill-blank ve transform sorularını MC'ye dönüştür
  - Distractor üretimi: önce same-kind same-topic answer'larından (kind-aware pool), yetmezse other-kind same-topic, hâlâ yetmezse placeholder
  - True/false ve mevcut MC sorular olduğu gibi
  - Sonuç array shuffled
- `ReviewSession` component'i parametrize edildi: `returnHref`, `returnLabel`, `homeHref`, `homeLabel`, `introTitle`, `introBody` props. Aynı component hem global review (`/english/review`) hem topic-specific quiz için kullanılıyor.
- Topic sayfasında üst "Review başlat →" butonu kaldırıldı (artık quiz inline)
- Recent attempts listesi alta taşındı

**Smoke test:** Topic sayfasında "Konuyu test et · 5 soru", "Çoktan seçmeli", "Present Simple — hazır mısın?", "Başla" hepsi render ediliyor. Tüm 56 topic sayfası HTTP 200.

**Sonraki adımlar:**
- (B) Soru CRUD UI — edit/delete/add formu (admin akışı)
- (C) Turso + Vercel deploy + Vercel Protection
- (D) Philosophy domain'i aktif

---

## [2026-05-22] build | Personal OS — Phase 2 tamamlandı

Phase 1 MVP'nin üstüne dört büyük katman geldi: tema toggle, FSRS scheduler entegrasyonu, soru havuzu (280 soru), aktif review flow, topic detay sayfası.

**Yeni dosyalar (`~/Projects/personal-os/`):**
- `src/components/ThemeProvider.tsx` — light/dark context + localStorage + prefers-color-scheme
- `src/components/ThemeToggle.tsx` — header güneş/ay butonu
- `src/components/ReviewSession.tsx` — 4 soru tipi için ayrı UI (fill-blank input, true/false 2 buton, multiple-choice 4 buton shuffled, transform textarea Cmd+Enter), intro/asking/feedback/done state machine
- `src/lib/fsrs.ts` — ts-fsrs entegrasyonu, StoredCard JSON serialize/deserialize, autoRate (doğru→Good=3, yanlış→Again=1), Grade type-safety
- `src/lib/actions.ts` — server actions: startReviewSession, endReviewSession, submitAttempt (attempt yaz + FSRS next() ile review state güncelle), CRUD scaffold
- `src/app/english/topics/[slug]/page.tsx` — topic detay: metadata (TR bridge, formula, examples, common errors), tüm soru havuzu, son 10 deneme geçmişi
- `scripts/seed-questions.ts` — ilk 10 konu (A1/A2 öncelikli) × 5 soru = 50
- `scripts/seed-questions-batch2.ts` — kalan 46 konu × 5 soru = 230

**Güncellenen:**
- `src/app/globals.css` — Tailwind 4 `@custom-variant dark`, semantic CSS variables (background/foreground/surface/card/border/muted/accent/success/warning/danger) hem light hem dark için
- `src/app/layout.tsx` — ThemeProvider wrapper, flash-prevention init script, ThemeToggle header'da
- `src/app/page.tsx`, `src/app/english/page.tsx`, `src/app/english/review/page.tsx` — tüm hardcoded zinc renkleri semantic class'lara dönüştürüldü (bg-card, border-border, text-muted-strong, vb.)
- `src/lib/queries.ts` — getReviewBatch (due > weak > unseen önceliği, topic başına max 2 soru, shuffle), getTopicBySlug, getEnglishDomainId
- `src/db/client.ts` (env: `.env.local` → `.env` — dotenv default load)

**Soru havuzu yapısı (280 toplam):**
- 56 konu × 5 soru ortalama
- Karışım her konuda: ~2 fill_blank + 1 true_false + 1 multiple_choice + 1 transform
- Her soru: prompt, answer, distractors (MC için 3 hatalı şık), context_sentence (öğretici ipucu, yaygın hatalar TR/EN bilgiler), difficulty (1-5)
- Distractor'lar yaygın Türk öğrenci hataları üzerine kurulu (örn. "more taller", "I am knowing", "where do you live" indirect'te)

**FSRS akışı:**
1. Review sayfası açıl → `getReviewBatch(20)` due topic'lerden 20 soru getir
2. "Başla" → `startReviewSession()` session row yarat
3. Her cevap → `submitAttempt({questionId, sessionId, userAnswer})`:
   - normalize(answer) === normalize(expected) ile correct kontrol
   - autoRate(correct) → Grade (Again/Good)
   - mevcut `reviews.fsrsRaw` (Card state) yükle veya emptyStoredCard()
   - `scheduler.next(card, now, grade)` ile yeni state
   - reviews tablosunu upsert (stability×100, difficulty×10 int, fsrsRaw JSON)
   - attempts tablosuna kayıt
   - items.status backlog→active terfi
4. Oturum sonu → `endReviewSession()` ended_at + duration + score (correct rate %)

**Adreslenen edge case'ler:**
- Stative verb traps in continuous tenses (Pres Perf Cont, Past Perf Cont, Future Cont, Future Perf Cont): "I am knowing" tipi soruda yakalanıyor
- Double comparative ("more taller")
- Indirect question word order ("Do you know what time is it?")
- "Despite + clause" hatası ("Despite he was tired")
- Mixed conditional ("If I would have known")
- Subjunctive ("I demand that she returns")
- Phrasal verb separability ("I picked up it")
- Causative misinterpretation ("I had cut my hair" = self vs. by-someone)
- "Used to" vs "Be used to + -ing"
- Cefr coverage: A1 (16), A2 (15), B1 (15), B2 (8), C1 (4) — yaklaşık Avrupa Çerçeve dengeli

**Tema sistemi:**
- CSS variables: `--background`, `--foreground`, `--surface`, `--card`, `--card-hover`, `--muted`, `--muted-strong`, `--border`, `--border-strong`, `--accent`, `--accent-hover`, `--success`, `--warning`, `--danger`
- `@theme inline` ile Tailwind utility class'larına dönüştürüldü: `bg-card`, `text-muted`, `border-border`, vb.
- Flash önlemek için `<head>` içinde inline script — localStorage'tan oku, `.dark` class'ı early apply et
- Tüm sayfalar tek seferde tema-aware

**Build durumu:** `npx next build` ✓ TypeScript hatasız. 4 dinamik route: `/`, `/english`, `/english/review`, `/english/topics/[slug]`.

**Smoke test sonuçları:**
- Tüm route'lar HTTP 200
- 280 soru DB'de (`SELECT COUNT(*) FROM questions` ⇒ 280)
- Review batch: 20 soru hazır
- Topic detay sayfası: subjunctive/inversion/phrasal-verbs hepsi 200

**Açık konular (Faz 3'e):**
- Soru CRUD UI (edit/delete/add formu — şu an sadece read-only listede görünüyor)
- Turso'ya geçiş + Vercel deploy + Vercel Protection
- Backup: günlük JSON export → GitHub push
- Obsidian sync: `wiki/_db_snapshot/state.json` günlük dump
- Philosophy domain'i aktif (filozof-kavram-eser üçgeni)
- Multi-tenant placeholder (user_id schema'ya)

---

## [2026-05-22] system | Personal OS — Phase 1 MVP kuruldu

Kullanıcı talebi üzerine Daily Engine v1'in halefi olacak **multi-domain Personal Intellectual OS** sistemi başlatıldı. Vault dışında ayrı Next.js + SQLite uygulaması olarak kuruldu (`~/Projects/personal-os/`).

**Konuşma çerçevesi:** Kullanıcı, 56 gramer konusunun günlük takibinin yanında felsefe, okunan kitaplar, izlenen filmler, projeler — tüm entelektüel etkinliğini tek dashboard'dan takip etmek istiyor. Ana dashboard (Life Layer) + alt domain dashboard'ları + DB'ye Claude erişimi + Obsidian ile mantıksal köprü.

**Kararlar (detay: [[personal-os-design-decisions]]):**
- Eski Daily Engine v1 → migrate + emekli (topics.json + grammar-coverage.md verisi DB'ye taşındı)
- Stack: Next.js 16 + Drizzle + libSQL (lokal SQLite şimdilik, Turso Faz 2'de) + Tailwind 4 + ts-fsrs
- Auth: Vercel Protection (built-in password, Faz 2 deploy'da aktif)
- Claude erişimi: sadece aggregate + metadata; ham içerik Claude'a girmez
- Faz 1 domains: English + Philosophy
- Konum: vault dışı (iCloud + node_modules çakışmasını önlemek için)

**Yeni dosyalar (vault dışı):**
- `~/Projects/personal-os/` — Next.js 16 + TypeScript + Tailwind 4 + App Router
- `src/db/schema.ts` — 9 tablo (domains, items, sessions, questions, attempts, reviews, links, events, obsidian_refs)
- `src/db/client.ts` — libSQL drizzle client
- `src/lib/queries.ts` — domain stats, English topics, review queue
- `src/app/page.tsx` — üst dashboard (Life Layer)
- `src/app/english/page.tsx` — 56 topic gridview, CEFR-renkli, güç barı
- `src/app/english/review/page.tsx` — bugünkü review iskelet
- `scripts/migrate.ts`, `scripts/seed.ts` — DB setup
- `drizzle/0000_init.sql` — ilk migration

**Vault'a dokunan (sync için):**
- `wiki/synthesis/personal-os-design-decisions.md` — 8 KR (Karar Kaydı), 15 edge case, faz planı, schema özet
- `index.md` — yeni "Personal OS" başlığı eklendi
- `log.md` — bu giriş

**Seed sonucu (`npx tsx scripts/seed.ts`):**
- 2 domain: English (id=1), Philosophy (id=2)
- 56 grammar topic insert edildi
- 16 mevcut session migrate edildi (grammar-coverage.md'den parse)
- 16 review state'i (FSRS-ish, strength→state mapping)
- 6 philosophy skeleton item

**Adreslenen edge case'ler (15 adet, detay synthesis sayfasında):** soru ezberleme tuzağı · vocab-grammar farklı kadanslar · multi-domain burnout · cold start · Obsidian-DB drift · iCloud-git çarpışması · backup test edilmedi = backup yok · Vercel auth · Claude gizlilik · mastery tanımı · re-engagement · multi-tenant placeholder · soru kalitesi denetimi · streak cutoff · context sentence pool

**Build durumu:** `next build` ✓ TypeScript hatasız, 3 dinamik sayfa (`/`, `/english`, `/english/review`)

**Sonraki adım (Faz 2):** Her topic için 5 soru CRUD UI · FSRS scheduler attempt entegrasyonu · Turso'ya geçiş + Vercel deploy + Vercel Protection · günlük JSON backup → GitHub push

**Açık sorular (Faz 2 öncesi):** Soru seed'i manuel mi LLM mi · streak veri modeli · philosophy ilk seed kapsamı · Obsidian sync yönü (tek/hybrid)

---

## [2026-05-21] build | Writing Ladder — Direkt Yaz, Kademeli Bırak (A1→B2)

Kullanıcının talebi: "İngilizce direkt yazmamı sağlayacak, etkili yazma fikrini canlı tutacak, A1'den başlayan, kendi orijinal zihinsel etkinliğim %20-30'la başlayıp giderek artan, output merkezli, pedagojik, edge case'li bir uygulama."

**Yeni dosyalar:**
- `Artifacts/writing-ladder.html` (~104 KB, single file, ~3180 satır)
- `wiki/artifacts/writing-ladder.md` — wiki kaydı

**Mevcut yazma artifact'leriyle farkı:**
- [[daily-writing-loop]] = mekanik taklit + ezberden yaz (drill)
- [[writing-atelier-001-bloomsday]] = tek edebi senaryo (B1, Joyce atölyesi)
- **writing-ladder** = kendi orijinal cümleni kur, A1→B2, kademeli scaffold

**5 basamak:**

| Lv | Adı | Yardım | Akış |
|----|-----|--------|------|
| L1 | Echo | %80 | TR cümle + tam EN model → kopyala, küçük değişiklikle uyarla |
| L2 | Frame | %60 | TR + EN iskelet boşluklu → doldur |
| L3 | Hint | %40 | TR + 3-5 anahtar kelime → cümleyi kur |
| L4 | Sketch | %20 | Sadece TR → tam serbest |
| L5 | Free | %0 | Sadece tema → tam serbest |

**25 prompt** (A1: 10 · A2: 8 · B1: 5 · B2: 2) + Custom mod. Her prompt 5 satır taşır: `tr_lines` + `en_lines` + `frames` + `keywords`. Level'a göre otomatik scaffold render.

**Yardım sistemleri:**
- 💡 Word help — 110 kelimelik curated TR-EN seed sözlük (partial match)
- 🔧 Pattern help — 20 gramer kalıbı (A1→B2), formula + örnek
- 🎯 Starter sentences — seviyeye özel 10 başlangıç (40 toplam)
- 🎤 Voice — Web Speech API (en-US), fallback otomatik gizleme

**Mekanikler:**
- Auto-fade (3 başarılı seans → level up önerisi)
- Streak (2 gün toleransı, 3+ → sıfırla)
- Heuristic check (AI yok, 13 klasik Türk öğrenci hata regex'i: `I am go`, `in home`, `more better`, `people is`, `everyone are`, vb.)
- Recent sessions (son 14) + "Düzelt" butonu ile re-load (spaced retrieval)
- 5 görsel tema (navy/forest/sunset/paper/midnight)

**Edge case'ler (17 adet):** Blank page anxiety (stuck timer + starter), perfectionism (ugly draft), TR geri kayma (banned TR), zaman baskısı (timer info-only), kötü gün (1-cümle mode), AI praise inflation (objektif skor), voice fallback, spaced retrieval, pre-translation hint, level plateau, klasik hata regex, streak toleransı, mobile, Speech API check, localStorage corrupt, soft caps, network independence.

**Pedagojik temel:** Krashen i+1, Vygotsky ZPD, Swain Output Hypothesis, Bruner Scaffolding, Schmidt Noticing, Krashen Affective Filter.

**Klasman uyumu:** [[Interactive Reader Template]] ile kısmi uyum (sticky header + tema + kısayollar + toast + modal + localStorage + print + mobile). Sapma: TTS ve XP yerine streak + check; tab yerine sol panel + ana yazma.

**Dokunulan dosyalar:** `Artifacts/writing-ladder.html` (yeni) · `wiki/artifacts/writing-ladder.md` (yeni) · `Artifacts/_dashboard.html` (Writing 3→4 dosya, Writing Ladder kartı en üste) · `index.md` (Writing kategorisi altına yeni satır, updated 2026-05-21) · `wiki/practice/_index.md` (L1 Production Cell altına araç linki) · `log.md` (bu giriş)

**Backlog (v1.1→v2.0):** Vault'a .md export · 300+ kelime sözlüğü · spaced retrieval otomatizmi · pattern coaching · voice transcript analizi · meslek/akademik prompt setleri · custom prompt bankası · AI inline coaching.

---

## [2026-05-21] build | Confusable Drill v2 + Collocation Heatmap v2 + Comparative Reader v2

Üç yeni artifact oluşturuldu — v1 içeriklerinden farklı, yeni konular:

**confusable-drill-v2.html** — 20 yeni çift (B1 odak): Modals (must/have to, could/was able to, may/might), Adverb pairs (hard/hardly, late/lately, near/nearly), Adj confusables (fun/funny, alone/lonely, sensible/sensitive, interested/interesting), Time adverbs (eventually/finally, actually/currently), trip/journey, by/until, beside/besides, let/make, its/it's, who/which, neither/either, in the end/at the end, go/come, although/despite. Category filter eklendi (Modals / Adverbs / Adjectives / Prepositions / Structure).

**collocation-heatmap-v2.html** — 3 yeni matris: (1) Adj+Preposition 8×6 grid (interested/good/afraid/proud/responsible/fond/capable/worried × in/at/of/for/about/with), (2) Verb+Preposition 8×6 grid (depend/agree/apply/believe/result/suffer/consist/succeed × on/with/for/in/of/from), (3) Adv+Adj yeni set (completely/deeply/badly/heavily/strongly/highly × different/moved/needed/armed/influenced/recommended). Her kombinasyon için örnek cümleler + "yanlış" hücre notları.

**comparative-reader-v2.html** — A2-B1 seviye, uzun metin: (1) Atomic Habits — The 1% Rule (5 chapter, 7 paragraf çifti, B1↔A2), (2) Don Quixote — The Windmills (6 chapter, 9 paragraf çifti, B1↔A2). Chapter label sistemi eklendi. Keyboard ← → ile segment gezme, sync scroll, legend tıkla filtrele.

---

## [2026-05-21] build | Grammar First Lesson 03 — Camden Market & Regent's Park

`Artifacts/grammar-first-lesson-03.html` oluşturuldu. 7 yapı (Future Will, Going To, 2nd Conditional, Passive Voice, Adverbs of Manner/Freq., FANBOYS, Countable/Uncountable), ~350 kelime hikâye, 55 soru (7×5 + 10 mix + 5 comprehension), JSON export, dark/light tema, Card↔List view, highlight filter. Wiki kaydı: `wiki/artifacts/grammar-first-lesson-03.md`.

---

## [2026-05-20] build | Feature Picker Wizard — Micro-App Spec Generator

Kullanıcının "her seferinde istediğimi tam aktaramıyorum, görsel arayüzle seçeyim → JSON üretsin → sen onu okuyup tam istediğimi yap" talebine yanıt olarak `Artifacts/_feature-wizard.html` oluşturuldu.

**Yapı:** 13 kategori (Tema, Tipografi, Layout, Navigation, İçerik, Etkileşim, Öğrenme, Modlar, Üretim, Gamifikasyon, Veri, AI, Edge Cases), **~80 özellik**. Her özellik için:
- TR etiket + İngilizce kod adı (Claude'un anlayacağı schema key)
- Açıklama metni
- Varyant chip'leri (örn. dark_mode → auto/manual/none)
- Edge case checkbox'ları (örn. SRS → leech_detection + status_track)
- Serbest not textarea'sı
- Kaynak artifact linki (varsa, hangi mevcut dosyadan ilham)

**JSON şema:** `schema_version`, `project_name`, `summary`, `features` (kategori → items[] → {id, label_en, variant, edge_cases, user_note, source_artifact}). Önizle/Kopyala/İndir butonları.

**Wiki kontrol:** `wiki/artifacts/` (33 .md) duplicate kontrolü yapıldı, hepsi unique.

**Dosyalar:** `Artifacts/_feature-wizard.html` (yeni) · `Artifacts/_dashboard.html` (wizard kartı eklendi)

---

## [2026-05-20] cleanup | Artifacts klasörü temizleme & dashboard yenileme

Kullanıcı talebiyle Artifacts/ klasörü sınıflandırıldı ve dashboard komple yenilendi.

**Yapılan işlemler:**
- `Artifacts/other/` klasörü oluşturuldu → 26 dosya taşındı (felsefe, Türkçe yazarlık, kişisel sistemler, finans, boş dosyalar)
- `Artifacts/copy-list/` klasörü oluşturuldu → 6 duplicate dosya taşındı (past-tenses-visual ×2, remixed-8fb951f4 ×2, framework (1), mantik-rehberi (1))
- `_dashboard.html` komple yeniden yazıldı: 25 dosya/8 kategori → **82 dosya/12 kategori**

**Yeni dashboard kategorileri:** ⚙️ Daily Engine (4) · 🏠 Hubs (9) · 📊 Grammar Ref (6) · ⏰ Tenses (3) · 🎯 Topics (8) · 📖 Vocabulary (5) · 📝 Practice (4) · ✍️ Writing (3) · 📚 Literary (20) · 📰 Readers (7) · 🗺️ Rehber (6) · 🔧 Tools (7)

**Dokunulan dosyalar:** `Artifacts/_dashboard.html` (yeniden yazıldı) · `Artifacts/other/` (26 dosya) · `Artifacts/copy-list/` (6 dosya)

---

## [2026-05-19] ingest | Decameron — Day 1, Story 1: Ser Ciappelletto (A2-B1)

Kullanıcı isteği üzerine Decameron'un ilk hikâyesi A2-B1 seviyesinde, sadık ama sadeleştirilmiş İngilizce ile yeniden anlatıldı. Format: TR konu özeti (çerçeve hikâye + olay örgüsü + tema açıklaması) → 6 bölümlü İngilizce anlatı (frame, the worst man, sickness, false confession, sainthood, Panfilo'nun yorumu) → 10-kelime EN-EN mini sözlük (plague, notary, sin, swear, confess, priest, monastery, bury, bless, saint).

**Yeni dosya:** `wiki/sources/decameron/Decameron-Day01-Story01-Ser-Ciappelletto.md`
**Güncellenen:** `index.md` (Sources altına yeni Decameron serisi başlığı eklendi)
**İlişkilendirme:** [[Past Simple]], [[Past Continuous]], [[Past Perfect]], [[Reported Speech Concept]], [[Linking Words]], [[Negation]] — anlatıda doğal pratik alanı.

**Not:** Seri olarak devam edebilir (100 hikâye), ileride istenirse Day 1 Story 2 (Abraham the Jew) ile sürdürülebilir.

---

## [2026-05-18] build | English Learning Engine v1 — Faz 1 kuruldu

**Sistem kurulumu:** Üç-motorlu günlük çalışma sistemi, JSON+INBOX köprüsü, 56 konu seed, SRS, tracking iskeleti.

**Yeni dosyalar (HTML motors):**
- `Artifacts/grammar-first-daily.html` — Motor A (kart + modal + mini quiz; kavram-önce)
- `Artifacts/text-first-daily.html` — Motor B (metin + renkli vurgu + 5 sekme + TTS; metin-önce)
- `Artifacts/vocab-srs.html` — SM-2 sadeleştirilmiş Anki-mantığı SRS
- `Artifacts/implementation-notes.html` — Faz 1 baş ucu defteri (kararlar/sapmalar/edge case/açık sorular)

**Yeni dosyalar (ortak motor):**
- `Artifacts/_engine/topics.json` + `topics.js` — 56 konu seed (slug, CEFR, TR köprü, formül, 2 örnek, yaygın hatalar, subpatterns)
- `Artifacts/_engine/profile.json` + `profile.js` — kullanıcı profili (B1→B2, 6 ilgi alanı: felsefe, yazarlık, finans, AI, psikoloji, edebiyat)
- `Artifacts/_engine/engine.css` — ortak tema (4 tema × 4 font boyutu)
- `Artifacts/_engine/engine.js` — rotation algoritması, localStorage, SM-2, JSON export, quiz üretimi, tooltip, header

**Yeni dosyalar (tracking + INBOX):**
- `00_INBOX/` (+ `_archive/`) — JSON dump'larının düşeceği klasör, README ile
- `wiki/tracking/_index.md` — tracking hub
- `wiki/tracking/grammar-coverage.md` — 56 konunun seed durumu, hesap formülleri (güç, borç)
- `wiki/tracking/weak-topics.md` — haftalık zayıf-konu kuyruğu (pazar update)
- `wiki/tracking/word-bank-master.md` — kullanıcının "Save to Bank" havuzu
- `wiki/tracking/srs-state.md` — SM-2 snapshot, leech listesi
- `wiki/tracking/weekly-review.md` — haftalık delta şablonu

**Yeni wiki artifact kayıtları:** `wiki/artifacts/english-learning-engine-v1.md`, `grammar-first-daily.md`, `text-first-daily.md`, `vocab-srs.md`, `implementation-notes.md`

**Dokunulan dosyalar:** `index.md` (Daily Engine v1 bölümü eklendi, artifacts sayısı 22→26), `Artifacts/_dashboard.html` (Daily Engine v1 section'ı en üste eklendi)

**Tasarım çerçevesi:**
- Kefir prensibi: sıfır sunucu, sıfır build, vanilla HTML/CSS/JS
- Bisiklet prensibi: her motor tek başına çalışır, hiç bağımlılık yok
- Tek köprü: HTML → JSON → `00_INBOX/` → Claude Code → `wiki/tracking/*.md` → `_archive/`
- Çapraz teyit: Motor A ve B aynı günü aynı 6-8 konuyla görür, iki ayrı session payload kaydı
- Aylık kapsam: borç skoru + kategori sınırı + zayıf-öncelik → 4 hafta içinde 56 konu en az 1× görülür

**Kefir kalitesi notları:** İlk açılışta tüm 56 konu güç=null, borç=30 varsayılır. İlk hafta set'leri biraz random gibi görünür ama 30 gün içinde kapsam garantili. SRS bank boşsa vocab-srs.html "save'lediğin yok henüz" mesajı verir.

**Faz 2 önerileri** implementation-notes.html'de 6 açık soru olarak kaydedildi.

---

## [2026-05-15] ingest | Paul Graham Essays 02–08 — Seri Tamamlandı

**Eklenen dosyalar (7 essay):**
- `02-keep-your-identity-small.md` — etiket = aptallık; ~1000 kelime; B1
- `03-how-to-do-what-you-love.md` — prestige tuzağı; "would you do it unpaid?"; ~4000 kelime; B1+
- `04-what-youll-wish-you-had-known.md` — hard problems; proxy tuzağı; ~3800 kelime; B1
- `05-how-to-think-for-yourself.md` — conventional vs. independent-minded; Overton; ~3000 kelime; B1+
- `06-cities-and-ambition.md` — şehirlerin mesajları; çevre = kimlik; ~2500 kelime; B2
- `07-hackers-and-painters.md` — making vs. discovering; taste; empathy; ~5000 kelime; B2
- `08-how-to-write-usefully.md` — true + novel + important + well-written; ~2000 kelime; B1+

**Seri durumu:** 8/8 ✅ TAMAMLANDI. Toplam: ~22.000 kelime + ~120 terim glossary + 56 sticky sentence.

**Dokunulan wiki sayfaları:** `index.md` (PG bölümü 8 satıra genişletildi)

---

## [2026-05-16] ingest | Rich Dad Poor Dad — Chapter 5: The History of Taxes and the Power of Corporations

**Eklenen dosyalar:**
- `wiki/sources/rich-dad-poor-dad/Rich-Dad-Poor-Dad-Ch05-The-History-of-Taxes.md` — Chapter 5 (~10.000 kelime, 8 part, 64 vocabulary, 5 grammar yapısı, chapter summary)

**Chapter 5 konuları:** Gelir vergisinin tarihi (geçici → herkese yaygın), Robin Hood etkisi tersine (orta sınıf en ağır yükü taşır), şirket yapısının iki avantajı (hukuki kalkan + earn→spend→tax sırası), dört finansal IQ bileşeni (muhasebe/yatırım/piyasa anlayışı/hukuk), bilgi en güçlü finansal kalkan, çalışan vs. şirket sahibinin vergi yolu, vergi kaçakçılığı (illegal) vs. vergi planlaması (yasal) farkı, Robert'ın etik sorusu ve rich dad'ın yanıtı.

**Seri dizini güncellendi:** Chapter 5 ✅ olarak işaretlendi.

---

## [2026-05-16] ingest | Rich Dad Poor Dad — Chapter 6: The Rich Invent Money

**Eklenen dosyalar:**
- `wiki/sources/rich-dad-poor-dad/Rich-Dad-Poor-Dad-Ch06-The-Rich-Invent-Money.md` — Chapter 6 (~10.000 kelime, 8 part, 64 vocabulary, 5 grammar yapısı, chapter summary)

**Chapter 6 konuları:** Fırsatlar keşfedilmez yaratılır (iki insan aynı şehri farklı görür), kaldıraç kavramı (OPM ile büyük varlık kontrolü), Robert'ın ilk gayrimenkul anlaşması (motive satıcı + leverage + pozitif nakit akışı), cesaret boşluğu (bilmek ile yapmak arasındaki mesafe), sıfır nakit anlaşma (note/IOU + yeniden satış + marj), yatırım vs. spekülasyon (güvenlik marjı), finansal zekanın bileşik büyümesi (erken başlamak neden kritiktir).

**Seri dizini güncellendi:** Chapter 6 ✅ olarak işaretlendi.

---

## [2026-05-15] ingest | Paul Graham Essays — Seri Kurulumu + 01 Life Is Short

**Eklenen dosyalar:**
- `wiki/sources/paul-graham/index.md` — 8 essay planlanan seri dizini; PG kim; Naval vs PG stil karşılaştırması; önerilen okuma sırası
- `wiki/sources/paul-graham/01-life-is-short.md` — PG'nin en çok okunan essay'i (Jan 2016, ~2000 kelime); 7 bölüm tam metin + kritik pasajlara TR not; 8 sticky sentence; 25 terim glossary; PG vs Naval karşılaştırma tablosu; 3 pratik egzersiz

**Kapsam:** Ölüm, zaman, "junk" aktiviteler ve ilişkiler, "saying no is saying yes", sinyal vs gürültü. Naval'ın felsefe ve alışkanlık bölümleriyle doğrudan köprü kurdu.

**Dokunulan wiki sayfaları:** `index.md` (Essays & Aphorisms bölümü genişletildi — Naval 7 bölüm tam liste + PG yeni alt başlık)

**Sonraki:** 02 — Keep Your Identity Small (Naval ego bölümünün PG versiyonu, ~1000 kelime, en kısa essay)

---

## [2026-05-15] ingest | Naval Almanack 04–07 — Seri Tamamlandı

**Eklenen dosyalar:**
- `wiki/sources/naval-almanack/04-happiness.md` — 10 aforizma + 10 pasaj + 7 sticky sentence + 25 terim glossary; mutluluğun beceri olduğu, arzunun sözleşme olduğu, equanimity ve hedonic treadmill
- `wiki/sources/naval-almanack/05-philosophy.md` — 10 aforizma + 10 pasaj + 7 sticky sentence + 25 terim glossary; ölüm/ego/anlam/Stoa/Budizm/harita-arazi ayrımı; felsefe haritası tablosu
- `wiki/sources/naval-almanack/06-reading-and-learning.md` — 10 aforizma + 10 pasaj + 7 sticky sentence + 20 terim glossary; voracious reading, Feynman tekniği, 10 kitap must-read tablosu
- `wiki/sources/naval-almanack/07-habits.md` — 10 aforizma + 10 pasaj + 7 sticky sentence + 20 terim glossary; meditasyon, kimlik oyları, sağlık-sevgi-misyon; Naval vs. James Clear karşılaştırma tablosu; seri tamamlanma özeti

**Seri durumu:** 7/7 bölüm ✅ TAMAMLANDI. Toplam: ~250 aforizma + ~70 genişletilmiş pasaj + ~200 terim glossary + 49 sticky sentence.

**Dokunulan wiki sayfaları:** `wiki/sources/naval-almanack/index.md` (04–07 satırları ✅)

---

## [2026-05-16] ingest | Rich Dad Poor Dad — Chapter 4: Mind Your Own Business

**Eklenen dosyalar:**
- `wiki/sources/rich-dad-poor-dad/Rich-Dad-Poor-Dad-Ch04-Mind-Your-Own-Business.md` — Chapter 4 (~10.000 kelime, 8 part, 64 vocabulary, 5 grammar yapısı, chapter summary)

**Chapter 4 konuları:** Ray Kroc/McDonald's'ın gerçek işi (hamburger değil, gayrimenkul), meslek (profession) vs. iş (business) farkı, varlık sütununa neler girer (şirket, hisse, tahvil, kiralık gayrimenkul, notes/IOU, telif hakları), işi tutarken aynı anda varlık sütunu kurmak, rich dad'ın kendi varlık hikâyesi, hayat tarzı enflasyonu (en büyük düşman), insanların neden başlayamadığı (meşguliyet tuzağı), varlıkları ve nakit akışını görmeye başlamak.

**Seri dizini güncellendi:** Chapter 4 ✅ olarak işaretlendi.

---

## [2026-05-15] artifact | Claude ile Dil Öğrenme Rehberi oluşturuldu

Özet: `Artifacts/claude-language-guide.html` oluşturuldu. Felsefe atlası estetiğinde (bej/koyu tema, serif font, geometrik SVG illüstrasyonlar, card-grid) Claude'un 10 dil öğrenme kapasitesini sunan interaktif HTML rehber. 7 bölüm: Hero (4 boyut), 10 Yetenek kartı, 8 Prompt formülü, 5 adımlı workflow, L1–L5 pratik şeridi, 6 altın kural, hızlı başlangıç. `wiki/artifacts/claude-language-guide.md` wiki kaydı oluşturuldu. 1 artifact + 1 wiki sayfası.

---

## [2026-05-15] system | Practice — Output-Centric 5-Lane System kuruldu

**Tetik:** Kullanıcı talebi — output merkezli, edge case dahil, AI yeteneklerini sömüren, sürdürülebilir interaktif pratik sistemi.

**Plan onaylandı:** `/Users/fatihgocgun/.claude/plans/bana-ingilizce-renme-konsuudan-humming-rabin.md`

**Mimari karar:** Reading C1 — production B1 gap'i kapatmak için 5-şeritli rotating practice system. Daily 45-60 dk (deep session), mixed modality (writing + voice).

**Eklenen dizinler:**
- `wiki/practice/cells/` — L1 daily production cells
- `wiki/practice/shadow/` — L2 style mimicking
- `wiki/practice/dialogues/` — L3 conversational loops (voice/text)
- `wiki/practice/drills/` — L4 error-targeted drills
- `wiki/practice/retrieval/` — L5 spaced retrieval
- `wiki/practice/errors/` — recurring error pattern tracking
- `wiki/portfolio/` — haftalık curated polished works

**Eklenen dashboard dosyaları:**
- `wiki/practice/_index.md` — 5-lane sistem merkezi, haftalık şablon, tetikleme protokolleri, bu haftaki durum tracker'ı, edge case handler'ları
- `wiki/practice/errors/_index.md` — pattern frequency tracking, boss battle / graduated / decay register, pattern sayfa şablonu
- `wiki/portfolio/_index.md` — haftalık curation kriterleri, cilalama akışı, portfolio sayfa şablonu

**Güncellenen dosyalar:**
- `CLAUDE.md` — Section 1 Dizin Yapısı (practice/ + portfolio/ + sources/ eklendi); yeni Section 8 "Practice Akışı" eklendi (5 lane tetikleme protokolleri, constraint felsefesi, edge case'ler); Section 9 Lint practice-spesifik kontrolle güncellendi; Section 10 Log Formatı practice L1/L3 örnekleriyle genişletildi; sonraki sectionlar renumber edildi (eski 8→9 Lint, 9→10 Log, 10→11 Çelişki, 11→12 Output, 12→13 Yaşayan)
- `index.md` — yeni Practice bölümü eklendi (Dashboard'dan önce)

**5 Lane özet:**

| Lane | Süre | Hedef |
|---|---|---|
| L1 Production Cell | 15-20 dk | Grammar+vocab+chunk aktif kullanım |
| L2 Shadow Author | 25-30 dk | Style elasticity, register awareness |
| L3 Conversational Loop | 30-45 dk | Speaking, real-time production |
| L4 Error Constellation Drill | 20-30 dk | Fossilization önleme |
| L5 Retrieval Carnival | 15-20 dk | Spaced retention, decay önleme |

**Adreslenmiş edge case'ler (16 adet):** comprehension illusion, forgetting curve, translation reflex, "same sentence" rut, perfectionism, solo bubble, plateau tunnel, phrasal verb confusion, format fatigue, AI praise inflation, disconnect from reading, output procrastination, vocabulary hoarding, fossilization, mode dependency, motivation collapse.

**Pilot hafta başlangıcı:** Bugün (2026-05-15, Cuma). İlk değerlendirme: 2026-05-22 (Cuma).

**Verification kriterleri (pilot sonu):**
- ≥ 5 L1 cell, ≥ 2 L3 transcript (en az 1 voice), ≥ 1 L5 retrieval
- ≥ 5 distinct error pattern dokumante edildi
- ≥ 1 portfolio piece

**İlk adım:** Kullanıcı "L1 yapalım" / "Production cell" diyerek bugünkü okumadan (son ingest: Naval Almanack) ilk cell'i başlatabilir.

---

## [2026-05-15] ingest | Naval Almanack 03 — Leverage

**Eklenen dosyalar:**
- `wiki/sources/naval-almanack/03-leverage.md` — 10 temel aforizma + 10 genişletilmiş pasaj + dört kaldıraç türü özet tablosu + 7 sticky sentence + 25 terim glossary + köprü tablosu + pratik egzersiz

**Kapsam:** Specific knowledge'ı çarpan mekanizma: capital, labor, code, media. En kritik ayrım: permissioned vs permissionless leverage. Kod ve medya = izin gerektirmeyen, gece uyurken çalışan kaldıraç. Naval'ın "yeni zenginlerin sırrı" dediği şey.

**Dokunulan wiki sayfaları:** `wiki/sources/naval-almanack/index.md` (03 satırı ✅)

---

## [2026-05-15] ingest | Naval Almanack 02 — Specific Knowledge

**Eklenen dosyalar:**
- `wiki/sources/naval-almanack/02-specific-knowledge.md` — 5 temel aforizma + 10 genişletilmiş podcast/röportaj alıntısı + 6 sticky sentence + 20 terim glossary + bağlantı tablosu (Atomic Habits, Thinking Fast and Slow, ikigai) + pratik egzersiz

**Kapsam:** Almanack'in kalbi — eğitimle kopyalanamayan, meraktan doğan, sana özel bilginin ne olduğu ve nasıl bulunacağı. Tweetstorm'daki 5 aforizma çekirdek; üstüne podcast ve Tim Ferriss röportaj pasajları eklendi.

**Dokunulan wiki sayfaları:** `wiki/sources/naval-almanack/index.md` (02 satırı ✅, 03 satırına link eklendi)

---

## [2026-05-15] ingest | Naval Almanack — Essays Kategorisi Kurulumu + Tweetstorm

**Eklenen dosyalar:**
- `wiki/sources/naval-almanack/index.md` — 7 bölümlük seri dizini, kitap özeti, Naval kim, wiki köprüleri ([[Rich-Dad-Poor-Dad-Series]], [[Thinking-Fast-and-Slow-Series]], [[Atomic-Habits-Series]])
- `wiki/sources/naval-almanack/01-how-to-get-rich-tweetstorm.md` — Naval'ın 31 Mayıs 2018 tweetstorm'u: 40 aforizma (6 tematik blokta), 7 sticky sentence vurgulu, 30 terim glossary (Finance/Concepts/Verbs üç altbaşlık), pratik egzersiz

**Yeni kategori:** Essays & Aphorisms — wiki'de ilk essay/aforizma serisi. Roman/hikâye (Les Misérables, Crime and Punishment, Don Quixote) + non-fiction extended reader (Atomic Habits, Thinking Fast and Slow, Rich Dad Poor Dad) formatlarından sonra üçüncü içerik tipi. Format: **minimal** (metin + glossary), pedagojik müdahale minimum, "sticky English" odaklı — aforizmalar zaten kısa, B1 dostu, ezberlenebilir cümleler.

**Stratejik bağlam:** Kullanıcı "çeşitlendirme" talebiyle 10 formatlı içerik diyeti listesi aldı (essay, aphorism, speech, letter, long-form blog, podcast transcript, biography, illustrated, encyclopedia, documentary). Essay kategorisini ilk olarak seçti. Naval Almanack içinden başladık — aforizma formatı hem "essay" hem "aphorism" kategorisini köprüler.

**Dokunulan wiki sayfaları:** `index.md` (Sources bölümüne "💡 Essays & Aphorisms — Sticky English / Wisdom Literature" alt başlığı + 2 satır eklendi)

**Sonraki adımlar:** 02 — Specific Knowledge, 03 — Leverage, 04 — Happiness, 05 — Philosophy, 06 — Reading and Learning, 07 — Habits bölümleri sonraki ingest'lerde eklenecek.

---

## [2026-05-15] maintenance | wiki/sources klasör düzenlemesi

**Yapılan işlem:** `wiki/sources/` altındaki seri dosyaları seri bazlı klasörlere taşındı.

**Oluşturulan klasörler:**
- `les-miserables/` — 10 dosya (A2B1 + Ch03–Ch10 + Ch04 Study Guide)
- `crime-and-punishment/` — 3 dosya (Ch01–Ch03)
- `don-quixote/` — 4 dosya (Ch01 A2 versiyonu dahil, Ch01–Ch03)
- `atomic-habits/` — zaten vardı; 2 serbest dosya (Series + Ch01) klasöre taşındı; toplamda 7 dosya
- `thinking-fast-and-slow/` — 2 dosya (Series + Ch01)
- `rich-dad-poor-dad/` — 2 dosya (Series + Ch01)

**Değiştirilmeden bırakılanlar:** `ulysses-bloomsday-b1.md`, `uzak-sehir-ep61.md` (tek dosyalık, klasör gerektirmiyor)

---

## [2026-05-16] ingest | Rich Dad Poor Dad — Chapter 3: Why Teach Financial Literacy?

**Eklenen dosyalar:**
- `wiki/sources/rich-dad-poor-dad/Rich-Dad-Poor-Dad-Ch03-Why-Teach-Financial-Literacy.md` — Chapter 3 (~10.000 kelime, 8 part, 64 vocabulary, 5 grammar yapısı, chapter summary)

**Chapter 3 konuları:** Paranın dili (finansal okuryazarlık), asset ve liability'nin derinlemesine tanımı, üç nakit akış diyagramı (yoksul/orta sınıf/zengin), ev neden bir varlık değildir (mortgage + vergi + sigorta + bakım = aylık çıkan para), orta sınıf tuzağı (hayat tarzı yükümlülükleri maaşı yutar), "pay yourself first" ilkesinin detayı, enflasyonun satın alma gücünü sessizce eritişi, finansal zekanın öğrenilebilir bir beceri olduğu.

**Seri dizini güncellendi:** Chapter 3 ✅ olarak işaretlendi.

---

## [2026-05-15] ingest | Rich Dad Poor Dad — Chapter 2: The Rich Don't Work for Money

**Eklenen dosyalar:**
- `wiki/sources/rich-dad-poor-dad/Rich-Dad-Poor-Dad-Ch02-The-Rich-Dont-Work-For-Money.md` — Chapter 2 (~10.000 kelime, 8 part, 64 vocabulary, 5 grammar yapısı, chapter summary)

**Chapter 2 konuları:** Duygu döngüsü (korku + arzu), beş dolarlık teklif ve açgözlülük dersi, duyguları gözlemleme vs. tepki verme, komik kitap kütüphanesi (ilk gerçek iş girişimi), üç çalışan tipi (yoksul/orta sınıf/zengin), vergi sisteminin çalışanlar ile işletmecilere farklı davranması, istihdam sisteminin üç zinciri (sevilen iş + güvenlik + emeklilik), kendi sistemini kurmak.

**Seri dizini güncellendi:** Chapter 2 ✅ olarak işaretlendi.

---

## [2026-05-15] ingest | Rich Dad Poor Dad — Seri Kurulumu + Chapter 1

**Eklenen dosyalar:**
- `wiki/sources/Rich-Dad-Poor-Dad-Series.md` — 10 chapter seri dizini (Giriş + 6 Ders + 3 kapanış bölümü), konu özetleri, ilerleme takibi
- `wiki/sources/Rich-Dad-Poor-Dad-Ch01-Two-Fathers.md` — Chapter 1: Two Fathers (~10.000 kelime, 8 part, 64 vocabulary, 5 grammar yapısı, chapter summary)

**Seri yapısı:** Robert Kiyosaki'nin *Rich Dad Poor Dad* kitabı, A2/B1 seviyesinde 10 chapter'a uyarlandı. Her chapter ~10.000 kelime / ~1 saat TTS dinleme. Chapter 1 konuları: iki babanın hayat felsefeleri (poor dad = eğitim + güvenli iş, rich dad = finansal zeka + varlık kurma), paycheck tuzağı, korku ve arzu döngüsü, assets vs. liabilities diyagramı, rat race kavramı, "pay yourself first" prensibi.

**Dokunulan wiki sayfaları:** `index.md` (Sources bölümüne Rich Dad Poor Dad eklendi)

**Format:** Atomic Habits serisiyle aynı şablon — çok bölümlü anlatı + her bölüm sonrası EN-EN vocabulary sözlük + chapter sonunda grammar notları + chapter summary.

---

## [2026-05-16] ingest | Thinking, Fast and Slow — Chapter 2: The Lazy Controller

**Eklenen dosyalar:**
- `wiki/sources/thinking-fast-and-slow/Thinking-Fast-and-Slow-Ch02-The-Lazy-Controller.md` — Chapter 2 (~10.000 kelime, 11 part, 55+ vocabulary, 5 gramer yapısı, chapter summary tablosu)

**Kapsam:** Yürüyüş ve düşünme deneyi → System 2 bir batarya gibi çalışır. İsrailli yargıç araştırması (1112 karar, şartlı tahliye oranı yorgunlukla %65'ten %0'a düşüyor). Ego depletion: Baumeister'ın kurabiye/turp deneyi. Glukoz ve beyin enerjisi. Bilişsel yük: 7 rakamlı sayı grubu kek seçer. Fluency etkisi: kolay okunan = doğru hissettirir. Stres altında System 2 devre dışı. Pratik: karar zamanlaması, çevre tasarımı, decision rules.

**Dokunulan wiki sayfaları:** `index.md`, `Thinking-Fast-and-Slow-Series.md` (Chapter 2 ✅)

---

## [2026-05-15] ingest | Thinking, Fast and Slow — Seri Kurulumu + Chapter 1

**Eklenen dosyalar:**
- `wiki/sources/Thinking-Fast-and-Slow-Series.md` — 10 chapter seri dizini, konu özetleri, ilerleme takibi
- `wiki/sources/Thinking-Fast-and-Slow-Ch01-Two-Systems.md` — Chapter 1: Two Systems (~10.000 kelime, 10 part, 50+ vocabulary, 5 grammar yapısı, chapter summary tablosu)

**Seri yapısı:** Daniel Kahneman'ın Nobel ödüllü *Thinking, Fast and Slow* kitabı, A2/B1 seviyesinde 10 chapter'a uyarlandı. Her chapter ~10.000 kelime / ~1 saat TTS dinleme. Chapter 1 konuları: System 1 (hızlı/otomatik) vs System 2 (yavaş/mantıklı), bat-ball testi, görünmez goril deneyi, WYSIATI, affect heuristic, framing effect, loss aversion giriş.

**Dokunulan wiki sayfaları:** `index.md` (Sources bölümüne Thinking, Fast and Slow eklendi)

## [2026-05-15] artifact + klasman | Writing Atelier 001 — Ulysses & Bloomsday (Active Writing)

**Eklenen dosyalar:**
- `Artifacts/writing-atelier-001-bloomsday.html` (~62 KB) — interaktif aktif yazma atölyesi
- `wiki/artifacts/writing-atelier-001-bloomsday.md` — artifact wiki kaydı
- `wiki/sources/ulysses-bloomsday-b1.md` — Joyce/Ulysses B1 kaynak (280 kelime model anlatı + TR çeviri + TED-Ed Sam Slote referansı)
- `wiki/synthesis/narrative-past-tenses-cluster.md` ⭐ — yeni sentez: 5 yapı kümesi (Past Simple + Past Continuous + Past Perfect + Used to/Would + Time Adverbials), anlatı yazımı için minimum set

**Pilot yeni klasman:** Vault'taki ilk **aktif yazma odaklı** artifact. Mevcut reader klasmanının (Compressed Galaxy, Les Mis, vb.) yanına `Writing Atelier` adlı yeni seri kurgusu eklendi. Pilot konu: Joyce'un *Ulysses* romanının Bloomsday'i (16 Haziran 1904, Dublin) — TED-Ed videosu (https://www.youtube.com/watch?v=X7FobPxu27M) referans alındı.

**5 sekme yapısı (reader template v2.0 türevi):**
1. **Story** — 280 kelimelik B1 Bloomsday model anlatı, 5 yapı renk-kodlu `data-g` etiket, 14 kelime hover glossary, TTS controller (0.6-1.4×), Türkçe çeviri toggle, "Why Bloomsday?" kültürel kutu
2. **Grammar** — 5 yapı accordion: formül + 4 örnek + edge case + 2-soru mini-test her yapı için (toplam 10 mini-test sorusu)
3. **Practice** — 3 alt mod: **Sentence Builder** (10 cümle, click-to-pick), **Rewrite Challenge** (6 base × 2-3 hedef varyant = 14 transformasyon), **Story Continuation** (4 prompt + pause-aware ghost text + hint butonu)
4. **Exercises** — FIB (10) + Find Error (8) + TR→EN (8); token-overlap toleranslı kontrol
5. **Explore** — Writing Craft (4 kart) + Joyce & Modernism (3 kart) + Translation Notes (6 satır) + açık-uçlu "Your Bloomsday" writing task

**Vault'a ilk getirilen özellikler:**
- **Pause-aware Ghost Text** — textarea overlay mirror; kullanıcı 1.5 sn duraklayınca pre-authored öneri ghost olarak belirir; Tab=kabul / Esc=reddet (3 sn cooldown); backspace 3 sn cooldown; kursor sonda + seçim yok kontrolü
- **Active Hint Button** — her writing prompt için model cümleyi gramer renkli açar (-5 XP)
- **Rewrite Challenge** modu — aynı temel cümleyi 2-3 farklı hedef yapıya dönüştürme
- **Streak çoklu confetti tier'ı** — 3 (altın) / 5 (flash) / 10 (Bloomsday Master)

**Edge case'ler (10 adet uygulandı):** ghost text güvenliği · backspace cooldown · confetti throttle (800ms) · valid permütasyon array · auto-save on blur · click-to-pick mobile · double-click reset onayı · cross-tab TTS stop · @media print sadeleştirme · TTS cleanup beforeunload

**XP / Level:** Apprentice → Storyteller → Chronicler → Bloomsday Wanderer → Joycean Master (0/120/300/600/1000). 8 achievement: First Sentence, On a Roll, Streak Master, Bloomsday Master, Ghost Taster, No Hints Needed, Master Builder, Master Rewriter.

**localStorage key:** `writing_atelier_001_v1`

**Sentez (narrative-past-tenses-cluster):** Bu küme yalnız bu artifact için değil, gelecek Writing Atelier bölümleri için ortak referans. 5 yapının birlikte nasıl bir günü anlatma kapasitesi oluşturduğu, yaygın B1 hataları (Past Perfect aşırı kullanımı, used to + V-ing karışıklığı, would'un state verbs ile çalışmaması, vb.), uygun senaryolar (anı, biyografi, günce, tek günlük olay örgüsü) sayfada belgelendi.

**Backlog:** Writing Atelier 002 (Kafka/Metamorphosis), 003 (Camus/The Stranger), 004 (Borges short fiction), 005 (Marie Curie laboratory day). Her bölüm aynı 5-sekme yapısı + farklı eser + farklı gramer kümesi.

**Dokunulan dosyalar:** `Artifacts/writing-atelier-001-bloomsday.html` (yeni), `wiki/artifacts/writing-atelier-001-bloomsday.md` (yeni), `wiki/sources/ulysses-bloomsday-b1.md` (yeni), `wiki/synthesis/narrative-past-tenses-cluster.md` (yeni), `index.md` (Writing + yeni "Literary Modernism" kategorisi + Synthesis bölümlerine eklendi), `log.md` (bu giriş), `Artifacts/_dashboard.html` (yeni kart eklendi)

---

## [2026-05-15] artifact | Compressed Galaxy 002 — Cogito (Descartes) Interactive Study App

**Eklenen dosyalar:**
- `Artifacts/compressed-galaxy-002-cogito.html` (77.5 KB) — interaktif çalışma sayfası
- `wiki/artifacts/compressed-galaxy-002-cogito.md` — artifact wiki kaydı

**Klasman:** [[Interactive Reader Template]] v1.0 ile birebir uyum. localStorage key: `cg002_progress_v1`.

**8 gramer yapısı (felsefe metnine özgü seçim):**
1. Past Simple (narrative, irregular verbs)
2. What if... (hypothetical question, Türkçe "ya...sa?")
3. Reported Speech (basic backshift)
4. Gerunds vs Infinitives (decide to / enjoy V-ing)
5. Even if / Even though (concession)
6. Cannot — Logical Impossibility (Descartes\'in çekirdek argümanı)
7. Cause/Effect Linkers (so/because/that\'s why/therefore)
8. "That" Clauses (think/know/believe/realise + that)

**20 kelime:** philosopher · doubt · radical · illusion · contradiction · certain · accept · question · truth · trick · dream · powerful · evil · exist · courage · comfortable · method · realise · imagine · lesson

**Explore sekmesi:**
- Writing Craft (Anaphora · Concrete verbs for abstract ideas · Famous Quote in Context · Closing Question)
- Philosophy Connection (Platon Mağara Alegorisi · Aristoteles First Principles · Hume Radikal Şüphe)
- Translation Notes (doubt/certain/illusion/contradiction/radical/cogito ergo sum)
- Writing Task: "One Thing I Have Never Questioned"

**002\'ye özgü ek:** Blockquote stili (Cogito, ergo sum kotasyonu için) — TTS\'in `getPassageText` fonksiyonu blockquote\'u da içerir.

**Dokunulan dosyalar:** `compressed-galaxy-002-cogito.html` (yeni), `wiki/artifacts/compressed-galaxy-002-cogito.md` (yeni), `index.md` (Compressed Galaxy bölümüne eklendi), `log.md` (bu giriş)

---

## [2026-05-15] artifact + klasman | Compressed Galaxy 001 — Loss Aversion Interactive Study App + Interactive Reader Template

**Eklenen dosyalar:**
- `Artifacts/compressed-galaxy-001-loss-aversion.html` (75.8 KB) — interaktif çalışma sayfası
- `wiki/artifacts/compressed-galaxy-001-loss-aversion.md` — artifact wiki kaydı
- `wiki/synthesis/Interactive-Reader-Template.md` ⭐ — yeniden kullanılabilir klasman dokümanı

**Sayfa özeti — 5 sekme (A2-B1):**
1. Reading — ~470 kelime, 8 renkli gramer yapısı (tooltip), TTS controller (play/pause/stop + hız 0.6-1.4×)
2. Vocabulary — 20 kelime, 4 mod (flashcards + 🔊 listen / quiz 12 soru / match 8 çift / write + örnek)
3. Grammar — 8 yapı (Zero/1st Cond, Comparatives, Present Perfect, Passive, Relative Clauses, Modals, Adverbs of Degree, Phrasal Verbs); accordion + formula + 4 örnek + edge cases + mini test
4. Exercises — FIB (10) + Find Error (8) + TR→EN (8), localStorage skor takibi
5. Explore — Writing Craft (Concrete Hook/Inclusive You/Contrast/Twist) + Philosophy (Platon/Aristoteles/Kahneman) + Translation Notes + Writing Task

**Spec'in üstüne eklenen edge case'ler (14 adet):**
TTS controller · font size cycler (A−/A/A+/A++) · localStorage persistence · reset button · klavye kısayolları (1-5, F, Shift+R) · scroll-to-top · toast notifications · print stylesheet · voice selection (Google atla) · grammar legend → kart atlama · word speak butonu · TTS cleanup (beforeunload) · fade-in animasyon · viewport-aware tooltip pozisyonu

**Klasman dokümanı (Interactive Reader Template):**
15 bölümlük standart — CSS değişkenleri, 5-sekme spec, sticky toolbar, klavye kısayolları, TTS standartı, localStorage formatı, mobile breakpoint, print, dosya adlandırma, 20+ edge case checklist, seviye uyarlama tablosu (A2→B1 Upper), kalite kontrol listesi. Tüm gelecekteki makale→reader dönüşümleri bu klasmana göre yapılacak.

**Dokunulan dosyalar:** `compressed-galaxy-001-loss-aversion.html` (yeni), `wiki/artifacts/compressed-galaxy-001-loss-aversion.md` (yeni), `wiki/synthesis/Interactive-Reader-Template.md` (yeni), `index.md` (Tech News + Synthesis bölümlerine eklendi), `log.md` (bu giriş)

---

## [2026-05-15] ingest | Atomic Habits — Chapter 1 (A2/B1 Non-fiction Reader)

**Eklenen dosyalar:**
- `wiki/sources/Atomic-Habits-Series.md` (yeni) — seri hub, 20 chapter haritası
- `wiki/sources/Atomic-Habits-Ch01-The-Surprising-Power.md` (yeni) — Chapter 1 tam okuma

**Format:** Markdown, A2/B1 uyarlaması, non-fiction / self-help
**İçerik:** 5 Part × uzun okuma + 5 × 8 vocabulary (EN-EN) + Chapter Summary + 5 gramer yapısı
**Konular:** James Clear'ın bisiklet kazası · 1% kuralı (1.01^365=37.78) · İngiliz bisiklet takımı (Dave Brailsford) · Latent potential plateau · Sistemler vs. hedefler
**Gramer yapıları:** Present Simple (facts), Modal verbs (can/will/might), First Conditional (If+present→will), Linking words (result/contrast), Comparison (-er / more / as...as)
**Dokunulan dosyalar:** `Atomic-Habits-Series.md` (yeni), `Atomic-Habits-Ch01-The-Surprising-Power.md` (yeni), `index.md` (güncellendi), `log.md` (bu giriş)

---

## [2026-05-15] ingest | Uzak Şehir — Episode 61 (A2 TV Series Reading)

**Eklenen dosya:** `wiki/sources/uzak-sehir-ep61.md`
**Format:** Markdown, TTS uyumlu, diyalog ağırlıklı, A2 seviyesi
**İçerik:** 8 sahne geniş anlatım + 6 diyalog kutusu + 6 gramer yapısı + 18 vocabulary
**Gramer yapıları:** Simple Past, Past Continuous, must/had to, could/couldn't, connectors (because/so/but/when), adjectives
**Dokunulan dosyalar:** `wiki/sources/uzak-sehir-ep61.md` (yeni), `index.md` (güncellendi)

---

## [2026-05-14] ingest | Compressed Galaxy — 5 Bölüm (Yeni Seri, A2-B1, TTS)

**Eklenen klasör:** `wiki/series/compressed-galaxy/`
**Format:** Markdown, TTS öncelikli, sade okuma deneyimi, interaktif element yok
**Seviye:** A2-B1 arası (kesinlikle B1 üstü değil)
**Konu rotasyonu:** Psychology → Philosophy → AI → History → Economics

**5 Bölüm:**
1. `001-loss-aversion.md` — Why Your Brain Hates Losing More Than It Loves Winning (Psikoloji)
2. `002-cogito.md` — The Man Who Burned Everything to Find One Truth (Felsefe / Descartes)
3. `003-machine-lies.md` — What Happens When a Machine Learns to Lie (AI / Hallucination)
4. `004-memory-accident.md` — The Accident That Changed How We Remember Things (Ebbinghaus)
5. `005-free-things.md` — Why Free Things Are Never Actually Free (Ekonomi / Opportunity Cost)

**Her bölüm:** ~950 kelime, 5 bölüm yapısı (Hook / The Idea / Deeper / The Twist / Landing), 5 hedef kelime sonda
**Ana index güncellendi:** Evet

---

## [2026-05-15] ingest | Crime and Punishment Ch03 — The Axe (Extended A2/B1 Reader)

**Eklenen dosya:** `wiki/sources/Crime-and-Punishment-Ch03-The-Axe.md`
**Format:** Markdown, 5 sahne + vocabulary (10 kelime/sahne) + Chunks + Phrasal Verbs, TTS uyumlu
**Kelime sayısı:** ~10.000

**5 Sahne:** The Preparation · The Crossing · The Door · The Search · The Escape
**Vocabulary:** 50 kelime (EN-EN) | **Chunks:** 15 ifade (EN tanım + TR çeviri) | **Phrasal Verbs:** 12 fiil (EN tanım + TR çeviri)
**index.md güncellendi:** Ch02 + Ch03 eklendi.

---

## [2026-05-15] ingest | Crime and Punishment Ch02 — The Letter (Extended A2/B1 Reader)

**Eklenen dosya:** `wiki/sources/Crime-and-Punishment-Ch02-The-Letter.md`
**Format:** Markdown, 5 sahne + vocabulary (10 kelime/sahne) + Chunks + Phrasal Verbs, TTS uyumlu
**Kelime sayısı:** ~10.000

**5 Sahne:** Morning in the Garret · What the Letter Said · The Walk · The Dream · The Overheard Conversation
**Vocabulary:** 50 kelime (EN-EN) | **Chunks:** 15 ifade (EN tanım + TR çeviri) | **Phrasal Verbs:** 14 fiil (EN tanım + TR çeviri)

---

## [2026-05-14] ingest | Crime and Punishment Ch01 — The Plan (Extended A2/B1 Reader)

**Eklenen dosya:** `wiki/sources/Crime-and-Punishment-Ch01-The-Plan.md`
**Format:** Markdown, 5 sahne, her sahneden sonra EN-EN vocabulary bölümü, TTS uyumlu
**Seviye:** A2/B1 arası | **Konu:** Dostoyevski — Suç ve Ceza, Bölüm 1
**Kelime sayısı:** ~10.000

**5 Sahne:**
1. The Garret — Raskolnikov'un odası, pawnbroker'a gidiş kararı
2. The Pawnbroker — Alyona Ivanovna ziyareti, gözlem, prova
3. The Tavern — Marmeladov ile karşılaşma
4. Marmeladov's Story — Katerina Ivanovna, Sonya, merhamet tartışması
5. The Night Walk — Kıyı yürüyüşü, genç kız sahnesi, karar

**Vocabulary bölümleri:** 10 kelime/sahne × 5 sahne = 50 kelime (EN-EN tanım + örnek cümle)
**index.md güncellendi:** "Crime and Punishment" serisi eklendi.

---

## [2026-05-14] ingest | iPhone 18 & iOS 27 — B1 Interactive Tech Reader

**Eklenen dosya:** `Artifacts/iphone-18-ios27-b1-reader.html`
**Format:** Tek dosya HTML, dark navy tema, 5 sekme, ~75KB
**Seviye:** B1 Upper | **Konu:** iPhone 18 sızıntıları + iOS 27 özellikleri

**8 Yeni Gramer Yapısı (daha önce işlenmemiş):**
1. Future Continuous (will be + V-ing)
2. 3rd Conditional (if + had + V3, would have + V3)
3. Modal Perfect (should/could/might + have + V3)
4. Cleft Sentences (It is…that / What…is)
5. Passive with Modal (is expected/said/believed/rumoured to)
6. Quantifiers (a number of / a great deal of / a large number of)
7. unless / as long as
8. The more…the more… (orantılı karşılaştırma)

**İçerik:** ~460 kelime B1 pasaj · 20 kelime (4 mod: flip/quiz/match/write) · 8 gramer kartı (accordion, mini test) · 3 alıştırma türü (FIB/error/çeviri) · Explore (craft/felsefe/çeviri notu/yazma görevi)
**index.md güncellendi:** "Tech News" bölümü eklendi.

---

## [2026-05-13] ingest | Les Misérables Ch10 — The End of the Road (Extended Reader) — SERİ SONU

**Eklenen dosya:** `wiki/sources/Les-Miserables-Ch10-The-End-of-the-Road.md`
**Kelime sayısı:** ~10.000 | **Seviye:** A2/B1 | **TTS uyumlu:** Evet

**Sahneler (16 + Epilog):**
1. Javert nehir kıyısında — iç yıkım; tüm inandıkları sarsıldı; nehire adım atıyor
2. Gillenormand'ın evi — Marius kapıya taşınıyor; dede kırılıyor
3. Cosette öğreniyor — Valjean haber veriyor; sabah ilk kez ağlamıyor
4. Yatağın başında — Cosette Marius'un elini tutuyor; ilk uyanış
5. İyileşme — haftalar, ateş, Cosette hiç ayrılmıyor; Gillenormand'ın özrü
6. Marius soruyor — Evlilik izni; Gillenormand evet diyor
7. Düğün — küçük, sıcak tören; Valjean arka sırada
8. Gerçek — Valjean Marius'a her şeyi anlatıyor: Jean Valjean, 24601
9. Mesafe — Marius yavaşça uzaklaşmaya başlıyor; Pazar yemekleri kesiliyor
10. Rue de l'Homme-Armé — Valjean yalnız odalarda; yemiyor; yavaşlıyor
11. Thénardier — kapıya geliyor; lağım bilgisini silah olarak kullanıyor; Marius her şeyi biliyor der
12. Rue de l'Homme-Armé'ye gidiş — Marius ve Cosette koşuyor; Valjean kapıyı açıyor
13. Marius'un özrü — sewer sahnesi; "küçüktü benden"
14. Ev'deki oda — Valjean taşınıyor; sabah ışığı; yemek
15. Son aylar — metotlar yazılıyor; Cosette her gece okuyuyor
16. Mumlar — Valjean piskoposu anlatıyor; "ruhunu tanrıya ver"; Cosette tutuyor
Son: Valjean sakin, sıcak, sevilen biriyle ölüyor — Epilog: Père-Lachaise mezarlığı, sade taş, dört dize

**SERİ TAMAMLANDI:** 10 Bölüm · ~100.000 kelime · A2/B1 · Victor Hugo
**index.md güncellendi:** Ch10 girişi eklendi, "SERİ SONU" notu.

---

## [2026-05-13] ingest | Les Misérables Ch09 — The Barricade (Extended Reader)

**Eklenen dosya:** `wiki/sources/Les-Miserables-Ch09-The-Barricade.md`
**Kelime sayısı:** ~10.000 | **Seviye:** A2/B1 | **TTS uyumlu:** Evet

**Sahneler (17):**
1. Paris Haziran 1832 — General Lamarque'ın ölümü, gergin şehir
2. Café Musain'de son toplantı — Enjolras kararı açıklıyor, tüm üyeler "gelirim" diyor
3. Barikatın kuruluşu — Rue de la Chanvrerie, kaldırım taşları ve mobilyalar
4. Gavroche — sokak çocuğu, korkusuz, kaşif
5. Kapıda kız — Éponine erkek kıyafetleriyle geliyor, Marius'u tanıyor
6. Javert yakalandı — casus olarak sızarken Gavroche'un fark etmesiyle
7. İlk saldırı — askeri saldırı püskürtüldü, kimse ölmedi
8. Éponine'in son eylemi — Marius'a yönelik kurşunun önüne geçiyor, Marius'un kollarında ölüyor
9. Cosette'in mektubu — Éponine mektubu sakladığını itiraf ediyor, Marius okuyor
10. Marius Gavroche'a mektup gönderiyor — Cosette'e adrese teslim
11. Beyaz saçlı adam — Valjean barikata gizlice katılıyor
12. Valjean Javert'i serbest bırakıyor — avluda silahı havaya ateşliyor
13. Gavroche kartriş topluyor — düşman hattına geçiyor, vurularak ölüyor
14. Son saldırı — topçu ateşi, barikat düşüyor, öğrenciler birer birer yıkılıyor
15. Enjolras'ın sonu — son savaşçı, mütevazı son
16. Marius vuruldu — yere düşüyor, baygın
17. Lağım kanalları + nehir kıyısı — Valjean Marius'u taşıyor; Javert bekliyor; kısa sessiz karşılaşma

**index.md güncellendi:** Sources tablosuna Ch09 girişi eklendi.

---

## [2026-05-13] artifact | Les Misérables Ch07 — Paris Intensive Study App

**Eklenen dosyalar:**
- `Artifacts/les-miserables-ch07-study.html` — interaktif tek dosya HTML/CSS/JS uygulaması
- `wiki/artifacts/les-miserables-ch07-study.md` — wiki kaydı

**İçerik:**
- Chapter 7 özet metin (~1.400 kelime, A2/B1, TTS uyumlu, 15 paragraf)
- 10 hedef kelime: peripheral · sanctuary · brevity · premonition · composure · proximity · methodically · vain · assessing · effusive
- 5 sekme: Read (tıklanabilir vurgular + popover) | 10 Words (kartlar) | Recall (A: eşleştirme, B: boşluk doldurma, C: doğru kullanım T/F) | Produce (sahne yeniden anlatımı + kelime sayacı + 5 kişisel cümle) | Score (puan özeti)
- Açık/koyu tema, Verdana, localStorage kalıcılık
**index.md güncellendi:** Artifacts sayısı 21'e yükseltildi, yeni satır eklendi.

---

## [2026-05-13] ingest | Les Misérables Ch08 — Marius (Extended Reader)

**Eklenen dosya:** `wiki/sources/Les-Miserables-Ch08-Marius.md`
**Kelime sayısı:** ~10.000 | **Seviye:** A2/B1 | **TTS uyumlu:** Evet

**Sahneler (19):**
1. Rue Plumet'deki ev — Valjean ve Cosette yeni evlerine yerleşiyor
2. Bir genç, bir bank — Marius ilk kez Cosette'i görüyor
3. Marius'un geçmişi — Baba Pontmercy, dede Gillenormand
4. Mektuplar — Babasının ölümü, kilise galerisindeki gizli ziyaretler
5. Dede ile kopuş — Marius evi terk ediyor, 12 frank, bir çanta kitap
6. Gorbeau evindeki yaşam — Yoksulluk, hukuki kopya işleri, Courfeyrac
7. Lüksemburg Bahçesi: İlk bakışlar — Haftalık karşılaşmalar, düşen eldiven
8. Hata — Valjean'ın keskin bakışı, bahçeye geliş kesilmesi
9. Yok oluş — Cosette ve Valjean bahçeye gelmiyor, Marius'un çaresizliği
10. Éponine — Bahçe kapısındaki kız, bilgi karşılığı pazarlık
11. Paris'teki Thénardier'ler — "Jondrette" adıyla Gorbeau'da yaşıyorlar
12. Rue Plumet'deki bahçe — İlk buluşma, taş bank, isimler öğreniliyor
13. Bahçe buluşmaları — Altı hafta, akşam konuşmaları, aşk itirafı
14. Valjean'ın fark etmesi — Bahçe kapısının ardından genç çifti izliyor
15. Mektup — Marius'un aşk mektubu, Cosette'in cevabı
16. Dışarıdaki dünya — General Lamarque'ın ölümü, barikatlar yaklaşıyor
17. Valjean'ın kararı — Gece evden ayrılma, tehlikenin sezilmesi
18. Marius bahçeye geliyor — Ev boş, ışıklar sönmüş, Cosette gitti
19. Son gece — Dede'ye veda, Courfeyrac, barikata gitme kararı

**index.md güncellendi:** Sources tablosuna Ch08 girişi eklendi.

---

## [2026-05-08] artifact | Les Misérables — The Cart Scene B1 Reader

**Özet:** Yarım kalan HTML artifact tamamlandı ve Artifacts/ klasörüne kaydedildi. `wiki/artifacts/les-miserables-cart-scene-b1.md` oluşturuldu. `index.md` güncellendi.

**Dosya:** `Artifacts/les-miserables-cart-scene-b1.html`

**Kapsam:** 5 sekme (Reading, Vocabulary, Grammar, Exercises, Explore), 8 renk kodlu gramer yapısı (Modal Perfect, Too+Adj, Passive Voice, Past Continuous, As/As soon as, Participial Clause, Adverb, Direct Speech), hover tooltip sistemi, 18 kelime (flashcard/quiz/match/write), 20 alıştırma sorusu, yazarlık + felsefe + çeviri analizi.

**Dokunulan sayfalar:** 3 (artifact dosyası, wiki artifact kaydı, index.md, log.md)

---

## [2026-05-08] ingest | Les Misérables Ch07 — Paris (Extended Reader)

**Özet:** Chapter 7 genişletilmiş versiyonu yazıldı. ~10.000 kelime, 16 bölümlük tam anlatım, A2/B1 seviyesi, TTS uyumlu düz metin.

**Eklenen dosya:** `wiki/sources/Les-Miserables-Ch07-Paris.md`

**Kapsanan sahneler:**
- Paris'in iki yüzü — zengin batı, fakir doğu; Gorbeau hanının tasviri
- Yerleşme — yeni kıyafetler, gerçek yemek, uyku
- Cosette'in okula kaydı — iki yaşlı öğretmen hemşire
- Valjean'ın günlük rutini — pişirme, rota ezberleme, yalnızlık
- İlkbahar büyümesi — Cosette okuma öğreniyor, gülüşü değişiyor
- "Grand-père" anı — ilk gülüş, içi ısınan Valjean
- Lüksemburg Bahçesi Pazar'ları — alışkanlık, güvenlik hissi
- Genç adamın bakışı — Marius, Cosette'i izliyor (sessiz tanıklık)
- Gece sokağında Javert — lamba direği altında tanınan yüz
- İç kriz ve kırılma noktası — kalma mı gitme mi
- Arka sokaklardan gece kaçışı — koşu, çıkmaz sokaklar, duvarlar
- İp ve duvar tırmanışı — bahçeye düşüş
- Fauchelevent'in tanıması — kucaklama, sevinç
- Başrahibe ile görüşme — müzakere, güvence
- Manastır duvarları içinde yaşam — kural, saat, sessizlik
- Cosette'in son sorusu — "Gerçekten burada mı kalacağız?"

**index.md güncellendi:** Sources tablosuna Ch07 girişi eklendi.

---

## [2026-05-08] ingest | Les Misérables Ch06 — Little Cosette (Extended Reader)

**Özet:** Chapter 6 genişletilmiş versiyonu yazıldı. ~10.000 kelime, 15 bölümlük tam anlatım, A2/B1 seviyesi, TTS uyumlu düz metin.

**Eklenen dosya:** `wiki/sources/Les-Miserables-Ch06-Little-Cosette.md`

**Kapsanan sahneler:**
- Valjean'ın kaçış sonrası planlaması — söz ve para, hedef Montfermeil
- Montfermeil köyüne yürüyüş — Noel gecesi, beyaz kar
- Thénardier hanının dışarıdan gözlemlenmesi
- Hanın günlük hayatı — Thénardier ve karısının karakteri
- Cosette'in gerçek hayatı — çalışma rutini, uyum, eksikliğin hissi
- Mağaza camındaki bebek — bir kez bakmak, geri dönmemek
- Noel Gecesi hanın kalabalığı ve Cosette'in işleri
- Kuyudan su çekme ve karşılaşma — ağır kova, yabancı el
- Odada tek başına düşünceler — söz, Fantine, Cosette
- Noel sabahı — Jacqueline (odun parçasından yapılmış bebek)
- Bebeğin satın alınması — sormadan ödeme, fiyattan vazgeçmeme
- Cosette'e hediye — sessizlik, sarılma, "thank you"
- Müzakere — Thénardier'nin oyunu, Valjean'ın soğukkanlılığı, ödeme
- Ayrılış — önlük, tahta pabuç, "Jacqueline'i alabilir miyim?"
- Orman yolu — el tutuşma, çiftçi evi, süt, uyku
- Sabah arabası — Paris'e doğru, annenin ölüm haberi, "iyiyiz"

**Dokunulan sayfalar:** `wiki/sources/Les-Miserables-Ch06-Little-Cosette.md` (yeni), `index.md`, `log.md`

---

## [2026-05-08] ingest | Les Misérables Ch04 — Study Workbook (Çalışma Rehberi)

**Özet:** Chapter 4 (Fantine's Story) için kapsamlı çalışma rehberi oluşturuldu. 7 ana bölüm, cevap anahtarlı, A2/B1 seviyesinde, metne bağlı alıştırmalar.

**Eklenen dosya:** `wiki/sources/Les-Miserables-Ch04-Study-Guide.md`

**Bölümler:**
- Part 1: Story Comprehension (T/F/N, olay sırası, kısa cevap)
- Part 2: Vocabulary Deep Dive (bağlam, kelime aileleri, eş/zıt, boşluk doldurma, collocation, serbest yazma)
- Part 3: Grammar Workshop (Past Simple vs Continuous, Could/Had to, Linking Words, Reported Thought, Descriptive Writing)
- Part 4: Memory Anchors (emotion-word, before/after, character compass, sentence reconstruction, vocabulary ladder)
- Part 5: Creative Writing Lab (Fantine'in mektubu, Cosette'in bakış açısı, sahneyi yeniden yazma)
- Part 6: Speaking & Thinking Prompts (tartışma soruları, agree/disagree)
- Part 7: Final Review Quiz (gramer, kelime, hata düzeltme) + Cevap Anahtarı

**Dokunulan sayfalar:** `wiki/sources/Les-Miserables-Ch04-Study-Guide.md` (yeni), `index.md`, `log.md`

---

## [2026-05-08] ingest | Don Quixote Ch03 — The Flock of Sheep (Extended Reader)

**Özet:** Chapter 3: The Flock of Sheep yazıldı. ~10.000 kelime, 17 bölümlük tam anlatım, A2/B1 seviyesi, TTS uyumlu. Keçi çobanlarıyla kamp sahnesi ve Altın Çağ konuşması, koyun sürüsüne şarj ve diş kaybı, Fierabras merhemi konuşması, geceleri cenaze alayına saldırı, kırık bacak ve "Kederli Yüzlü Şövalye" isminin doğuşu, iki günlük han dinlenmesi sahnelerini kapsar. index.md güncellendi.

---

## [2026-05-08] ingest | Don Quixote Ch02 — The Windmills (Extended Reader)

**Özet:** Chapter 2: The Windmills yazıldı. ~10.000 kelime, 17 bölümlük tam anlatım, A2/B1 seviyesi, TTS uyumlu. Don Quixote ve Sancho'nun birlikte ilk yolculuğu, yel değirmeni savaşı, keşiş-büyücü sahnesi, Biscayan centilmenle düello ve gece mola sahnelerini kapsar. Ek: "A Note on Windmills" kapanış bölümü. index.md güncellendi.

---

## [2026-05-08] ingest | Don Quixote Ch01 — A New Life (Extended Reader)

**Özet:** Don Quixote genişletilmiş okuma serisi başlatıldı. Chapter 1: A New Life yazıldı. ~10.000 kelime, 18 bölümlük tam anlatım, A2/B1 seviyesi, TTS uyumlu düz metin. NotebookLM'deki Don Quixote (Ormsby çevirisi) notebook'una dayanarak oluşturuldu. Alonso Quixano'nun kitap tutkusu, delirmesi, şövalye olma kararı, Rocinante ve Dulcinea del Toboso'nun seçimi, ilk yolculuk, han sahnesi, sahte şövalyelik töreni ve Sancho Panza'nın işe alınmasını kapsar. index.md güncellendi.

---

## [2026-05-08] ingest | Les Misérables Ch05 — The Inspector's Trap (Extended Reader)

**Özet:** Chapter 5 genişletilmiş versiyonu yazıldı. ~10.000 kelime, 13 bölümlük tam anlatım, A2/B1 seviyesi, TTS uyumlu düz metin.

**Eklenen dosya:** `wiki/sources/Les-Miserables-Ch05-The-Inspectors-Trap.md`

**Kapsanan sahneler:**
- Madeleine'in geceyi masa başında geçirmesi — vicdan muhasebesi
- Arras'a gece yolculuğu — atların sesi, karanlık yollar, iç çatışma
- Arras'a varış ve Adalet Sarayı'nı dışarıdan izleme
- Duruşma salonu — Champmathieu'nun yüzü ve şaşkın hali
- Üç tanık — eski mahkûmlar ve gardiyan, "O, Valjean" diyorlar
- Madeleine'in içindeki savaş — fidan ile sözü arasında
- Galeride ayağa kalkma — "Ben Jean Valjean'ım" sahnesi
- İki günlük kimlik doğrulama süreci
- Geri dönüş yolculuğu — söz tutma zorunluluğu
- Hastane odası — Fantine ile son konuşma
- Javert'in odaya girmesi — tutuklama, Fantine'in anlayışı
- Fantine'in ölümü — "Cosette" diyerek
- Javert'in geceleri masasında oturması — kategorilere sığmayan bir şey
- Kaçış ve şehirden ayrılış — fabrika, kilise, hastane önünde durma

**Dokunulan sayfalar:** `wiki/sources/Les-Miserables-Ch05-The-Inspectors-Trap.md` (yeni), `index.md`, `log.md`

---

## [2026-05-07] ingest | Les Misérables Ch04 — Fantine's Story (Extended Reader)

**Özet:** Chapter 4 genişletilmiş versiyonu yazıldı. ~10.000 kelime, 13 bölümlük tam anlatım, A2/B1 seviyesi, TTS uyumlu düz metin.

**Eklenen dosya:** `wiki/sources/Les-Miserables-Ch04-Fantine.md`

**Kapsanan sahneler:**
- Paris'teki öğrenci yılları — sekiz arkadaş, bahar pikniği, neşeli hayat
- Tholomyès ve Fantine'in aşkı — güven, tam teslimiyet
- Cosette'in doğumu — Tholomyès'in rahatsızlığı, Fantine'in inkârı
- Veda mektubu — Saint-Cloud gezisi, dört erkeğin kaçışı, yıkım
- Paris'te yapayalnız — toplumun soğukluğu, paranın tükenmesi
- Kuzeye yolculuk kararı ve Cosette'i bırakma zorunluluğu
- Thénardier hanı — iyi görünen yüzler, aldatıcı tablo
- Cosette'i bırakma — son öpücükler, arkaya bakmadan yürüyüş
- Fabrikada çalışma — mektuplar, her ay daha fazla para talebi
- Cosette'in gerçek hayatı — paçavralar, ağır işler, kalan yemekler
- Tespih ve işten çıkarılma — süpervizörün yargısı, kapıların kapanması
- Düşüş — saçlarını satması, dişlerini satması, sokak hayatı
- Hastane — Javert'in tutuklaması, Madeleine'in müdahalesi, söz

**Dokunulan sayfalar:** `wiki/sources/Les-Miserables-Ch04-Fantine.md` (yeni), `index.md`, `log.md`

---

## [2026-05-06] ingest | Les Misérables Ch03 — A New Life (Extended Reader)

**Özet:** Chapter 3 genişletilmiş versiyonu yazıldı. ~10.000 kelime, 12 bölümlük tam anlatım, A2/B1 seviyesi, TTS uyumlu düz metin.

**Eklenen dosya:** `wiki/sources/Les-Miserables-Ch03-A-New-Life.md`

**Kapsanan sahneler:**
- Petit-Gervais — yoldaki çocuk ve para sahnesi (ahlaki dönüm noktası)
- Valjean'ın kuzey yolculuğu ve karar süreci
- Montreuil-sur-Mer'e varış ve gözlem süreci
- Fabrika kurulumu ve boncuk üretimi innovasyonu
- İşçilere adil davranış ve gizli hayırseverlik
- Belediye başkanlığı — üç kez ret, kabul
- Başkanlık döneminde yapılanlar (hastane, okul, sığınak)
- Fauchelevent arabası kazası — arabanın kaldırılması
- Javert'in karakteri, geçmişi ve Montreuil'e neden geldiği
- Javert-Madeleine karşı karşıya sahnesi (Arras davası öncesi)
- Gece: Madeleine'in kararı — Arras'a doğru yola çıkış

**Dokunulan sayfalar:** `wiki/sources/Les-Miserables-Ch03-A-New-Life.md` (yeni), `index.md`, `log.md`

---

## [2026-05-06] ingest | Les Misérables — A2/B1 Graded Reader

**Özet:** Victor Hugo'nun Les Misérables romanı A2/B1 seviyesinde, tamamen İngilizce, 30 sayfalık bir graded reader olarak yeniden yazıldı ve vault'a eklendi.

**Eklenen dosya:** `wiki/sources/Les-Miserables-A2B1.md`

**İçerik:**
- 10 bölüm, ~8.200 kelime, 30 sayfa eşdeğeri
- Seviye: A2/B1 (B1'i geçmiyor) — kısa cümleler, yaygın kelimeler
- Tüm ana karakterler: Jean Valjean, Bishop Myriel, Fantine, Cosette, Javert, Marius, Thénardier, Enjolras
- Hikayenin tamamı: hapishane → piskoposun armağanı → yeni hayat → Fantine → Cosette → Paris → barikat → ölüm
- Afterword: Hugo'nun teması (yoksulluk, değişim, merhamet)
- Vocabulary help tablosu (10 kelime + tanım)
- Grammar focus bölümü (Past Simple, Past Continuous, Reported Speech, Modals, Linking Words)

**Dokunulan sayfalar:** `wiki/sources/Les-Miserables-A2B1.md` (yeni), `index.md` (güncellendi), `log.md` (bu giriş)

**Kaynak:** NotebookLM'deki "The Bishop of D——" notebook'u (Les-Miserables.pdf) — PDF çok büyük olduğu için doğrudan bilgiden yazıldı.

---

## [2026-05-01] ingest | CEFR Sistemi + Vocabulary Hub + Phrasal Verbs Hub + Word Formation

**Yapılan:**

Sisteme 4 büyük ekleme yapıldı:

### 1. `wiki/synthesis/cefr-curriculum-map.md` — YENİ
- Tüm 55+ gramer konusu CEFR A1→C2 seviyelerine atandı
- Her seviyedeki eksik konular tespit edildi (✅ var / ❌ eksik)
- Yüksek öncelikli 10 eksik konu listelendi (Word Formation, Verb Patterns, Compound Nouns, Collocations, Too/Enough, So/Such, Hedging, Nominalization, Register, Idioms)
- Öğrenme sırası önerisi eklendi

### 2. `wiki/concepts/word-formation.md` — YENİ (B2 seviyesi)
- 25+ prefix (un-, re-, pre-, dis-, over-, inter-, trans-, anti-, co-, mono- vb.)
- 25+ suffix (-tion, -ment, -ness, -ful, -less, -able, -ize, -ify, -en, -ly vb.)
- 50 Latin kökü (port, vert, dict, spec, scrib, fac, duc, mit, cap, ten vb.)
- 30 Yunanca kökü (graph, log, phone, bio, geo, chron, psych, arch, demo vb.)
- 3 kelime ailesi örneği (EDUCATE, CREATE, DEPEND — 7-8 türev her biri)
- Tahmin stratejisi + yaygın hatalar bölümü

### 3. `Artifacts/vocabulary-hub.html` + `wiki/artifacts/vocabulary-hub.md` — YENİ
- 260 seed kelime (A1:50, A2:37, B1:39, B2:30, C1:20, C2:10)
- Her kelime: EN-EN tanım + örnek cümle + eş anlam + zıt anlam + etimoloji/morfoloji
- Web Speech API ile sesletme (internet gerektirmez)
- localStorage ile öğrenildi/yıldız takibi
- CEFR seviyesi filtreleme + arama + ilerleme barları
- Sistem 3000 kelimeye kadar ölçeklenir

### 4. `Artifacts/phrasal-verbs-hub.html` + `wiki/artifacts/phrasal-verbs-hub.md` — YENİ
- 200 phrasal verb (16 base verb grubu: break/bring/call/come/cut/fall/get/give/go/hold/keep/look/make/put/run/set/take/turn/work + 20 daha)
- SEP (separable) etiketi — her PV için ayrılabilirlik bilgisi
- 3 sekme: Tablo Listesi · Chunk Cümleleri · Kullanım Rehberi
- 20 chunk seti × 3 cümle = 60 Türkçe çevirili örnek cümle
- CEFR dağılımı: A1:8 · A2:38 · B1:78 · B2:67 · C1:9
- Ses + localStorage takibi

### index.md güncellendi
- Artifacts: 18 → 20 kayıt, 25 → 27 dosya
- Vocabulary & Phrasal Verbs bölümü eklendi
- Concepts: 55 → 56 konu (Word Formation eklendi)
- Synthesis: 0 → 1 sayfa

**Dokunulan dosya sayısı:** 8 yeni dosya + 2 güncelleme = 10 dosya

---

## [2026-04-18] ingest | 7 Kapsamlı Gramer Concept Sayfası — Prepositions, Conjunctions, Linking, Passive Forms

**Yapılan:**
Daha önce stub olarak oluşturulmuş 7 concept sayfasının yerini alan, tam kapsamlı wiki sayfaları yazıldı:

- `wiki/concepts/prepositions-time.md` — IN/ON/AT/FOR/SINCE/DURING/BY/UNTIL/TILL/FROM-TO/WITHIN/AFTER/BEFORE/AGO/sıfır edat; at the end vs in the end, on time vs in time, by vs until edge cases; 18 örnek
- `wiki/concepts/prepositions-place.md` — Statik (in/on/at/above/over/between/among/beside/near/opposite) + Hareket (to/into/onto/from/out of/off/through/across/along/around/up/down/past/towards) + Ulaşım edatları + Kurum ifadeleri; arrived at vs in, BrE/AmE farkları; 18 örnek
- `wiki/concepts/prepositions-fixed.md` — Adj+Prep (~40), Verb+Prep (~40), Noun+Prep (~35) kolokasyon tabloları; at/in/on/by sabit ifade listeleri; different from/to/than, good at/for/to/with, think about/of, tired of/from edge cases; 18 örnek
- `wiki/concepts/coordinating-conjunctions.md` — FANBOYS (For/And/But/Or/Nor/Yet/So), parallelism kuralı, Oxford virgül tartışması, EITHER...OR / NEITHER...NOR, BOTH...AND, cümle başında And/But; 12 örnek
- `wiki/concepts/subordinating-conjunctions.md` — Zaman (when/while/as/before/after/since/until/as soon as/by the time/no sooner than), KRİTİK KURAL: zaman cümlelerinde will yok; Sebep (because/since/as/now that), Amaç (so that/in order to/so as not to/in case), Sonuç (so...that/such...that), Kabul (although/even though/though/whereas), Koşul, Biçim; although vs despite, while vs whereas, unless kullanım sınırı; 18 örnek
- `wiki/concepts/linking-words.md` — Ekleme/Karşıtlık/Sebep/Sonuç/Örnekleme/Vurgu/Özet/Sıra/Zaman kategorileri; COMMA SPLICE hatası, "also" konumu, "due to" + isim kuralı, "such as" vs "for example"; 18 örnek
- `wiki/concepts/passive-infinitives-gerunds.md` — Passive Infinitive (to be V3), Passive Gerund (being V3), Passive Perfect Infinitive (to have been V3), Passive Perfect Gerund (having been V3), Reporting Structures (It is said that / She is said to be), need/want/require + gerund (edilgen anlam); perception verbs in passive, be supposed to, to let; 15 örnek

**index.md güncellendi:** 7 sayfa ⭐ kapsamlı işareti ile güncellendi.

**Her sayfa içeriyor:**
- Frontmatter (title, type, tags, related, created, updated)
- Türkçe açıklamalar + yapı tabloları
- Kullanım alanları bölümü (alt kategorilerle)
- Edge cases & yaygın hatalar bölümü (4–6 hata/nüans)
- 12–18 örnek cümle
- Wikilinks (çift yönlü bağlantılar)

**Dokunulan dosya sayısı:** 7 yeni/değiştirilmiş sayfa + index.md + log.md = 9 dosya

---

## [2026-04-18] ingest | 7 Kapsamlı Gramer Concept Sayfası (Sıfat/Zarf/Karşılaştırma/Niceleyici Seti)

**Yapılan:**
7 yeni kapsamlı wiki sayfası oluşturuldu — Adjectives, Adverbs, Comparison, Order of Adjectives, Quantifiers, Determiners, Ellipsis and Substitution:

- `wiki/concepts/quantifiers.md` — Countable/uncountable/both ayrımı, a few vs few kritik çifti, some vs any kuralları, each vs every, a number of vs the number of, fewer vs less, predeterminer all/both/half, 20 örnek
- `wiki/concepts/determiners.md` — 7 determiner türü, predeterminer/central/postdeterminer pozisyonları, tek central kural, each vs every, all vs whole, another vs other vs else, such/what yapısı, 20 örnek
- `wiki/concepts/adjectives.md` — Attributive vs predicative (only-attributive/only-predicative listeler), compound adjectives, gradable vs non-gradable, tam comparative/superlative çekimi, double comparative, AS...AS, modifying comparatives, adjectives as nouns, elder/further/worth edge cases, 20 örnek
- `wiki/concepts/adverbs.md` — Formation + -ly anlam değişikliği çiftleri (hard/hardly vb.), 6 zarf türü, frekans zarfı konumu, enough/too/quite/rather, only/even/still/yet/already edge cases, sentence adverbs, good vs well, 22 örnek
- `wiki/concepts/comparison.md` — as...as/twice as, comparative+than, the+comparative paralel artış, double comparative, superlative+PP kalıbı, karşılaştırıcı güçlendirme, fewer/less, like vs as, superior/prefer/different/compared to edge cases, 20 örnek
- `wiki/concepts/order-of-adjectives.md` — DOSASCOMP 8 kategori tablosu, koordinatlı vs koordinatsız, postpositive, compound colors, sabit deyimler, belirsizlik, 20 örnek
- `wiki/concepts/ellipsis-substitution.md` — 4 ellipsis türü (subject/VP/comparative/to-sub), one/do so/so/not substitution, anaphoric vs cataphoric, gapping, so/neither inversion, edge cases (one≠uncountable, to kalır, I hope not), 22 örnek

**index.md güncellendi:** 7 sayfa ⭐ kapsamlı işareti ile güncellendi.

**Her sayfa içeriyor:**
- Frontmatter (title, type, tags, related, created, updated)
- Türkçe açıklamalar + yapı tabloları
- Kullanım alanları bölümü (alt kategorilerle)
- Edge cases & yaygın hatalar bölümü (4–6 hata/nüans)
- 20–22 örnek cümle
- Wikilinks (çift yönlü bağlantılar)

**Dokunulan dosya sayısı:** 7 yeni sayfa + index.md + log.md = 9 dosya

---

## [2026-04-18] ingest | 7 Kapsamlı Gramer Concept Sayfası

**Yapılan:**
7 yeni kapsamlı (comprehensive) wiki sayfası oluşturuldu — mevcut kısa stub sayfaların yerini alacak veya onları destekleyecek detaylı içerikle:

- `wiki/concepts/subjunctive.md` — Present & Past Subjunctive, BrE/AmE farkı, inverted conditionals, sabit deyimler, 14 örnek
- `wiki/concepts/indirect-questions.md` — Dolaylı sorular, word order, if/whether, tense backshift, embedded questions, 14 örnek
- `wiki/concepts/negation.md` — Negatif kelimeler, double negatives, not/any/no denkliği, negatif önekler, partial negation, 14 örnek
- `wiki/concepts/emphasis.md` — do/does/did, fronting + inversion, intensifiers, gradable/non-gradable adjectives, emphatic pronouns, 14 örnek
- `wiki/concepts/be-used-to-get-used-to.md` — 3 farklı "used to" yapısının tam karşılaştırması, tense tabloları, 14 örnek
- `wiki/concepts/pronouns.md` — Personal/possessive/reflexive/demonstrative/indefinite pronouns, it's special uses, singular they, 15 örnek
- `wiki/concepts/possessives.md` — Saxon genitive, of-possessive, time genitive, double possessive, group genitive, 14 örnek

**index.md güncellendi:** İlgili 7 sayfa "⭐ kapsamlı" işareti ile güncellendi.

**Her sayfa içeriyor:**
- Frontmatter (title, type, tags, related, created, updated)
- Türkçe açıklamalar + yapı tabloları
- Kullanım alanları bölümü
- Edge cases & yaygın hatalar bölümü (en az 4-5 hata)
- 14-15 örnek cümle (İngilizce + Türkçe not)
- Wikilinks (ilişkili konulara çift yönlü bağlantı)

**Dokunulan dosya sayısı:** 7 yeni sayfa + index.md + log.md = 9 dosya

---

## [2026-04-16] ingest | İngilizce Gramer — 55 Konu Kapsamlı İngest

**Yapılan:**
- `erkek-manikur.html` ve `python-dersi.html` kapsam dışı dosyalar silindi
- `wiki/concepts/` dizini oluşturuldu
- 55 İngilizce gramer konusu wiki sayfası olarak oluşturuldu:
  - Tenses (13): Present Simple/Continuous/Perfect/Perfect Continuous, Past Simple/Continuous/Perfect/Perfect Continuous, Future Will/Going To/Continuous/Perfect/Perfect Continuous
  - Core Verb Structures (7): Passive Voice, Causative, Reported Speech, Conditionals, Mixed Conditionals, Wish/If Only, Subjunctive
  - Clauses (7): Relative Clauses, Gerunds & Infinitives, Participle Clauses, Noun Clauses, Adverbial Clauses, Cleft Sentences, Inversion
  - Modals & Key Structures (5): Modal Verbs, Phrasal Verbs, Used To/Would, Be/Get Used To, Emphasis
  - Questions & Negation (4): Question Formation, Question Tags, Indirect Questions, Negation
  - Nouns & Pronouns (6): Countable/Uncountable, Plural Nouns, Pronouns, Possessives, Quantifiers, Articles
  - Adjectives & Adverbs (4): Adjectives, Order of Adjectives, Adverbs, Comparison
  - Determiners (1): Determiners
  - Prepositions (3): Time, Place, Fixed
  - Conjunctions & Linking (3): Coordinating, Subordinating, Linking Words
  - Other (2): Ellipsis & Substitution, Passive Infinitives & Gerunds
- `index.md` güncellendi (55 concept sayfası eklendi)
- `Artifacts/_dashboard.html` güncellendi (kapsam dışı dosyalar kaldırıldı)
- Her sayfa: frontmatter, Türkçe açıklamalar, yapı tabloları, kullanım alanları, edge cases, 10-15 örnek cümle, wikilinks içeriyor

**Dokunulan sayfa sayısı:** 55 concept sayfası + index.md + log.md = 57 dosya

---

## [2026-04-16] init | Wiki kurulumu

**Yapılan:**
- `CLAUDE.md` oluşturuldu (işletim el kitabı, 12 bölüm)
- `index.md` oluşturuldu (içerik dizini)
- `wiki/artifacts/` dizini oluşturuldu
- 18 artifact wiki sayfası oluşturuldu (27 HTML dosyasını kapsar):
  - `english-mastery-hub.md` (4 dosya)
  - `english-learning-framework.md`
  - `lingualab.md` (2 dosya)
  - `english-grammar-diagram.md`
  - `grammar-roadmap.md`
  - `grammar-explorer.md`
  - `grammarforge.md`
  - `tense-aspect-map.md`
  - `future-tenses.md`
  - `past-tenses.md` (2 dosya)
  - `passive-voice.md`
  - `report-grammar.md`
  - `supposed-to.md`
  - `living-room-vocabulary.md`
  - `grammarpath.md`
  - `lingoforge.md`
  - `yazakademik.md`
  - `english-rehber.md` (3 dosya)
- `Artifacts/_dashboard.html` oluşturuldu (güzel HTML arayüzü)
- `log.md` oluşturuldu (bu dosya)

**Tespit edilen kapsam dışı dosyalar:**
- `erkek-manikur.html` — manikür hizmeti (kullanıcı kararı bekliyor)
- `python-dersi.html` — Python eğitimi (kullanıcı kararı bekliyor)

**Bekleyen concept sayfaları (artifact'lardan tespit):**
- Modal Verbs, Present Perfect, Will vs Going To, Causative, Conditionals, Relative Clauses

**Dokunulan sayfa sayısı:** 22 dosya oluşturuldu

## [2026-05-16] practice L4 | Passive Voice Gap-Fill (10-Q)
Özet: İlk drill dosyası oluşturuldu — `wiki/practice/drills/2026-05-16_passive-voice-fundamentals.md`. 10 soru: past simple, present continuous, present perfect, future will, modal, passive infinitive, passive gerund, reporting structure (is said + perfect infinitive), born, intransitive tuzağı (happen). Cevap anahtarı `<details>` collapse içinde, her cevapta 1 satır kural notu. Geri linkler: [[Passive Voice Concept]] ve [[Passive Infinitives and Gerunds]]. Güncellenen: `wiki/practice/_index.md` (L4 sayacı 1 oldu), `index.md` (Practice → Drills listesi eklendi), `wiki/concepts/passive-voice-concept.md` (Pratik bölümü eklendi).

---

## [2026-05-18] ingest | Daily Writing Loop — Tek HTML Üretim Döngüsü

**Eklenen dosyalar:**
- `Artifacts/daily-writing-loop.html` (~50 KB) — kullanıcının kod öğrenme metodundan ("basit pilot uygulamalar") esinlenmiş günlük yazma drill aracı
- `wiki/artifacts/daily-writing-loop.md` — artifact wiki kaydı

**Akış:** Setup → 16 hazır tema veya Custom mod (yan yana TR/EN paste) → TR referans (aktif cümle vurgulu) → Box A: rehberli yazma (mirror div real-time diff, yanlış harfler kırmızı, offset bozulunca sonrası da kırmızı; "Show sentence with placeholder" butonu sadece içinde bulunulan cümleyi placeholder olarak gösterir) → Box B: hafızadan yazma (hibrit TR preview: otomatik ilerler, ← → ile manuel override) → Check (word-level LCS diff, cümle cümle skor + eksik/fazla kelimeler + PV kullanım) → Save & Complete (streak +1 eğer skor ≥%70).

**16 hazır tema:** picnic, morning, cinema, first-day, childhood, shopping, mom-call, rainy-day, new-recipe, weekend-plans, gym, lost-keys, favorite-book, bad-day, dream-trip, new-language (A1-B1, her biri 4-5 cümle + 5 hedef PV).

**5 görsel tema:** Navy (default) · Forest · Sunset · Paper (krem, odak) · Midnight (siyah/sarı, yüksek kontrast).

**Phrasal Verb sistemi:** Tema-bağlantılı tracking (Box A ve B'de ayrı regex kontrolü, separable destek "pick X up" max 4 token arada) + 30 PV'lik bağımsız havuzdan günlük rotasyon (date hash) drill. Min 6 kelime + regex kontrolü.

**Kullanıcı UX kararları:** Diff davranışı = "kabul + kırmızı vurgu" (typing tutor reddet DEĞİL); TR preview = hibrit (otomatik + manuel override); Custom mod = yan yana TR/EN textarea (her satır bir cümle); Gamification = minimal (sadece streak + bugün ✓, XP/level YOK); 16+ tema seçildi (8 değil).

**Güncellenenler:**
- `index.md` — Writing bölümüne 1 satır + Artifacts sayacı 21→22, 28→29 dosya
- `Artifacts/_dashboard.html` — Writing kategorisine yeni kart (en üstte ⭐ YENİ); sayaç 2→3

**Vault entegrasyonu:** [[Practice/Grammer Topics/_index|Practice Hub]] L1 Production Cell'in interaktif aracı. [[writing-atelier-001-bloomsday]] (5-sekme atölye, geniş) ile sınıflama uyumu kısmi; sapma: bu drill aracı dar/disiplinli/her gün açılır. TTS ve XP/achievement bilinçli olarak çıkarıldı (saf yazma odağı).

**Edge case'ler:** 20+ senaryo uygulandı — paste/whitespace normalize, smart quote apostrof, fazla/eksik cümle Δ, tema değişiminde confirm modal, localStorage corrupt fallback, mobile responsive, print stylesheet, pazar portfolio reminder, 16 tema tamamlanma achievement, 2+ gün streak gap toast.

**Tetik:** Kullanıcı "bana bir uygulama yazmanı istiyorum" mesajıyla, kod öğrenirken "basit pilot uygulamalar ile öğrendiği kuralları kullanarak öğrendiği" metodu İngilizce yazıma uyarlamak istedi. Asıl saik: süreklilik (devamlılık) sağlamak.

## [2026-05-20] query | Artifact'lardan çalışma yöntemleri kataloğu çıkarma

Kullanıcı talebi: "Artifact'lara bakarak micro software'lerin içeriklerinden çalışma yöntemlerimin listesini çıkar, mantığını açıkla, en işe yarayanı belirt, yeni öneriler de getir."

**Yapılan:** `wiki/synthesis/calisma-yontemleri-analizi.md` oluşturuldu. İçerik:
- 10 format kataloğu (M1 Interactive Reader → M10 Vocabulary Hub)
- 9 ortak mimari prensip (tek HTML, localStorage, klavye, TTS, renk kodu, edge case, JSON bridge, CEFR, no praise inflation)
- Çeşitlilik haritası (hangi ihtiyaç → hangi format)
- En iyi format seçimi: M2 Daily Engine (sabah) + M4 Daily Writing Loop (akşam) önerisi
- 7 yeni format önerisi: Listening Ladder, Translation Pendulum, Confusable Drill, Voice Journal, Collocation Heatmap, Comparative Reader, Generative Prompt Bank
- 8 soruluk tekrar edilebilirlik checklist'i

**Dokunulan sayfalar:** index.md (Synthesis bölümüne eklendi), log.md.

## [2026-05-20] artifact | 3 yeni pilot: Confusable Drill + Collocation Heatmap + Comparative Reader

[[calisma-yontemleri-analizi]]'ndeki Ö3 (Confusable Drill), Ö5 (Collocation Heatmap) ve Ö6 (Comparative Reader) önerileri **9 standart prensibe** uygun şekilde tek-dosya HTML olarak uygulandı.

**Confusable Drill** (`Artifacts/confusable-drill.html`, ~480 satır):
- 20 minimal pair seed (say/tell, much/many, fewer/less, since/for, used to/be used to, lay/lie, rise/raise vb.)
- 8 sn timer; timeout = hata
- localStorage + JSON export → `confusable_drill_session`
- Hata frekansı → [[errors/confusables]] hedefli

**Collocation Heatmap** (`Artifacts/collocation-heatmap.html`, ~520 satır):
- 3 matris: Verb+Noun (make/do/take...), Adj+Noun (heavy/strong...), Adv+Adj (highly/deeply...)
- Strength gradient (none/weak/mid/strong) görsel heatmap
- Hücre tıklama → EN+TR örnek + CEFR
- Drill sekmesi: 10 boşluk doldurma
- JSON: `collocation_session` (cell_views + drill_reviews)

**Comparative Reader** (`Artifacts/comparative-reader.html`, ~450 satır):
- Çift panel; sol orijinal (B2/C1), sağ A2 uyarlama
- Paralel segment id eşleşmesi; tıkla → her iki panelde vurgula
- Sync scroll (toggle); 4 tag grubu (g1-g4) renkli
- Seed metinler: Naval — Specific Knowledge (C1↔B1), Paul Graham — Life Is Short (B2↔A2)
- JSON: `comparative_reader_session`

**Wiki kayıtları:** `wiki/artifacts/confusable-drill.md`, `collocation-heatmap.md`, `comparative-reader.md` — her biri 9-prensip uyum tablosu, JSON şeması, genişletme yol haritası içerir.

**Dokunulan sayfalar:** index.md (Practice & Tracking + Writing bölümlerine 3 satır), log.md.

**Sonraki:** Confusable pair seed'i 100+'a çıkar; Collocation matrisine business/travel temaları ekle; Comparative Reader için Compressed Galaxy bölümlerini otomatik üret (Claude Code prompt-driven).

## [2026-05-20] artifact | Grammar-First Lesson 02 — Mert's Sunday on the South Bank

Lesson 01'in (havaalanı + Borough Market) doğrudan devamı: ertesi pazar günü, anne-oğul South Bank yürüyüşü, otobüs kaçırma, Tate Modern, tarçınlı kafe, Camden planı. ~500 kelime, akıcı anlatı.

**8 yeni gramer yapısı (Lesson 01 ile çakışma yok):** Past Continuous, Present Perfect Continuous, Relative Clauses, Gerunds & Infinitives, Used to / Would, Quantifiers, First Conditional, Reported Speech.

**Mimari farklar (Lesson 01'e göre):**
- Default sekme = **Grammar** (kart grid + list toggle, CEFR filter, search, prev/next ders şeritleri)
- Story'de **Sade Okuma** modu (vurgular kalkar, Georgia serif, koyu sarımtırak kâğıt) — çalışırken metni klasik gibi okumak için
- Quiz: 4 sekme — Per-Topic (5-Q × 8 bağımsız) + General Mix (16-Q can/combo) + **Story-Grammar Combo** (hikâye bağlamında 10-Q, matching dahil) + Comprehension (8-Q)
- JSON Export `lesson-progress-1.0` şeması: `summary`, `topics`, `weak_topics`, `mistakes`, `bank`, `reflect_text`, `next_lesson_hint.inject_review`, `instructions_for_claude_code` — `00_INBOX/` köprü tasarımı

**Dosyalar:**
- `Artifacts/lessons/grammar-first-lesson-02.html` (single-file, ~1500 lines)
- `wiki/artifacts/grammar-first-lesson-02.md` (wiki kaydı)
- `index.md` (Daily Engine bölümüne satır eklendi)

**Sonraki ders (Lesson 03 — Camden + Regent's Park) için planlanmış 8 yapı:** Second Conditional, Wish/If only, Passive Voice, Causative, Future Forms (will vs going to), Adverbs of Frequency, Order of Adjectives, Linking Words.

**Spec uyum:** `untitled-micro-app-spec.json`'daki 49 seçili özelliğin tamamı veya muadili implemente edildi. Print-friendly `user_note: "sadece metin için"` notuna uyuldu — yazdırma yalnızca Story sekmesini sade biçimde çıkarır.

## [2026-06-10] infrastructure | Panorama v2 — Komuta Merkezi + Bilişsel Gelişim Katmanı

Vault'taki zihin yapısı dokümanları (İRFAN halka modeli, _Tasnif Çalışması 04/08/12/15) ile personal-os arasındaki boşluk analizi yapıldı; panorama dashboard'u Komuta Merkezi olarak yeniden inşa edildi.

**Bulgular:** Panorama statikti (10 sorgu tek Promise.all); bilişsel gelişim hiçbir göstergeye bağlı değildi; yüzey kuyruğu 294 kartla ölü durumdaydı; halka modeli kodda yoktu; Komuta Merkezi sadece redirect'ti.

**Yapılanlar (personal-os repo):**
- Panorama → ayarlardan aç/kapat + sırala edilebilen 10 widget; her widget ayrı Suspense ile bağımsız akıyor, kapalı widget'ın verisi hiç çekilmiyor (KR-014)
- Bilişsel katman: haftalık kavrayış eğrisi + FSRS bellek sağlamlığı + halka hunisi (`queries-cognitive.ts`, KR-015)
- `items.halka_stage` 0-7 (İRFAN §3) + `advanceHalka` action + events tarihçesi (KR-016, migration 0004 — lokale uygulandı, Turso bekliyor)
- Yüzey triyajı: 30+ gün gecikmiş orta/düşük öncelikli kartlar tek tıkla arşiv (KR-017)
- Döngü widget'ı: Oku→Düşün→Üret→Denetle dört ipi, en zayıf ip nudge'ı
- Ufuklar widget'ı: 10yıl→tema→çeyrek→ay zinciri, ayarlardan düzenlenir
- /komuta → /panorama redirect; ayarlara Panorama Widget'ları + Ufuklar bölümleri

**Dokunulan sayfalar:** wiki/synthesis/personal-os-design-decisions.md (§8 KR-014..017), log.md.

**Sonraki:** Turso'ya 0004 migration; session duration heartbeat; faculty_rollups → bülten pipeline; halka geçmişinden derinleşme hızı metriği.

## [2026-06-10] infrastructure | Mabet + Sade Modül Dashboard'ları + Kuantum Domain'i

"Çalışma mabedi" vizyonu: Obsidian vault = metin veritabanı, personal-os = tatbik ve takip katmanı. Üç yeni parça eklendi.

**1. Kuantum modülü:** Quantum vault'u (38 not, 6 bölüm: Temeller/Algoritmalar/Programlama/Donanım/Ekosistem/Fırsatlar) quantum domain'i olarak seed edildi — 23 item + obsidian_refs (her item vault notuna bağlı). Qubit/Süperpozisyon/Dolanıklık aktif başlangıç. `scripts/seed-quantum.ts` (idempotent, Turso için yeniden çalıştırılabilir).

**2. /d/[slug] — sade modül dashboard'u (jenerik):** Her domain için tek tip, tek ekran: 4 sayı (7g seans, 30g doğruluk, mastery, halka) + bölüm dağılımı + çalışma kuyruğu (halka ilerletme + "vault ↗" obsidian:// linki) + son üretimler. Yeni domain seed edilince kod değişmeden çalışır.

**3. /mabet — ortak sonuç dashboard'u:** Üst şerit (seri, bugün, 7g süre, döngü 4-nokta) + modül tablosu (mastery bar, doğruluk, halka, üretim, son aktivite; soğuyan modül kırmızı). Panorama=komuta (canlı akış), Mabet=muhasebe (sonuç) ayrımı.

**Ayarlar:** quantum + mabet modül listesine eklendi, kullanıcının görünür modüllerine işlendi. Panorama alan kartlarına Kuantum girdi.

**Sonraki:** Turso'ya seed-quantum + 0004; kuantum sorular/quiz içeriği (KR-006 deseniyle); diğer vault'lar (Yazarlık alt bölümleri) için kategori seed'i.

## [2026-09-02] synthesis | Pollakhōs Atlası — form-önce örüntü katmanı

Vault'a yeni bir **okuma ekseni** eklendi. Şimdiye kadar bütün içerik konu-önce (topic-first) düzenliydi: Present Perfect, Passive Voice, Causative… Bu düzen öğretmek için iyi, **tanımak** için kötü — çünkü öğrenci metinde konu görmez, form görür.

**İlke (Aristoteles, Metafizik Γ.2 — τὸ ὂν λέγεται πολλαχῶς):** Bir form çok şekilde söylenir. V3 tek bir "geçmiş zaman" değil, 10 ayrı iş yapar; have 9, -ing 9, -s 5.

**İki eksen:** Dikey = bir form kaç iş yapar. Yatay = bir işi kaç form yapar. Kalıcılık kesişimden doğar.

**Merkezî bulgu — Uzaklık Yasası:** Geçmiş biçim (V2/would/could) "geçmiş zaman" değil "buradan uzak" demektir; uzaklık zamanda, gerçeklikte veya nezakette olur. Bu tek yasa şu beş ayrı konuyu birleştirir: Past Simple + Second Conditional + Wish/If only + Reported Speech backshift + Polite Requests.

**Kapsam:** 11 omurga · 82 ayrı işlev (her biri kalıp + EN örnek + TR karşılık + hata notu) · 13 işlev alanı · 50 dolu kesişim.

**Artifact — 5 mod:** Dikey omurga (Ramist bracket diyagramı + yatay bağ linkleri) · Yatay alan · 11×13 kesişim matrisi · Uzaklık Yasası (5 adımlı interaktif ölçek) · Av (10 soruluk tanıma oyunu, skor/seri/en iyi, kaçırılanlar listesi). Tek dosya HTML, kütüphanesiz; dikey/yatay/matris/quiz **aynı veri kaynağından** üretiliyor, bu yüzden çelişemezler.

**Dokunulan sayfalar (5):**
- `Artifacts/pollakhos-atlas.html` (yeni)
- `wiki/synthesis/form-first-pattern-atlas.md` (yeni — ilke sayfası)
- `wiki/artifacts/pollakhos-atlas.md` (yeni — artifact kaydı)
- `index.md` (yeni "Form-First Katmanı" bölümü + Synthesis 5→6)
- `log.md`

**Sonraki:** Av modunun kaçırdığı dalları `00_INBOX/` JSON köprüsüyle Error Constellation'a bağlamak. İkinci parti omurga adayları: MAKE · THERE · -ED · ONE · SO · EVER. Ayrıca `Artifacts/_dashboard.html` kartı eklenecek.
