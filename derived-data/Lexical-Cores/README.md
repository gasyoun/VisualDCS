# Lexical-Cores

_Created: 04-07-2026 · Last updated: 10-07-2026_

Frequency dictionaries and "lexical core" vocabulary lists derived from the DCS corpus,
from V.V. Leonchenko's "Цифровой корпус санскрита для исследования лексических ядер
древнеиндийской литературы" ("Digital corpus of Sanskrit for the study of the lexical
cores of ancient Indian literature") study. See the parent
[`../README.md`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/README.md)
for how this folder fits into the wider research archive, and
[`../INDEX.md`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/INDEX.md)
for the size/file-count table.

## Most-frequent-word / core-vocabulary files

All spreadsheets are legacy Excel 97 `.xls` (32-bit row cap of 65,536) except the one
`.xlsx`. Row counts below exclude the header row, i.e. they're word counts.

| File | Words | Notes |
|---|---:|---|
| [Приложение 3. «Частотный словарь корпуса»](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Lexical-Cores/Приложение%203.%20%20%C2%ABЧастотный%20словарь%20корпуса%C2%BB%20(таблица%20MS%20Excel%2097)..xls) | **65,535** | Single overall corpus frequency dictionary (lemma, POS, absolute frequency), ranked by frequency. Fills the `.xls` format's hard 65,536-row cap exactly, with real data in the last row — the underlying list is very likely **longer and got truncated** by the file format, not a natural stopping point. |
| [Prilozhenie-10-Spisok-stabilnoy-yadernoy-leksiki.xls](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Lexical-Cores/Prilozhenie-10-Spisok-stabilnoy-yadernoy-leksiki.xls) | **440** | Приложение 10. «Список стабильной ядерной лексики за всю историю санскритской литературы, отраженную в корпусе». The tightest curated list: lemmas that stay in the "core vocabulary" across every historical period of the corpus (lemma + POS). This is the closest thing to a canonical "most frequent Sanskrit words" list. |
| [Сборное ядро.xlsx](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Lexical-Cores/Сборное%20ядро.xlsx) | **7,532** | Consolidated/merged core (4 cols). |
| [Приложение 5. «Лексические ядра... различных исторических периодов»](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Lexical-Cores/Приложение%205.%20%C2%ABЛексические%20ядра%20санскритской%20литературы%20различных%20исторических%20периодов%C2%BB.xls) | up to 3,493 | Lexical cores broken out **per historical period** — 7 periods × 2 cols (lemma, POS), longest period's column reaches 3,493 words; other periods are shorter and blank-padded in the same sheet. |
| [Приложение 9. «Список выпадающей ядерной лексики...»](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Lexical-Cores/Приложение%209.%20%C2%ABСписок%20выпадающей%20ядерной%20лексики%20в%20различных%20исторических%20периодах%C2%BB.xls) | 392 / 239 / 54 / 453 | 4 sheets (`2 периода`, `3 периода`, `4 периода`, `5 периодов`) — words that **drop out** of the core vocabulary depending on how many periods are compared. |
| [Приложение 2. «Частотные словари текстов...»](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Lexical-Cores/Приложение%202.%20%C2%ABЧастотные%20словари%20текстов%20цифрового%20корпуса%20Санскрита%C2%BB%20(таблица%20%20MS%20Excel%2097)..xls) | up to 22,749 | **Per-text** frequency dictionaries — ~128 texts side by side, 2 cols each (lemma, frequency). Not one list; the longest single text's column reaches 22,749 words. |
| [Приложение 4. «Частотные словари текстов различных исторических периодов»](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Lexical-Cores/Приложение%204.%20%C2%ABЧастотные%20словари%20текстов%20различных%20исторических%20периодов%C2%BB%20(таблица%20%20MS%20Excel%2097)..xls) | up to 53,932 | **Per-period** frequency dictionaries — 11 periods × 2 cols each, longest period's column reaches 53,932 words. |
| [Приложение 11. «Частотные алфавиты...»](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Lexical-Cores/Приложение%2011.%20%C2%ABЧастотные%20алфавиты%20санскритских%20текстов%20различных%20исторических%20периодов%C2%BB.xls) | — | Small summary table (7 rows × 51 cols) of letter/sound frequencies by period, not a word list. |

## Other files in this folder

- [Prilozhenie-1-Dannye-obshchego-parametricheskogo-analiza.xlsx](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Lexical-Cores/Prilozhenie-1-Dannye-obshchego-parametricheskogo-analiza.xlsx) — Приложение 1. «Данные общего параметрического анализа грамматичских характристик корпуса» (таблица MS Excel 97) — general parametric grammar-characteristics analysis.
- [Приложение 12. «Частотная таблица сочетаемости согласных звуков...»](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Lexical-Cores/Приложение%2012.%20%C2%ABЧастотная%20таблица%20сочетаемости%20согласных%20звуков%20в%20санскритских%20текстах%C2%BB.xls) — consonant co-occurrence frequency table.
- [Приложение 13. «Композит Aṣṭādhyāyī III. 2. 142»](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Lexical-Cores/Приложение%2013.%20%C2%ABКомпозит%20Aṣṭādhyāyī%20III.%202.%20142%C2%BB%20(документ%20MS%20Word)..doc) — a single Word-doc case study.
- `Prilozhenie-6.-«Sintagmaticheskie-tablicy-chastotnyh-leksicheskih-yader-razlichnyh-istoricheskih-periodov»/` and `Prilozhenie-7.-«Sintagmaticheskaya-tablica-dlya-vseh-lemm-korpusa»v/` — syntagmatic (collocation) tables, per-period and for all corpus lemmas respectively; unpacked from the `Works-Share-CORES/` zip archives below.
- [`Works-Share-CORES/`](https://github.com/gasyoun/VisualDCS/tree/main/derived-data/Lexical-Cores/Works-Share-CORES) — files recovered from the legacy `Works/Share/CORES` export tree that didn't already duplicate something above: the same syntagmatic tables as zip archives (Приложение 6, Приложение 7) plus a duplicate copy of the source study document.
- The `.doc` file at the folder root — V.V. Leonchenko's study write-up itself (the paper behind all the appendices in this folder).

## File naming

Приложение 1 and Приложение 10 were renamed to short ASCII stems on 10-07-2026
(`Prilozhenie-1-…`, `Prilozhenie-10-…`), matching the convention the `Prilozhenie-6.-…`
and `Prilozhenie-7.-…` folders already use. Their original Russian titles are preserved
in the tables above. The Cyrillic names encoded to 205 and 209 UTF-8 bytes — close to
the 255-byte per-component limit on Linux filesystems that a sibling file had already
crossed, breaking `actions/checkout` for the whole repo. Keep new filenames here short
and ASCII.

## Provenance

Part of [`derived-data/`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/README.md),
the DCS-corpus half of a personal Sanskrit-linguistics research archive. **Not** wired
into the VisualDCS dashboard pipeline (`../src/DCS-data-2021/`, `../src/DCS-data-2026/`)
— treat as reference material to mine for ideas or figures.

_Dr. Mārcis Gasūns_
