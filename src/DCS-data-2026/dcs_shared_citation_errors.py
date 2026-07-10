#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""F4-DCS — shared *erroneous* citation test (MW <- Boehtlingk), run against the DCS passage corpus.

Handoff H203 (Opus 4.8, ``claude-opus-4-8``). Supersedes H128 (which was blocked because the
local ``DCS`` repo has reference data only, no passage corpus). This runs against the
VisualDCS-local DCS CoNLL-U SQLite master, which DOES carry per-token lemmas keyed to a
verse locus.

Method
------
For each shared rare ``<ls>`` citation that appears in BOTH a Petersburg dictionary (PWG/PW)
and MW, resolve its verse reference to a DCS locus and check whether the cited passage's
tokens actually contain the cited lemma:

* VERIFIED  — locus resolvable AND lemma present at that locus.
* ERRONEOUS — locus resolvable AND lemma absent  (a shared wrong locus = copying, the smoking gun).
* UNRESOLVED — the reference cannot be mapped to a DCS locus at all (with a machine reason code).

A shared ERRONEOUS ref is the airtight evidence: two independent lexicographers cannot invent
the same wrong locus. But an "absent lemma" is often an edition/numbering artifact rather than a
real error, so ERRONEOUS candidates are emitted for HAND adjudication, never auto-counted as proof.

Read-only against the DCS master; emits CSV + JSON reports with provenance and coverage
denominators. Silent coverage caps are a defect, so every unmapped sigil/text and every
out-of-range number is reported with its reason, not dropped.

Paths default to the in-repo layout; override with env vars F4_DCS_DB / F4_CAND / F4_REPORTS.
"""
import sqlite3, csv, json, re, sys, os, hashlib

sys.stdout.reconfigure(encoding="utf-8")
sys.stderr.reconfigure(encoding="utf-8")
from indic_transliteration import sanscript

HERE = os.path.dirname(os.path.abspath(__file__))
DCS_FULL = os.environ.get("F4_DCS_DB") or os.path.join(HERE, "dcs_full.sqlite")
DCS_CLEAN = os.path.join(HERE, "dcs.sqlite")
CAND_CSV = os.environ.get("F4_CAND") or r"C:\Users\user\Documents\GitHub\csl-atlas\data\forensic\shared_rare_citations.csv"
ABBR_LIST = r"C:\Users\user\Documents\GitHub\DCS\DCS-abbreviation-list.txt"
REPORTS = os.environ.get("F4_REPORTS") or os.path.join(HERE, "reports")

# ---------------------------------------------------------------------------
# CDSL <ls> sigil -> DCS text.  Deliberately CONSERVATIVE: only sigils whose
# Petersburg-dictionary referent is the SAME work DCS carries are mapped. A wrong
# map would manufacture spurious loci, so ambiguous/mismatched sigils are left
# unmapped and reported (BIJAG. in PW = Bijaganita (Colebrooke, mathematics), NOT
# DCS's Bijanighantu -> unmapped; GANAR/LAGHUK/CHANDOM/BHASAP/VEDANTAS/SAH/PURUSOTT/
# VENIS have no DCS text at all).
# ---------------------------------------------------------------------------
SIGIL_TO_DCS = {
    "HARIV": ("Harivaṃśa", 566),
    "KAUŚ": ("Kauśikasūtra", 71),
    "CAURAP": ("Caurapañcaśikā", 437),
}


def sha256(path):
    try:
        h = hashlib.sha256()
        with open(path, "rb") as fh:
            for chunk in iter(lambda: fh.read(1 << 20), b""):
                h.update(chunk)
        return h.hexdigest()
    except OSError:
        return None


def sigil_of(full):
    """The textual sigil: everything before the first digit (matches f1_citations.source_of)."""
    m = re.search(r"\d", full)
    return (full[:m.start()] if m else full).strip(" .,;")


def sigil_key(sig):
    """Canonical sigil for the SIGIL_TO_DCS lookup: drop parenthetical recension markers
    like ' (A.)' so 'CAURAP. (A.)' -> 'CAURAP' (the recension caveat is recorded separately)."""
    return re.sub(r"\s*\(.*?\)", "", sig).strip(" .,;")


def number_of(full):
    """The (last) integer in the reference, or None. Petersburg rare refs are single running numbers."""
    nums = re.findall(r"\d+", full)
    return int(nums[-1]) if nums else None


def slp1_to_iast(s):
    try:
        return sanscript.transliterate(s, sanscript.SLP1, sanscript.IAST)
    except Exception:
        return s


def norm(s):
    """Fold to a bare comparison key: lowercase + strip surrounding whitespace. Diacritics are
    kept (lemma identity depends on them)."""
    return (s or "").strip().lower()


def load_dcs(db):
    con = sqlite3.connect(db)
    q = lambda s, *a: con.execute(s, *a).fetchall()
    prov = dict(q("SELECT key,value FROM provenance"))
    texts = {tid: name for tid, name in q("SELECT text_id,name FROM text")}
    chapters = {}
    for cid, tid, ref in q("SELECT chapter_id,text_id,ref FROM chapter ORDER BY chapter_id"):
        chapters.setdefault(tid, []).append((cid, ref))
    return con, q, prov, texts, chapters


def verse_lemmas(q, chapter_id, verse):
    """All token lemmas (IAST) in the given chapter at sent_counter == verse (any subcounter)."""
    rows = q(
        "SELECT DISTINCT tk.lemma FROM sentence s "
        "JOIN token tk ON tk.sentence_id=s.id "
        "WHERE s.chapter_id=? AND s.sent_counter=?",
        (chapter_id, str(verse)),
    )
    return {norm(r[0]) for r in rows if r[0]}


def main():
    os.makedirs(REPORTS, exist_ok=True)
    db = DCS_FULL if os.path.exists(DCS_FULL) else DCS_CLEAN
    con, q, prov, texts, chapters = load_dcs(db)

    text_facts = {}
    for sig, (name, tid) in SIGIL_TO_DCS.items():
        chs = chapters.get(tid, [])
        maxv = q(
            "SELECT MAX(CAST(s.sent_counter AS INTEGER)) FROM sentence s "
            "JOIN chapter ch ON s.chapter_id=ch.chapter_id "
            "WHERE ch.text_id=? AND s.sent_counter GLOB '[0-9]*'",
            (tid,),
        )[0][0]
        total_verses = q(
            "SELECT COUNT(DISTINCT ch.chapter_id || ':' || s.sent_counter) FROM sentence s "
            "JOIN chapter ch ON s.chapter_id=ch.chapter_id WHERE ch.text_id=?",
            (tid,),
        )[0][0]
        text_facts[sig] = {
            "dcs_name": name, "dcs_text_id": tid, "n_chapters": len(chs),
            "max_verse_in_chapter": maxv, "total_verses": total_verses,
            "single_chapter_id": chs[0][0] if len(chs) == 1 else None,
        }

    rows = list(csv.DictReader(open(CAND_CSV, encoding="utf-8")))
    out = []
    for r in rows:
        lemma_slp1 = r["lemma"]
        ref = r["shared_ref"]
        sig = sigil_of(ref)
        skey = sigil_key(sig)
        num = number_of(ref)
        rec = {
            "lemma_slp1": lemma_slp1,
            "lemma_iast": slp1_to_iast(lemma_slp1),
            "shared_ref": ref,
            "sigil": sig,
            "source_dict": r["source_dict"],
            "inheritor": r["inheritor"],
            "dcs_text": "", "dcs_text_id": "", "dcs_locus": "",
            "status": "UNRESOLVED", "reason": "", "lemma_present": "", "note": "",
        }
        fact = text_facts.get(skey)
        if skey not in SIGIL_TO_DCS:
            rec["reason"] = "text-absent-from-DCS-or-ambiguous-sigil"
            out.append(rec); continue
        if sig != skey:
            rec["note"] = "recension marker '%s' dropped for lookup; DCS carries one recension only" % sig
        rec["dcs_text"], rec["dcs_text_id"] = fact["dcs_name"], fact["dcs_text_id"]
        if num is None:
            rec["reason"] = "reference-has-no-verse-number"
            out.append(rec); continue
        if fact["single_chapter_id"] is None:
            if num > (fact["total_verses"] or 0):
                rec["reason"] = ("edition-mismatch: Petersburg continuous no. %d exceeds DCS "
                                 "total verses %d (vulgate vs critical edition)" % (num, fact["total_verses"]))
            else:
                rec["reason"] = ("edition-mismatch: multi-chapter DCS text uses per-chapter "
                                 "(ch,verse); no concordance from Petersburg continuous no.")
            out.append(rec); continue
        if num < 1 or (fact["max_verse_in_chapter"] and num > fact["max_verse_in_chapter"]):
            rec["reason"] = "verse-number-out-of-range for single-chapter DCS text (recension gap?)"
            out.append(rec); continue
        lemmas_iast = verse_lemmas(q, fact["single_chapter_id"], num)
        rec["dcs_locus"] = "%s v.%d" % (fact["dcs_name"], num)
        cand_iast = norm(rec["lemma_iast"])
        present = any(cand_iast == L or cand_iast in L or L in cand_iast for L in lemmas_iast if L)
        rec["lemma_present"] = "yes" if present else "no"
        rec["status"] = "VERIFIED" if present else "ERRONEOUS"
        vnote = ("verse lemmas: " + ", ".join(sorted(lemmas_iast))) if lemmas_iast else "no tokens at locus"
        rec["note"] = (rec["note"] + " | " + vnote) if rec["note"] else vnote
        out.append(rec)

    from collections import Counter
    status_ct = Counter(r["status"] for r in out)
    reason_ct = Counter(r["reason"] for r in out if r["status"] == "UNRESOLVED")
    sigil_ct = Counter(r["sigil"] for r in out)
    mapped = [r for r in out if r["dcs_text"]]
    summary = {
        "handoff": "H203", "model": "Opus 4.8 (claude-opus-4-8)",
        "candidates_total": len(out),
        "status_counts": dict(status_ct),
        "unresolved_reasons": dict(reason_ct),
        "candidates_by_sigil": dict(sigil_ct),
        "sigils_mapped_to_DCS": {s: text_facts[s] for s in SIGIL_TO_DCS},
        "sigils_unmapped": sorted({r["sigil"] for r in out if not r["dcs_text"]}),
        "candidates_with_DCS_text": len(mapped),
        "candidates_locus_resolved": sum(1 for r in out if r["status"] in ("VERIFIED", "ERRONEOUS")),
        "verified": [r for r in out if r["status"] == "VERIFIED"],
        "erroneous_for_adjudication": [r for r in out if r["status"] == "ERRONEOUS"],
        "provenance": {
            "dcs_db": os.path.basename(db),
            "dcs_source_commit": prov.get("source_commit"),
            "dcs_imported_at": prov.get("imported_at"),
            "candidate_csv": os.path.basename(CAND_CSV),
            "candidate_csv_sha256": sha256(CAND_CSV),
            "n_texts_in_dcs": len(texts),
        },
    }

    csv_path = os.path.join(REPORTS, "dcs_shared_citation_errors.csv")
    cols = ["lemma_slp1", "lemma_iast", "shared_ref", "sigil", "source_dict", "inheritor",
            "dcs_text", "dcs_text_id", "dcs_locus", "status", "lemma_present", "reason", "note"]
    with open(csv_path, "w", encoding="utf-8", newline="") as fh:
        w = csv.DictWriter(fh, fieldnames=cols)
        w.writeheader()
        for r in out:
            w.writerow({k: r.get(k, "") for k in cols})
    json_path = os.path.join(REPORTS, "dcs_shared_citation_errors.json")
    with open(json_path, "w", encoding="utf-8") as fh:
        json.dump(summary, fh, ensure_ascii=False, indent=2)

    print("F4-DCS shared-erroneous-citation test — DCS passage corpus (%s)" % os.path.basename(db))
    print("candidates: %d   |   with a mappable DCS text: %d   |   locus-resolved: %d"
          % (len(out), len(mapped), summary["candidates_locus_resolved"]))
    print("status:", dict(status_ct))
    print("VERIFIED: %d   ERRONEOUS (need hand adjudication): %d"
          % (status_ct.get("VERIFIED", 0), status_ct.get("ERRONEOUS", 0)))
    print("reports:", csv_path, "|", json_path)
    con.close()


if __name__ == "__main__":
    main()
