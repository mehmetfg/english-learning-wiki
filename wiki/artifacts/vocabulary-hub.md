---
title: Vocabulary Hub
type: artifact
tags: [vocabulary, cefr, dictionary, tracking, morphology, audio]
related: [[Word Formation]], [[CEFR Curriculum Map]], [[Phrasal Verbs Hub]]
created: 2026-05-01
updated: 2026-05-01
---

# Vocabulary Hub

**Dosya:** `Artifacts/vocabulary-hub.html`

3000 kelimelik (şu an 260 seed kelime) İngilizce-İngilizce sözlük + CEFR seviyesi takip sistemi.

---

## Özellikler

| Özellik | Detay |
|---------|-------|
| **Kelime sayısı** | 260 seed (A1→C2); sistem 3000'e kadar ölçeklenir |
| **Tanım formatı** | İngilizce–İngilizce (EN–EN) |
| **Ses** | Web Speech API — tarayıcı yerleşik, internet gerektirmez |
| **Takip** | localStorage — öğrenildi / yıldızlandı |
| **Filtreleme** | CEFR seviyesi, öğrenildi/öğrenilmedi/yıldızlı, arama |
| **Kelime kartı** | Tanım · Örnek cümle · Eş anlamlılar (yeşil) · Zıt anlamlılar (kırmızı) · Etimoloji/morfoloji ipucu (mavi) |
| **İlerleme** | Header'da seviye bazlı bar grafik |

---

## Kelime Dağılımı (Mevcut Seed)

| Seviye | Kelime | Hedef |
|--------|--------|-------|
| A1 | 50 | 500 |
| A2 | 37 | 600 |
| B1 | 39 | 700 |
| B2 | 30 | 600 |
| C1 | 20 | 400 |
| C2 | 10 | 200 |
| **Toplam** | **186** | **3000** |

---

## Kelime Kartı Anatomisi

Her kart şunları içerir:

1. **Kelime** + CEFR rozeti + 🔊 seslet + ⭐ yıldız
2. **Tanım** — İngilizce–İngilizce, net ve kısa
3. **Örnek cümle** — italik, gerçekçi bağlam
4. **Eş anlamlılar** — yeşil tag'ler
5. **Zıt anlamlılar** — kırmızı tag'ler
6. **Morfoloji ipucu** — mavi sol kenarlık; kök + prefix/suffix açıklaması
7. **Öğrenildi butonu** — tıklayınca localStorage'a kaydeder

---

## Genişletme Planı

Kelime listesini büyütmek için iki yöntem:

### Yöntem 1: Oturumda kelime ekleme
Her çalışma oturumunda 20–50 yeni kelime istenilebilir:
> "B1 seviyesinde 30 yeni kelime ekle: collocations temasında"

### Yöntem 2: Tematik set ekleme
Temaya göre kelime ailesi olarak ekle:
- İş/kariyer kelimeleri (B1-B2)
- Akademik kelime listesi (AWL) — B2-C1
- IELTS/TOEFL vocabulary — B2-C1
- Duygu/karakter kelimeleri

---

## NotebookLM Entegrasyon Akışı

NotebookLM'den kelime verisi çekmek için:

1. NotebookLM'de ilgili üniteyi aç
2. "Bu ünitedeki B1 düzeyinde anahtar kelimeleri listele: kelime, EN tanım, eş anlam, zıt anlam, etimoloji" şeklinde sor
3. Çıktıyı bu oturuma yapıştır
4. Vocabulary Hub'a eklenmesi istenilebilir

---

## İlgili Sayfalar

- [[Word Formation]] — prefix/suffix/kök rehberi (morfoloji ipuçlarının kaynağı)
- [[CEFR Curriculum Map]] — seviye haritası
- [[Phrasal Verbs Hub]] — phrasal verb takip aracı
