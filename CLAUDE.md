# CLAUDE.md — English Learning Wiki: İşletim El Kitabı

## 0. Birinci Kural (tartışmaya kapalı)

Her cevaptan **ÖNCE**:
1. `index.md` oku
2. İlgili wiki sayfalarını bağlama çek ve oku
3. Sonra cevap ver

Her anlamlı alışverişten **SONRA**:
1. İlgili wiki sayfalarını güncelle
2. `index.md`'yi güncelle (gerekirse)
3. `log.md`'ye giriş ekle

**İzin sorma. Vault'u doğrudan güncelle.**  
Yalnızca geri dönüşü olmayan işlemlerden önce sor: sayfa silme, klasör taşıma, büyük yeniden yapılandırma.

---

## 1. Dizin Yapısı

```
/
├── CLAUDE.md              # Bu dosya — işletim el kitabı
├── index.md               # Wiki içerik dizini (her ingest'te güncelle)
├── log.md                 # Kronolojik kayıt (append-only)
├── raw/                   # Değişmez kaynaklar (dokunma, sadece oku)
│   └── [makaleler, PDF'ler, notlar, yapıştırılan içerikler]
├── wiki/                  # Senin alanın — tüm sentez burada
│   ├── artifacts/         # Her HTML artifact için kayıt sayfaları
│   ├── concepts/          # Gramer kavramları, dilbilgisi konuları
│   ├── vocabulary/        # Kelime grupları, tema bazlı listeler
│   ├── synthesis/         # Karşılaştırmalar, analizler, sentez
│   ├── sources/           # Ingest edilen kaynaklar
│   ├── practice/          # 5-lane output system (cells/shadow/dialogues/drills/retrieval/errors)
│   └── portfolio/         # Haftalık curated, polished works
└── Artifacts/             # Ham HTML araçları (içeriğe dokunma)
    └── _dashboard.html    # Artifact yönetim arayüzü
```

---

## 2. Sayfa Şablonu

Her wiki sayfası şu frontmatter ile başlar:

```yaml
---
title: [Sayfa başlığı]
type: [artifact | concept | vocabulary | synthesis | source]
tags: [grammar, tenses, vocabulary, ...]
related: [[Bağlantılı Sayfa 1]], [[Bağlantılı Sayfa 2]]
created: YYYY-MM-DD
updated: YYYY-MM-DD
---
```

---

## 3. Dil Kuralı

- **Kavram adları**: İngilizce (Present Perfect, Passive Voice, Reported Speech…)
- **Açıklamalar ve notlar**: Türkçe
- **Örnekler**: İngilizce cümle + Türkçe açıklama yan yana
- **Frontmatter alanları**: İngilizce

---

## 4. Wikilink Kuralları

- Her ilk geçişte bağlantı kur: `[[Present Perfect]]`
- Çift yönlü bağlantı zorunlu — A→B varsa B sayfasında da A'ya link olmalı
- Artifact sayfaları concept sayfalarına bağlanmalı; concept sayfaları da ilgili artifact'lara geri dönmeli
- Wikilink'te Türkçe açıklama kullanmak istersen: `[[Present Perfect|Geniş Zaman Tamamlanmış]]`

---

## 5. Artifact Yönetimi

Her HTML artifact için iki şey olmalı:
1. `wiki/artifacts/[slug].md` — içeriği, kapsamı, ilişkileri açıklayan wiki kaydı
2. `Artifacts/_dashboard.html` — artifact'ları listeleyen, açan, filtreleyen arayüz

**Yeni artifact geldiğinde:**
1. `wiki/artifacts/[slug].md` oluştur
2. `Artifacts/_dashboard.html`'i güncelle (kartı ekle)
3. `index.md`'deki Artifacts bölümünü güncelle
4. `log.md`'ye kaydet

---

## 6. Ingest Akışı

Yeni kaynak geldiğinde (makale, PDF, not, web linki, konuşma özeti, yapıştırılan metin):

1. Kaynağı oku
2. Temel çıkarımlar üzerine kullanıcıyla kısa tartış (isteğe bağlı)
3. `wiki/sources/[başlık].md` oluştur
4. İlgili concept/vocabulary sayfalarını güncelle
5. Gerekirse yeni concept/vocabulary sayfaları oluştur
6. `index.md`'yi güncelle
7. `log.md`'ye kaydet

Bir ingest 5–15 sayfaya dokunabilir — bu normaldir. Batch ingest de mümkün, ama tek tek daha verimli.

---

## 7. Query Akışı

Soru geldiğinde:

1. `index.md`'yi oku → ilgili sayfaları belirle
2. Sayfaları bağlama çek ve oku
3. Cevap ver (kaynakları `[[wikilink]]` ile belirt)
4. Cevap wiki'ye değer katıyorsa yeni synthesis sayfası olarak kaydet
5. `log.md`'ye kaydet

---

## 8. Practice Akışı (Output-Centric 5-Lane System)

Pratik talebi geldiğinde (üretim, drill, sohbet, retrieval). Ingest ve Query'e paralel üçüncü ana akış. Detay: [[Practice/Grammer Topics/_index|wiki/practice/_index.md]]

**Beş Şerit:**

| Lane | Tetik kelimeleri | Süre | Output |
|------|------------------|------|--------|
| **L1** Production Cell | "cell", "L1", "today's production" | 15-20 dk | `wiki/practice/cells/YYYY-MM-DD.md` |
| **L2** Shadow Author | "shadow", "X gibi yaz", "style mimicking" | 25-30 dk | `wiki/practice/shadow/YYYY-MM-DD_author.md` |
| **L3** Conversational Loop | "sohbet", "dialogue", "L3 voice" | 30-45 dk | `wiki/practice/dialogues/YYYY-MM-DD_topic.md` |
| **L4** Error Drill | "error drill", "L4", "boss battle" | 20-30 dk | `wiki/practice/drills/YYYY-MM-DD_pattern.md` |
| **L5** Retrieval Carnival | "retrieval", "L5", "spaced" | 15-20 dk | `wiki/practice/retrieval/YYYY-MM-DD.md` |

**Genel akış (her lane için ortak):**
1. Lane tetik kelimesini tanı → `wiki/practice/_index.md`'i oku → lane protokolünü uygula
2. Constraints'i kullanıcıya açıkça duyur (ne kullanılacak)
3. Üretim alınır
4. Annotate: ✅ doğru | ⚠️ güçlendirilebilir | ❌ hata
5. Output dosyasını oluştur (frontmatter zorunlu)
6. Hatalar → `wiki/practice/errors/[pattern].md` frekans sayacını artır
7. `wiki/practice/_index.md` "Bu Haftaki Durum" tablosunu güncelle
8. `log.md`'ye `practice` tipinde giriş ekle

**Constraint felsefesi:** Özgür yazım yerine sınırlandırılmış prompt (örn. "şu 5 phrasal verb'ü kullan"). Hatasızlık değil, kullanmaya zorlama hedefimiz.

**Edge case'ler:**
- 3+ tekrar eden hata → "Boss Battle" L4 mode
- Aynı kelime 3 turda yok → Deep decay list (3 gün L1'de zorunlu)
- Voice friction → text fallback, haftada 1 voice'a indir
- AI praise inflation YAPMA → her output'ta skor + hata sayısı + delta zorunlu

**Haftalık katman:** Pazar [[Portfolio Curation]] — haftanın en iyi paragrafı `wiki/portfolio/` altına cilalanarak arşivlenir.

---

## 9. Lint Akışı (~10 oturumda bir)

Kontrol et:
- Öksüz sayfalar (hiç gelen bağlantısı olmayan)
- Tarihi geçmiş/geçersiz iddialar (yeni kaynaklarla çelişen)
- Kırık wikilink'ler (var olmayan sayfaya bağlantı)
- Sayfası olmayan ama sık geçen kavramlar
- Araştırılması gereken bilgi boşlukları
- **Practice spesifik:** Errors klasöründe graduated olması gerekirken aktif kalan pattern'ler, decay register'da çürüyenler
- Öner: bir sonraki 3 araştırma sorusu

---

## 10. Log Formatı

```
## [YYYY-MM-DD] ingest | Kaynak Başlığı
Özet: Ne eklendi, hangi sayfalar güncellendi, kaç sayfa dokunuldu.

## [YYYY-MM-DD] query | Soru özeti
Özet: Ne soruldu, ne yanıtlandı, wiki'ye eklendi mi.

## [YYYY-MM-DD] practice L1 | Cell başlığı
Özet: Hangi kaynak, hangi target'lar, kaç hata, hangi pattern'ler frekans aldı.

## [YYYY-MM-DD] practice L3 | Dialogue başlığı
Özet: Senaryo, modalite (voice/text), kaçırılan constraint'ler, top 3 hata.

## [YYYY-MM-DD] lint | Lint turu #N
Özet: Bulgular, yapılan düzeltmeler, önerilen sonraki sorular.

## [YYYY-MM-DD] init | Wiki kurulumu
Özet: Başlangıç yapısı oluşturuldu.
```

---

## 11. Çelişki Yönetimi

Eski ve yeni bilgi çelişiyorsa:
- **Üstünü örtme** — her ikisini de tut
- Tarihleri düş
- `> ⚠️ ÇELIŞKI (YYYY-MM-DD): ...` blokquote ekle
- Bir sonraki lint turunda çöz

---

## 12. Learning Output Formatları

Standart wiki sayfaları dışında üretilebilecek formatlar (pilot onaylandıktan sonra aktif):
- Flashcard seti (Obsidian Spaced Repetition formatı)
- Alıştırma sayfası (boşluk doldurma, dönüştürme)
- Mini test (5–10 soru, cevap anahtarlı)
- Diyalog senaryosu (kavramı gerçek konuşmada kullanma)

---

## 13. Yaşayan Belge

Bu dosya taşa kazınmamış. Neyin işlediğini gördükçe güncelle. Her değişiklikten sonra `log.md`'ye kaydet.
