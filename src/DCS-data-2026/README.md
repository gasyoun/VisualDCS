_Created: 06-06-2026 · Last updated: 05-09-2026_

# `src/DCS-data-2026/` — Digital Corpus of Sanskrit (DCS), CoNLL-U (2026 snapshot)

This folder is the **2026 CoNLL-U side** of the DCS in VisualDCS. The older **2021 relational-DB
export** lives in the sibling [`../DCS-data-2021/`](../DCS-data-2021/). Keeping the two in dated folders
lets us hold both versions side by side and document exactly how the corpus changed.

## The two versions, dated

| | **2021 — relational DB export** | **2026 — CoNLL-U** |
|---|---|---|
| Where | [`../DCS-data-2021/`](../DCS-data-2021/) (in this repo) | [`conllu/`](conllu) — git submodule → [`gasyoun/dcs-conllu`](https://github.com/gasyoun/dcs-conllu) |
| Version date | **~August 2021** (the largest source files' timestamps) | **2026-03-05** (upstream commit `04e0778`) |
| Format | normalized SQL/CSV tables joined by integer IDs | Universal-Dependencies **CoNLL-U**, one token per line |
| Source | `OliverHellwig/sanskrit` DB-era dump | `OliverHellwig/sanskrit` → `dcs/data/conllu` @ `04e0778` |
| Size | ~760 MB (LFS + split parts) | 1.2 GB / 15,900 files (in the data repo, not here) |
| Coverage | 246 texts | 270 texts · 744,757 lines · 5,464,818 words |

> **Format epoch:** per upstream, the CoNLL-U format "changed in the **2022-08-09** release to comply
> with the UD standard." So the ~4.5-year gap between the two versions also crosses a format redesign,
> not just more data.

## What's in this folder

| Path | What |
|---|---|
| `conllu/` | **Submodule** → the full pinned CoNLL-U corpus (`files/` + `lookup/` incl. `dictionary.csv` = `LemmaId → lemma`). Fetch with `git submodule update --init`. |
| `sample_conllu/` | One unmodified CoNLL-U file (Abhidhānacintāmaṇi 1) so the scripts run without the submodule. |
| [`DCS_FORMAT_COMPARISON.md`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/DCS_FORMAT_COMPARISON.md) | **The differences in detail** — verified, same-text. |
| [`compare_dcs_formats.py`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/compare_dcs_formats.py) | Reproduces the comparison (`python compare_dcs_formats.py`). |
| [`DCS_CONLLU_IMPORT_PLAN.md`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/DCS_CONLLU_IMPORT_PLAN.md) | Plan + roadmap to import the 2026 updates into the 2021 export. |
| [`check_conllu_updates.py`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/check_conllu_updates.py) | Flags upstream CoNLL-U commits after the `04e0778` pin. |

## The differences, in detail

Full verified write-up (with counts, same-verse example, field mapping) is in
[`DCS_FORMAT_COMPARISON.md`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/DCS_FORMAT_COMPARISON.md). In brief — **same underlying data, different
serialisation**: the integer IDs the 2021 `0.csv` stores per sentence are *exactly* the CoNLL-U
`LemmaId` values, so the two are joinable on `LemmaId`. The substantive differences:

1. **Data model.** 2021 = normalized tables (join `0.csv` + `10.csv` + `12/15.csv` by ID). 2026 = one
   self-contained token per line.
2. **Morphology.** 2021 = DCS-internal **numeric codes** in separate tables. 2026 = Universal-Dependencies
   `UPOS` + `FEATS` strings (readable), with a DCS-specific `Case=Cpd` for compound members.
3. **Sandhi / segmentation.** 2026 makes it explicit (multiword-token spans + an `Unsandhied=` form per
   token); 2021 keeps only the joined surface string.
4. **Syntax.** 2026 carries dependency trees (`HEAD`/`DEPREL`) **only for Vedic Treebank chapters**
   (e.g. `conllu/files/Ṛgveda`, where the opening `agnim īḷe purohitam` is fully parsed: `obj`, `root`,
   `nmod:appos`, `conj`). Most texts are morphological only. 2021 has no syntax layer.
5. **Semantics.** 2026 adds `WordSem` lexical-sense IDs (→ Sanskrit WordNet) and `OccId` occurrence IDs.
6. **Encoding.** Both IAST/Unicode, but anusvāra differs: 2021 uses `ṁ` (U+1E41), 2026 uses `ṃ`
   (U+1E43) — normalise before string-matching across the two.
7. **Coverage / recency.** 2026 covers more texts (270 vs 246) and is maintained; 2021 is a frozen
   snapshot whose value is that VisualDCS's existing dashboards were built from it.

## License & citation

The CoNLL-U data is **CC BY 4.0** (Oliver Hellwig); see [`conllu/PROVENANCE.md`](conllu) and the
upstream `conllu/readme.md`. Cite: *Hellwig, Oliver. The Digital Corpus of Sanskrit (DCS). 2010–2024.*

_Dr. Mārcis Gasūns_
