---
title: Personal OS — Design Decisions (Phase 1)
type: synthesis
tags: [personal-os, architecture, decisions, infrastructure]
related: [[english-learning-engine-v1]], [[implementation-notes]], [[_index]]
created: 2026-05-22
updated: 2026-05-22
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

## 7. Bağlantılar

- Mevcut sistem: [[english-learning-engine-v1]], [[implementation-notes]]
- Migrate edilen veri: [[grammar-coverage]], [[_index|wiki/tracking/_index]]
- Faz 2 öncesi reading: FSRS paper, Anki algorithm changelog 2023
