---
title: Error Constellation — Top Error Patterns
type: synthesis
tags: [practice, errors, drill, fossilization]
related: [[_index|Practice Hub]], [[Error Constellation Drill]]
created: 2026-05-15
updated: 2026-05-15
---

# Error Constellation — Top Error Patterns

Bu dosya tekrar eden hata pattern'lerinizi frekans bazlı takip eder. Her L1 ve L3 seansından sonra Claude buraya yazar.

**Felsefe:** Hatalar veri. Frekans yükseldikçe pattern "boss battle" statüsüne geçer ve [[Error Constellation Drill]] (L4) o pattern'e özel mini-drill üretir.

---

## Aktif Pattern'ler (Frequency-Tracked)

| Pattern | Frekans | İlk gözlem | Son gözlem | Kaynak | Status |
|---------|---------|------------|------------|--------|--------|
| `used-to/would` — state verb kuralı | 5 | 2026-05-20 | 2026-05-20 | L02 quiz (4 hata) + confusable (1) | 🔴 Boss Battle |
| `make/do` — collocation karışıklığı | 3 | 2026-05-20 | 2026-05-20 | L02 collocation drill (2) + confusable (1) | 📈 Aktif |
| `ppc-form` — "have" eksikliği / spelling | 3 | 2026-05-20 | 2026-05-20 | L02 quiz (how long you been waiting; have been planing) | 📈 Aktif |
| `past-cont-form` — "was not listenig" spelling | 2 | 2026-05-20 | 2026-05-20 | L02 quiz (2 kez aynı soru) | 🆕 Yeni |
| `lend/borrow` karışıklığı | 1 | 2026-05-20 | 2026-05-20 | confusable drill | 🆕 Yeni |
| `speak/talk` — formal/informal fark | 1 | 2026-05-20 | 2026-05-20 | confusable drill | 🆕 Yeni |
| `rise/raise` — transitivity | 1 | 2026-05-20 | 2026-05-20 | confusable drill | 🆕 Yeni |
| `remember/remind` — self vs other | 1 | 2026-05-20 | 2026-05-20 | confusable drill | 🆕 Yeni |
| `few/a few` — negatif/pozitif tını | 1 | 2026-05-20 | 2026-05-20 | confusable drill | 🆕 Yeni |
| `fewer/less` — count/uncount | 1 | 2026-05-20 | 2026-05-20 | confusable drill | 🆕 Yeni |
| `win/beat` — game vs opponent | 1 | 2026-05-20 | 2026-05-20 | confusable drill | 🆕 Yeni |
| `deep+sleep` — adj vs adv confusion | 1 | 2026-05-20 | 2026-05-20 | collocation drill | 🆕 Yeni |
| `highly` — spelling (higly) | 1 | 2026-05-20 | 2026-05-20 | collocation drill | 🆕 Yeni |

---

### 🔴 Boss Battle: `used-to / would` — State Verb Kuralı

**Frekans:** 5 (eşik: 5 → Boss Battle tetiklendi)  
**Pattern:** `would` + state verb kullanımı — *"I would know him well"*, *"He would be tall"*, *"I was used to"*  
**Kural:** State verb'ler (know, think, be, understand, like…) → sadece `used to`, `would` almaz  
**Öncelik:** L03 General Mix'e 2 adet `used-to/would` sorusu enjekte et; L04'e "Boss Battle drill" planla

### 📈 Aktif: `make/do` — Collocation Karışıklığı

**Frekans:** 3  
**Yanlış:** *"make me a favor"* (do a favor); *"do a decision"* (make a decision)  
**Kural:** DO: görev/iş/aktivite (do homework, do a favor, do exercise). MAKE: üretim/oluşturma (make a decision, make a mistake, make money)  
**Öncelik:** Collocation Heatmap drill'inde tekrar et; confusable-drill'e ek cümle ekle

### 📈 Aktif: `ppc-form` — Present Perfect Continuous Form

**Frekans:** 3  
**Yanlış:** *"you been waiting"* (how have you been waiting); *"have been planing"* (planning — tek n değil)  
**Kural:** have/has + been + V-ing. Spelling: plan→planning, run→running (double final consonant)  
**Öncelik:** L03 review quiz'e PPC sorusu; gelecek hafta tekrar gözle

**Status açıklamaları:**
- 🆕 Yeni (1-2 görülme)
- 📈 Aktif (3-5 görülme)
- 🔴 Boss Battle (6+ görülme — L4 öncelik)
- ✅ Graduated (3 seans üst üste hatasız)

---

## Pattern Sayfa Şablonu

Her pattern kendi dosyasında detaylanır: `errors/[pattern-slug].md`

Örnek dosya iskeleti:

```yaml
---
title: Article Omission with Abstract Nouns
type: error-pattern
tags: [error, articles, abstract-nouns]
frequency: 4
first_seen: 2026-05-16
last_seen: 2026-05-19
status: active
related: [[Articles]], [[Countable and Uncountable Nouns]]
---

## Pattern
Soyut isimlerin önünde "the" düşürme — "He values knowledge" doğru, "He values the knowledge" yanlış.

## Sizin Hatalarınız (chronological)
1. [2026-05-16, cells/2026-05-16] "She found the happiness in solitude" → "She found happiness in solitude"
2. [2026-05-17, dialogues/2026-05-17] "Education is the key" (bağlamda yanlış) → "Education is key"
3. ...

## Kural
- Abstract noun + zero article: genel kavram olarak
- Abstract noun + the: belirli bir context'te (the happiness she felt that day)

## İlgili Concept
[[Articles]], [[Countable and Uncountable Nouns]]

## Drill Geçmişi
- [2026-05-20, drills/2026-05-20_article-omission] 10/10 doğru → frekans 4 → 2
```

---

## Graduated Errors (Archive)

> Henüz mezun olmuş hata yok.

| Pattern | Frekans (tepe) | Graduated date | Total seans |
|---------|----------------|----------------|-------------|

---

## Decay Register

Vocabulary/concept'ler ki aktive edilemedi (L5 retrieval'da kaçırıldı):

> Boş — L5 seansları başlayınca dolacak.

| Item | Tip | Eklendiği tarih | Re-exposure deadline |
|------|-----|------------------|----------------------|
