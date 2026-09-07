---
title: Pollakhōs Atlası
type: artifact
tags: [artifact, meta-grammar, pattern, interactive, form-first]
related: [[form-first-pattern-atlas]], [[Passive Voice Concept]], [[Causative]], [[Conditionals Concept]], [[Wish If Only]], [[Gerunds and Infinitives]], [[Reported Speech Concept]], [[Cleft Sentences Concept]], [[Modal Verbs Concept]], [[Used To Would]], [[Be Used To Get Used To]], [[Participle Clauses]], [[Relative Clauses]], [[Possessives]], [[Plural Nouns]], [[Pronouns]]
created: 2026-09-02
updated: 2026-09-02
---

# Pollakhōs Atlası

**Dosya:** `Artifacts/pollakhos-atlas.html` (tek dosya, bağımlılıksız)
**Yayın:** https://claude.ai/code/artifact/bc05c70f-b7d4-4748-8261-52715859b0c6
**Kaynak ilke:** [[form-first-pattern-atlas]]

## Ne yapar

Vault'taki ilk **form-önce** araç. Konuları değil formları merkeze alır: bir formu dikey olarak bütün işlevlerine, bir işlevi yatay olarak bütün formlarına açar. Aristoteles'in *pollakhōs legetai* ("çok şekilde söylenir") ilkesinin gramer karşılığı.

## Kapsam

- **11 omurga (form):** V3 · HAVE · -ING · TO · WOULD · GET · THAT · -S · IT · AS · V2
- **82 ayrı işlev**, her biri: kalıp + İngilizce örnek (form vurgulu) + Türkçe karşılık + hata/ayrım notu
- **13 işlev alanı**, **50 dolu kesişim**

## Beş mod

| Mod | Ne yapar |
|-----|----------|
| **Dikey — Omurga** | Ramist küme parantezi diyagramı; form → dallanan işlevler. Her dalın ayrıntı panelinde "yatay bağ": aynı işi yapan başka formlara tek tıkla geçiş |
| **Yatay — Alan** | İşlev seç → o işi yapan bütün formlar yan yana; alan başına karşılaştırma notu |
| **Kesişim** | 11×13 matris; hücreye tıkla → o formun o alandaki bütün işleri |
| **Uzaklık Yasası** | 5 adımlı interaktif ölçek; aynı `went` formunun zaman → aktarım → gerçeklik → arzu → nezaket boyunca uzaklaşması |
| **Av** | 10 soruluk tanıma oyunu; cümledeki işaretli form hangi işi yapıyor? Skor + seri + en iyi (localStorage) + kaçırılanlar listesi |

## Teknik

Tek dosya HTML/CSS/JS, kütüphanesiz. Veri tek kaynaktan (`SPINES`) türetilir — dikey görünüm, yatay görünüm, matris ve quiz **aynı veriden** üretilir, bu yüzden çelişemezler. Açık/koyu tema (sistem + manuel), `localStorage` (son sekme, tema, en iyi skor), tam klavye erişimi, `prefers-reduced-motion`.

**Tasarım dili:** 16. yy Ramus bracket diyagramı + tezhip paleti (mürekkep-lacivert zemin, altın varak, lapis). Tipografi: EB Garamond (Yunanca destekli) + Archivo + IBM Plex Mono.

## Bağlantılar

Atlas mevcut concept sayfalarını **yeniden indeksler**, onların yerine geçmez:

- V3 dalları → [[Passive Voice Concept]], [[Causative]], [[Participle Clauses]], [[Conditionals Concept]], [[Passive Infinitives and Gerunds]]
- HAVE dalları → [[Causative]], [[Modal Verbs Concept]], [[Present Perfect]]
- -ING dalları → [[Gerunds and Infinitives]], [[Participle Clauses]], [[Relative Clauses]]
- TO dalları → [[Gerunds and Infinitives]], [[Be Used To Get Used To]], [[Fixed Prepositions]]
- WOULD / V2 dalları → [[Conditionals Concept]], [[Wish If Only]], [[Used To Would]], [[Reported Speech Concept]], [[Subjunctive]]
- IT dalları → [[Cleft Sentences Concept]], [[Pronouns]], [[Emphasis]]
- -S dalları → [[Plural Nouns]], [[Possessives]], [[Present Simple]]
- AS dalları → [[Comparison]], [[Subordinating Conjunctions]], [[Adverbial Clauses]]

## Sonraki adım

Av modunun kaçırılan dalları [[errors/_index|Error Constellation]]'a besleyecek şekilde JSON köprüsüne bağlanabilir (`00_INBOX/` deseni). Ayrıca ikinci parti omurga adayları: `MAKE` · `THERE` · `-ED` · `ONE` · `SO` · `EVER`.
