# SIGNOFF A38 — author-voice pass

_Created: 06-09-2026 · Last updated: 06-09-2026_

**Scope.** Manuscript: [papers/A38_dcs2026_release_paper.md](https://github.com/gasyoun/VisualDCS/blob/main/papers/A38_dcs2026_release_paper.md) — *The Digital Corpus of Sanskrit 2026: An Open Treebank-and-Morphology SQLite Release with a Validated 2021→2026 Cross-Walk*. Handoff: [H3857](https://github.com/gasyoun/Uprava/blob/main/handoffs/H3857-Fable_Uprava_all-articles-author-voice-pass-workflow_01.09.26.md). Pass 1, 06-09-2026, Fable 5.1 (`claude-fable-5-1`). Voice, register and framing only; no number, claim or citation altered; mechanical drift gate ([voice_drift_check.py](https://github.com/gasyoun/Uprava/blob/main/tools/voice_drift_check.py) against `origin/main`) CLEAN: numbers 351/351, URLs 58/58, citations 4/4, IAST 23/23, headings 22/22, table rows 47/47. No review memo existed for this paper; this is the first signoff.

## 1. Voice calls made — each may be vetoed

| # | Location | Call | Rationale |
|---|---|---|---|
| 1 | Abstract, §1, §2, §2.1, §3.4, §5.1 (21 pronouns) | `we` / `our` → `I` / `my` / `the` throughout the prose | Sole-authored data descriptor; Research Data Journal does not forbid the singular. Every `our X` that named a table or the pipeline became `the X` or `my X`. Revert wholesale if the venue's copy-editor wants the plural. |
| 2 | Abstract, last sentence | "The contribution is not new corpus annotation — that is Hellwig's — but a validated … packaging" → "The contribution is a validated … packaging …; the corpus annotation itself is Hellwig's, and none of it is new here." | Removes the "not X — but Y" cliché and the em-dash copula; the negation (no new annotation, Hellwig's) is kept at the same strength. |
| 3 | Abstract | "We are deliberately explicit about two annotation caveats" → "I state explicitly two annotation caveats" | Drops the self-congratulating adverb; the explicitness is now shown, not asserted. |
| 4 | §1, para 1 | "de-facto" → "de facto" | Typography; the Latin phrase takes no hyphen. |
| 5 | §1, paras 1–2 | Four bold inline emphases (`relational-database export`, `Universal-Dependencies CoNLL-U`, `queryable SQLite master`, `lemma-keyed cross-walk`) un-bolded | Bold-every-other-term in running prose; the abstract's bold headline numbers and the numbered-claim lead-ins are untouched. |
| 6 | §1, before the numbered claims | "Our claims are modest and data-oriented:" → "The claims are modest and data-oriented:" | **Reverted after adversarial verify:** the added contribution sentence ("The contribution is a single one: … lemma-keyed cross-walk.") was refuted as a meaning change and deleted; only the pronoun drop of call 1 remains on this line. |
| 7 | §1, claim 3 | Em-dash after the bold lead-in → full stop | Em-dash-as-copula; sentence content unchanged. |
| 8 | §2, para 1 | The bold "We could not independently verify …" sentence: pronoun → I only | **Partly reverted after adversarial verify:** the bold markers on the do-not-cite disclaimer are restored (their removal was refuted as weakening a warning); the pronoun change of call 1 stays. |
| 9 | §2.1 | "The **novelty claim** is not new annotation but the *validated … packaging* … migrate." → "The novelty claim is the *validated … packaging* … migrate; new annotation is not claimed." | Third occurrence of the same "not X but Y" frame; negation kept. |
| 10 | §3.4, after the code table | "… landing in the *same* UD bucket is not a mapping error — it is the UD `Tense=Past` collapse …" → "That the Perfect and Aorist rows land in the *same* UD bucket is no mapping error: it is the UD `Tense=Past` collapse …" | Em-dash copula → colon; contrast and reference to §6 unchanged. |
| 11 | §5, para 1 | "… one command and one SHA — the property that distinguishes …" → "… one SHA, which is the property that distinguishes …" | Em-dash copula. |
| 12 | §7, opening | ~~Added: "The reuse problem posed in the introduction … is closed."~~ | **Reverted after adversarial verify:** refuted as a meaning change (a new closing claim not made in the abstract); the conclusion opens as in origin ("DCS-2026 is a FAIR, reproducible, query-ready packaging…"). |
| 13 | Header | Both dated header lines bumped to 06-09-2026; one line "author-voice pass 06-09-2026 (SIGNOFF link)" appended to the draft-status blockquote | Per the pass contract; nothing else in the status note touched. |

Not changed on purpose: "not merely *more data* but a format redesign" (§1 — the qualifier *merely* is part of the claim); "The release is intentionally a *layer over* the DCS, not a re-annotation" (§5) and "It does not re-annotate Sanskrit; it makes …" (§7) — both are the paper's genuine boundary statement, one contrast per section is fair; "A queryable, validated master changes what is cheap." (§5) — authorial, kept.

## 2. Substance flags carried (not fixed)

1. **Consumer count mismatch.** §2 ("Sanskrit-NLP consumers") says "§5 documents five concrete consumers of the present release"; §5.1 lists **three** consumers of the master and then two pipelines of the companion archive, explicitly "not as uptake of the master". One of the two sentences is wrong.
2. **Readiness inconsistency.** YAML front matter and `status:` say 4/5; the draft-status blockquote still opens "Draft status (2026-07-04, readiness 3/5)".
3. **DOI claimed before minting.** The abstract calls the descriptor "DOI-minted"; §8 carries the DOI as a TODO and the status note lists minting as open item (1). Either "DOI-minted" waits for the Zenodo step or the abstract says "to be DOI-minted".
4. **Working notes inside the body.** §2 ends with a paragraph about ISCLS 2026 ("no specific ISCLS 2026 paper … was identified … so none is added pending a fuller TOC check before submission") and §6 bullet 1 closes with "(A previous edition of this paper reported `feat_formation` as …)". Both are editorial history addressed to the author, not to a reader of a data descriptor; decide whether they survive submission.
5. **Aorist/perfect: three statements a referee may read as contradictory.** §4.4 reports Perfect Active / Aorist Active / Periphrastic Perfect "no longer merged (§6)"; §6 says the collapse is "partially recoverable"; §6.1 says "No re-split of aorist vs perfect (see above)". The distinction (release tables vs dashboard-side derivation) is stated in §6.1 but easy to miss; one connecting clause in §4.4 would remove the reading.
6. **Two code denominators.** §3.4 "31 of 33 attested codes resolve" (pilot scope) vs §4.4's correction box "`timws.csv` binds 42 category codes to only 30 distinct category names" — the text never reconciles 33 attested with 42 bound.
7. **Unsourced count.** §1 "a directory of ~15,900 plain-text files" has no row in the §4.5 claim-to-artifact inventory, which promises that "every headline figure … traces to a committed, public artifact".
8. **781,618 vs 781,616.** §4.4's first sentence gives 781,618 without pointing to the correction box that explains the 2-unit gap to the documented 781,616; a referee reading linearly meets the discrepancy before the explanation.
9. **Two dated header lines.** The file carries `_Created … · Last updated …_` both above the YAML block (line 1) and below the H1 (line 15); both were bumped, one should go at camera-ready.
10. **Repo conventions in the submission copy.** The YAML front matter, the draft-status blockquote, the §4.4 "Correction (04-08-2026)" box and the closing `_Dr. Mārcis Gasūns_` line are repository furniture; the academic byline (no "Dr.") is already correct in the front matter.

## 3. Read-and-sign

Reading time ~30 minutes: the abstract and §1 (calls 1–7), §2–2.1 (calls 8–9), §3.4 (call 10), §7 (call 12), then flags 1, 3 and 5, which touch what the paper claims. Proposed readiness: stays **4/5** (propose only); the bump to 5/5 waits on flags 1 and 3 and on the two open items in the status note (Zenodo DOI, §2 bibliographic check). Venue: Research Data Journal is locked and fits the data-descriptor genre the paper itself invokes in §2; no change recommended.

_Dr. Mārcis Gasūns_
