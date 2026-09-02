---
title: Kelime Pasaportu
type: artifact
tags: [vocabulary, method, kant, schema, srs, retrieval, single-file-html]
related: [[apriori-kelime-yontemi]], [[vocab-srs]], [[word-bank-master|wiki/tracking/word-bank-master]], [[calisma-yontemleri-analizi]], [[_index|Practice Hub]]
created: 2026-09-02
updated: 2026-09-02
---

# Kelime Pasaportu

`Artifacts/kelime-pasaportu.html` · tek dosya, vanilla JS, bağımlılıksız.
Yöntemin tam gerekçesi: [[apriori-kelime-yontemi]].

**Tek cümle:** Kelime, beş önsel formdan (uzam · zaman · derece · bağ · kip) mühür almadan deneyime giremez; mühürlerden sonra kendi şema cümlenle üretilir.

---

## Beş sekme

| Sekme | İşi |
|-------|-----|
| **Atlas** | 12 sabit sahnenin ızgarası. Her sahnede kaç kelime yaşıyor, kaçının vadesi gelmiş (kırmızı pip). İlerleme burada **sahne dolumu** olarak gösterilir, `n/9000` olarak değil. |
| **Gümrük** | Beş mühürlü pasaport sihirbazı + şematizm adımı. Sol rayda mühürler; tamamlanan mühür damgalanır (eğik, oksit kırmızısı). Beş mühür tamamlanmadan "Mühürle" açılmaz. |
| **Devriye** | Form üzerinden geri çağırma. 5 çağrı tipi rastgele: uzam / derece / bağ / kip / şema. Self-grade → SM-2 sadeleştirilmiş takvim. |
| **Defter** | Tüm dosyalar; sahne + metin süzgeci, vade sıralı. JSON dışa/içe aktarma. |
| **Yöntem** | Gerekçe metni — teşhis, beş mühür, şematizm, düzenleyici ide düzeltmesi, günlük ritim. |

---

## Zorunlu kısıtlar (yöntemin kendisi)

- Beş mührün **hepsi** dolmadan kelime kaydedilemez.
- Şema cümlesi üç testten geçer: kelimenin kendisi geçecek · `I / my / me` geçecek (**Ben-testi**) · ≥ 6 kelime.
- Günlük kota göstergesi **3**; küçük ve bitirilebilir gün için bilerek düşük.
- Devriyede kelime hiç sorulmaz — sadece formu verilir, kelimeyi kullanıcı üretir.

---

## Veri modeli

```json
{
  "id": "w...",
  "term": "linger", "pos": "verb", "tr": "oyalanmak, geç ayrılmak",
  "source": "Les Misérables Ch07",
  "space":  { "scene": "kafe", "detail": "boşalmış fincanın yanında oturduğum masa" },
  "time":   { "when": "akşam", "aspect": "süreç" },
  "degree": { "weaker": "stay", "stronger": "loiter", "opposite": "rush off" },
  "bond":   { "cause": "gitmek istememek", "effect": "vaktin fark edilmeden akması",
              "coll": ["linger over coffee", "the smell lingered"] },
  "mode":   { "register": "nötr", "certainty": "olası" },
  "schema": "I lingered in the cafe for an hour because I did not want to go home yet.",
  "srs":    { "ef": 2.5, "interval": 6, "reps": 2, "lapses": 0, "due": "2026-09-08" }
}
```

**Depo:** `localStorage['apriori-vocab-v1']`. Özel sekmede yazma sessizce atlanır (oturum içi çalışır, kalıcı olmaz).

## JSON köprüsü

Export şeması `apriori-vocab-1.0`, dosya adı `YYYY-MM-DD-kelime-pasaportu.json` → `00_INBOX/` → Claude Code işler:
`counts` · `streak` · `words[]` · `instructions_for_claude_code`.
İçe aktarma **birleştirir** (aynı `term` varsa atlanır), üzerine yazmaz.

---

## Seed içerik

10 tam mühürlü örnek kelime, hepsi vault kaynaklarından damıtılmış — Defter'de `örnek` etiketiyle işaretli, silinebilir:
`plateau` · `cue` (Atomic Habits) · `linger` (Les Misérables) · `blunt` · `leverage` (Naval) · `threshold` (Thinking Fast and Slow) · `restless` (Crime and Punishment) · `brittle` (Decameron) · `ease` (Lesson 02) · `stubborn` (Don Quixote)

Uygulama boş kabuk olarak açılmaz; ilk bakışta ne yaptığı görünür.

---

## Tasarım kararları

- **Belge estetiği, kart estetiği değil.** Gümrük evrağı: ince kural çizgileri, mono etiketler, 2px köşe. Yuvarlaklık yalnızca mühürlerde — tek yuvarlak nesne odur.
- **Palet:** Prusya mavisi `#1E3F72` (ana) + oksit kırmızısı `#8E2433` (onay mürekkebi). Nötrler maviye çalar.
- **Tipografi:** Spectral (serif başlık) · Karla (gövde) · IBM Plex Mono (mühür etiketleri, sayılar, sahne kodları `S·01`).
- **Sahne kodları** ikon değil, kayıt numarasıdır — belge mantığının parçası, süs değil.
- Üç temalı: açık · koyu · sistem (data-theme damgası + `prefers-color-scheme`).

---

## [[vocab-srs]] ile ilişkisi

Aynı SM-2 formülünü paylaşırlar, birbirinin yerini almazlar:

| | vocab-srs | Kelime Pasaportu |
|---|---|---|
| Girdi | word bank'tan otomatik | elle, beş mühürle |
| Soru | kelime → anlam (tanıma) | form → kelime (üretim) |
| Hız | çok kelime, hızlı | az kelime, derin |
| Rolü | geniş pasif dağarcık | çekirdek aktif dağarcık |

Öneri: pasif hacim `vocab-srs`'te kalsın; **aktif üretime girmesini istediğin** kelimeler pasaporta alınsın.

---

## Genişletme yol haritası

1. Sahne başına 25 kelime eşiği → alt sahne bölme uyarısı
2. Phrasal verb için ayrılabilirlik (separable/inseparable) altıncı formu
3. `wiki/vocabulary/[sahne].md` otomatik üretimi (JSON köprüsünden)
4. L1 Production Cell entegrasyonu: "bugün şu sahnedeki 5 kelimeyle yaz" constraint'i
5. Şema cümlesi tazeleme turu (6 ay dolan cümleler için)
