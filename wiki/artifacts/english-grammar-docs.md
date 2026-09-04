---
title: English Grammar Docs
type: artifact
tags: [grammar, reference, documentation, all-topics]
related: [[CEFR Curriculum Map]], [[Grammar Roadmap]], [[English Grammar Diagram]], [[Grammar Explorer]]
created: 2026-09-04
updated: 2026-09-04
---

# English Grammar Docs

**Dosya:** `Artifacts/english-grammar-docs.html`
**Artifact URL:** https://claude.ai/code/artifact/ac14becb-df9e-462c-816a-2570975cb6fb
**Tip:** Statik referans dokümanı (alıştırma/quiz yok — bilinçli tercih)

## Ne yapar

Laravel dokümantasyon sitesinin (laravel.com/docs) görsel dilini ve navigasyon yapısını birebir taklit eden, içeriği tamamen İngilizce gramer olan tek dosyalık referans sitesi. Vault'taki 56 concept sayfasının taksonomisi doğrudan sol menü kategorilerine dönüştürülmüştür.

## Kapsam

| Ölçüt | Değer |
|-------|-------|
| Toplam sayfa | 60 (4 giriş + 56 gramer konusu) |
| Kategori (nav grubu) | 13 |
| İçerik bölümü | 306 |
| Örnek cümle (EN + TR yan yana) | 354 |
| Yanlış/doğru hata çifti | 224 |

### Nav kategorileri

1. **Prelude** (4) — Introduction, How to Use, CEFR Roadmap, Cheat Sheet
2. **Tenses** (13) — [[Present Simple]] → [[Future Perfect Continuous]]
3. **Core Verb Structures** (7) — [[Passive Voice Concept|Passive Voice]], [[Causative]], [[Reported Speech Concept|Reported Speech]], [[Conditionals Concept|Conditionals]], [[Mixed Conditionals]], [[Wish If Only]], [[Subjunctive]]
4. **Clauses & Complex Structures** (7) — [[Relative Clauses]], [[Gerunds and Infinitives]], [[Participle Clauses]], [[Noun Clauses]], [[Adverbial Clauses]], [[Cleft Sentences Concept|Cleft Sentences]], [[Inversion]]
5. **Modals & Key Structures** (5) — [[Modal Verbs Concept|Modal Verbs]], [[Phrasal Verbs]], [[Used To Would]], [[Be Used To Get Used To]], [[Emphasis]]
6. **Questions & Negation** (4) — [[Question Formation]], [[Question Tags]], [[Indirect Questions]], [[Negation]]
7. **Nouns & Pronouns** (6) — [[Countable and Uncountable Nouns]], [[Plural Nouns]], [[Pronouns]], [[Possessives]], [[Quantifiers]], [[Articles]]
8. **Adjectives & Adverbs** (4) — [[Adjectives]], [[Order of Adjectives]], [[Adverbs]], [[Comparison]]
9. **Determiners** (1) — [[Determiners]]
10. **Prepositions** (3) — [[Prepositions of Time]], [[Prepositions of Place and Movement]], [[Fixed Prepositions]]
11. **Conjunctions & Linking** (3) — [[Coordinating Conjunctions]], [[Subordinating Conjunctions]], [[Linking Words]]
12. **Other Structures** (2) — [[Ellipsis and Substitution]], [[Passive Infinitives and Gerunds]]
13. **Word Formation** (1) — [[Word Formation]]

## Sayfa anatomisi (her konu için sabit iskelet)

1. Breadcrumb + başlık + Türkçe alt başlık + CEFR seviye rozeti
2. **Introduction** — kavramın işlevi, Türkçedeki karşılığı ve tuzağı
3. **Form** — koyu kod bloğunda olumlu/olumsuz/soru kalıpları
4. **Usage / karşılaştırma tabloları**
5. **Examples** — iki sütunlu tablo: solda İngilizce (hedef yapı vurgulu), sağda Türkçe
6. **Common Mistakes** — ❌ yanlış / ✅ doğru + neden açıklaması
7. **Related** — bağlantılı konulara geçiş + önceki/sonraki sayfalayıcı

## Teknik

- Tek dosya HTML, harici bağımlılık yok (yalnızca Google Fonts: Instrument Sans + JetBrains Mono)
- İçerik JS veri katmanında (`TOPICS` dizisi), render motoru sayfaları hash routing ile üretir (`#/present-perfect`)
- Sol menü: katlanabilir kategori grupları, aktif sayfa vurgusu, canlı arama filtresi
- Sağ menü: "On this page" TOC, IntersectionObserver ile aktif başlık takibi
- Koyu/açık tema (sistem tercihi + localStorage), Laravel kırmızısı `#f9322c` marka rengi
- Mobil: hamburger drawer + backdrop, tablolar kendi içinde yatay kayar, örnek tabloları tek sütuna iner
- Klavye: `/` arama, `Esc` temizle, `←`/`→` önceki/sonraki konu

## Neden bu format

Mevcut artifact'ların çoğu **etkileşimli araç** (quiz, drill, tracker). Bu bilinçli olarak farklı: hızlı **lookup** (arama) ihtiyacı için tasarlandı. Bir yapıyı unuttuğunda ya da bir hatanın nedenini görmek istediğinde 10 saniyede doğru sayfaya ulaşmayı hedefler; öğretmez, hatırlatır ve düzeltir.

## Kaynak

Tasarım referansı: laravel.com/docs (sol sticky kategori menüsü + sağ TOC + koyu kod blokları + turuncu-kırmızı marka rengi). İçerik: vault'un 56 concept sayfası taksonomisi + [[CEFR Curriculum Map]] seviyelendirmesi.
