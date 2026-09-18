#!/usr/bin/env python3
"""test_concordance_sa.py — offline unit tests for the H5153 SA concordance layer.

No database, no network: every test runs on a synthetic byte corpus built in-memory.
The compiled SA/LCP path needs pydivsufsort (skipped when the wheel is absent, so the
suite stays green on a bare box); the pure-Python fallback is exercised directly.

Run from the VisualDCS repo root:
    python -m pytest src/DCS-data-2026/test_concordance_sa.py -q
"""
from __future__ import annotations

import sys
from pathlib import Path

import pytest

REPO = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(REPO / "tools"))

import sais_concordance as cs  # noqa: E402


CORPUS = b"banana bandana bananarama\nsecond sentence here\x00third text starts"


def naive_suffix_array(T: bytes):
    return sorted(range(len(T)), key=lambda i: T[i:])


def naive_lcp(T: bytes, sa):
    lcp = [0]
    for i in range(1, len(sa)):
        a, b, h = sa[i - 1], sa[i], 0
        while a + h < len(T) and b + h < len(T) and T[a + h] == T[b + h]:
            h += 1
        lcp.append(h)
    return lcp


def test_suffix_array_matches_naive():
    pytest.importorskip("pydivsufsort")
    sa, backend = cs.build_suffix_array(CORPUS)
    assert "compiled" in backend or "divsufsort" in backend
    assert sa.tolist() == naive_suffix_array(CORPUS)


def test_lcp_matches_naive():
    pytest.importorskip("pydivsufsort")
    sa, _ = cs.build_suffix_array(CORPUS)
    lcp, _ = cs.build_lcp(CORPUS, sa)
    assert lcp.tolist() == naive_lcp(CORPUS, list(sa))


def test_find_range_matches_naive_scan():
    pytest.importorskip("pydivsufsort")
    sa, _ = cs.build_suffix_array(CORPUS)
    for pat in [b"banana", b"ban", b"a", b"\nsecond", b"absent", b"bandana", b" "] :
        lo, hi = cs.find_range(CORPUS, sa, pat)
        assert sorted(sa[lo:hi].tolist()) == cs.naive_find(CORPUS, pat), pat


def test_pattern_separators_rejected():
    with pytest.raises(SystemExit):
        cs._pattern_bytes("bad\npattern")
    with pytest.raises(SystemExit):
        cs._pattern_bytes("bad\x00pattern")
    assert cs._pattern_bytes("sapta sa") == b"sapta sa"  # spaces are legal


def test_text_boundary_rewrites_join_space():
    # tokens: three tokens over two texts; the join space at the text change -> \x00
    T = bytearray(b"aa bb \ncc ")
    tok_start = [0, 3, 7]
    tok_sent = [0, 0, 1]
    sent_chap = [1, 2]
    chap_text = {1: 10, 2: 20}
    T2, sent_text, marked = cs.mark_text_boundaries(T, tok_start, tok_sent, sent_chap, chap_text)
    assert marked == 1
    assert T2[5:7] == b"\x00\n", bytes(T2)
    assert sent_text.tolist() == [10, 20]


def test_maximal_repeats_on_toy_corpus():
    pytest.importorskip("pydivsufsort")
    T = b"xyabcabcabcxy"
    sa, _ = cs.build_suffix_array(T)
    lcp, _ = cs.build_lcp(T, sa)
    reps = cs.top_maximal_repeats(sa, lcp, T, 5)
    frags = {r["repeat"] for r in reps}
    assert any("abcabc" in f or "abc" in f for f in frags), frags


def test_naive_find_is_the_oracle():
    assert cs.naive_find(CORPUS, b"banana") == [0, 15]
    assert cs.naive_find(CORPUS, b"xz") == []


def test_per_text_counts_resolve_chapters():
    import numpy as np
    tok_start = np.asarray([0, 5, 10], dtype=np.int32)
    tok_sent = np.asarray([0, 0, 1], dtype=np.int32)
    sent_chap = np.asarray([7, 9], dtype=np.int32)
    chap_text = {7: 100, 9: 200}
    texts = {100: "Alpha", 200: "Beta"}
    rows = cs.per_text_counts([0, 5, 10], tok_start, tok_sent, sent_chap, chap_text, texts)
    assert rows == [("Alpha", 2), ("Beta", 1)]