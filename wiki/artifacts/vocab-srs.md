---
title: Vocab SRS
type: artifact
tags: [engine, srs, anki, vocabulary, phrasal-verbs, chunks]
related: [[english-learning-engine-v1]], [[word-bank-master|wiki/tracking/word-bank-master]], [[kelime-pasaportu]], [[apriori-kelime-yontemi]]
created: 2026-05-18
updated: 2026-05-18
---

# Vocab SRS — Anki Mantığı

`Artifacts/vocab-srs.html` · ~330 satır vanilla JS.

**Akış:** Word bank'tan beslenir, SM-2 sadeleştirilmiş algoritmasıyla tekrar aralığını yönetir. Kart-flip UI + 4 buton (again / hard / good / easy). Leech (8+ "again") otomatik işaretlenir.

## Algoritma

```
quality 0 (again) → interval=1, EF=max(1.3, EF-0.20), repetition=0
quality 3 (hard)  → interval=round(interval*1.2), EF=max(1.3, EF-0.15)
quality 4 (good)  → interval=round(interval*EF), EF aynı
quality 5 (easy)  → interval=round(interval*EF*1.3), EF=EF+0.10

İlk gösterim (rep=0): interval=1
İkinci gösterim (rep=1): interval=6
Üçüncü+: yukarıdaki formül
```

## Status geçişleri

| Status | Şart |
|--------|------|
| new | bank'a yeni eklendi, henüz review yok |
| learning | interval 1-6 gün |
| young | interval 7-30 gün |
| mature | interval >30 gün |
| leech | _again_count >= 8 (boss-battle adayı) |
| suspended | kullanıcı manuel pasifleştirdi |

## JSON çıktı şeması

```json
[
  {
    "schema_version": "1.0",
    "type": "srs_review",
    "session_id": "2026-05-18-2030-vocab-srs",
    "payload": {
      "reviews": [
        { "card_item": "fall back on", "card_type": "phrasal_verb",
          "quality": 4, "before": {...srs}, "after": {...srs}, "ts": "..." }
      ],
      "bank_snapshot": [...],
      "counts": { "new": 12, "learning": 8, "young": 3, "mature": 0, "leech": 1 }
    }
  }
]
```

## Boss Battle önerisi

Bir kart `status: leech` olursa Claude Code'a manuel olarak:
> "şu kelime/PV/chunk'ı içeren 100 kelimelik bir mini-metin yaz, B1 seviyesinde, [profil alanı] konusunda"

dedirtebilirsin. Bu metin yeni bir source olarak vault'a girer, bağlam tekrarı sağlanır.

İlgili: [[implementation-notes]], [[word-bank-master|word-bank tracking]]

---

## Kardeş araç: [[kelime-pasaportu]] (2026-09-02)

Aynı SM-2 formülünü paylaşır, yerini almaz. Ayrım:

| | vocab-srs | [[kelime-pasaportu]] |
|---|---|---|
| Girdi | word bank'tan otomatik | elle, beş mühürle |
| Soru | kelime → anlam (**tanıma**) | form → kelime (**üretim**) |
| Hız | çok kelime, hızlı | az kelime, derin |
| Rolü | geniş pasif dağarcık | çekirdek aktif dağarcık |

**Kural:** Pasif hacim burada kalsın; aktif üretime girmesini istediğin kelimeler pasaporta alınsın. Gerekçe: [[apriori-kelime-yontemi]].
