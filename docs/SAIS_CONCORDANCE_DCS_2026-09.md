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
array ([`tools/sais_concordance.py`](https://github.com/gasyoun/VisualDCS/blob/main/tools/sais_concordance.py)),
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
py -3.12 -m pip install pydivsufsort numpy     # any Python ≥3.9 with the wheel; py -3.12 on Windows
py -3.12 tools/sais_concordance.py build     # → derived-data/concordance_sa/
py -3.12 tools/sais_concordance.py selftest  # 5 patterns vs naive scan, 1M-token slice
py -3.12 tools/sais_concordance.py find 'dharmakṣetre'
py -3.12 tools/sais_concordance.py count-text 'dharma'
py -3.12 tools/sais_concordance.py repeats --top 20
py -3.12 tools/sais_concordance.py table
```

Without the wheel the SA falls back to a system `libdivsufsort` via ctypes, and the
LCP to pure-Python Kasai (correct, minutes slower). Two API conventions are worth
recording because both trained a bug: `pydivsufsort.kasai` returns the **forward-shifted**
LCP (gap between SA entries `i` and `i+1`) and is reindexed to the textbook convention
here; LCP-interval bounds are `[start-1, i-1]` on pop, not `[start, i]` — the offline
toy-corpus test caught the off-by-one that shifted every repeat frequency.

## Measured

Corpus: **48,167,032 bytes · 5,688,416 tokens · 754,726 sentences · 270 texts ·
269 text boundaries** — all four counts match the deep manual's live-verified row
counts, i.e. the spine join is lossless. Corpus stats and artifact sizes are
byte-identical across both build boxes below.

### macOS (18-09-2026, Python 3.13.15, pydivsufsort 0.0.20)

| stage | time |
|---|---|
| spine (text/chapter/sentence maps) | 0.42 s |
| extract + token join | 8.58 s |
| SA-IS (`pydivsufsort.divsufsort`) | 1.90 s |
| Kasai LCP (`pydivsufsort.kasai`) | 1.25 s |
| **total wall** | **≈13 s** |

### Windows (18-09-2026, Python 3.12.0, pydivsufsort 0.0.20 — independent verification pass)

| stage | time |
|---|---|
| spine (text/chapter/sentence maps) | 1.89 s |
| extract + token join | 28.29 s |
| SA-IS (`pydivsufsort.divsufsort`) | 3.36 s |
| Kasai LCP (`pydivsufsort.kasai`) | 3.80 s |
| **total wall** | **≈37 s** |

Selftest on the Windows box: **5/5 patterns exact vs naive scan** on the 1M-token
slice (8,493,339 B · 57 text boundaries), compiled backends engaged. Hand-checked
hits: the `dharmakṣetre` occurrence verified byte-level in `T.bin` at offset
37,550,420 (`… sa prabhuḥ \ndharmakṣetre kurukṣetre`) and through SQL joins
(sentence 7 of `SkPur (Rkh), Revākhaṇḍa, 143`, sent_id 416558); `count-text 'dharma'`
is substring-semantics by design — e.g. Mahābhārata 5,510 occurrences vs 2,660
exact-form tokens in plain SQL — the documented stem-query behaviour.

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

Index artifact digests (Windows verification build, `derived-data/concordance_sa/`,
SHA256 — regenerate locally; nothing large is committed):

| artifact | SHA256 |
|---|---|
| `T.bin` | `2557b35b4c783f47cbe99a8cded607da8dff5f4375e00c6b6baa023160895cde` |
| `sa.npy` | `774c7769ed1662064ef9bbd1b9f437812b55bde447b5683ad6f59d241878f8ca` |
| `lcp.npy` | `03ff36c33f93b4880ecb1d09ea133b6da1b49dce2096dcd5325305a4f3d0ffb1` |

## Findings the queries produced

- `find 'dharmakṣetre'` → **1 occurrence**: `SkPur (Rkh), Revākhaṇḍa, 143`, sent 7 —
  byte-level and SQL-verified, this IS the famous Gītā 1.1 dyad opening
  (`dharmakṣetre kurukṣetre`), quoted inside the Skandapurāṇa (Revākhaṇḍa); DCS holds
  exactly one token instance in the whole 5.69M-token master (the naive-scan oracle
  agrees on the same text).
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