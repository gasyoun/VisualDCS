# DharmaMitra Pre-Workshop Questionnaire — what it tells us for Sanskrit dictionary work

_Created: 02-07-2026 · Last updated: 02-07-2026_

**Source:** [non-derived/Pre-Workshop_Questionnaire.md](https://github.com/gasyoun/VisualDCS/blob/main/non-derived/Pre-Workshop_Questionnaire.md) — a saved draft of the Google Form for the [DharmaMitra](https://dharmamitra.org/) workshop *"Translation in the Age of AI: DharmaMitra for Translator Workflows"*, with M. Gasūns' draft answers. Public visibility of both files was explicitly approved by MG on 02-07-2026.

## What the document is

A pre-workshop intake form from the DharmaMitra team (Buddhist/classical-text AI translation, Berkeley ecosystem). It is dual-value: (a) the **form's own questions** reveal how a leading AI-translation team models the problem space; (b) the **draft answers** record a positioning statement of our own work.

## Six takeaways for the dictionary work

### 1. Cologne dictionaries are named as baseline infrastructure

The form's tool list explicitly cites *"Cologne Sanskrit Dictionaries"* alongside DDB, Steinert, and RangjungYesheWiki as the online lexicons translators rely on. That is third-party confirmation — from a competing/adjacent AI team — that CDSL is the reference dictionary layer for the AI-translation community. Usable as an impact statement in papers and grant text (feeds [`Uprava/ARTICLES.md`](https://github.com/gasyoun/Uprava/blob/main/ARTICLES.md) framing).

### 2. "Updatable verified dictionary" — the recorded thesis of our whole pipeline

The draft answer to *"biggest challenges or bottlenecks in your current translation workflow"* is **"Udpatable verified dictionary"** (sic — typo worth fixing in the live form: *Updatable*). One line, but it is exactly the gap the Cologne-side work targets:

- **verified** — human-gated corrections ([csl-corrections](https://github.com/sanskrit-lexicon/csl-corrections) audit trail, G5-gated pwg_ru promotion, review-sheet voting);
- **updatable** — the monthly batched-PR correction pipeline into csl-orig, vs. frozen print-era PDFs.

No existing tool in the form's list (DharmaMitra included) offers this combination. That is the differentiator sentence for the kosha lookup service and any lexicography paper introduction.

### 3. A ready-made failure taxonomy for our translation gates

The form's *"biggest problems with AI / machine translation"* options are a field-tested error typology: terminology inconsistency · grammar/syntax · context loss across sentences · passage-level incoherence · technical-term handling · register · **hallucinated content** · **polysemy**. Plus a breakdown-level scale (word → sentence → paragraph → whole document) and a post-editing-burden scale.

This maps almost 1:1 onto the PWG→RU/EN judging rubric (the S7 Fable judge's failure class was "addition", i.e. hallucinated content, incl. one MW translation-memory leak). Adopting DharmaMitra's category names as the shared vocabulary in [`FU1_PLAN.md`](https://github.com/gasyoun/RussianTranslation) methods/provenance sections makes our evaluation legible to the wider field — we measure the same failure classes they ask about.

### 4. DharmaMitra is a potential consumer of Cologne data, not just a competitor

Their feature list — Translate, Deep Research (translation **with references**), Explore (parallel passages), grammatical/segmentation analysis, OCR, DharmaNexus (intertextuality), **dictionary/lexical lookup** — includes surfaces that a machine-readable CDSL could feed. The C-SALT/Kosh API work in csl-apidev is the natural integration point: their "Deep Research with references" needs exactly the citable, versioned dictionary layer we maintain. Workshop = the networking channel to propose it.

### 5. Audience segmentation for the learner's layer

The persona question (professional translator / academic / student / practitioner / hobbyist) and the source-language multi-select (Tibetan, Sanskrit, Pāli, Chinese, Japanese) sketch the market DharmaMitra sees. For the Q4 2026 learner's-layer plan and kosha's audience definition, this is free market research: the practitioner + hobbyist segments are first-class users there, not an afterthought.

### 6. The workshop itself is a demo slot

The form invites bringing *"a short passage or translation sample to work on together."* A PWG entry (or a Sanskrit passage) where the verified-dictionary layer demonstrably corrects an AI mistranslation — e.g. a G5-rejected card vs. its gated final — would demo the "updatable verified dictionary" thesis live, in front of the one team best positioned to consume it.

## Follow-ups (decided 02-07-2026, MG)

1. **@DO (human):** fix the "Udpatable" typo in the live Google Form before submitting. Workshop is within ~2 weeks of 02-07-2026.
2. **Decided:** both files committed to public VisualDCS as-is.
3. **Decided:** prepare a PWG G5 demo passage (a gate-caught unfaithful translation, before/after) — agent task, handoff in [`Uprava/handoffs/`](https://github.com/gasyoun/Uprava/tree/main/handoffs).
4. **Decided:** "propose CDSL/Kosh API feed to DharmaMitra" = GTD **@DO after workshop**, anchored on the csl-apidev Salt/Kosh integration.

_Dr. Mārcis Gasūns_
