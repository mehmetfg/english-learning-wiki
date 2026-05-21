---
title: SRS State Snapshot
type: tracking
tags: [tracking, srs, anki]
related: [[_index]], [[word-bank-master]]
created: 2026-05-18
updated: 2026-05-18
---

# SRS State — Snapshot

Her `srs_review` JSON'u işlendiğinde buraya yazılır. **Asıl canlı veri** `vocab-srs.html`'in localStorage'ında — bu sayfa **insan-okunur özet** ve grafik tabanı.

## Algoritma — SM-2 (sadeleştirilmiş)

Her kartın iki alanı var: `interval` (gün), `EF` (easiness factor, başlangıç 2.5).

```
Kullanıcı geri bildirimi:
  again (0)  → interval = 1, EF = max(1.3, EF - 0.20), repetition = 0
  hard  (3)  → interval = round(interval * 1.2), EF = max(1.3, EF - 0.15)
  good  (4)  → interval = round(interval * EF), EF aynı
  easy  (5)  → interval = round(interval * EF * 1.3), EF = EF + 0.10

İlk gösterimde (repetition=0): interval = 1
İkinci gösterimde (repetition=1): interval = 6
Üçüncü+ : yukarıdaki formül
```

## Bugünkü Snapshot

*Henüz kart yok.*

## Histogram (placeholder)

| Status | Adet |
|--------|------|
| new | 0 |
| learning (1-6 gün) | 0 |
| young (7-30 gün) | 0 |
| mature (>30 gün) | 0 |
| suspended | 0 |
| leech | 0 |

## Due Today

*Boş.*

## Leech List (8+ "again" gelen)

*Boş. Listeye girince burada **boss battle adayı** olur — Claude Code'a o öğeyi içeren özel metin yazdırılır.*
