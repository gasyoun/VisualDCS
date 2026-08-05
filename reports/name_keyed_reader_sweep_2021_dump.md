# Name-keyed-reader sweep across the DCS-2021 dump readers

_Created: 05-08-2026 · Last updated: 05-08-2026_

Follow-up sweep recommended by [issue #70](https://github.com/gasyoun/VisualDCS/issues/70)
(*"Worth sweeping the other `timws.csv` / `10.csv` readers in this repo and in sibling
repos for the same name-keyed pattern"*), executed as
[H2293](https://github.com/gasyoun/Uprava/blob/main/handoffs/H2293-Opus_VisualDCS_name-keyed-reader-sweep-issue-70_05.08.26.md)
on Opus 5 (`claude-opus-5`).

## The pattern being hunted

Keying a **code-indexed** source by its **human-readable names** is silent lossy
aggregation: the dict just gets shorter, nothing raises, and no count mismatch appears in
the output. In [H1486](https://github.com/gasyoun/VisualDCS/pull/68) this dropped 39,836
verbal examples from the 2021 side of the M7 delta table and a paper then *explained the
resulting gap away* as "a separate aggregation of the same 2021 vintage".

## Verdict — every reader of the 2021 dump

Sources and their true keys: `timws.csv` → **code** (42 codes, 30 distinct names) ·
`15.csv` → **code** (headerless) · `_8.csv` → **(lemma, POS)** (90,954 rows,
83,275 distinct lemma strings) · `0.csv` → sentence rows grouped by text name.

| Reader | Source | Keyed by | Verdict |
|---|---|---|---|
| [`regen_widgets.py::read_2021_verbcats`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/regen_widgets.py) | `timws.csv` | name, **summed** | ✅ fixed by H1486; guards added here |
| [`export_master.py::read_timws`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/export_master.py) | `timws.csv` | **code** | ✅ correct by construction |
| [`export_master.py::learn_code_map`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/export_master.py) | `15.csv` | **code** | ✅ correct by construction |
| [`export_master.py::diff_8`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/export_master.py) | `_8.csv` | name, was last-wins | ⚠️ **latent trap — fixed here** |
| [`gen_dcs_lemma_summary.py`](https://github.com/gasyoun/VisualDCS/blob/main/gen_dcs_lemma_summary.py) | `_8.csv` | SLP1 key, **summed** | ✅ the published contract asset is sound |
| [`delta_stats.py::read_2021_freq`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Corpus-Delta-2021-2026/delta_stats.py) | `_8.csv` | name, **summed** | ✅ (dead last-wins local removed) |
| [`delta_supplement.py::read_2021_own_lexicon_pos`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Corpus-Delta-2021-2026/delta_supplement.py) | `_8.csv` | POS class, summed | ✅ |
| [`delta_supplement.py::read_2021`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Corpus-Delta-2021-2026/delta_supplement.py) · [`coverage_diff.py::read_2021`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/coverage_diff.py) | `0.csv` | text name, accumulated | ✅ group-by-name is the intent |
| [`KocherginaUchebnik_1998/verify_claims_dcs.py`](https://github.com/gasyoun/SanskritGrammar/blob/main/KocherginaUchebnik_1998/verify_claims_dcs.py) | `timws.csv` | **code** | ✅ — see note below |
| [`ZalizniakOcherk_1978/verify_claims_dcs.py`](https://github.com/gasyoun/SanskritGrammar/blob/main/ZalizniakOcherk_1978/verify_claims_dcs.py) · [`ZalizniakKonspekt_2004/`](https://github.com/gasyoun/SanskritGrammar/blob/main/ZalizniakKonspekt_2004/verify_claims_dcs.py) · [`BuhlerLeitfaden_1923/`](https://github.com/gasyoun/SanskritGrammar/blob/main/BuhlerLeitfaden_1923/verify_claims_dcs.py) | `timws.csv`, `15.csv` | **code** | ✅ code-keyed dicts / tuple lists |
| [`BuhlerLeitfaden_1923::tense_token_shares`](https://github.com/gasyoun/SanskritGrammar/blob/main/BuhlerLeitfaden_1923/verify_claims_dcs.py) | `tense_case_data.json` | exact label over a **list** | ✅ sums duplicates — see below |
| [`WhitneyGrammar_1889/whitney_per_text_counts.py`](https://github.com/gasyoun/SanskritGrammar/blob/main/WhitneyGrammar_1889/whitney_per_text_counts.py) | `15.csv` | form set by code | ⚠️ **header bug — fixed here** |

**Headline: the H1486 bug was the only materially-wrong instance. No second corrupted
number shipped anywhere.** Two real-but-non-propagating defects were found and fixed.

## What the sweep actually found

### 1. `_8.csv` is a far larger instance of the same trap — but every live reader sums

`_8.csv` is keyed by (lemma, POS); homographs get one row per part of speech (`vid`
appears 6×: `6.Ā.`, `adj`, `2.Ā.`, `adj`, `f`, …). 6,340 lemma strings carry more than
one row. A name-keyed **last-wins** read would therefore lose:

| | tokens |
|---|---:|
| `_8.csv` true total (90,954 rows) | 4,577,461 |
| what a last-wins name-keyed read retains | 2,085,186 |
| **silently dropped** | **2,492,275 (54.4%)** |

That is 63× the H1486 loss. It never fired because every consumer that uses the counts
already accumulates — including [`gen_dcs_lemma_summary.py`](https://github.com/gasyoun/VisualDCS/blob/main/gen_dcs_lemma_summary.py),
which generates the `dcs_lemma_summary.json` contract asset csl-atlas consumes.

`export_master.py::diff_8` was the one exception: it assigned last-wins. It escaped
consequence only because it uses the map for set membership and `len()` and never reads a
count — a trap armed for the next person to write `old[lemma]`. Now sums, and reports
`old_rows` beside `old_lemmas` so the 90,954 → 83,275 collapse is visible in the report
rather than implied.

### 2. A list saved the sibling repo where a dict would have lost the data

`BuhlerLeitfaden_1923::tense_token_shares` consumes the *derived* asset
[`tense_case_data.json`](https://github.com/gasyoun/VisualDCS/blob/main/tense_case_data.json)
by exact label name — the highest-risk-looking pattern in the sweep. It is safe, and
instructively so: the asset is a **list of 38 rows that preserves duplicate labels**
(`Imperfect` twice: 35,921 + 4,442; `Aorist Act.` twice: 721 + 583), and `sum_labels()`
iterates that list. So it returns imperfect = 42,803 and aorist = 2,452 — both correctly
summed across colliding codes. Had that asset been serialised as a name-keyed object, the
identical consumer code would have silently read the H1486 numbers.

Parity checked end-to-end: `timws.csv` and `tense_case_data.json` both total **781,618**;
the 4 codes present in the CSV but absent from the JSON (17, 18, 31, 34) are all
zero-count with empty labels. No mass is lost in the derivation.

### 3. Kochergina's reader had the right answer all along

[`KocherginaUchebnik_1998/verify_claims_dcs.py`](https://github.com/gasyoun/SanskritGrammar/blob/main/KocherginaUchebnik_1998/verify_claims_dcs.py)
keys `timws.csv` by code and aggregates over *explicit code lists* —
`TOK[4] + TOK[8] + TOK[9] + TOK[16] + TOK[27]` for imperfect,
`sum(TOK[c] for c in (10, 11, 12, 13))` for aorist. `TOK[4] + TOK[8]` is
35,921 + 4,442 = **40,363**: the corrected figure, computed in a sibling repo while
VisualDCS was publishing 4,442. Nothing compared the two.

> The reusable lesson is narrower than "name-keying is bad": **the same fact was held
> correctly in one repo and incorrectly in another for months, and no mechanism existed
> to notice.** Cross-repo agreement of derived numbers is unmonitored surface.

### 4. A header slice copied onto a headerless file

`whitney_per_text_counts.py` read `15.csv` with `.splitlines()[1:]`. `timws.csv` has a
header; **`15.csv` does not** — line 1 (`21865,158442,'likhyante',24,9,`) is a real
finite-form row, silently discarded on every run. Harmless in this instance only because
that row's tense_code 24 is not an aorist: the form set is 690 before and after the fix,
so no published claim or ledger number moves. The three sibling `verify_claims_dcs.py`
readers of `15.csv` take every line and were already correct.

## Guards added (issue #70's two recommendations, both implemented)

In [`read_2021_verbcats`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/regen_widgets.py):

1. **Collision visibility.** The reader now prints every name carrying more than one code,
   with the per-code breakdown and the summed result. A 42 → 30 shrink can no longer
   happen without saying so:

   ```
   timws.csv: 42 codes -> 30 names; 8 name(s) carry >1 code (summed, not overwritten):
     'Imperfect Active': 35,921(code 4) + 4,442(code 8) = 40,363
     'Aorist Active': 583(code 10) + 721(code 12) = 1,304
     …
   ```

2. **Total reconciliation against an independently documented figure.** The parsed sum is
   checked against the 781,616 headline that has sat in
   [README.md](https://github.com/gasyoun/VisualDCS/blob/main/README.md) and
   [CLAUDE.md](https://github.com/gasyoun/VisualDCS/blob/main/CLAUDE.md) the whole time —
   derived from the Excel source, so a genuine cross-check rather than a restatement
   (tolerance ±10; the true delta is 2). Verified against the pre-H1486 value: 741,782 vs
   781,616 is a −39,834 delta and **would have been caught at parse time**, years earlier.

## Limitations

- Scope was readers of the **DCS-2021 dump** specifically. The same class could exist over
  other code-keyed sources in the org; not swept here.
- Two guards live in `regen_widgets.py` only, not as a shared helper — there is no
  registered org-wide collision-guard utility
  ([SHARED_CODE.md](https://github.com/gasyoun/github-spine/blob/main/SHARED_CODE.md)
  checked, none exists). Extracting one is deferred, not done.
- The cross-repo number-agreement gap in §3 is **diagnosed, not closed**. Nothing added
  here compares VisualDCS's derived figures against SanskritGrammar's independently
  computed twins.

_Dr. Mārcis Gasūns_
