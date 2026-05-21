---
title: INBOX — JSON Köprüsü
type: tracking
updated: 2026-05-18
---

# 00_INBOX — JSON Köprüsü

HTML uygulamalarından inen `.json` dosyaları **buraya** düşer. Claude Code bu klasörü her oturumda tarar, içerikleri wiki'ye sentezler, sonra `_archive/YYYY-MM/` altına taşır.

## Akış

```
[HTML uygulama] → "Vault'a İndir" → indirilenler/*.json
                                         ↓ (sürükle bırak)
                                  00_INBOX/*.json
                                         ↓ (Claude Code okur)
                              wiki/tracking/*.md güncellenir
                                         ↓
                              00_INBOX/_archive/YYYY-MM/
```

## Beklenen JSON tipleri

| `type` alanı | Üretici | Hedef |
|--------------|---------|-------|
| `session_grammar_first` | `grammar-first-daily.html` | `grammar-coverage.md` |
| `session_text_first` | `text-first-daily.html` | `grammar-coverage.md` |
| `word_bank_add` | her iki motor (Save to Bank butonu) | `word-bank-master.md` |
| `srs_review` | `vocab-srs.html` | `srs-state.md` |
| `weak_focus_session` | haftalık zayıf-konu modu | `weak-topics.md` |

## Şema garantileri

Her JSON şu alanlarla başlar:

```json
{
  "schema_version": "1.0",
  "type": "...",
  "timestamp": "2026-05-18T14:32:00+03:00",
  "engine": "grammar-first | text-first | vocab-srs",
  "payload": { ... }
}
```

Tek dosyaya birden fazla `record` koyabilir (array). Claude Code okurken `payload[]` üzerinden döner.

## Claude Code'a not

INBOX'a yeni `.json` düştüğünde:

1. **Sırayla oku** — eski tarihliyi önce işle (dosya adı `YYYY-MM-DD-HHmm-<engine>.json` formatında).
2. **Tip switch** — `type` alanına göre ilgili tracking dosyasını güncelle.
3. **Çelişki politikası** — daha eski bir kayıt yeni kaydı geçersiz kılmıyorsa üstüne yazma, append et.
4. **Arşivle** — işlendikten sonra `_archive/YYYY-MM/` altına taşı.
5. **Log** — `log.md`'ye `inbox-process` tipinde bir giriş ekle.

İşlenen dosya silinmez, taşınır. Geri dönüş için kanıt kalsın.
