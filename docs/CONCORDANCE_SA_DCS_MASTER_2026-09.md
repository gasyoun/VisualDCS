# SA-IS concordance layer over the DCS 2026 master

_Created: 18-09-2026 · Last updated: 18-09-2026_

_Handoff: [H5153](https://github.com/gasyoun/Uprava/blob/main/handoffs/H5153-OxAlpha_VisualDCS_sais-concordance-dcs-master_18.09.26.md)
(OxAlpha `zai-coding-plan/glm-5.3-flash`) · predecessor: [H5137](https://github.com/gasyoun/Uprava/blob/main/handoffs/H5137-OxAlpha_Uprava_6851-l16-suffix-array-doc-retrieval_18.09.26.md)
(MIT 6.851 L16 study, demo-scale prototype) · MIT 6.851 Spring'21
[L16](https://courses.csail.mit.edu/6.851/spring21/lectures/L16.html) ·
[L17](https://courses.csail.mit.edu/6.851/spring21/lectures/L17.html) ·
[L18](https://courses.csail.mit.edu/6.851/spring21/lectures/L18.html) (E. Demaine)_

## What this is

A compiled suffix-array concordance over the full DCS 2026 master: the concatenated
`token.form` stream of all 5,688,416 tokens, indexed with a linear-time SA-IS suffix
array ([`concordance_sa.py`](https://github.com/gasyoun/VisualDCS/blob/main/concordance_sa.py)),
a Kasai LCP array, and color arrays that map every text position back to its token,
sentence, chapter and text through the canonical spine join
([`docs/DCS_SQLITE_CONLLU_CONSUMER_DEEP_MANUAL.md`](https://github.com/gasyoun/VisualDCS/blob/main/docs/DCS_SQLITE_CONLLU_CONSUMER_DEEP_MANUAL.md) §3).

It is the scale-up the H5137 lecture study called for: that prototype used rank
doubling (O(n log² n), honest at 646 K headword chars) and no color array; this layer
uses compiled SA-IS and answers the four concordance queries over the real master.

Prior art distinct: [`gen_concordance_data.py`](https://github.com/gasyoun/VisualDCS/blob/main/gen_concordance_data.py) +
[`sanskrit_concordance.html`](https://github.com/gasyoun/VisualDCS/blob/main/sanskrit_concordance.html)
(H1505) is a UI over pre-computed per-form counts with no suffix array; the kosha
Paninian sūtra-corpus concordance indexes a different object.

## Build and query

The corpus master is read-only and streaming (`file:...?mode=ro`), per CLAUDE.md.
The index artifacts are **not** committed — `derived-data/concordance_sa/` is
gitignored; regenerate locally (≈13 s wall, ≈1 GB peak RSS) with the compiled wheel:

```sh
python3 -m venv .venv-sa && .venv-sa/bin/pip install pydivsufsort numpy
.venv-sa/bin/python concordance_sa.py build     # → derived-data/concordance_sa/
.venv-sa/bin/python concordance_sa.py selftest  # 5 patterns vs naive scan, 1M-token slice
.venv-sa/bin/python concordance_sa.py find 'dharmakṣetre'
.venv-sa/bin/python concordance_sa.py count-text 'dharma'
.venv-sa/bin/python concordance_sa.py repeats --top 20
.venv-sa/bin/python concordance_sa.py table
```

Without the wheel the SA falls back to a system `libdivsufsort` via ctypes, and the
LCP to pure-Python Kasai (correct, minutes slower). Two API conventions are worth
recording because both trained a bug: `pydivsufsort.kasai` returns the **forward-shifted**
LCP (gap between SA entries `i` and `i+1`) and is reindexed to the textbook convention
here; LCP-interval bounds are `[start-1, i-1]` on pop, not `[start, i]` — the offline
toy-corpus test caught the off-by-one that shifted every repeat frequency.

## Measured (build 18-09-2026, macOS, Python 3.13.15, pydivsufsort 0.0.20)

Corpus: **48,167,032 bytes · 5,688,416 tokens · 754,726 sentences · 270 texts ·
269 text boundaries** — all four counts match the deep manual's live-verified row
counts, i.e. the spine join is lossless.

| stage | time |
|---|---|
| spine (text/chapter/sentence maps) | 0.42 s |
| extract + token join | 8.58 s |
| SA-IS (`pydivsufsort.divsufsort`) | 1.90 s |
| Kasai LCP (`pydivsufsort.kasai`) | 1.25 s |
| **total wall** | **≈13 s** |

| artifact | bytes |
|---|---|
| `T.bin` (corpus text) | 48,167,032 |
| `sa.npy` (int32 SA) | 192,668,256 |
| `lcp.npy` (int32 LCP) | 192,668,256 |
| `tok_start.npy` / `tok_sent.npy` (int32 × 5,688,416) | 22,753,792 each |
| `sent_chap.npy` / `sent_no.npy` (int32 × 754,726) | 3,019,032 each |
| `sent_sid.json.gz` | 1,697,562 |
| **index total** | **486,747,153 B = 10.11× raw text** |

**Vs the H5137 ~100 MB estimate: 105 MB estimated → 487 MB measured (~4.9× over).**
The estimate was optimistic because it counted the SA alone; the dominant real cost is
SA + LCP at 4 bytes per text byte each (384 MB together), plus 51 MB of color arrays.
Halving is possible (LCP could be compressed, the SA is irreducible at 32-bit for a
48 MB text); a whole-index reduction needs an FM-index/BWT, which the L18 lecture
covers but this handoff scoped out.

## Findings the queries produced

- `find 'dharmakṣetre'` → **1 occurrence**: `SkPur (Rkh), Revākhaṇḍa, 143`. The famous
  Gītā 1.1 form is not a DCS token there — a real corpus-shape fact worth a follow-up,
  not an index defect (the naive-scan oracle agrees on the same text).
- `count-text 'dharma'` → 12,361 occurrences; top: Mahābhārata 5,510 · Rāmāyaṇa 847 ·
  Saddharmapuṇḍarīkasūtra 475 · Matsyapurāṇa 314 · Aṣṭasāhasrikā 292 · Lalitavistara 277.
- `repeats` → the top maximal repeats are **Buddhist sūtra stock passages**: a 4,132-char
  passage ×2, and the Lalitavistara/Avadāna litany *"…vyākartu kāmaḥ bhavati … 'ntardhīyante"*
  repeated 3–6×. The LCP-interval query is exactly the philological instrument the
  handoff asked for: duplicate and near-duplicate intertexts surface without any
  alignment work.

## Limits

- Search is **O(P log n)**, not O(P): the H5136 RMQ over LCP is not wired in, and no
  suffix-tray/LRUF machinery is used (same sanctioned substitution the H5137 note
  recorded).
- The index is single-machine, in-memory (`np.load`); 487 MB is fine locally, not a
  service shape.
- Matches are over the **byte** text: a pattern may match inside a form (documented
  behaviour, useful for stem queries) and never crosses a sentence (`\n`) or text
  (`\x00`) boundary; the token-join space is searchable, so two-word phrases work.

_Гасунс_