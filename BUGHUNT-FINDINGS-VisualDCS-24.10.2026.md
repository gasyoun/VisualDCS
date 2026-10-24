# Bug hunt — VisualDCS — 24.10.2026

_Created: 24-10-2026 · Run: interactive day-mode `/bughunt` (rotation slot 18/171) · Base: `main` @ `927bad9` (19-10-2026) · Elapsed: ~10 min · Model: DeepSeek Flash (`deepseek-flash`)._

The 03:00 nightly for this slot scored **exit 4 — provider blocked** (all three providers
cooled until 03:33, `~/.config/opencode/state/bughunt/ledger.jsonl`), so the driver never
hunted. This pass takes the same slot, interactively.

## Verdict at a glance

| # | Sev | Finding | Status |
|---|---|---|---|
| H1 | HIGH | Release envelope `CHK-2` is red: the tag resolves to `34109b3` while the envelope pins `6d19eed` (a pre-`filter-repo` SHA); the checker exits 1 and is wired into no workflow | **@DO** — release records need an owner ruling, not a self-fix |
| H2 | HIGH | `delta_supplement.py` plants a **0-byte `dcs_full.sqlite`** at the master path (the H848 decoy) on a fresh clone, then crashes | **FIXED** in this PR |
| M1 | MEDIUM | `regen_widgets.collocations()` never flushes the **last sentence** — silently wrong co-occurrence counts | reported |
| M2 | MEDIUM | `node tests/test_nominal_dashboard.js` is **red on `main` since 03-10-2026**, and no workflow runs any of the 7 node / 6 python test files | reported |
| M3 | MEDIUM | `dcs_shared_citation_errors.py` is unrunnable off the author's Windows box (hardcoded `C:\Users\user\…`), contradicting its own docstring | reported |
| M4 | MEDIUM | Two "denominator closure" assertions are tautologies — cannot fail, yet the build reports claim the partition is asserted | reported |
| M5 | MEDIUM | `validate.py` coverage gate passes with up to **2 % of the corpus missing**, and never gates the lemma/token totals it prints | reported |
| M6 | MEDIUM | `envelope_check.py` reports **PASS for CHK-3/CHK-5 when every digest was skipped** (0 bytes verified) | reported |
| L1 | LOW | `import_archive.py` writes `parallel_text.n_source_rows` as NULL on every row although the loader computes it | reported |
| L2 | LOW–MED | `make_deliverables.py` writes the "top-20 membership **20/20**" claim as a literal, so that cross-check cannot fail | reported |
| L3 | LOW | `verb_total_check.py` pins the README with a bare substring, and the README carries the number twice | reported |
| L4 | LOW | `h2499_dual_run_rebuild.py` defaults its scratch dir to a Windows absolute path | reported |

Severity here: HIGH = wrong published number / data-integrity / crash of a documented
path; MEDIUM = broken guard or wrong edge case; LOW = latent.

## What verified green in this pass

- **Node tests:** 6 of 7 pass — `test_collocations`, `test_concordance`, `test_morphostatistics`,
  `test_nominal_trainer`, `test_paradigm_builder`, `test_passage_reader`. The 7th is M2.
- **Python tests:** `test_paradigm_attested`, `test_learner_contracts`,
  `test_past_nonindicative_formation`, `test_concordance_sa`, `test_published_figures`,
  `validate_past_tense_resplit` — all exit 0.
- **Dashboards:** all 13 root pages were executed headlessly against a DOM stub with their
  real data files; every page renders (no throw, no "Данные не загрузились" fallback). The
  nominal dashboard's two inline scripts render `app` (14,577 chars) and `classsplitApp`
  (2,874 chars) — the H5741 panel is healthy.
- **Gates:** `scripts/generated_table_contract.py --selftest` green (13/13),
  `validate_dcs_lemma_summary.py` green (83,239 lemmas), `changelog_duplicate_bullets.py`
  green, `check_generated_figures.py` green. `envelope_check.py` is the one red gate — H1.
- **Hygiene:** no committed secrets in tracked code/YAML/JSON/MD (`git grep` for gh\*/AKIA/private-key
  shapes); no broken local `src`/`href` reference in any dashboard; the landing page's 13 local
  links all resolve.

## H1 — Release envelope CHK-2 is red, and nothing runs it (HIGH, @DO)

```
$ python3 scripts/envelope_check.py
[    PASS] CHK-1: schema release-envelope-v1; all required fields non-empty
[    FAIL] CHK-2: tag resolves to 34109b3ec4912c230944275072ba35cd98913528,
                  envelope records 6d19eed11a75076c3639cfb2f9e6f5ff9c6648cf
…
summary: 16 pass / 0 skip / 1 recorded / 1 fail        (exit 1)
```

The tag itself is a **lightweight** tag on `34109b3`
(`git for-each-ref refs/tags/learner-contracts-v1-2026-08-09` → `commit 34109b3…`).
The recorded `6d19eed` is a *different commit with the same subject* — it is reachable only
from `origin/backup/pre-filter-repo-H5884-2026-10-04`, i.e. it is the **pre-rewrite** twin
of the release commit (`git merge-base --is-ancestor 6d19eed 34109b3` → false). The envelope
was added on 07-09-2026 (`cc8e815`); the H5884 `git filter-repo` on 04-10-2026 rewrote the
history and re-pointed the tag, leaving the envelope pinned to a SHA that no longer exists on
`main`.

Both `pin_commit` fields repeat the stale SHA
([envelope](https://github.com/gasyoun/VisualDCS/blob/main/visual/contracts/envelopes/learner-contracts-v1-2026-08-09.envelope.json#L11-L12)),
while `pin_rule` says "the release tag commit itself". The artifact evidence is intact —
CHK-3 and CHK-5 pass 4/4 and 3-of-3 plus 4/4 at the tag — so this is a **provenance record**
defect, not corrupted artifacts.

Why it survived: `scripts/envelope_check.py` appears in **no** workflow
(`grep -rn envelope_check .github/workflows` → zero hits), so the red state is invisible.
Re-pinning the envelope is a release-record decision (does the rewritten SHA get blessed?),
so it is parked as a GTD `@DO` row rather than self-fixed. Fix shape: re-pin `code_revision.commit`
and the `source_pins[].pin_commit` values to `34109b3…` **after** re-proving the blob equivalence
against the tag (the CHK-3 digests already do), and wire the checker into CI.

## H2 — `delta_supplement.py` plants the H848 decoy, then dies (HIGH, fixed)

[`derived-data/Corpus-Delta-2021-2026/delta_supplement.py`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Corpus-Delta-2021-2026/delta_supplement.py)
opened the gitignored master with a bare connect:

```python
119:    db = sqlite3.connect(DB_2026)
```

`sqlite3.connect()` **creates** a missing database. On a fresh clone (the master is
gitignored/regenerable) the documented run therefore leaves a **0-byte
`src/DCS-data-2026/dcs_full.sqlite`** at exactly the path CLAUDE.md names as the H848 decoy,
and only then crashes with `no such table: text`. A later consumer that trusts `os.path.isfile()`
— `delta_stats.py:58-61` does — reads that decoy as an empty corpus.

Reproduced on a fresh-clone layout in `/tmp` (real `0.csv`/`_8.csv`, no DB):

```
rc=1
sqlite3.OperationalError: no such table: text
$ ls -la src/DCS-data-2026/ → dcs_full.sqlite   0 bytes
```

Fixed in this PR ([`delta_supplement.py:111-141`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Corpus-Delta-2021-2026/delta_supplement.py#L111-L141)):
every input is now checked **before anything is read** (missing **or empty** → `exit 2`, nothing
created — the 0-byte case is caught too), and the master is opened read-only
(`file:…?mode=ro`, so no `-wal`/`-shm` sidecars). This mirrors the guard its own sibling
`delta_stats.py` already has.

Verification of the fix:

- missing DB → `rc=2`, message, **no file created**;
- full run against the real 920 MB master → `rc=0`, `270 texts, 754,726 sentences,
  5,688,416 tokens, 98,606 distinct lemmas`, and the three regenerated CSVs are
  **byte-identical** to the committed ones (`lemma_freq_drift_top200.csv`,
  `pos_distribution_shift.csv`, `per_text_token_delta.csv`) — the guard changed no output.

## M1 — `collocations()` drops the last sentence (MEDIUM)

[`src/DCS-data-2026/regen_widgets.py:247-259`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/regen_widgets.py#L247-L259):
the previous sentence is flushed only when the sentence id *changes* inside the loop; there is
no post-loop flush, so the final sentence never contributes a co-occurrence pair.

Reproduced verbatim on an in-memory DB, sentences `{1,2} {1,3} {1,4}`:

```
actual  : {2: 1, 3: 1}
expected: {2: 1, 3: 1, 4: 1}   ← pair 1–4 lost
```

Caveat of scope: `regen_widgets` writes gitignored `widgets/`, and the committed
`visual/coll_compact.json` has a different (800-lemma, POS-bucketed) shape that predates
this code path — so the shipped asset is not provably wrong today. The generator is, and the
next regeneration is. Fix shape: move the flush into a nested `flush(bag)` called both on the
id change and once after the loop.

## M2 — A documented test gate is red, and no workflow runs it (MEDIUM)

```
$ node tests/test_nominal_dashboard.js
AssertionError [ERR_ASSERTION]: expected exactly one inline <script> in the page
2 !== 1        (tests/test_nominal_dashboard.js:52)
```

[`b443a67`](https://github.com/gasyoun/VisualDCS/commit/b443a67) (H5741, 03-10-2026) added the
class-split panel as a **second** inline `<script>` to
[`sanskrit_nominal_dashboard.html`](https://github.com/gasyoun/VisualDCS/blob/main/sanskrit_nominal_dashboard.html#L404)
without touching the test that asserts exactly one. The page itself is fine (both scripts run
and both panels render, verified), so this is a dead guard, not a broken page — but CLAUDE.md's
sync rule ("edit the dashboard → `node tests/test_nominal_dashboard.js` in the same PR") has
been **unusable for 21 days**.

Nobody saw it because **no workflow runs the tests**: the 9 workflows never invoke `node tests/`
and never invoke any of the `test_*.py` files (`grep -rn "node tests\|test_paradigm_attested"
.github/workflows` → 0 hits); `dcs-validate.yml` runs `import_dcs_conllu.py` + `validate.py` only.
Fix shape: (a) run **all** inline scripts in the test, loading
`visual/paradigm_nominal_class_split_adj_data.js` too, and assert the `classsplitApp` panel
renders — that makes the guard cover both panels; (b) add a workflow step that runs the 7 node
tests and the 6 python tests, so the next drift is visible in a PR.

## M3 — A documented analysis script cannot start off the author's box (MEDIUM)

[`src/DCS-data-2026/dcs_shared_citation_errors.py:45-46`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/dcs_shared_citation_errors.py#L45-L46):

```python
CAND_CSV = os.environ.get("F4_CAND") or r"C:\Users\user\Documents\GitHub\csl-atlas\…"
ABBR_LIST = r"C:\Users\user\Documents\GitHub\DCS\DCS-abbreviation-list.txt"
```

while its own docstring says "Paths default to the in-repo layout; override with env vars".
On this Mac:

```
$ python3 src/DCS-data-2026/dcs_shared_citation_errors.py
FileNotFoundError: … 'C:\\Users\\user\\Documents\\GitHub\\csl-atlas\\…\\shared_rare_citations.csv'
rc=1
```

Both files exist locally at `~/Documents/GitHub/csl-atlas/…` and `~/Documents/GitHub/DCS/…`, so
the default is portable in one line. `ABBR_LIST` is also **dead** — defined and never read.
This matters beyond tidiness: the script's outputs (`reports/dcs_shared_citation_errors.csv/.json`,
the shared-erroneous-citation evidence) are committed, and the only box that could re-derive
them was a Windows machine that is gone. Fix shape: env var + sibling-repo default
(`Path(__file__).resolve().parents[3] / "csl-atlas" / …`) + a clear "missing input" exit; drop
`ABBR_LIST` or wire it.

## M4 — Two closure assertions that cannot fail (MEDIUM)

[`audit_past_nonindicative_formation.py:265-271`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/audit_past_nonindicative_formation.py#L265-L271):

```python
by_bucket = collections.Counter()
for (bucket, _tagged), n in scan["past"].items():
    by_bucket[bucket] += n
total = sum(by_bucket.values())
if total != sum(scan["past"].values()):          # same Counter, regrouped
    raise SystemExit("CLOSURE FAILED …")
```

`by_bucket` is `scan["past"]` regrouped by its first key; summing a regrouped dict equals summing
the original by construction, so a dropped mood bucket is absent from **both** sides and the check
can never fire. [`validate_past_tense_resplit.py:118-121`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/validate_past_tense_resplit.py#L118-L121)
has the same shape (`classes`, summed from a `GROUP BY feat_formation`, vs a `COUNT(*)` over the
identical predicate on the same connection).

The live guards in those files are the **stray-formation** checks right beside them (those are
real). The closure claims in the docstrings/reports ("the partition is asserted to close") are
false assurance: a future dropped or renamed bucket would publish with a green closure line.
Fix shape: assert against an independent count (a direct `COUNT(*)` of the bucket universe, or a
hard-coded expected total from the fixture), not against the same Counter.

## M5 — The M6 coverage gate tolerates a 2 % corpus loss (MEDIUM)

[`validate.py:149-155`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/validate.py#L149-L155):

```python
return {"corpus_folders": folders, "master_texts": texts, "distinct_lemmas": lemmas,
        "tokens": toks, "pass": texts >= folders * 0.98}
```

With 270 folders, `270 × 0.98 = 264.6`, so 265…270 texts all pass — up to five texts can vanish
while `reports/m6_validation.md` says "PASS" and the report calls the run "full corpus (all 270
texts)". `distinct_lemmas` and `tokens` are computed for display and never gated. Fix shape:
gate `texts == folders` (or document the slack with the reason and a hard lower bound), and add
plausibility floors for lemmas/tokens.

## M6 — `envelope_check` passes CHK-3/CHK-5 having verified zero bytes (MEDIUM)

[`scripts/envelope_check.py:178-181`](https://github.com/gasyoun/VisualDCS/blob/main/scripts/envelope_check.py#L178-L181)
(and 259-262) gates only `fail`, never `skip`:

```python
if fail:
    record("CHK-3", "FAIL", f"{ok} pass / {skip} skip / {fail} fail")
else:
    record("CHK-3", "PASS", f"{ok} pass / {skip} skip / 0 fail")
```

Reproduced with a `/tmp` copy of the envelope whose four pinned paths were renamed to
nonexistent blobs:

```
[    SKIP] CHK-3: visual/contracts/v1/GONE-0.json: blob absent at … (×4)
[    PASS] CHK-3: 0 pass / 4 skip / 0 fail
summary: 12 pass / 4 skip / 1 recorded / 1 fail
```

Deleting or renaming a pinned artifact would therefore turn the strongest integrity check into
a PASS. Fix shape: require `ok > 0` and refuse when `skip > 0` on a local clone that is supposed
to carry the tag (keep SKIP only for explicitly foreign clones).

## L1–L4 — latent, reported only

- **L1** [`import_archive.py:430-436`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/import_archive.py#L430-L436) —
  `n_source_rows` is hardcoded `None` although `build_source_id_map` computes the per-text rows;
  `cmd_parallels` discards the map (`stats, _ = load_parallels(...)`). Schema promises the column,
  every row ships NULL.
- **L2** [`make_deliverables.py:66-70`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Fonetika/regen-2026/make_deliverables.py#L66-L70) —
  `overlap`, `mo`, `lo` are computed, but the sentence "top-20 membership: **20/20** — each of my
  top-20 rows is present" is a literal, so it survives a 19/20 regeneration.
- **L3** [`verb_total_check.py:61-66`](https://github.com/gasyoun/VisualDCS/blob/main/scripts/verb_total_check.py#L61-L66) —
  `want = [f"{codes} category codes", f"{total:,}"]` is a bare substring test; `781,618` also
  appears at README lines 73 and 414, so deleting either pinned statement still PASSes.
- **L4** [`h2499_dual_run_rebuild.py:265`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/h2499_dual_run_rebuild.py#L265) —
  `default=Path(r"C:\Users\user\AppData\Local\Temp\h2499-rebuild")`; on macOS this creates a
  literal `C:\Users\…` directory tree in the cwd instead of using tmp.

## Not reported (checked, could not defend)

- `build_akshara_ligature_freq.py:140` B023 — the closure captures `ORDER`, but it is re-assigned
  to the same constant in every iteration and called synchronously, so no wrong output.
- Read-write `sqlite3.connect` on the master in `gen_paradigm_attested.py`, `export_master.py`,
  `validate.py`, `import_archive.py` — contradicts CLAUDE.md's read-only rule (and can create
  `-wal`/`-shm` sidecars), but no path was found where it changes a published number; folded into
  the H2 convention note.
- Hardcoded measured percentages in `gen_paradigm_attested.py:120-122`,
  `split_pooled_nominal_classes.py:661-666`, `gen_paradigm_nominal.py:637-640` — all match the
  committed reports today; staleness risk, not a current defect.
- `sais_concordance.py` LCP/window handling — Windows lane frozen since 03-10-2026 and
  `pydivsufsort` is not installed here; needs a Windows re-verification, not a Mac run.

## Addendum — fix pass, 24.10.2026

The three offered MEDIUMs were requested and fixed in a follow-up PR:

1. **M2 test restored.** `tests/test_nominal_dashboard.js` no longer asserts "exactly one inline
   `<script>`"; it loads every local data `<script src>` and runs every inline script **in page
   order**, then asserts both the grid and the H5741 class-split panel render from their own data
   files. Green. Negative control: with the class-split data file removed the test fails (exit 1).
2. **Tests are now enforced.** `.github/workflows/ci.yml` gains `node-render-tests` (every
   `tests/*.js`) and `python-tests` (the DB-free suite plus the SA module under `pytest`). This is
   what kept the red test invisible for 21 days.
3. **M3 portable.** `dcs_shared_citation_errors.py` defaults the candidate list to the sibling
   `csl-atlas` checkout (`F4_CAND` overrides), drops the dead `ABBR_LIST` constant, and refuses a
   missing/empty input with exit 2 instead of a traceback. A full re-run now works and takes 0.2 s:
   **598 candidates**, 567 mappable, 1 locus-resolved `ERRONEOUS`. That re-run also shows the
   committed report is **stale** — it covers 587 candidates (2026-07-10), so 11 sibling rows have
   never been adjudicated. The committed artifact was deliberately **not** regenerated here.
4. **M1 fixed.** `regen_widgets.collocations()` flushes the final sentence; the toy repro now
   yields `{2:1, 3:1, 4:1}`.

**Correction to "What verified green".** `python3 test_concordance_sa.py` exits 0 **without running
any test** — it is a `pytest` module with no `__main__`, so the earlier "PASS" was a false green.
Under `python -m pytest` it is **4 passed / 4 skipped** (the compiled SA path skips, `pydivsufsort`
absent). CI now runs it with `pytest`, not as a script.

## Reproduce

```bash
cd ~/Documents/GitHub/VisualDCS
node tests/test_nominal_dashboard.js            # M2 — red
python3 scripts/envelope_check.py               # H1 — exit 1 (CHK-2)
python3 src/DCS-data-2026/dcs_shared_citation_errors.py   # M3 — FileNotFoundError
# H2, pre-fix, on a fresh-clone layout: the run leaves a 0-byte src/DCS-data-2026/dcs_full.sqlite
```

_Dr. Mārcis Gasūns_
