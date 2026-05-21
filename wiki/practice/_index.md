---
title: Practice Hub — 5 Lane Output System
type: synthesis
tags: [practice, output, production, system]
related: [[index]], [[CLAUDE]], [[CEFR Curriculum Map]]
created: 2026-05-15
updated: 2026-05-15
---

# Practice Hub — 5 Lane Output System

Bu klasör vault'taki **üretim merkezli** pratik sisteminin merkezidir. Reading/input C1 seviyesinde, üretim B1'de takılı — burası o gap'i kapatır.

**Felsefe:** Constraint > Freedom. Anladığını üretmeye zorlama. Her pratik wiki artifact üretir. Hatalar veridir, başarısızlık değil.

---

## Beş Şerit (Rotating Lanes)

| # | Lane | Süre | Hedef | Klasör |
|---|------|------|-------|--------|
| **L1** | [[Production Cell]] | 15-20 dk | Grammar + vocab + chunk aktif kullanım | [`cells/`](cells/) |
| **L2** | [[Shadow Author]] | 25-30 dk | Style elasticity + register awareness | [`shadow/`](shadow/) |
| **L3** | [[Conversational Loop]] | 30-45 dk | Speaking + real-time production | [`dialogues/`](dialogues/) |
| **L4** | [[Error Constellation Drill]] | 20-30 dk | Fossilization önleme | [`drills/`](drills/) |
| **L5** | [[Retrieval Carnival]] | 15-20 dk | Spaced retention, decay önleme | [`retrieval/`](retrieval/) |

**Haftalık katman:** Pazar günü [[Portfolio Curation]] — haftanın en iyi paragrafı [`wiki/portfolio/`](../portfolio/) altına arşivlenir.

---

## Haftalık Şablon

| Gün | Ana Şerit (30-40 dk) | Yan Şerit (15-20 dk) |
|---|---|---|
| **Pzt** | L1 Production Cell | L4 Error Drill |
| **Sal** | L2 Shadow Author | L1 Production Cell |
| **Çar** | L3 Conversational Loop (voice) | L4 Error Drill |
| **Per** | L1 Production Cell | L5 Retrieval Carnival |
| **Cum** | L3 Conversational Loop (voice) | L1 Production Cell |
| **Cmt** | L5 Retrieval Carnival | L2 Shadow Author |
| **Paz** | Portfolio Curation (haftalık) | Rest / okuma |

Şablon esnek — günün enerjisine göre lane değiştirilebilir. Minimum: her gün **en az L1** (10 dk fallback versiyonu mevcut).

---

## Lane Tetikleme Protokolleri (Claude için)

### L1 — Production Cell
**Tetik:** "L1 yapalım" / "Production cell" / "Today's cell"
**Akış:**
1. Kullanıcının son okuduğu kaynağı sor (veya log.md'den çıkar)
2. O kaynaktan 3 grammar pattern + 5 chunk + 5 phrasal verb çıkar (kullanıcıya göster)
3. Kullanıcı 100-150 kelimelik tek paragraf yazar
4. Annotate et: ✅ doğru | ⚠️ güçlendirilebilir | ❌ hata
5. Hataları `errors/` altına frekans sayacıyla kaydet
6. Output: `cells/YYYY-MM-DD.md` (frontmatter + source + targets + production + annotation)

### L2 — Shadow Author
**Tetik:** "Shadow Author" / "Style mimicking" / "X gibi yaz"
**Akış:**
1. Kullanıcıdan source paragraf seç (mevcut okumadan)
2. "DNA" çıkar: tense profile, clause types, cohesion devices, register, rhythm
3. Yeni konu öner (3 seçenek)
4. Kullanıcı seçilen konuda aynı DNA ile paragraf yazar
5. Fidelity score + grammar accuracy + register match notes
6. Output: `shadow/YYYY-MM-DD_author-slug.md`

### L3 — Conversational Loop
**Tetik:** "Sohbet" / "Dialogue" / "L3 voice" / "Konuşma pratiği"
**Akış:**
1. Modalite belirle: voice (Claude voice app) veya text
2. Senaryo seç: (a) son okuma karakteri, (b) hayati durum, (c) tematik debat
3. Constraints duyur: 3 phrasal verb + 2 modal pattern + son haftanın 5 yeni kelimesi
4. Sohbet (15-30 dk)
5. Transcript analizi: hatalar + kaçırılan kullanım şansları + natural alternatif phrasings
6. Output: `dialogues/YYYY-MM-DD_topic.md` (transcript + analiz)
7. **Banned-Turkish mode:** sıkı versiyonda Türkçe kelime/yapı düşünme yasak

### L4 — Error Constellation Drill
**Tetik:** "Error drill" / "L4" / "Hata pratiği"
**Akış:**
1. `errors/` klasörünü oku → top 3 frequent pattern çıkar
2. Her pattern için 10 production mini-drill üret (boşluk doldurma DEĞİL — cümle üretimi)
3. Kullanıcı çözer
4. Doğru çözümler: pattern frequency sayacı azalır
5. Kaybolan pattern → "graduated" archive
6. Output: `drills/YYYY-MM-DD_pattern.md`

### L5 — Retrieval Carnival
**Tetik:** "Retrieval" / "L5" / "Spaced practice"
**Akış:**
1. Sample al:
   - 1 concept (2 hafta önce eklenen — `wiki/concepts/`'ten yaş'a göre)
   - 5 vocabulary (1 hafta önce)
   - 3 phrasal verb (1 ay önce)
2. Kullanıcı hepsini içeren tek mini-story veya dialogue yazar
3. Eksik kullanılanlar → decay register
4. Yanlış kullanılanlar → re-exposure list (3 gün L1'de zorunlu kullanım)
5. Output: `retrieval/YYYY-MM-DD.md`

---

## Edge Case Handler'ları

| Senaryo | Aksiyon |
|---|---|
| 3 gün üst üste L1 yok | Daily minimum reminder, 10-dk versiyonu öner |
| Aynı hata 3+ kez | "Boss Battle" L4 mode — 1 hafta o pattern'e özel drill |
| Voice friction | Text-only fallback, haftada 1 voice'a indir |
| Aynı kelime 3 turda yok | Deep decay list — 3 gün L1'de zorunlu |
| AI praise inflation | Açık skor + hata sayısı + improvement delta her seansta |
| Plateau (B1'de takılma) | L2 Shadow Author yüksek register (Hugo, Joyce) ile zorla |

---

## Bu Haftaki Durum (live tracker)

> Pilot hafta başlangıcı: **2026-05-15** (Cuma)
> İlk değerlendirme: **2026-05-22** (Cuma)

| Lane | Hedef (7 gün) | Tamamlanan | Durum |
|------|---------------|------------|-------|
| L1 Production Cell | ≥ 5 | 0 | ⬜ |
| L2 Shadow Author | ≥ 1 | 0 | ⬜ |
| L3 Conversational Loop | ≥ 2 (en az 1 voice) | 0 | ⬜ |
| L4 Error Drill | ≥ 1 (pilot sonu) | 1 | 🟡 ([[2026-05-16_passive-voice-fundamentals\|Passive Voice gap-fill]]) |
| L5 Retrieval Carnival | ≥ 1 | 0 | ⬜ |
| Portfolio Curation | 1 | 0 | ⬜ |

---

## Verification Kriterleri (pilot hafta sonu)

**Quantitative:**
- ≥ 5 L1 cell, ≥ 2 L3 transcript (en az 1 voice), ≥ 1 L5 retrieval
- ≥ 5 distinct error pattern dokumante edildi
- ≥ 1 portfolio piece

**Qualitative:**
- Hangi şerit en zevkliydi / en sıkıcı?
- 45-60 dk gerçekçi miydi?
- Voice modalitesi işe yaradı mı?
- Üretim akıcılığında subjective fark var mı?

---

## İlgili Sayfalar

- [[index]] — vault haritası
- [[CLAUDE]] — Practice Akışı (Section 8)
- [[CEFR Curriculum Map]] — seviye haritası
- [[narrative-past-tenses-cluster]] — anlatı için minimum set
- [[Phrasal Verbs Hub]] — L1 ve L5 için kaynak
- [[Vocabulary Hub]] — L1 ve L5 için kaynak
