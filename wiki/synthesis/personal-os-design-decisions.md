---
title: Personal OS — Design Decisions (Phase 1)
type: synthesis
tags: [personal-os, architecture, decisions, infrastructure]
related: [[english-learning-engine-v1]], [[implementation-notes]], [[_index]]
created: 2026-05-22
updated: 2026-06-10
---

# Personal OS — Design Decisions (Phase 1)

Vault dışında **ayrı bir Next.js + SQLite uygulaması** olarak kurulan kişisel entelektüel işletim sistemi. Daily Engine v1'in yerine geçecek, multi-domain (English + Philosophy + ... ) destekli.

**Konum:** `~/Projects/personal-os/` (vault'tan tamamen ayrı, sebebi: node_modules ve `.next/` build dir'i iCloud'a girerse sync kâbusu olur).

**İlk açılış:** 2026-05-22

---

## 1. Mimari Çerçeve

```
┌─────────────────────────────────────┐
│   ÜST DASHBOARD (Life Layer)        │
│   /                                 │
│   • Domains: English, Philosophy,   │
│     Reading, Films, Writing, ...    │
└────────────────┬────────────────────┘
                 │
        ┌────────┴────────┐
        ▼                 ▼
   /english          /philosophy
   (56 grammar)      (skeleton)
        │
        ▼
   /english/review
   (FSRS scheduler, Faz 2'de aktif soru havuzu)
```

**Katmanlar:**
- **Frontend:** Next.js 16 App Router + React 19 + Tailwind 4
- **DB:** lokal SQLite (libSQL) `~/Projects/personal-os/data/local.db` — Faz 1 boyunca lokal, Faz 2'de Turso cloud'a göç
- **ORM:** Drizzle (type-safe, migration disiplinli)
- **SRS:** ts-fsrs (FSRS algoritması, SM-2'den ~30% daha verimli)
- **Auth:** Vercel Protection (built-in password) — Faz 2 deploy'unda aktif
- **Backup:** Faz 2'de günlük JSON export → GitHub push
- **Obsidian sync:** Faz 3'te `wiki/_db_snapshot/state.json` günlük dump

---

## 2. Karar Kayıtları

### KR-001 · Mevcut Daily Engine v1 emekli
**Karar:** Migrate + emekli et. `Artifacts/_engine/topics.json` ve `wiki/tracking/grammar-coverage.md`'deki veriler yeni DB'ye taşındı. Eski HTML motorları kalır ama yeni iş yapılmaz, read-only arşive geçer (Faz 2 sonu).

**Why:** İki paralel sistem bakım yükü → unutulan biri ölür, drift birikir.

### KR-002 · Lokal SQLite önce, Turso sonra
**Karar:** Faz 1'de DB lokal file (`file:./data/local.db`). Faz 2'de aynı driver (`@libsql/client`), `DATABASE_URL` Turso URL'ine geçirilir.

**Why:** Turso account ve token kurulumu kullanıcı müdahalesi gerektirir; lokal başlangıç implementation'ı blok etmiyor.

### KR-003 · Generic `items` tablosu
**Karar:** Grammar topic, vocab, book, film, philosopher, concept, project — hepsi `items` tablosunda. `type` ile ayrılır.

**Why:** Yeni domain eklemek için schema değişmez. Cross-domain link (Crime and Punishment → Dostoyevski → Rus edebiyatı) tek `links` tablosunda yaşar.

### KR-004 · Claude'a sınırlı erişim
**Karar:** Claude (yani ben) DB'ye sadece **aggregate + metadata** seviyesinde erişir. Ham içerik (günlük, film notları) Claude'un context'ine girmez.

**Why:** Kişisel günlüğün her açılışta context'e girmesi mahremiyet açısından kötü, ayrıca token israfı.

**Nasıl uygulanır:** Faz 3'te `wiki/_db_snapshot/state.json` Obsidian'a günde 1 kez yazılır — Claude bunu okur. Endpoint API olmaz (canlı erişim yok).

### KR-005 · Vault dışı proje
**Karar:** `~/Projects/personal-os/` (vault dışı, ayrı git repo).

**Why:** Vault iCloud sync altında, `node_modules` (~10k dosya) iCloud'a girerse her dosya değişikliği sync tetikler — pratik olarak kullanılmaz.

### KR-006 · Soru havuzu mantığı (Faz 2 kararı)
**Karar:** Sabit 5 soru/konu değil, **15-20 soru havuzu + slot rotation**. Sistem her günkü 5 soruyu zayıflara ağırlık vererek seçer.

**Why:** Sabit 5 soru 3-4 günde ezberlenir, mastery yanılsaması oluşur. Havuz ile aynı konunun farklı yüzleri (formula / edge case / transformation / context) görülür.

### KR-007 · Streak cutoff
**Karar:** Local TZ + 04:00 cutoff. Gece 02:00'da yapılan çalışma "önceki gün" sayılır.

**Why:** "Gece tipi" çalışma haftalarında streak haksız kırılmasın.

### KR-008 · Mastery tanımı
**Karar (taslak):** FSRS retention > 0.9 + son 5 attempt'ten 4'ü doğru + interval ≥ 30 gün. Item status = `mastered`.

**Why:** Yoksa "ne zaman bittim?" sorusu sonsuz açık kalır, motivasyon zayıflar.

---

## 3. Adreslenen Edge Case'ler

| # | Edge case | Çözüm | Faz |
|---|-----------|-------|-----|
| 1 | Soru ezberleme tuzağı | 15-20'lik havuz + rotation | F2 |
| 2 | Vocab-grammar farklı kadanslar | Aynı SM-2 ama target retention farklı (G:0.85, V:0.90) | F2 |
| 3 | Multi-domain burnout | Günlük "kapasite kotası" UI'da görünür | F2 |
| 4 | Cold start (ilk 3 hafta boş grafik) | Onboarding state'i + "baseline kuruluyor" mesajı | F1 ✓ |
| 5 | Obsidian → DB drift | MD frontmatter'a UUID, DB ona bağlanır | F3 |
| 6 | iCloud + git çarpışması | Vault dışı proje | F1 ✓ |
| 7 | Backup test edilmedi = backup yok | İlk haftada restore drill | F2 |
| 8 | Vercel halka açık URL | Vercel Protection (built-in password) | F2 |
| 9 | Claude DB tam erişimi gizlilik riski | Sadece aggregate + JSON snapshot | F3 |
| 10 | Mastery tanımı belirsiz | KR-008 ile tanımlandı | F2 |
| 11 | Re-engagement | "Hoş geldin, son 14 gündür..." nudge | F4 |
| 12 | Tek kullanıcı yanılsaması | Schema'da user_id placeholder | F3 |
| 13 | Soru kalitesi denetimi | Her soruda "sil/iyileştir" butonu | F2 |
| 14 | Streak cutoff belirsizliği | KR-007 ile tanımlandı | F1 ✓ |
| 15 | Context sentence pool | Sources'dan ekstraksiyon | F2 |

---

## 4. Faz Planı

**Faz 1 — MVP (✅ 2026-05-22 tamam):**
- Next.js iskeleti + Drizzle + libSQL
- 8 tablo schema + ilk migration
- 56 topic + 16 mevcut session/review state migrate
- `/`, `/english`, `/english/review` minimal sayfalar
- Vault'a sync yok, lokal çalışıyor

**Faz 2 — Question pool + FSRS aktif (önümüzdeki 1-2 hafta):**
- Soru CRUD UI + her topic için 5 soru başlangıç
- FSRS scheduler entegrasyonu (attempt → quality → next review)
- Review flow (fill-blank, true-false, multiple-choice)
- Turso'ya geçiş + Vercel deploy + Vercel Protection
- Backup: günlük JSON → GitHub push

**Faz 3 — Vault entegrasyon + Multi-domain:**
- Obsidian → DB tek yönlü sync
- `wiki/_db_snapshot/state.json` günlük dump (Claude okur)
- Philosophy domain'i etkin (filozof + kavram + eser)
- Reading, Films, Writing domain'leri eklenir
- Cross-domain link UI

**Faz 4 — Sürekli iyileştirme:**
- LLM-assisted question generation
- Year-in-review otomatik raporlar
- Re-engagement nudge sistemi
- Context sentence pool (sources'dan ekstraksiyon)

---

## 5. DB Schema Özet

```
domains          (id, slug, name, icon, color, weight)
items            (id, domain_id, type, slug, title, status, cefr,
                  category, metadata_json, body_md_path)
sessions         (id, domain_id, item_id, kind, started_at, ended_at,
                  duration_sec, score, notes, metadata)
questions        (id, item_id, kind, prompt, answer, distractors,
                  context_sentence, source_ref, difficulty, active)
attempts         (id, question_id, session_id, user_answer, correct,
                  response_ms, quality)
reviews          (id, item_id, scheduled_at, last_reviewed_at,
                  stability, difficulty, reps, lapses, state, fsrs_raw)
links            (id, from_item_id, to_item_id, relation, weight)
events           (id, domain_id, item_id, kind, payload, at)
obsidian_refs    (id, item_id, vault_path, frontmatter_id, last_synced_at)
```

**Anahtar tasarım:**
- `reviews` tek tablo hem grammar hem vocab için (item.type ile ayrılır)
- `events` ham timeline — heatmap & year-in-review için
- `obsidian_refs` Faz 3'te aktif (şimdilik boş tablo)

---

## 6. Açık Sorular (Faz 2 öncesi karara bağlanacak)

- [ ] Faz 2'de Turso DB ismi: `personal-os` mu, `pos-prod` mu?
- [ ] İlk 56 × 5 soru seed'i: manuel mi (kullanıcı yazsın), yoksa LLM-generated + onay mı?
- [ ] Streak veri modeli: `events` üzerinden hesaplanan view mi, ayrı `streak` tablo mu?
- [ ] Philosophy domain detayı: filozof–kavram–eser üçgeni; ilk seed neyi içersin?
- [ ] Obsidian sync yönü: tek yön (DB→MD) mi, hybrid mi (MD frontmatter'dan DB'ye sync de var)?

---

## 7. Denetim ve Yeniden Yapılandırma (2026-06-10)

> Tetik: "Sürekliliği sağlayamadım" — 18 günde yalnızca 6 program günü tamamlandı,
> son attempt'ler 0 doğru ile bitti (5 ve 8 Haziran), sonra kullanım durdu.

**Not:** Proje konumu `~/Documents/projects/personal-os/` (bu dökümandaki eski `~/Projects/` yolu geçersiz). Vercel: `personal-os-two-alpha.vercel.app`.

### 7a. Denetim Bulguları

| # | Bulgu | Kanıt | Durum |
|---|-------|-------|-------|
| 1 | **Gün çok ağır** — 5 aşamanın (ders, quiz, okuma, oyun, üretim) 4'ü placeholder; gün kilidi hepsini istiyor | 18 günde 6 tamamlama | ✅ Çekirdek Gün (KR-009) |
| 2 | **Serbest cevap = exact match** — transform/translate (281 soru) tek referans cevaba karşı notlanıyor; geçerli üretimler "yanlış" sayılıyor | Son oturumlar 0/2 doğru → bırakma anı | ✅ Self-grade (KR-010) |
| 3 | **Sözlük TR'siz** — 843 kelimenin 710'unda `definition_tr` yok; flashcard'lar EN-only açılıyordu | DB taraması | ✅ 710/710 dolduruldu |
| 4 | **Çeldirici kalitesi** — 748 vocab MCQ'da çeldiriciler rastgele: POS uyuşmazlığı yüzünden soru anlamı bilmeden eleme ile çözülüyordu | Örnek: adverb boşluğuna "swayed/reality/prime" | ✅ POS-eşleşmeli yeniden üretildi (KR-011) |
| 5 | **Cevap sızıntısı** — 15 MCQ prompt'unda cevap kelimesi açıkça geçiyordu | SQL denetimi | ✅ 15 prompt yeniden yazıldı |
| 6 | **Yeni kelime seli** — due az olduğunda kuyruk sınırsız yeni kelimeyle doluyordu; sırasız aktivasyon | `getVocabStudyQueue` | ✅ Günlük 8 tavan + sıralama (KR-012) |
| 7 | Takvim-bazlı `computePosition` ölü kod olarak kafa karıştırıyordu (ilerleyiş zaten tamamlama-bazlı) | `program.ts` | ✅ Deprecated işaretlendi |
| 8 | Kelime başına tek soru (720 kelime) — KR-006'nın gramer için çözdüğü ezber tuzağı vocab'da duruyor | DB taraması | ⬜ Faz 2 backlog |
| 9 | Kaynak cümlelerde noktalama kayıpları ("behaviour good habits feel bad") | ingest script artığı | ⬜ Lint turunda |

### 7b. Yeni Karar Kayıtları

**KR-009 · Çekirdek Gün** — Gün tamamlama = **ders + quiz** (~15 dk). Okuma/oyun/üretim bonus; UI ders+quiz bitince "günü kilitle" teklif eder.
*Why:* Devamlılık > kapsam. 5 zorunlu aşama all-or-nothing'di; yarım gün "hiç gün" sayılıyordu, suçluluk birikiyordu.

**KR-010 · Serbest üretim self-grade** — transform/translate sorularında cevap gönderilince model cevap gösterilir, kullanıcı "Doğru saydım / Yanlıştı" ile kendisi notlar (Anki rasyoneli). FSRS bu nota göre ilerler.
*Why:* Tek referans cevaba karşı exact-match, doğru üretimleri cezalandırıp motivasyonu kırıyordu; yanlış-negatifler FSRS state'ini de kirletiyordu.

**KR-011 · Çeldirici politikası** — Vocab MCQ çeldiricisi aynı POS havuzundan gelir; cevapla ve prompt'taki kelimelerle çakışamaz. Script: `scripts/regen-vocab-distractors.ts` (yeniden çalıştırılabilir).
*Why:* POS uyuşmazlığı soruyu gramer bulmacasına çevirir — kelime bilgisi ölçülmez.

**KR-012 · Yeni kelime tavanı** — Günde en çok 8 yeni kelime kuyruğa girer; CEFR'i belli (küratörlü) kelimeler önce. Due kartlar her zaman önceliklidir.
*Why:* Sınırsız yeni kelime "review dağı" büyütür; 133 kartlık vadesi geçmiş yığın bırakmanın ikinci ana sebebiydi.

**KR-013 · Sözlük TR zorunlu** — Yeni vocab ingest'i `definition_tr` olmadan DB'ye giremez. Mevcut açık `scripts/fill-tr-definitions.ts` + `scripts/data/tr-definitions.json` ile kapatıldı.
*Why:* TR karşılıksız flashcard B1 öğrenicide recall testi yapamaz, tanıma testine düşer.

### 7c. Yeniden Yapılandırılmış Günlük Protokol

```
ÇEKİRDEK (her gün, ~15 dk — gün bunu bitirince kilitlenir):
  1. Ders: günün 2 konusu (28-günlük rotasyon, tamamlama-bazlı — kaçan gün konu atlatmaz)
  2. Quiz: review batch (gramer %60 / vocab %40, 7-oturum cooldown)

BONUS (vakit varsa, sırasıyla):
  3. Okuma (plan.reading kaynağı)
  4. Mini-oyun (vocab match / confusable)
  5. Üretim (L1-L5 lane'leri — transform sorularında artık self-grade var)

HAFTALIK:
  - Pazar: Portfolio curation (mevcut protokol)
  - Review dağı 40 kartı aşarsa: o gün yeni kelime tavanı 0'a iner (manuel kural, Faz 2'de otomatikleşecek)
```

### 7d. Faz 2 Backlog'a Eklenenler

- [ ] Kelime başına 2-3 soru tipi (meaning + fill-blank + reverse) — KR-006'nın vocab karşılığı
- [ ] Kaynak cümle noktalama onarımı (ingest script'i düzelt + mevcut örnekleri lint'le)
- [ ] Review dağı otomatik fren: due > 40 iken yeni kelime kapısı kapanır
- [ ] Re-engagement: 3+ gün boşlukta "çekirdek gün 10 dakika" nudge'ı (KR'daki F4 maddesi öne çekildi)

---

## 8. Panorama v2 — Komuta Merkezi + Bilişsel Katman (2026-06-10)

> Tetik: "Tüm gelişim/bilgi akışım tek yerden ilerlemeli; kavrayışımın arttığına
> tık olabilmeliyim; panorama çok daha etkili ve değiştirilebilir olmalı."
> Vault kaynakları: PDM `_Tasnif Çalışması/12 - Komuta Merkezi.md`, İRFAN Protokolü §3 (halka modeli).

### 8a. Denetim Bulguları

| # | Bulgu | Kanıt | Durum |
|---|-------|-------|-------|
| 1 | Panorama statikti — 10 sorgu tek `Promise.all`, kişiselleştirme yok, sadece felsefe roadmap'i gömülü | `panorama/page.tsx` (eski) | ✅ Widget mimarisi (KR-014) |
| 2 | Bilişsel gelişim görünmüyordu — FSRS verisi (134 review, 147 attempt) hiçbir "kavrayış" göstergesine bağlanmamıştı | UI taraması | ✅ Bilişsel katman (KR-015) |
| 3 | Halka modeli (İRFAN §3) kodda temsil edilmiyordu | şema taraması | ✅ `halka_stage` (KR-016) |
| 4 | Yüzey kuyruğu ölüydü — 294 kart, hepsi pending, hepsi vadesi geçmiş; `/yedi-yeti`'de gömülü kalıyordu | DB taraması | ✅ Panorama kartları + triyaj (KR-017) |
| 5 | Komuta Merkezi route'u `/`'a redirect'ti; vault'taki 4-panel tasarımın kod karşılığı yoktu | `komuta/page.tsx` | ✅ Panorama = Komuta Merkezi |
| 6 | Session duration'ların çoğu NULL — zaman ölçümü kırık | DB taraması | ⬜ Backlog (heartbeat sayacı) |

### 8b. Yeni Karar Kayıtları

**KR-014 · Widget mimarisi** — Panorama, ayarlardan açılıp/kapanan ve sıralanabilen 10 widget'tan oluşur (`panorama.order` + `panorama.hidden` ayar blob'unda). Her widget kendi verisini çeken async server component; `<Suspense>` ile bağımsız akar. **Kapalı widget'ın verisi hiç çekilmez.**
*Why:* Tek dev Promise.all en yavaş sorguya rehin kalıyordu; kişiselleştirme yoktu.

**KR-015 · Kavrayış sinyali = davranış + bellek + pedagoji** — Üç katman: (1) haftalık quiz doğruluk eğrisi (davranışsal), (2) FSRS stability ortalaması = "bellek sağlamlığı" (otomatik), (3) halka hunisi (pedagojik, manuel). `queries-cognitive.ts`.
*Why:* Tek metrik yanıltır; FSRS tek başına üretimi (te'lif) görmez, halka tek başına disiplin ister.

**KR-016 · Halka aşaması items üzerinde** — `items.halka_stage` (0-7: sınır→damıt→mecz→tatbik→anlat→tekrar→te'lif) + `halka_updated_at`; tarihçe `events` (kind=`halka_advance`). Aşama ≥5 (anlat) → `os_dongu_kapali=true` otomatik. Migration: `drizzle/0004_halka_progress.sql` (+ idempotent `scripts/apply-0004-halka.ts`; **Turso'ya henüz uygulanmadı**).
*Why:* "Anlatılmayan kavram sahipsiz halkadır" kuralı veri modelinde yaşamalı; ayrı tablo overkill.

**KR-017 · Yüzey triyajı** — 30+ gün gecikmiş, yüksek-öncelik olmayan pending yüzeyler tek tıkla arşivlenir (`triageStaleSurfaces`). Panorama'da günde max 5 kart gösterilir; gerisi sayaçla `/yedi-yeti`'ye link.
*Why:* 294 kartlık vadesi geçmiş yığın = İngilizce'deki "review dağı"nın (KR-012) yüzey karşılığı; yığın gösterilirse sistem yine bırakılır.

### 8c. Yeni Widget Seti

`bugun` (streak+seans+paralel ipler) · `ritim` (kalp-atış) · `dongu` (Oku→Düşün→Üret→Denetle, en zayıf ip nudge'ı) · `resurfacing` (due kartlar+triyaj) · `bilissel` (kavrayış eğrisi+halka hunisi+halka başlat) · `yeti` (7 yeti şeridi) · `fikir` (açık halkalar) · `okuma` · `alanlar` · `ufuklar` (10yıl→tema→çeyrek→ay, ayarlardan düzenlenir).

### 8d. Mabet + Sade Dashboard Katmanı (aynı gün, ikinci tur)

**KR-018 · Vault = metin veritabanı, personal-os = tatbik katmanı** — Uzun-form içerik Obsidian'da yaşar; uygulama yalnızca index + durum + ölçüm tutar (KR-004'ün genelleştirilmesi). Her item `obsidian_refs` ile vault notuna bağlanır; UI'dan `obsidian://open` ile tek tık vault'a iner.

**KR-019 · Jenerik sade dashboard `/d/[slug]`** — Domain başına özel sayfa yazmak yerine tek jenerik sayfa: 4 sayı + bölümler + çalışma kuyruğu (halka ilerletme) + son üretimler. Yeni domain = sadece seed; kod değişmez.
*Why:* Her yeni öğrenme alanı (kuantum gibi) için sayfa yazmak ölçeklenmez.

**KR-020 · Mabet `/mabet` = ortak sonuç ekranı** — Panorama "komuta"dır (canlı akış, widget'lar); Mabet "muhasebe"dir (modül başına sonuç satırı: mastery, doğruluk, halka, üretim, son aktivite). İki ekran farklı soruya cevap verir: "şimdi ne yapayım?" vs "nerede duruyorum?".

**Kuantum domain'i** — Quantum vault'undan 23 item seed edildi (`scripts/seed-quantum.ts`, idempotent); Temeller üçlüsü (Qubit, Süperpozisyon, Dolanıklık) aktif.

### 8e. Backlog'a Eklenenler

- [ ] Session duration heartbeat sayacı (bulgu #6)
- [ ] `faculty_rollups` hesaplama → haftalık bülten pipeline'ına bağla
- [ ] Halka aşama geçmişinden "derinleşme hızı" metriği (events.halka_advance)
- [ ] Turso'ya 0004 migration (`DATABASE_URL=libsql://... npx tsx scripts/apply-0004-halka.ts`)

## 9. Bağlantılar

- Mevcut sistem: [[english-learning-engine-v1]], [[implementation-notes]]
- Migrate edilen veri: [[grammar-coverage]], [[Practice/Grammer Topics/_index|wiki/tracking/_index]]
- Faz 2 öncesi reading: FSRS paper, Anki algorithm changelog 2023
- Zihin yapısı kaynakları: PDM vault `🧭 İRFAN Operasyon Protokolü`, `_Tasnif Çalışması/04, 08, 12, 15`
