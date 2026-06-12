---
title: Translation Pendulum — EN→TR→EN Back-Translation
type: artifact
tags: [translation, back-translation, naval, paul-graham, b1, pendulum, diff]
related: [[calisma-yontemleri-analizi]], [[naval-almanack/index]], [[paul-graham/01-life-is-short]], [[_index|Practice Hub]], [[errors/_index|Error Constellation]]
created: 2026-05-23
updated: 2026-05-23
file: Artifacts/translation-pendulum.html
level: B1
mode: tool
---

# Translation Pendulum — EN ↔ TR Salınımı

[[calisma-yontemleri-analizi]] Ö2 önerisinin **v1 örneği**. Profesyonel çevirmen eğitiminin core drill'i: **back-translation**. EN'yi gör → TR'ye çevir → gecikme → sadece TR'den hafızadan EN'ye çevir → orijinal ile diff.

📁 Dosya: `Artifacts/translation-pendulum.html`

---

## Felsefe

> **Çift-yönlü kodlama. "Anladım" değil, "geri üretebiliyorum."**

Vault'ta TR→EN var (writing-ladder/daily-writing-loop). Ama **EN→TR→EN tekrar** yok. Bu drill onu kapatır:

1. EN cümleyi gör — TR'ye çevir.
2. Model TR ortaya çıkar; karşılaştır.
3. **20 sn gecikme bar'ı** — cümle aklında çürüsün.
4. EN gizlenir, TR görünür. Hafızadan EN'yi yeniden yaz.
5. **Word-level LCS diff** → kayıp + fazla + eşleşen.

---

## Cümleler (6 — B1 uyarlamalı)

Kaynak: [[naval-almanack/index]] + [[paul-graham/01-life-is-short]] çevresi. Tek cümlelik aforizmalar — yüksek "encoding density".

| # | EN | TR | Kaynak |
|---|----|----|--------|
| 1 | Life is short. The days are full of small things that do not matter. | Hayat kısa. Günler önemli olmayan küçük şeylerle dolu. | [[paul-graham/01-life-is-short]] |
| 2 | You will not get rich by selling your time. You must own a piece of something. | Vaktini satarak zengin olamazsın. Bir şeyin parçasına sahip olmalısın. | [[naval-almanack/01-how-to-get-rich-tweetstorm]] |
| 3 | Read what you love until you love to read. | Sevdiğin şeyi oku, ta ki okumayı sevene kadar. | [[naval-almanack/06-reading-and-learning]] |
| 4 | Avoid people who make you feel bad about yourself. | Sana kendini kötü hissettiren insanlardan uzak dur. | [[naval-almanack/04-happiness]] |
| 5 | A calm mind is a strong mind. | Sakin bir zihin güçlü bir zihindir. | [[naval-almanack/04-happiness]] |
| 6 | If you cannot decide, the answer is no. | Karar veremiyorsan, cevap hayırdır. | [[naval-almanack/05-philosophy]] |

---

## Teknik

- **LCS diff:** klasik dp tablosu + backtrack, kelime düzeyinde (lowercase + punctuation strip).
- **Tag tipleri:** `same` (yeşil) · `miss` (kırmızı üstü çizgi) · `extra` (sarı italic).
- **Skor:** `same / len(original) * 100`.
- **Kayıp kelimeler defteri:** her atlanan kelime localStorage'da frekans sayar. 3+ frekansla [[errors/_index|Error Constellation]]'a manuel taşınabilir.
- **Delay bar:** 20 sn (skip butonu test için).
- **Stepper:** 6 cümle arası gezinme + ✓ tamamlanmış işareti.
- **Tema:** Amber/altın default + paper-light fallback (Naval estetiği).

---

## Edge Case'ler

| # | Senaryo | Davranış |
|---|---------|----------|
| 1 | Phase A'yı atlama | Phase B textarea/button disabled |
| 2 | Gecikme bar | 20 sn auto + skip; resume eden user-flow yok |
| 3 | Boş input | `< 3 char` → alert |
| 4 | Aynı cümleyi tekrar deneme | `Sıfırla` butonu (tüm progress) |
| 5 | Stepper'la atlamak | Free navigation — herhangi bir cümleye atlanabilir |
| 6 | Phase B sonrası tekrar Phase A | Tek yön: B tamamlanınca diff kalıcı |
| 7 | LCS hesabı uzun cümlede | n×m küçük (≤20 token) — performans OK |
| 8 | Çevirinin "ideal" değil yakın olması | Manuel; user kendini değerlendirir (model TR sadece referans) |

---

## v1 Sınırlamaları

- **Sadece 6 cümle** — vault'ta 7 Naval Almanack + 8 Paul Graham essay var; v2'de seri seçici (15-30 cümle).
- **Tek yön gecikme** — gerçek "24 saat çürüme" simüle edilmiyor. 20 sn = kısa hipo. v2'de "kayıt et, yarın aç" mod düşünülebilir.
- **Kayıp defteri manuel** — `wiki/practice/errors/translation-lost-words.md`'ye auto-write yok. JSON bridge ile yapılabilir.

---

## Wiki Bağlantıları

- [[calisma-yontemleri-analizi#Ö2 — Translation Pendulum]] — orijinal öneri
- [[naval-almanack/index]] · [[paul-graham/index]] — kaynak cümleler
- [[errors/_index|Error Constellation]] — kayıp kelime register'ı için hedef
- [[daily-writing-loop]] — komşu yazma drill'i (taklit + ezberden yaz); pendulum onun çevirmen versiyonu
