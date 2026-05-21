---
title: Word Bank — Master Pool
type: tracking
tags: [tracking, vocabulary, srs]
related: [[_index]], [[srs-state]]
created: 2026-05-18
updated: 2026-05-18
---

# Word Bank — Kullanıcı Tarafından Kaydedilen Havuz

Kullanıcı motorlarda "💾 Save to Bank" butonuna bastığında ilgili öğe (kelime, phrasal verb veya chunk) buraya eklenir. `vocab-srs.html` bu listeden kart oluşturur.

## Tablo

| Item | Tip | İlk eklendi | Kaynak | Definition (EN) | Definition (TR) | Example | Status |
|------|-----|-------------|--------|-----------------|-----------------|---------|--------|

| tried | word | 2026-05-20 | grammar-first-lesson-02 | to have made an attempt or effort to do something | denemek (geçmiş) | "He tried to wave at the driver, but it was no use." | new |
| plaque | word | 2026-05-20 | grammar-first-lesson-02 | a flat piece of metal or stone fixed to a wall to commemorate a person, event, or building | plaket, anıt levha | "She stopped to read a small plaque on a building that had once been a power station." | new |
| leading | word | 2026-05-20 | grammar-first-lesson-02 | most important or in first position; guiding a group | önde gelen, baş, rehberlik eden | "A guide who was leading a small tour said the top-floor view was worth seeing." | new |
| cinnamon | word | 2026-05-20 | grammar-first-lesson-02 | a brown spice with a warm, sweet flavour, made from the inner bark of a tropical tree | tarçın | "A small cafe that smelled of cinnamon pulled them in." | new |
| carrot | word | 2026-05-20 | grammar-first-lesson-02 | a long, orange root vegetable eaten as food | havuç | "She told me I should try the carrot cake." | new |
| ease | word | 2026-05-20 | grammar-first-lesson-02 | freedom from difficulty, effort, or discomfort; a relaxed, natural feeling | rahatlık, kolaylık | "She said that she had never felt more at ease in a foreign city." | new |

## Şema (her `word_bank_add` JSON'undan gelen alanlar)

```json
{
  "item": "fall back on",
  "type": "phrasal_verb",            // word | phrasal_verb | chunk
  "definition_en": "to use as a reserve when other plans fail",
  "definition_tr": "yedek planda kullanmak",
  "example": "If the deal fails, we'll fall back on the original budget.",
  "source": {
    "engine": "text-first",
    "session_id": "2026-05-18-1430-text-first",
    "topic": "modal-verbs"
  },
  "first_seen": "2026-05-18"
}
```

## Status alanı

| Status | Anlam | Eylem |
|--------|-------|-------|
| `new` | yeni eklendi, SRS'e girmemiş | bir sonraki vocab-srs açılışında karta dönüşür |
| `learning` | SRS aktif, interval < 7 gün | her gün ihtimal |
| `young` | SRS aktif, interval 7-30 gün | haftalık |
| `mature` | SRS aktif, interval > 30 gün | aylık |
| `suspended` | kullanıcı askıya aldı | gösterilmez |
| `leech` | 8+ defa "again" geldi | tekrar kaynağa konsolidasyon önerilir |

## Üretim Köprüsü (önemli)

Bu havuzdaki **henüz mature olmamış** öğeler, Motor B (text-first) her gün metin üretirken **mümkünse içine yerleştirilir** (önceliği günün gramer konularına bozmadan). Böylece kelime sadece kart üzerinden değil, gerçek bağlamda tekrar görülmüş olur.
