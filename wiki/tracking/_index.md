---
title: Tracking Hub
type: tracking
tags: [tracking, progress, srs, coverage]
related: [[grammar-coverage]], [[weak-topics]], [[word-bank-master]], [[srs-state]], [[weekly-review]]
created: 2026-05-18
updated: 2026-05-18
---

# Tracking Hub

English Learning Engine'in **veri tabakası**. Bütün motorlar (grammar-first, text-first, vocab-srs) sonuçlarını `00_INBOX/*.json` olarak indiriyor. Claude Code o JSON'ları okuyup buradaki .md dosyalarını güncelliyor.

## Dosyalar

| Dosya | Ne tutar | Kim günceller |
|-------|----------|---------------|
| [[grammar-coverage]] | 56 gramer konusunun her biri × kaç oturum × son tarih × güç skoru | INBOX işlendikçe Claude Code |
| [[weak-topics]] | Bu haftanın zayıf-konu kuyruğu (skor düşük + ay-sonu borçlu) | Pazar günü Claude Code (haftalık derleme) |
| [[word-bank-master]] | Kullanıcının "Save to Bank" ile eklediği kelime/PV/chunk havuzu | Her `word_bank_add` JSON'unda |
| [[srs-state]] | Kart başına SM-2 durumu (interval, EF, due date) snapshot | Her `srs_review` JSON'unda |
| [[weekly-review]] | Haftalık delta — pazar günleri yazılır | Pazar Claude Code |

## Veri akışı

```
HTML motor (3 tane) → JSON indir → 00_INBOX/ → Claude Code → bu klasör → log.md
```

Hiçbir motor doğrudan bu .md dosyalarına yazmıyor; hepsi JSON üretiyor, Claude Code köprü oluyor. Bu sayede:
- HTML çalışırken Obsidian açık olmak zorunda değil
- Aynı kaynak (.json) hem human-readable .md hem grafik veriye dönüşebilir
- Çelişki çıkarsa kaynak JSON'lar `_archive/`'de duruyor

## Konvansiyon

- Tarih formatı: `YYYY-MM-DD` (ISO)
- Konu adlandırma: `slug` (`present-perfect`, `passive-voice`, …) — `_engine/topics.json` ile aynı
- Güç skoru: 0-100 ölçeği. Hesap: `(doğru_sayısı / toplam) × 100`, son 3 oturumun ağırlıklı ortalaması (en son ×3, önceki ×2, ondan önceki ×1).
- Borç skoru: `(bugün − son_tarih) günü × (100 − güç_skoru) / 100`. Yüksek borç = öncelikli konu.
