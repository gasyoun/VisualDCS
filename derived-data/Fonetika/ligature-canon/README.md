# Two-tier ligature canon — union of four inventories + coverage curve

_Created: 10-10-2026 · Last updated: 10-10-2026_

MG ruling 10-10-2026 (A1): DCS-999 sets the **teaching order** (fence, published
on the lila page); the **canon** is ONE union artifact of four inventories.
Minted under [H6391](https://github.com/gasyoun/Uprava/blob/main/handoffs/H6391-GLM_VisualDCS_ligature-canon-union-two-tier_10.10.26.md)
(grill context: [LIGATURE_TEACHING_GRILL_DECISIONS_10-10-2026.md](https://github.com/gasyoun/Uprava/blob/main/reports/LIGATURE_TEACHING_GRILL_DECISIONS_10-10-2026.md)).

## Tiers (measured distinct counts — denominators stated)

| Tier | Source | Measured | Provenance |
|---|--:|--:|---|
| ustav-chat appendix | «Сводный список лигатур», yadisk `Sanskrityatina/10_Узелки/!Узелки письма деванагари 2022.docx` (read-only WebDAV, H4677 pattern) | **788** | sha256 `06f73ee…f38c2bf`; three-font Devanāgarī (Sanskrit 2003 / Siddhanta / Santipur 2014) |
| attested-807 | [Nagari/Varnamala](https://github.com/gasyoun/Nagari/tree/master/Varnamala) `Liste-807-Sanskrit-Ligaturen-D.txt` | **789** | sha256 `46f8f56…b9685f4`; 807 lines, 18 duplicate tokens in the legacy file |
| Rigveda-460 | Nagari/Varnamala `Liste-460-Rigveda-Ligaturen.txt` | **460** | sha256 `8545a11…cbf366c`; with Rigveda occurrence counts |
| DCS-999 | [`../regen-2026/ligature_freq.csv`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Fonetika/regen-2026/ligature_freq.csv) | **999** | 3,265,549 tokens; corpus pin 2026-03-05 (see regen-2026 provenance) |
| **Union** | all four | **1082** | this directory |

Two documented rulings (numbers are measured, labels keep their popular names):

1. The mission/grill label «~280 historic» is the pre-revolutionary textbook's
   **nominal quote** («около 280 т. наз. лигатуръ», chapter §1.5); the appendix
   actually collected in the ustav-chat measures **788** entries. The tier ships
   as `ustavchat_appendix` with the measured count.
2. The «807» list is 807 **lines** but 789 **distinct** clusters (legacy
   duplicates, e.g. `kh` ×3). The union keys are distinct clusters.

## Files

| File | What |
|---|---|
| [`ligature_canon_union.csv`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Fonetika/ligature-canon/ligature_canon_union.csv) | 1082 rows: `iast, slp1, hk, devanagari, devanagari_halant, n_consonants`, four `in_*` source flags, `n_sources`, `rigveda_count`, `dcs_rank, dcs_count, dcs_pct`. Sorted by DCS rank (unobserved-by-DCS rows last, by IAST). |
| [`coverage_topn.tsv`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Fonetika/ligature-canon/coverage_topn.tsv) | Cumulative coverage: top-N ligatures vs % of 3,265,549 ligature tokens (and % of 4,240,775 corpus words). Teaching order = DCS frequency, untouched. |
| [`sources/`](https://github.com/gasyoun/VisualDCS/tree/main/derived-data/Fonetika/ligature-canon/sources) | Committed normalized inventories (extracted once by [`extract_sources.py`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Fonetika/ligature-canon/extract_sources.py) from the docx + Nagari lists; sha256 above). |
| [`build_ligature_canon.py`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Fonetika/ligature-canon/build_ligature_canon.py) | Deterministic builder — reads ONLY committed files, no network/corpus/yadisk. |

## Coverage (from coverage_topn.tsv)

Top-10 = **31.37 %** of all ligature tokens · top-50 = 73.09 % · top-100 =
90.07 % · top-200 = 97.97 % · top-280 (nominal historic tier) = 99.27 % ·
all 999 = 100 %.

## Reproduce

```
python3 build_ligature_canon.py            # exit 0, self-checks inside
python3 build_ligature_canon.py && git diff --exit-code -- . && echo DETERMINISTIC
```

Canary (own data): union top-10 `pr sy tr nt kṣ ty rv st tv tt` — identical to
the live lila drill `data.js` (Systema-Sanscriticum `public/lila/ligatures/`),
counts included.

## Regen note (H4046 closure)

The regen-2026 builder is re-landed and byte-deterministic (see
[`../regen-2026/README.md`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Fonetika/regen-2026/README.md) § Regen determinism):
counts identical on every row to the 04-09 snapshot; cross-check vs legacy
`Все лигатуры.xlsx` documented **20/20 membership** (rank drift `dy`↔`ddh`
ruled in that README). kosha `dcs-grapheme-frequency` regen mark flips to PASS.

_Dr. Mārcis Gasūns_
