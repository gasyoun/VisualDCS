# H4480 — samāsa ИИ-алгоритмы + Композиты: schema, cross-check, verdict

_Created: 13-09-2026 · Last updated: 13-09-2026_

Mission inputs (yadisk):
[`Сложные слова (samāsa) в санскрите (2)/Алгоримы обработки сложных слов (для искуственного интеллекта)/`](https://yadi.sk)
+ `kRtam/Композиты (csv, 266 MB)`. Cross-check targets: kosha `samasa-trainer`,
`dcs-compound-dictionary`, `kompozity-names-compound-splits`, `uttarapada-dict-vs-corpus`.

## What the "algorithm docs" actually are

| File (yadisk folder) | What it is | MG-drafted? |
|---|---|---|
| `compounds.txt` / `compounds.html` (1.3/2.3 MB) | **"MW H3 compounds"** — 12,609 parent occurrences / 12,326 distinct H1/H2 headwords × their H3 compound children, from the Cologne MW 1899 digitization (key2 `X-Y` shortened to `+Y`). Parent-(pūrvapada)-keyed dictionary productivity index. Jan 2023. | Collected table (Cologne-derived), not an algorithm draft |
| `!Deep Learning Based Approach….txt` | Forwardable ISCLS-19 mailing-list note with links (Jivnesh Sandhan et al. compound-type-ID papers, github.com/Jivnesh/ISCLS-19) | No — external paper pointers |
| `W16-3701.pdf`, `anil.pdf`, `scti-5scls.pdf`, `ISCLS_PPT.pdf`, `compounds.pptx` | Published papers/slides (Sandhan/Krishna/Goyal line of work on neural compound-type identification) | No — external method references |

No MG-authored algorithm prose was found in the folder — the only MG-curated
data artifact is the MW H3 parent table.

## Schema: kRtam/Композиты CSV (266 MB) — already ingested

Identical to the local copy shipped at
[`derived-data/Kompozity/`](https://github.com/gasyoun/VisualDCS/tree/main/derived-data/Kompozity)
(`CompDic.csv`, `cmps.csv`, `names.csv`, `parts.csv`, `verbx.csv`, `pronx.txt`,
`good.txt`, `cmp400000.csv` (0 bytes both sides), xlsx/ods binaries). Row shape
of the frequency tables: `surface;split;nParts;totalFreq;per-period…` —
documented in the folder README since 05-07-2026.

**Drift probe (H4480, 13-09-2026):** yadisk copies (2024-11-08 mtime) are
uniformly *larger* by bytes than the local copies — probed `parts.csv`,
`verbx.csv`, `CompDic.csv`: line counts identical, and after stripping CR,
**byte-identical content**. The delta is CRLF line endings only. Zero content
drift; no re-ingest warranted.

## Cross-check vs the four kosha datasets

| Dataset | Axis / content | Relation to H4480 inputs |
|---|---|---|
| `dcs-compound-dictionary` (168,880 splits) | DCS-side compound splits | Supersedes the Kompozity CSV corpus side (that IS its source) |
| `kompozity-names-compound-splits` | DCS `names.csv` splits + freq | Same — supersedes |
| `samasa-trainer` (H948/H1298 bracket method) | Rule-based trainer over attested splits | The ISCLS DL papers are method references only; a neural type-ID lane would be a new program, out of scope for a bounded enrich unit |
| `uttarapada-dict-vs-corpus` (H1328) | **Final-member(uttarapada)-keyed** MW × DCS join, 19,178 rows, classified | Complementary axis — the MW H3 table is **parent-keyed** and was NOT registered anywhere |

## Verdict: enrichment input for exactly one novel artifact

**Corpus side (266 MB CSV): SUPERSEDED** — already ingested, byte-identical
(CRLF-only delta), already feeding three registered datasets.

**MW H3 parent-keyed compounds table: NOVEL → landed.** The dictionary-side
compound-productivity view exists in the estate only final-member-keyed
(H1328); the pūrvapada/parent axis was missing. Landed (bounded — 1.3 MB
source + 1 MB derived, no 266 MB movement):

- `derived-data/Kompozity/compounds.txt` — source table, committed for reproducibility
- [`derived-data/Kompozity/build_mw_h3_parent_compounds.py`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Kompozity/build_mw_h3_parent_compounds.py) — parser + coverage cross-check (H1328 fold conventions: `@` join, avagraha, anusvara U+1E43→U+1E41; no sandhi manufacture)
- `derived-data/Kompozity/mw_h3_parent_compounds.tsv` — 12,609 rows × `parent<TAB>n_children<TAB>children`

### Own-data parity / coverage numbers (13-09-2026 run)

```
source rows (parent occurrences): 12609
distinct parents:                12326
child tokens:                    112154
distinct children (folded):      111488
corpus universe (cmps.csv):      399162 surfaces / 318885 stem-concats
children attested (surface):     2061 (1.8%)
children attested (stem-concat): 12033 (10.8%)
children attested (any key):     12948 (11.6%)
children dictionary-only:        98540 (lower bound)
```

Hand spot-checks: `akṣadyūta` matches cmps stem-split `akṣa dyūta` ✓;
`rājaputra` matches surface ✓. Residual classes (expected, NOT collapsed, per
H1328 doctrine): initial-a elision (`aṁśavataraṇa` ↔ DCS stem `avataraṇa`),
junction sandhi/vṛddhi (`aṁśokaraṇa`-style surfaces), kosa-stratum words
(`a+kāra` never attested as a bare compound split). The 88.4% dictionary-only
residue is a **lower bound**, consistent with H1328/FINDINGS s86 (corpus gaps +
kosa-only lexical stratum dominate MW-only mass).

## Checks

```
python3 derived-data/Kompozity/build_mw_h3_parent_compounds.py   # numbers above, exit 0
```

Drift probe: `diff <(tr -d '\r' < yadisk-parts.csv) parts.csv` → identical for
all three probed CSVs.

## Risks

- `compounds.txt` provenance is MG's local collection of a Cologne-derived
  table; upstream generator not identified (title comment says "MW digitization
  of 1899", 12,609 records). Committed as-is with parser; provenance note in README.
- `cmp400000.csv` is 0 bytes on BOTH yadisk and local — dead file, never ingest.
- The ISCLS DL method lane (neural compound-type ID) remains an unbuilt option;
  parked as a decision for MG, not executed here.

_Executed by OxAlpha (opencode/z-ai/glm-5.3-flash) under H4480. Verifier: class=data —
a DIFFERENT session's PASS is required per the handoff's `## Verifier` section._

_Dr. Mārcis Gasūns_
