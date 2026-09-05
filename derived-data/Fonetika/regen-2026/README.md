# DCS akshara · varṇa · ligature frequency — for teaching Devanāgarī

_Created: 06-07-2026 · Last updated: 05-09-2026_

Regenerated from the **Digital Corpus of Sanskrit** (Oliver Hellwig, CC BY 4.0)
for [gasyoun/Nagari](https://github.com/gasyoun/Nagari) — data to sequence how
students learn the script (most-frequent conjuncts first).

## What this is

A reproducible frequency analysis of the reading surface of the whole DCS corpus
(4,240,775 words across 754,726 sandhied `# text` lines).
Every word is transliterated IAST → SLP1 (one unambiguous char per phoneme) and
segmented into three orthographic units:

| Unit | Definition | Distinct | Total occurrences |
|---|---|--:|--:|
| **akshara** (syllable) | onset cluster + vowel + modifiers `C* V M*`, or a word-final consonant coda | 7,347 | 14,326,647 |
| **varṇa** (letter) | each individual phoneme (consonant / vowel / anusvāra / visarga) | 48 | 31,805,819 |
| **ligature** (conjunct) | a maximal run of ≥2 consonants (rendered as a saṃyoga glyph) | 999 | 3,265,549 |

`ligature2` is the two-consonant subset (417 distinct).

## Files

Each unit ships as two CSVs — **frequency order** (`*_freq.csv`) and traditional
**varṇamālā order** (`*_varnamala.csv`) — with columns Devanāgarī · IAST · SLP1 ·
count · % · per-period counts (`slot1..slot5`).

| Unit | Frequency order | Varṇamālā order |
|---|---|---|
| akshara | [`akshara_freq.csv`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Fonetika/regen-2026/akshara_freq.csv) | [`akshara_varnamala.csv`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Fonetika/regen-2026/akshara_varnamala.csv) |
| varṇa | [`varna_freq.csv`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Fonetika/regen-2026/varna_freq.csv) | [`varna_varnamala.csv`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Fonetika/regen-2026/varna_varnamala.csv) |
| ligature | [`ligature_freq.csv`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Fonetika/regen-2026/ligature_freq.csv) | [`ligature_varnamala.csv`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Fonetika/regen-2026/ligature_varnamala.csv) |
| ligature (2-cons) | [`ligature2_freq.csv`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Fonetika/regen-2026/ligature2_freq.csv) | [`ligature2_varnamala.csv`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Fonetika/regen-2026/ligature2_varnamala.csv) |

Regenerate: `python build_akshara_ligature_freq.py && python make_deliverables.py`.

## Periods

Counts are also split by DCS `dcsTimeSlot` (1 = oldest/Vedic stratum … 5 = latest),
mapped per chapter from `chapter-info.xml`. The legacy Fonetika spreadsheets used
slots 2–5 only; this regeneration keeps all five (18 files had no slot).

---

## Top 30 conjuncts (ligatures) — the teaching priority list

| # | Devanāgarī | IAST | Count | % | Cum % | Cons |
|--:|:--|:--|--:|--:|--:|--:|
| 1 | प्र | pr | 187,951 | 5.76 | 5.8 | 2 |
| 2 | स्य | sy | 125,906 | 3.86 | 9.6 | 2 |
| 3 | त्र | tr | 122,734 | 3.76 | 13.4 | 2 |
| 4 | न्त | nt | 109,857 | 3.36 | 16.7 | 2 |
| 5 | क्ष | kṣ | 102,577 | 3.14 | 19.9 | 2 |
| 6 | त्य | ty | 89,159 | 2.73 | 22.6 | 2 |
| 7 | र्व | rv | 78,286 | 2.40 | 25.0 | 2 |
| 8 | स्त | st | 77,283 | 2.37 | 27.4 | 2 |
| 9 | त्व | tv | 74,883 | 2.29 | 29.7 | 2 |
| 10 | त्त | tt | 55,873 | 1.71 | 31.4 | 2 |
| 11 | स्व | sv | 51,914 | 1.59 | 33.0 | 2 |
| 12 | श्च | śc | 51,333 | 1.57 | 34.5 | 2 |
| 13 | व्य | vy | 51,222 | 1.57 | 36.1 | 2 |
| 14 | ष्ट | ṣṭ | 49,682 | 1.52 | 37.6 | 2 |
| 15 | र्य | ry | 49,153 | 1.51 | 39.1 | 2 |
| 16 | क्त | kt | 48,172 | 1.48 | 40.6 | 2 |
| 17 | स्म | sm | 47,253 | 1.45 | 42.1 | 2 |
| 18 | न्य | ny | 47,210 | 1.45 | 43.5 | 2 |
| 19 | द्य | dy | 42,231 | 1.29 | 44.8 | 2 |
| 20 | र्म | rm | 41,865 | 1.28 | 46.1 | 2 |
| 21 | द्ध | ddh | 41,422 | 1.27 | 47.3 | 2 |
| 22 | द्व | dv | 41,420 | 1.27 | 48.6 | 2 |
| 23 | श्र | śr | 39,771 | 1.22 | 49.8 | 2 |
| 24 | क्र | kr | 38,431 | 1.18 | 51.0 | 2 |
| 25 | ज्ञ | jñ | 38,043 | 1.17 | 52.2 | 2 |
| 26 | द्र | dr | 36,444 | 1.12 | 53.3 | 2 |
| 27 | न्न | nn | 33,650 | 1.03 | 54.3 | 2 |
| 28 | स्थ | sth | 32,945 | 1.01 | 55.3 | 2 |
| 29 | श्व | śv | 32,716 | 1.00 | 56.3 | 2 |
| 30 | ब्र | br | 32,584 | 1.00 | 57.3 | 2 |

## Top 25 two-consonant conjuncts

| # | Devanāgarī | IAST | Count | % | Cum % | Cons |
|--:|:--|:--|--:|--:|--:|--:|
| 1 | प्र | pr | 187,951 | 6.12 | 6.1 | 2 |
| 2 | स्य | sy | 125,906 | 4.10 | 10.2 | 2 |
| 3 | त्र | tr | 122,734 | 4.00 | 14.2 | 2 |
| 4 | न्त | nt | 109,857 | 3.58 | 17.8 | 2 |
| 5 | क्ष | kṣ | 102,577 | 3.34 | 21.1 | 2 |
| 6 | त्य | ty | 89,159 | 2.91 | 24.1 | 2 |
| 7 | र्व | rv | 78,286 | 2.55 | 26.6 | 2 |
| 8 | स्त | st | 77,283 | 2.52 | 29.1 | 2 |
| 9 | त्व | tv | 74,883 | 2.44 | 31.6 | 2 |
| 10 | त्त | tt | 55,873 | 1.82 | 33.4 | 2 |
| 11 | स्व | sv | 51,914 | 1.69 | 35.1 | 2 |
| 12 | श्च | śc | 51,333 | 1.67 | 36.7 | 2 |
| 13 | व्य | vy | 51,222 | 1.67 | 38.4 | 2 |
| 14 | ष्ट | ṣṭ | 49,682 | 1.62 | 40.0 | 2 |
| 15 | र्य | ry | 49,153 | 1.60 | 41.6 | 2 |
| 16 | क्त | kt | 48,172 | 1.57 | 43.2 | 2 |
| 17 | स्म | sm | 47,253 | 1.54 | 44.7 | 2 |
| 18 | न्य | ny | 47,210 | 1.54 | 46.3 | 2 |
| 19 | द्य | dy | 42,231 | 1.38 | 47.7 | 2 |
| 20 | र्म | rm | 41,865 | 1.36 | 49.0 | 2 |
| 21 | द्ध | ddh | 41,422 | 1.35 | 50.4 | 2 |
| 22 | द्व | dv | 41,420 | 1.35 | 51.7 | 2 |
| 23 | श्र | śr | 39,771 | 1.30 | 53.0 | 2 |
| 24 | क्र | kr | 38,431 | 1.25 | 54.3 | 2 |
| 25 | ज्ञ | jñ | 38,043 | 1.24 | 55.5 | 2 |

## Top 30 aksharas (syllables)

| # | Devanāgarī | IAST | Count | % | Cum % |
|--:|:--|:--|--:|--:|--:|
| 1 | त | ta | 389,843 | 2.72 | 2.7 |
| 2 | व | va | 355,259 | 2.48 | 5.2 |
| 3 | म् | m | 339,486 | 2.37 | 7.6 |
| 4 | स | sa | 285,415 | 1.99 | 9.6 |
| 5 | य | ya | 277,383 | 1.94 | 11.5 |
| 6 | म | ma | 272,370 | 1.90 | 13.4 |
| 7 | अ | a | 269,327 | 1.88 | 15.3 |
| 8 | न | na | 269,172 | 1.88 | 17.2 |
| 9 | प | pa | 245,142 | 1.71 | 18.9 |
| 10 | र | ra | 233,447 | 1.63 | 20.5 |
| 11 | ति | ti | 205,258 | 1.43 | 21.9 |
| 12 | च | ca | 178,343 | 1.24 | 23.2 |
| 13 | वि | vi | 176,297 | 1.23 | 24.4 |
| 14 | वा | vā | 162,930 | 1.14 | 25.5 |
| 15 | क | ka | 158,069 | 1.10 | 26.6 |
| 16 | द | da | 138,310 | 0.97 | 27.6 |
| 17 | प्र | pra | 132,266 | 0.92 | 28.5 |
| 18 | त् | t | 131,141 | 0.92 | 29.5 |
| 19 | मा | mā | 130,821 | 0.91 | 30.4 |
| 20 | ह | ha | 128,833 | 0.90 | 31.3 |
| 21 | ते | te | 128,099 | 0.89 | 32.2 |
| 22 | ता | tā | 126,403 | 0.88 | 33.0 |
| 23 | ना | nā | 126,198 | 0.88 | 33.9 |
| 24 | रा | rā | 120,064 | 0.84 | 34.8 |
| 25 | नि | ni | 114,122 | 0.80 | 35.6 |
| 26 | श | śa | 109,526 | 0.76 | 36.3 |
| 27 | न् | n | 102,459 | 0.72 | 37.0 |
| 28 | ग | ga | 101,729 | 0.71 | 37.7 |
| 29 | या | yā | 100,813 | 0.70 | 38.4 |
| 30 | इ | i | 100,374 | 0.70 | 39.2 |

## All varṇas by frequency-in-corpus (varṇamālā order)

| # | Devanāgarī | IAST | Count | % | Cum % |
|--:|:--|:--|--:|--:|--:|
| 1 | अ | a | 6,267,173 | 19.70 | 19.7 |
| 2 | आ | ā | 2,441,708 | 7.68 | 27.4 |
| 3 | इ | i | 1,502,169 | 4.72 | 32.1 |
| 4 | ई | ī | 324,006 | 1.02 | 33.1 |
| 5 | उ | u | 808,917 | 2.54 | 35.7 |
| 6 | ऊ | ū | 180,187 | 0.57 | 36.2 |
| 7 | ऋ | ṛ | 243,902 | 0.77 | 37.0 |
| 8 | ॠ | ṝ | 1,946 | 0.01 | 37.0 |
| 9 | ऌ | ḷ | 2 | 0.00 | 37.0 |
| 10 | ए | e | 899,825 | 2.83 | 39.8 |
| 11 | ऐ | ai | 191,205 | 0.60 | 40.4 |
| 12 | ओ | o | 505,648 | 1.59 | 42.0 |
| 13 | औ | au | 77,932 | 0.24 | 42.3 |
| 14 | ं | ṃ | 738,014 | 2.32 | 44.6 |
| 15 | ः | ḥ | 495,873 | 1.56 | 46.2 |
| 16 | क् | k | 751,962 | 2.36 | 48.5 |
| 17 | ख् | kh | 56,039 | 0.18 | 48.7 |
| 18 | ग् | g | 327,030 | 1.03 | 49.7 |
| 19 | घ् | gh | 39,994 | 0.13 | 49.8 |
| 20 | ङ् | ṅ | 46,283 | 0.15 | 50.0 |
| 21 | च् | c | 435,613 | 1.37 | 51.4 |
| 22 | छ् | ch | 46,128 | 0.14 | 51.5 |
| 23 | ज् | j | 311,462 | 0.98 | 52.5 |
| 24 | झ् | jh | 838 | 0.00 | 52.5 |
| 25 | ञ् | ñ | 72,013 | 0.23 | 52.7 |
| 26 | ट् | ṭ | 97,099 | 0.31 | 53.0 |
| 27 | ठ् | ṭh | 37,566 | 0.12 | 53.1 |
| 28 | ड् | ḍ | 47,804 | 0.15 | 53.3 |
| 29 | ढ् | ḍh | 7,633 | 0.02 | 53.3 |
| 30 | ण् | ṇ | 320,629 | 1.01 | 54.3 |
| 31 | त् | t | 2,176,895 | 6.84 | 61.2 |
| 32 | थ् | th | 200,406 | 0.63 | 61.8 |
| 33 | द् | d | 785,509 | 2.47 | 64.3 |
| 34 | ध् | dh | 309,897 | 0.97 | 65.2 |
| 35 | न् | n | 1,295,525 | 4.07 | 69.3 |
| 36 | प् | p | 854,608 | 2.69 | 72.0 |
| 37 | फ् | ph | 18,154 | 0.06 | 72.1 |
| 38 | ब् | b | 138,931 | 0.44 | 72.5 |
| 39 | भ् | bh | 345,198 | 1.09 | 73.6 |
| 40 | म् | m | 1,219,508 | 3.83 | 77.4 |
| 41 | य् | y | 1,327,363 | 4.17 | 81.6 |
| 42 | र् | r | 1,766,267 | 5.55 | 87.1 |
| 43 | ल् | l | 289,868 | 0.91 | 88.0 |
| 44 | व् | v | 1,346,021 | 4.23 | 92.3 |
| 45 | श् | ś | 474,369 | 1.49 | 93.8 |
| 46 | ष् | ṣ | 468,350 | 1.47 | 95.2 |
| 47 | स् | s | 1,105,336 | 3.48 | 98.7 |
| 48 | ह् | h | 407,014 | 1.28 | 100.0 |

---

## Cross-check vs legacy `Все лигатуры.xlsx`

Legacy distinct ligatures (union of numeric sheets): **1047**. Regenerated distinct: **999**. Top-20 overlap: **19/20**.

| # | mine (IAST) | count | legacy rank | legacy Σabs |
|--:|:--|--:|--:|--:|
| 1 | प्र pr | 187,951 | 1 | 125,343 |
| 2 | स्य sy | 125,906 | 3 | 87,068 |
| 3 | त्र tr | 122,734 | 2 | 90,357 |
| 4 | न्त nt | 109,857 | 5 | 71,809 |
| 5 | क्ष kṣ | 102,577 | 4 | 73,994 |
| 6 | त्य ty | 89,159 | 8 | 55,958 |
| 7 | र्व rv | 78,286 | 7 | 59,146 |
| 8 | स्त st | 77,283 | 6 | 62,019 |
| 9 | त्व tv | 74,883 | 9 | 52,010 |
| 10 | त्त tt | 55,873 | 11 | 40,857 |
| 11 | स्व sv | 51,914 | 16 | 34,447 |
| 12 | श्च śc | 51,333 | 10 | 45,102 |
| 13 | व्य vy | 51,222 | 13 | 36,539 |
| 14 | ष्ट ṣṭ | 49,682 | 15 | 35,044 |
| 15 | र्य ry | 49,153 | 17 | 34,335 |
| 16 | क्त kt | 48,172 | 12 | 38,795 |
| 17 | स्म sm | 47,253 | 20 | 32,379 |
| 18 | न्य ny | 47,210 | 14 | 35,483 |
| 19 | द्य dy | 42,231 | 23 | 30,575 |
| 20 | र्म rm | 41,865 | 18 | 33,705 |
| 21 | द्ध ddh | 41,422 | 19 | 32,418 |
| 22 | द्व dv | 41,420 | 22 | 30,582 |
| 23 | श्र śr | 39,771 | 21 | 31,130 |
| 24 | क्र kr | 38,431 | 25 | 29,446 |
| 25 | ज्ञ jñ | 38,043 | 26 | 26,027 |

## Provenance

Source: DCS CoNLL-U mirror, see ../PROVENANCE.md (commit 04e0778…, pin 2026-03-05). Input: # text = surface (sandhied) lines, files/**/*.conllu.
Transliteration: IAST -> SLP1 via indic_transliteration; Devanagari for display. Generated by
[`build_akshara_ligature_freq.py`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Fonetika/regen-2026/build_akshara_ligature_freq.py) in 480.9s.
Fully reproducible, offline.

_Dr. Mārcis Gasūns_
