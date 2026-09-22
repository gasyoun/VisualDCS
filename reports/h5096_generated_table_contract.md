# H5096 — Reusable round-trip and determinism contract for generated TSV/CSV artifacts

_Created: 18-09-2026 · Last updated: 18-09-2026_

Executed under [H5096](https://github.com/gasyoun/Uprava/blob/main/handoffs/H5096-OxAlpha_VisualDCS_generated-table-roundtrip-contract_18.09.26.md) (OxAlpha tier, executed by GLM `zai-coding-plan/glm-5.3-flash`).
Generalizes the defensive method proven in PR #136 (`c01838f`, Kompozity
`mw_h3_parent_compounds.tsv`: non-colliding child separator, LF-explicit
write, re-read-and-assert round trip) into one shared validator:
[`scripts/generated_table_contract.py`](https://github.com/gasyoun/VisualDCS/blob/main/scripts/generated_table_contract.py).

## 1. Builder census (12 TSV/CSV-writing builders)

| Builder | Generated outputs | Verdict |
|---|---|---|
| `derived-data/Kompozity/build_mw_h3_parent_compounds.py` | `mw_h3_parent_compounds.tsv` | **PILOT 1** — PR #136 anchor; list-field + declared-count column (the proven failure class) |
| `derived-data/Leksicheskie-issledovaniya/Gapaksy-DCS-2026/gen_dcs_hapax.py` | `dcs2026_hapax_{all,single_morpheme,compound}.tsv` | **PILOT 2** — free-text `meaning` field smuggled from sqlite (newline-stripped but NOT tab-stripped — sharpest remaining delimiter gap); cross-artifact count identity `all == single + compound` |
| `derived-data/Corpus-Delta-2021-2026/delta_supplement.py` | `per_text_token_delta.csv` (+2 sibling CSVs, not gated) | **PILOT 3** — comma-CSV quoting round-trip; arithmetic reconciliation `tok_delta == tok_2026 - tok_2021`; committed inputs (`src/DCS-data-2021/`) |
| `derived-data/Kompozity/build_uttarapada_dict_vs_corpus.py` | `uttarapada_dict_vs_corpus.tsv` | **PILOT 4** — `csv.DictWriter` write path; 8 numeric + 1 enum column; key uniqueness over 19,177 finals |
| `derived-data/Kompozity/build_uttarapada…` inputs | `cmps.csv`, `names.csv`, `Paralleli…/*`, `Lexical-Cores…` | upstream SOURCE datasets — untouched per handoff ("do not rewrite source datasets") |
| `derived-data/Corpus-Delta-2021-2026/delta_stats.py` / `delta_annotation_layers.py` | `REPORT.md` tables / `annotation_layers_by_text.csv` | not selected — annotation_layers duplicates the per-text shape with fewer invariants; delta_stats writes no CSV |
| `derived-data/Fonetika/regen-2026/build_akshara_ligature_freq.py`, `varga-series-diachrony/aggregate_vargas.py` | `*_freq.csv`, `*_varnamala.csv`, `varga_share_by_period.csv` | not selected — small dense numeric grids, no list fields, no free text; lowest risk class |
| `derived-lsc/build_lsc_pilot.py` / `build_lsc_gold_sample.py` | `lsc_scores.tsv`, `lsc_targets.tsv`, `lsc_human_gold_sample.tsv` | not selected — rebuild needs sibling repos (`dcs-conllu`, `sanskrit-util`); weaker CI story than the chosen four |
| `derived-data/Samsaadhanii-DCS-SH-alignment/ingest_dcs_sh_alignment.py` | alignment TSVs under a temp dir | not selected — alignment layer with its own ingest validation; inputs gitignored |

Three distinct risk classes × four distinct write paths are covered: (a)
separator-collision list field, (b) control characters in free text +
cross-file count identity, (c) CSV quoting + arithmetic columns, (d) enum +
numeric domain.

## 2. The contract

One stdlib-only module, four modes:

```
python3 scripts/generated_table_contract.py --selftest   # 16 synthetic fixtures, happy + failing
python3 scripts/generated_table_contract.py --check      # all 7 committed artifacts + group identity (CI-safe)
python3 scripts/generated_table_contract.py --mutate     # 8 planted mutations in TEMP copies, require 8/8 RED
python3 scripts/generated_table_contract.py --rebuild <artifact>   # two-build determinism == committed blob
```

Enforced axes: byte hygiene (UTF-8, no BOM, LF-only, trailing newline) ·
delimiter safety (exact header, exact field count, no TAB/CR/LF smuggled in a
TSV field, CSV quoting round-trip) · encode/decode round-trip (canonical
re-serialization byte-identical) · row/key preservation (counts + key
uniqueness; mw_h3 is occurrence-keyed by upstream design — 12,609 occurrences
/ 12,326 headwords, e.g. `ota → otaprota` legitimately recurs at source lines
1537 and 2131 — so NO uniqueness rule there, the byte round-trip pins the
multiset) · declared-count reconciliation (`n_children == |children|`,
`tok_delta == tok_2026 - tok_2021`, hapax `all == single ⊎ compound`,
pairwise disjoint) · domain rules (non-negative ints — `tok_delta` is
legitimately negative and is exempt — enum `corpus_status ∈ {final,
form_variant, nonfinal_only, absent}`).

Builders wired post-write with `gtc.enforce(...)` (the PR #136 pattern,
generalized): all four pilot builders call the shared check after writing; a
missing spec is a build failure, not a silent pass. CI:
[`.github/workflows/validate-generated-tables.yml`](https://github.com/gasyoun/VisualDCS/blob/main/.github/workflows/validate-generated-tables.yml)
runs selftest + `--check` + `--mutate` on the committed bytes only.

## 3. Evidence receipts

**Full-corpus GREEN** (`--check`, all bytes == HEAD):

| Artifact | Rows | Distinct full rows |
|---|---:|---:|
| `Kompozity/mw_h3_parent_compounds.tsv` | 12,609 | 12,606 |
| `Gapaksy-DCS-2026/dcs2026_hapax_all.tsv` | 39,987 | 39,987 |
| `…/dcs2026_hapax_single_morpheme.tsv` | 23,067 | 23,067 |
| `…/dcs2026_hapax_compound.tsv` | 16,920 | 16,920 |
| group hapax-trio | partition holds over 39,987 ids, single ∩ compound = ∅ | |
| `Corpus-Delta-2021-2026/per_text_token_delta.csv` | 276 | 276 |
| `Kompozity/uttarapada_dict_vs_corpus.tsv` | 19,177 | 19,177 |

**Two-build determinism** (each gate: 2 rebuild runs, run1 hash == run2 hash
== committed HEAD blob):

| Artifact | sha256 (16 chars) |
|---|---|
| `mw_h3_parent_compounds.tsv` | `b72325a23855fcba` |
| `uttarapada_dict_vs_corpus.tsv` | `ebaac23cbb07b1a2` |
| `dcs2026_hapax_all.tsv` | `c2970942fd0d6165` |
| `dcs2026_hapax_single_morpheme.tsv` | `a02dae1a9b2d3d71` |
| `dcs2026_hapax_compound.tsv` | `fbf57b31c4b20737` |
| `per_text_token_delta.csv` | `ded308c548f24d98` |

No generated artifact changed in this PR — the LF fixes below made every
builder reproduce the committed bytes exactly.

**Planted-mutation RED** (`--mutate`, 8/8 CAUGHT, committed files
hash-verified untouched):

| Planted information loss | Diagnosis that fired |
|---|---|
| mw_h3: child token dropped, `n_children` stale | count-reconcile (0 tokens vs 1) |
| mw_h3: literal TAB inside children field | delimiter-safety (4 fields ≠ 3) |
| hapax_all: TAB smuggled into `meaning` | delimiter-safety (6 fields ≠ 5) |
| hapax trio: row deleted from `_all` | group count (39,986 ≠ 23,067 + 16,920) |
| per_text: `tok_delta` no longer reconciles | count-reconcile (−233 ≠ −240) |
| per_text: unquoted comma in text name | delimiter-safety (8 fields ≠ 7) |
| per_text: whole row silently dropped | row-count-pin (275 rows, spec pins 276) |
| uttarapada: `corpus_status` outside enum | enum domain |

## 4. Independent verification + hardening commit

The delivery was adversarially verified pre-close by **DeepSeek V4.1 Flash
(openrouter/deepseek/deepseek-v4.1-flash)** — static re-derivation of every
DoD axis against the code, row counts re-counted from the artifacts, VERDICT:
**pass**. Its two mechanical residuals were fixed in the same PR:

1. **Whole-row-drop hole** — `--check` had no pinned absolute row count, so a
   builder silently dropping rows stayed GREEN. Fixed: every spec now pins
   `expect_rows` (12,609 / 39,987 / 23,067 / 16,920 / 276 / 19,177); a
   legitimate data refresh bumps the pin in the same PR. New planted mutation
   (whole row dropped from per_text) is RED via the pin — 8/8.
2. **Hapax siblings outside the rebuild family** — `single_morpheme` /
   `compound` specs carried no rebuild command, so `--rebuild` did not
   hash-compare them. Fixed: all three hapax specs share the builder command;
   the gate now prints DETERMINISTIC lines for all three (verified against
   the copied master DB).

## 4. Real defects the gate caught on first live contact

All three pre-existing builders wrote `csv.writer`/`csv.DictWriter` with the
module-default `\r\n` lineterminator, so a rebuild could never reproduce the
committed LF blobs (silent blob churn on the next touch):

1. `build_uttarapada_dict_vs_corpus.py` — first `--rebuild` run FAILED with
   "CR byte found"; fixed with `lineterminator="\n"`, now deterministic.
2. `gen_dcs_hapax.py` `write_tsv` — same; fixed.
3. `delta_supplement.py` (all three CSV writers) — same; fixed.

Also fixed in passing: the `--rebuild` baseline is now hashed from
`git show HEAD:<path>` rather than the working file (which an earlier rebuild
in the same session may already have overwritten — this produced one false
"differ from committed" message before the fix).

## 5. Limitations (honest residue)

- `--rebuild` for uttarapada needs the sibling `../MWderivations/issue15`
  checkout; hapax and delta rebuilds need the gitignored 921 MB
  `src/DCS-data-2026/dcs_full.sqlite` (copied in from the shared checkout for
  these receipts). CI therefore runs committed-bytes checks + selftest +
  mutations only; determinism gates are local (Launch box: any, with inputs).
- `delta_supplement.py` also regenerates `supplement_tables.md`, whose
  committed copy carries hand-added dated header + byline that the builder
  does not emit — regenerating strips them (restored here; not a contract
  target; flagged as a GTD residual).
- Round-trip is byte-exact by design: any intentional format change requires
  regenerating the artifact in the same PR (the gate says so verbatim).

## 6. Reproduction runbook

```
python3 scripts/generated_table_contract.py --selftest
python3 scripts/generated_table_contract.py --check
python3 scripts/generated_table_contract.py --mutate
# with inputs present (DB copied in / sibling repo checked out):
python3 scripts/generated_table_contract.py --rebuild derived-data/Kompozity/mw_h3_parent_compounds.tsv
python3 scripts/generated_table_contract.py --rebuild derived-data/Kompozity/uttarapada_dict_vs_corpus.tsv
python3 scripts/generated_table_contract.py --rebuild derived-data/Leksicheskie-issledovaniya/Gapaksy-DCS-2026/dcs2026_hapax_all.tsv
python3 scripts/generated_table_contract.py --rebuild derived-data/Corpus-Delta-2021-2026/per_text_token_delta.csv
```

_Гасунс_
