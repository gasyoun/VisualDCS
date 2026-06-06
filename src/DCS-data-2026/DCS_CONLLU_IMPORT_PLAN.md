# Plan: import DCS CoNLL-U updates into the relational export

**Status:** proposal — awaiting go-ahead. Date: 2026-06-06.

## Decisions (from Q&A, 2026-06-06)

| Question | Answer |
|---|---|
| What it produces | **Full refresh** — current CoNLL-U is the source of truth; rebuild the dataset from it |
| Hard constraint | **Must not lose the old data structure** |
| Schema | **Hybrid** — new clean tables (master) **+** compatibility exports in the old CSV shapes |
| Storage | **Both** — SQLite master **+** CSV exports |
| Serves | **Both** — regenerate the VisualDCS dashboards **and** support ad-hoc queries |
| Syntax | DCS CoNLL-U now has dependency annotation for **some** texts (not all) → import `HEAD`/`DEPREL` where present |

---

## 1. Won't a full refresh lose the old structure? No — by construction

1. **Git history** keeps the 2021 dump (`0.csv`, `10.csv`, `_8.csv`, …) forever — recover any file with
   `git show <sha>:src/DCS-data-2021/0.csv`.
2. **Compatibility exports** regenerate the old-shape CSVs from the new master, so existing dashboards
   and the Lazarus/Pascal tools keep reading the same filenames and columns.
3. **Refresh re-derives content, preserves shape.** We rebuild *rows* from current CoNLL-U; the *schema*
   is reproduced on purpose.

> ⚠️ The one genuine fidelity risk is the **numeric morphology codes** in `10.csv` (DCS-internal
> integers). CoNLL-U expresses morphology as UD `FEATS` strings instead, so reproducing the exact old
> integers needs the DCS codebook — see §6.

---

## 2. Target architecture

```
   OliverHellwig/sanskrit  ──clone──►  conllu/files/*.conllu   (current source of truth)
                                              │ parse
                                              ▼
                                   ┌────────────────────────┐
                                   │  dcs.sqlite  (MASTER)   │  new clean normalized schema
                                   │  text / chapter /       │  + HEAD/DEPREL where present
                                   │  sentence / token /     │  + provenance (source commit)
                                   │  lemma / mwt            │
                                   └───────────┬─────────────┘
                         ┌─────────────────────┼─────────────────────┐
                         ▼                     ▼                     ▼
                exports/clean/*.csv   exports/legacy/*.csv    derived analysis
                (tidy UD tables)      (0.csv, _8.csv, …       (texts.csv, timws.csv,
                                       old shapes)             visual/*.json → dashboards)
                         │                     │                     │
                  ad-hoc queries        existing Pascal tools   VisualDCS dashboards
```

The **2021 dump stays in place** under `src/DCS-data-2021/` (git-tracked); the refresh writes to new
locations (`dcs.sqlite`, `exports/`) and only *regenerates* the legacy CSVs when we choose to swap them.

---

## 3. New clean schema (SQLite master) — proposed

| Table | Key columns | Notes |
|---|---|---|
| `text` | `text_id` PK, `name`, `has_dependencies` | one row per DCS text; flag whether syntax is annotated |
| `chapter` | `chapter_id` PK, `text_id` FK, `ref` (`AbhCint, 1`) | |
| `sentence` | `sent_id` PK, `chapter_id` FK, `counter`, `subcounter`, `text_sandhied` | CoNLL-U sentence = atomic unit |
| `token` | `occ_id` PK, `sent_id` FK, `idx`, `form`, `lemma_id` FK, `upos`, `xpos`, `head`, `deprel`, `unsandhied`, `unsandhied_reconstructed` | one row per token |
| `token_feat` | `occ_id` FK, `key`, `value` | UD `FEATS` as tidy rows (`Case=Nom`…); or flatten common keys as columns |
| `mwt` | `sent_id` FK, `span_start`, `span_end`, `form` | sandhi/compound surface spans |
| `lemma` | `lemma_id` PK, `lemma`, `pos` | built from `(LemmaId, LEMMA)` pairs across the corpus |
| `provenance` | `source_repo`, `source_commit`, `imported_at`, `n_texts`, `n_tokens` | reproducibility record |

`lemma_id` is the **shared join key** to the 2021 export (proven in
[`DCS_FORMAT_COMPARISON.md`](DCS_FORMAT_COMPARISON.md)).

---

## 4. Legacy compatibility exports (old shapes regenerated)

| Old file | How it's regenerated from the master | Fidelity |
|---|---|---|
| `0.csv` | `"name";ref;index;<lemma-id list>;<sandhied text>` per sentence/line | **Full** (re-map anusvāra `ṃ`→`ṁ` if byte-match needed) |
| `_8.csv` | `count,lemma,pos` from `lemma` + token counts | **Full** |
| `10.csv` / `10.txt` | one row per token (IDs, position, morphology) | **Partial** — UD fields full; legacy **numeric codes** need the codebook (§6) |
| `12.csv` / `15.csv` | non-finite / finite verb forms filtered by `FEATS.VerbForm`/`Tense`/… | **Mostly** derivable |
| `timws.csv` | 38 tense/mood categories × corpus frequency | **Recompute** — needs the FEATS→38-category mapping (timws.csv itself is the code table) |
| `texts.csv` | per-text statistical profile (the dashboard input) | **Recompute** from tokens |

Each export is generated, then **diffed against the committed 2021 file** so we see exactly what changed
and why.

---

## 5. Pipeline (phases)

- **Phase 0 — Acquire & pin.** Clone `OliverHellwig/sanskrit`; record the **commit SHA** in `provenance`
  (so the import is reproducible). The repo is large → keep it *outside* VisualDCS, point the importer at
  its `dcs/data/conllu/files/` path.
- **Phase 1 — Parse.** Promote the parser in `compare_dcs_formats.py` to a full reader: MWT spans, all
  `FEATS`, `MISC` (`LemmaId`/`OccId`/`Unsandhied`), and `HEAD`/`DEPREL`. Output staging rows.
- **Phase 2 — Build master.** Load the normalized SQLite schema (§3). Build the `lemma` table from
  `(LemmaId, LEMMA)` pairs; flag `text.has_dependencies`.
- **Phase 3 — Align & diff vs 2021.** Join on `lemma_id` + chapter `ref`; produce a **coverage report**
  (texts added / removed / renamed across 246 ↔ 270) and reconcile the **granularity mismatch** (one old
  metrical line ↔ several CoNLL-U sentences) by keeping the CoNLL-U sentence atomic and recording the old
  line grouping where `0.csv` supplies it.
- **Phase 4 — Legacy exports.** Regenerate the old-shape CSVs (§4) into `exports/legacy/`; diff vs
  committed originals.
- **Phase 5 — Derived analysis + dashboards.** Recompute `texts.csv` / `timws.csv` / `cs.csv` / `verx.csv`
  / `111.csv`, then `visual/*.json` and the `.xlsx`-equivalent; refresh the dashboard headline numbers.
- **Phase 6 — Validate.** See §9.
- **Phase 7 — Land.** Commit `dcs.sqlite` as normal git if small (else its own repo — **not** LFS);
  update `README.md`, `CHANGELOG.md`, `.ai_state.md`; pin the source SHA.

---

## 6. The numeric-codebook problem (the one real fidelity risk)

The old `10.csv` stores morphology as DCS integers; CoNLL-U stores UD `FEATS` strings. To regenerate
`10.csv` **byte-for-byte** we need integer↔feature maps. Strategy:

1. **Recover what's inferable.** `timws.csv` already maps the 38 tense/mood IDs → names. Reconstruct
   case / number / gender / person maps **empirically**: for tokens present in both vintages (same
   `lemma_id` + same surface form in the same chapter), pair the old numeric code with the CoNLL-U UD
   feature and learn the mapping.
2. **Where a code can't be recovered:** keep the new schema **lossless** (UD fields populated), and in the
   legacy `10.csv` export fill the integer via the learned map, or write a **documented sentinel** for the
   unmapped minority.

→ **Decision needed (D1):** is **byte-exact** `10.csv` required, or is *"UD-faithful + best-effort legacy
codes"* acceptable? This materially changes Phase 4 effort.

---

## 7. ID strategy

- **`lemma_id`** — shared across both vintages → the primary join key. Stable.
- **`occ_id`** (CoNLL-U `OccId`) — per-occurrence PK in the new schema.
- **Old per-row PKs** (`10.txt`, e.g. `281915`) appear to be a *different* ID space from `OccId`, so they
  are **not** used for matching. Consequence: we **cannot patch individual 2021 rows** — the refresh
  rebuilds. That's consistent with "full refresh" and is the simplest correct approach.

---

## 8. Syntax (partial treebank)

- Import `HEAD`/`DEPREL` **whenever present**; store on `token`.
- Set `text.has_dependencies` so consumers can filter to the annotated subset.
- Correct the earlier "morphological corpus, not a treebank" wording in the comparison doc (done as part
  of this change).

---

## 9. Validation & acceptance criteria

- **Counts:** report Δ texts / sentences / tokens vs the 2021 dump (expect growth: 246→~270 texts).
- **Cross-walk still holds:** the `0.csv`-style lemma-ID list regenerated from the master must equal the
  CoNLL-U `LemmaId` sequence (the existing `compare_dcs_formats.py` check, run at scale).
- **Idempotency:** re-running the importer on the same source SHA yields byte-identical exports.
- **Spot checks:** N random verses round-tripped against the CoNLL-U source.
- **Dashboard deltas:** new headline numbers (e.g. the 781,616 / 745,394 totals) recomputed and the
  *change explained* (more texts, updated analyses) — not silently swapped.

---

## 10. Deliverables & layout

```
src/DCS-data-2026/
  conllu/                       # submodule -> gasyoun/dcs-conllu (pinned 04e0778)
  parse_conllu.py               # M1: full lossless CoNLL-U reader -> staging JSONL
  staging/  <Text>.jsonl        # M1 output (gitignored, regenerable)
  import_dcs_conllu.py          # M2: the importer (builds dcs.sqlite + exports)
  dcs.sqlite                    # master DB
  exports/
    clean/   *.csv|*.parquet    # tidy UD tables for queries
    legacy/  0.csv, _8.csv, …   # old shapes for the existing pipeline
  DCS_CONLLU_IMPORT_PLAN.md     # this file
  reports/coverage_diff.md      # texts added/removed/renamed, count deltas
```

Plus updates to `README.md`, `CHANGELOG.md`, `.ai_state.md`.

---

## 11. Sequencing & effort (rough)

1. Phase 0–2 (acquire → parse → master DB) — the core; everything else builds on it.
2. Phase 3 (align/diff + coverage report) — needed before trusting any export.
3. Phase 4 (legacy exports) — gated by **D1**.
4. Phase 5 (derived analysis + dashboards) — gated by **D4**.
5. Phase 6–7 (validate + land).

Phases 0–3 are independently useful even if we stop there (a clean, queryable, current DCS DB).

---

## 12. Decisions

**Resolved (2026-06-06):**
- **D1 — `10.csv` fidelity:** ✅ **UD-faithful + best-effort** legacy codes — the new schema is lossless;
  the legacy `10.csv` fills the old integer codes where recoverable, sentinel for the rest. No full
  codebook reverse-engineering. (§6)
- **D4 — Dashboards:** ✅ **data layer first** — build/validate the master + exports; refresh the
  dashboards as a separate follow-up.
- **D5 — Scope:** ✅ **pilot first** — start with the texts already in the 2021 dump, then scale to all ~270.

- **D2 — Source pinning:** ✅ **pin to a commit** — record one source SHA for reproducibility; re-pin
  deliberately when newer data is wanted.
- **D3 — Output location:** ✅ **new `exports/` folders** — write alongside the originals; overwrite the
  2021 files only after validation.
- **D6 — Acquisition:** ✅ **clone upstream to a sibling `sanskrit/` dir** (`git clone --depth 1
  OliverHellwig/sanskrit`); no fork needed — the importer just reads `dcs/data/conllu/files/`.

All decisions are now locked; M0 (below) is unblocked and is the next concrete step.

## 13. Roadmap — milestones

Pilot-first, data-layer-before-dashboards. Each milestone has an acceptance gate.

**Status (2026-06-06):** M0–M2 ✅ done (corpus + parser + SQLite master); **M3 (align & coverage diff) next**.

- [x] **M0 — Acquire & pin.** ✅ *Done 2026-06-06.* Full CoNLL-U committed to `gasyoun/dcs-conllu`
  (pinned `04e0778`, 2026-03-05) and mounted as the `src/DCS-data-2026/conllu` submodule.
  — *Gate met:* the importer reads `src/DCS-data-2026/conllu/files/` (270 texts) + `lookup/dictionary.csv`.
- [x] **M1 — Parser → staging.** ✅ *Done 2026-06-06.* `parse_conllu.py` — full **lossless** CoNLL-U
  reader (MWT spans, all FEATS incl. the DCS-specific `Formation`, all MISC, `HEAD`/`DEPREL`, empty
  nodes, doc + sentence metadata) → one JSONL per text in `staging/` (gitignored). — *Gate met:*
  Meghadūta (244 sent / 3393 tok, morphological) **and** Ṛgveda treebank (264 dependency arcs) both
  parse with **0 column errors**.
- [x] **M2 — Master DB (pilot).** ✅ *Done 2026-06-06.* `import_dcs_conllu.py` builds `dcs.sqlite`
  (flatten-all schema — every FEATS/MISC key a column; `lemma` ← `dictionary.csv`) over a 13-text pilot
  (incl. Ṛgveda + Arthaśāstra treebanks). — *Gate met:* schema loads · 180,176 lemmas · 134,027 tokens ·
  **0 orphan lemma_ids** (FK OK).
- [ ] **M3 — Align & coverage diff.** Join on `lemma_id` + chapter ref; reconcile granularity; emit
  `reports/coverage_diff.md`. — *Gate:* coverage report reviewed.
- [ ] **M4 — Exports (pilot).** Generate clean + legacy CSVs; diff legacy vs the committed 2021 files;
  learn the best-effort code map. — *Gate:* regenerated `0.csv`/`_8.csv` match originals (modulo
  documented anusvāra / code gaps).
- [ ] **M5 — Validate pilot.** Cross-walk at scale, idempotency, N-verse spot checks. — *Gate:* green on
  the pilot.
- [ ] **M6 — Scale to all ~270 texts.** — *Gate:* full import idempotent; coverage matches upstream.
- [ ] **M7 — Derived analysis + dashboards (follow-up).** Recompute `texts.csv` / `timws.csv` /
  `visual/*.json`; refresh dashboard numbers with deltas explained. — *Gate:* dashboards render; changes
  documented.
- [ ] **M8 — Land.** Commit `dcs.sqlite` (normal git if small, else its own repo — **not** LFS, per the
  de-LFS decision); update `README.md` / `CHANGELOG.md` / `.ai_state.md`; pin the source SHA.
  — *Gate:* committed; docs updated.

> Stop-anywhere value: after **M5** you already have a clean, queryable, current DCS DB for the pilot
> texts, even if M6–M8 wait.
