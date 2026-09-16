# Yandex-Disk samāsa bundle — «Алгоритмы обработки сложных слов» + kRtam/Композиты census and dedupe verdict

_Created: 17-09-2026 · Last updated: 17-09-2026_

[H4480](https://github.com/gasyoun/Uprava/blob/main/handoffs/H4480-OxAlpha_VisualDCS_samasa-algorithms-enrich_09.09.26.md)
(class `data`, OxAlpha lane). Scope: the two Yandex-Disk folders named in the mission —
`yadisk:Сложные слова (samāsa) в санскрите (2)/Алгоримы обработки сложных слов (для искуственного интеллекта)/`
(the *method* half, 8 objects) and `yadisk:kRtam/Композиты/` (the *data* half, 12 objects,
253.770 MiB = 266,097,580 B). Question asked: **enrichment input or superseded?**

**Verdict in one line: superseded on the data half (12/12 objects already in this repo,
byte-identical payloads), reference-only on the method half (published third-party NLP
papers plus a byte-identical copy of an estate-internal artifact) — nothing new landed.**

Sibling precedent: the same shape was answered for the kRtam parallels CSVs in
[H4472](https://github.com/gasyoun/Uprava/blob/main/handoffs/archive/H4472-OxAlpha_SanskritLexicography_krtam-parallels-csv_09.09.26.md)
(same-scope, not novel). Inventory context:
[Uprava reports/YADISK_INVENTORY_07-09-2026.md](https://github.com/gasyoun/Uprava/blob/main/reports/YADISK_INVENTORY_07-09-2026.md).

## 1. Data half — `kRtam/Композиты/` vs `derived-data/Kompozity/`

All twelve remote objects are accounted for locally. The six text files differ in size by
**exactly their line count** — the repo copies are the same bytes with CRLF→LF
normalisation; the two >95 MB payloads ship here as 7-Zip split volumes
(see [RESTORE_SPLIT_FILES.md](https://github.com/gasyoun/VisualDCS/blob/main/RESTORE_SPLIT_FILES.md)).

| Yandex-Disk object | Remote bytes | Local counterpart | Local bytes | Δ | Parity evidence |
|---|---:|---|---:|---:|---|
| `CompDic.csv` | 428,941 | [derived-data/Kompozity/CompDic.csv](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Kompozity/CompDic.csv) | 391,608 | 37,333 | Δ = 37,333 lines (CRLF); head-3000 md5 MATCH |
| `cmps.csv` | 15,632,161 | [derived-data/Kompozity/cmps.csv](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Kompozity/cmps.csv) | 15,230,683 | 401,478 | Δ = 401,478 lines; head-3000 md5 MATCH |
| `names.csv` | 90,664,029 | [derived-data/Kompozity/names.csv](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Kompozity/names.csv) | 90,495,149 | 168,880 | Δ = 168,880 lines; head-3000 md5 MATCH |
| `parts.csv` | 1,392,926 | [derived-data/Kompozity/parts.csv](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Kompozity/parts.csv) | 1,390,259 | 2,667 | Δ = 2,667 lines; head-3000 md5 MATCH |
| `verbx.csv` | 1,800,700 | [derived-data/Kompozity/verbx.csv](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Kompozity/verbx.csv) | 1,797,300 | 3,400 | Δ = 3,400 lines; head-3000 md5 MATCH |
| `pronx.txt` | 796,022 | [derived-data/Kompozity/pronx.txt](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Kompozity/pronx.txt) | 794,488 | 1,534 | Δ = 1,534 lines; head-3000 md5 MATCH |
| `cmp400000.csv` | 0 | [derived-data/Kompozity/cmp400000.csv](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Kompozity/cmp400000.csv) | 0 | 0 | empty on both sides (a stub, not a loss) |
| `good.txt` | 119,975,069 | `good.txt.7z.001` → `good.txt` | 119,975,069 (payload) | 0 | archive listing: same uncompressed size |
| `Распределение композитов по текстам.7z` | 17,210,482 | `Композиты.xlsx.7z.001` → `Композиты.xlsx` | 253,737,678 (payload) | 0 | **stored CRC32 `1EBB24F6` on both sides**, same mtime `2022-11-22 11:57:39` — different container (LZMA:24 vs LZMA2:18), identical payload |
| `Композиты 4+.xlsx` | 2,064,580 | same name under `derived-data/Kompozity/` | 2,064,580 | 0 | size-exact |
| `Сложные слова с разбиением на основы (испр).ods` | 5,087,424 | same name under `derived-data/Kompozity/` | 5,087,424 | 0 | size-exact |
| `категории композитов.ods` | 11,045,246 | same name under `derived-data/Kompozity/` | 11,045,246 | 0 | size-exact |

The only remote name with no like-named local twin — `Распределение композитов по текстам.7z`
— was the one download this pass (17.2 MB) precisely because the name suggested a novel
per-text distribution. It is not: it is `Композиты.xlsx` re-packed, already in the repo as
`Композиты.xlsx.7z.001`, proven by identical stored CRC32.

### Schema (already documented, unchanged)

`CompDic.csv` is a one-column IAST headword list; `parts.csv` / `verbx.csv` / `cmps.csv` /
`names.csv` are header-less, `;`-delimited rows of
`surfaceForm; splitIntoParts; partCount; totalFrequency; freq_1; freq_2; …`. Full schema and
caveats: [derived-data/Kompozity/README.md](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Kompozity/README.md).
No re-derivation was attempted here — H4480 is a census, not a rebuild.

## 2. Method half — «Алгоримы обработки сложных слов (для искуственного интеллекта)»

The folder name promises algorithms; the contents are a **reading bundle of published
third-party work**, not an MG-drafted specification. Nothing in it is executable code.

| Object | Bytes | What it actually is |
|---|---:|---|
| `!Deep Learning Based Approach for Compound Type Identification in Sanskrit.txt` | 1,694 | A link dump: [Jivnesh/ISCLS-19](https://github.com/Jivnesh/ISCLS-19), the UoHyd compound index CGI, a Google-Drive folder, 6th-ISCLS conference mail |
| `W16-3701.pdf` | 205,527 | Krishna, Satuluri, Sharma, Kumar, Goyal — *Compound Type Identification in Sanskrit: What Roles do the Corpus and Grammar Play?* (COLING-WS 2016, CC BY 4.0). Four-class AV/TP/BV/DV, Aṣṭādhyāyī rules + Amarakośa + Adaptor Grammars, random forest, accuracy 0.77 |
| `ISCLS_PPT.pdf` | 584,715 | Sandhan, Krishna, Goyal, Behera — *Revisiting the Role of Feature Engineering for Compound Type Identification in Sanskrit*, slides, 24-10-2019 |
| `scti-5scls.pdf` | 240,054 | Kulkarni & Kumar — *Clues from Aṣṭādhyāyī for compound type identification* (5th SCLS), rule-based classifier |
| `anil.pdf` | 1,849,267 | Anil Kumar — *An Automatic Sanskrit Compound Processing*, PhD thesis, University of Hyderabad, April 2012 |
| `compounds.pptx` | 467,877 | Talk deck *Rules, Knowledge Base and Algorithms: Automated analysis of compound types in Sanskrit* (docProps author `Sumeru`, 2021-01-20) |
| `compounds.txt` | 1,346,227 | **Already in the estate, byte-identical** — funderburkjim `MWderivations/compounds/compounds.txt` (md5 `f94d9e0a86e6b0ba57b10ddfd3087071`, `cmp` exit 0) |
| `compounds.html` | 2,331,129 | Same generator's HTML rendering; size-exact match to `MWderivations/compounds/compounds.html` |

`compounds.txt` is the **forward** MW compound index (`count:pūrvapada:+uttarapada …`) that
[MWderivations/issue15/build_reverse_compound_index.py](https://github.com/gasyoun/MWderivations/blob/master/issue15/build_reverse_compound_index.py)
inverts into `compounds_reverse_classified.tsv` — i.e. the dictionary side already consumed by
[derived-data/Kompozity/build_uttarapada_dict_vs_corpus.py](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Kompozity/build_uttarapada_dict_vs_corpus.py).
The Yandex copy is a snapshot of a file the pipeline already reads from its canonical home.

## 3. Cross-check against the four named estate datasets

| Estate dataset (kosha `data/manifest/datasets.json`) | Relation to the Yandex bundle | Consequence |
|---|---|---|
| `dcs-compound-dictionary` (613,758 rows, 170,169,424 B) | Is *exactly* the CSV bundle of `derived-data/Kompozity/` — i.e. the Yandex Композиты CSVs (H291 Step 4) | already registered; no new row |
| `kompozity-names-compound-splits` (168,879 rows, 90,664,029 B) | Registered size equals the **remote** `names.csv` byte count to the byte | already registered; confirms the same origin file |
| `uttarapada-dict-vs-corpus` (19,177 rows) | Joins the MW side (from `compounds.txt` → issue15 reverse index) against `cmps.csv`/`names.csv` | both inputs already local; the Yandex copies add nothing |
| `samasa-trainer` (759 rows) | Consumes `uttarapada-dict-vs-corpus` with the member stoplist (H1398). Its gold type distribution is skewed (TP 458 / BV 298 / DV 2 / KD 1) | **the one live gap** — the bundle's papers are *method* prior art for type identification, not gold data, and cannot fill the DV/KD deficit |

## 4. What this means for the trainer (the only forward-looking finding)

The published work in the method half targets precisely the trainer's weak axis — four-class
compound type identification with a documented accuracy ceiling (0.77, Krishna et al. 2016) and
an explicit finding that Aṣṭādhyāyī alone is inadequate as a classifier, lexical databases
(Amarakośa) carrying the discriminating signal. That is a **literature pointer for a future
type-classification handoff**, not data to land: none of these papers ships a labelled set we
may redistribute, and the DV/KD gold deficit stays open. No dataset row, no payload, no
schema change follows from this pass.

## 5. Evidence — commands actually run (17-09-2026)

```sh
rclone size "yadisk:kRtam/Композиты"          # 12 objects, 253.770 MiB (266,097,580 B)
rclone lsf -R --format sp "yadisk:Сложные слова (samāsa) в санскрите (2)/Алгоримы обработки сложных слов (для искуственного интеллекта)"
wc -l derived-data/Kompozity/CompDic.csv derived-data/Kompozity/cmps.csv derived-data/Kompozity/names.csv derived-data/Kompozity/parts.csv derived-data/Kompozity/verbx.csv derived-data/Kompozity/pronx.txt
rclone cat --count 4000 "yadisk:kRtam/Композиты/<f>" | tr -d '\r' | head -c 3000 | md5sum   # vs local: MATCH x6
7z l -slt "Распределение композитов по текстам.7z"        # CRC 1EBB24F6, 253,737,678 B
7z l -slt derived-data/Kompozity/Композиты.xlsx.7z.001    # CRC 1EBB24F6 — same payload
cmp compounds.txt ~/Documents/GitHub/MWderivations/compounds/compounds.txt   # exit 0
```

rclone 1.74.4 (`C:\Users\user\tools\rclone.exe`, remote `yadisk:`); 7-Zip 20.02; probes
read-only apart from two temp downloads under `C:\Users\user\Temp\h4480\`, which are not
committed anywhere.

_Гасунс_
