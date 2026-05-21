---
title: English Learning Engine v1
type: artifact
tags: [engine, daily, grammar, vocabulary, srs, tracking, anki, json]
related: [[grammar-first-daily]], [[text-first-daily]], [[vocab-srs]], [[implementation-notes]], [[_index|wiki/tracking/_index]]
created: 2026-05-18
updated: 2026-05-18
---

# English Learning Engine v1

Üç-motorlu günlük çalışma sistemi. Kefir + bisiklet prensibi: her motor tek başına çalışır, hepsi ortak bir JSON+INBOX köprüsünden konuşur. Hedef: çapraz teyit (grammar-first ↔ text-first), aylık tüm 56 konu kapsamı, SRS ile kalıcı kelime/PV/chunk.

## Bileşenler

| Dosya | Rol |
|-------|-----|
| [[grammar-first-daily]] | **Motor A** — Önce kavram, sonra metin (`english_rehber2.html` mimarisi) |
| [[text-first-daily]] | **Motor B** — Önce metin, sonra kavram (`compressed-galaxy-002-cogito.html` mimarisi) |
| [[vocab-srs]] | Müstakil SM-2 SRS — word bank'tan beslenir |
| [[implementation-notes]] | Tasarım kararları, sapmalar, edge case'ler, açık sorular |

## Ortak motor (_engine/)

```
Artifacts/_engine/
  topics.js / topics.json   # 56 konu seed (canonical: .js)
  profile.js / profile.json # kullanıcı profili (ilgi alanları)
  engine.css                # ortak tema (4 tema × 4 font boyutu)
  engine.js                 # rotation + localStorage + SM-2 + export
```

## Veri akışı (köprü)

```
HTML motor → "📥 Vault'a İndir" → indirilenler/*.json
                                       ↓ (kullanıcı sürükler)
                          00_INBOX/YYYY-MM-DD-HHmm-*.json
                                       ↓ (Claude Code okur)
                          wiki/tracking/*.md güncellenir
                                       ↓
                          00_INBOX/_archive/YYYY-MM/
```

Beklenen JSON tipleri:
- `session_grammar_first` → Motor A çıktısı
- `session_text_first` → Motor B çıktısı
- `word_bank_add` → "Save to Bank" tetikleri
- `srs_review` → vocab-srs.html oturumu

## Rotation kuralı (engine.js)

Her gün 6-8 konu seçilir (varsayılan 7). Seçim sırası:

1. `weak_topics` (haftalık zayıf-konu kuyruğu) — zorunlu
2. **Borç skoru** en yüksek olanlar: `(gün_farkı × (100 - güç_skoru)) / 100`
3. **Kategori sınırı**: aynı kategoriden maks 2 (örn. 2'den fazla tense yok)
4. Aynı gün her iki motor aynı set'i görür — **çapraz teyit**

Reroll butonuyla farklı kombinasyon alınabilir.

## CEFR ve hedefler

- Mevcut tahmin: B1
- Hedef: B2
- Günlük süre hedefi: ~45 dk (45/3 = motor başına ~15 dk)
- Aylık kapsam garantisi: 56 konu × 7 günlük taze rotation → 4 hafta içinde her konu en az 1× görülür

## İlgili wiki kavramları

Engine, [[CEFR Curriculum Map]] üzerindeki tüm 56 grammar konseptini referans alır. Her konunun wiki sayfası (örn. [[Present Perfect]], [[Passive Voice Concept]], [[Reported Speech Concept]]) bu motorların seed datasıyla **manuel olarak** senkron tutulur. Wiki sayfası daha zengindir; seed sadece motor için minimum yapı verir.

## Sonraki aşama (Faz 2 önerileri)

implementation-notes.html'de detaylı listelenmiş. Özetle:
- Günlük passage'ı Claude Code'un sabah üretmesi (LLM-jeneratif metin)
- Quiz seti zenginleştirme (`_engine/daily-questions-YYYY-MM-DD.json`)
- Tema/font tercihinin localStorage'a yazılması
- LocalStorage backup/restore aracı
- Boss-battle leech için otomatik mini-metin tetiği
