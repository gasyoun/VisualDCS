_Created: 19-07-2026 · Last updated: 19-07-2026_

# Plan — paradigm trainer scale-up: 6 roots → the attested verb space (2026 H2)

Generalise the shipped 6-root paradigm browser
([`sanskrit_pxn_v4.html`](https://github.com/gasyoun/VisualDCS/blob/main/sanskrit_pxn_v4.html):
√kṛ, √bhū, √as, √gam, √vac, √dā across the corpus's 25 tense/mood categories) into a
**frequency-driven trainer over the whole attested verb space** (~8k roots), showing and
drilling **only corpus-attested cells**. This executes two items the repo's own README
future-work list already names — "Attested-only filter" and the flashcard extension —
and the org-wide quantification flagged in
[`FEATURES_INDEX.md`](https://github.com/gasyoun/SanskritLexicography/blob/master/FEATURES_INDEX.md).

Staged 19-07-2026 via [`/ask-batch`](https://github.com/gasyoun/claude-config/blob/main/commands/ask-batch.md)
by Fable 5 (`claude-fable-5`); interview rulings in
[`ASK_BATCH_STAGING_PEDAGOGY_2026-07.md`](https://github.com/gasyoun/Uprava/blob/main/ASK_BATCH_STAGING_PEDAGOGY_2026-07.md).
Handoff: [H1299](https://github.com/gasyoun/Uprava/blob/main/handoffs/H1299-Sonnet_VisualDCS_paradigm-trainer-attested-scaleup_19.07.26.md)
(Sonnet 5 `claude-sonnet-5`, queued).

## Decisions taken (19-07-2026)

| # | Decision | Ruling |
|---|---|---|
| 1 | Home | **VisualDCS** — the browser, its data pipeline (`src/DCS-data-2021/` → `visual/paradigm_endings.json`), and the flashcard pattern live here; heavier builds prove standalone first (mixed-per-candidate ruling) |
| 2 | Cell inventory source | **Corpus-attested cells only** by default: reuse the existing per-root form extraction that powers the 6-root browser, scaled by frequency; cross-check against the csl-observatory paradigm-cell coverage dataset (E46, distinct finite cells per root) rather than re-deriving that census |
| 3 | Scale strategy | **Frequency-first**: top-100 roots get the full browser treatment (the `sanskrit_verb_forms.md` inventory already covers them); the long tail gets attested-cells-only cards, no hand-curated notes |
| 4 | No new engine | Extend the existing static HTML/JS pattern (self-contained, double-click, no server) — the repo's house style; no framework |
| 5 | Downstream | Export a trainer-consumable JSON so Systema/kosha can pull items later; registered in kosha's manifest when it ships |

## Implementation steps ([H1299](https://github.com/gasyoun/Uprava/blob/main/handoffs/H1299-Sonnet_VisualDCS_paradigm-trainer-attested-scaleup_19.07.26.md))

1. **Data build**: extend the generation path that produces
   [`visual/paradigm_endings.json`](https://github.com/gasyoun/VisualDCS/blob/main/visual/paradigm_endings.json)
   / the 6-root data into a per-root attested-cell table for all roots above a frequency
   floor (floor documented in the script header; report how many roots/cells the floor
   admits). Reuse the repo's existing CSV parsing — do not re-derive from raw DCS.
2. **Cross-check (consume, don't rebuild)**: reconcile per-root distinct-cell counts
   against csl-observatory's paradigm-cell coverage dataset (E46); disagreements logged
   to a report file, not silently resolved.
3. **UI scale-up**: root picker with search + frequency rank; attested-only cells
   rendered (the README's "attested-only filter" done by construction); per-cell corpus
   counts kept (the existing color-coding); the известное 6-root deep view stays intact.
4. **Trainer mode**: extend the existing flashcard pattern (P9) to the scaled space:
   cards sampled frequency-weighted from attested cells; export JSON for downstream SRS.
5. **Ambiguity discipline**: unaccented-DCS class ambiguities (I/VI, IV/passive) and
   `Tense=Past` conflation carry through as flags on affected cells — surface, never
   fabricate (the kosha R1/R3 rulings, same data).
6. **Verification**: spot-check 10 roots' cells against the 6-root browser + corpus
   counts; page loads standalone; a regression script pins the top-100 root list; DCS
   (Hellwig) attribution on the page.

## Verification / acceptance

- Data build reproducible (byte-stable rerun); floor + admitted counts reported.
- E46 reconciliation report committed; zero silent disagreement resolutions.
- 6-root browser behaviour unchanged (its users keep their tool).
- Page + trainer load standalone by double-click; no external requests.
- Changelog entry + release; `.ai_state.md` updated; hub sweep on ship.

_Dr. Mārcis Gasūns_
