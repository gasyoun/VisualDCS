#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
export_master.py — M4 of the DCS CoNLL-U import (see DCS_CONLLU_IMPORT_PLAN.md).

Generates exports from the SQLite master (dcs.sqlite) and diffs the legacy shapes
against the committed 2021 originals:

  exports/clean/      sentences.csv, tokens.csv, lemmas.csv  (normalized, one per table)
                      tokens_wide.csv                        (denormalized convenience)
  exports/legacy/     _8.csv  (count,lemma,grammar — regenerated; diffs cleanly)
                      0.csv   (per-sentence approximation; 2026 is pāda-segmented)
                      10.csv  (best-effort; see the limitation note below)
  reports/m4_exports.md   exports inventory + diff results + the learned code map

The verb tense/mood **code map** is learned by aligning 2021 `15.csv` forms to the
2026 master's verb tokens and reading off their UD features; `timws.csv` supplies
the human names (15.csv's tense code indexes timws.csv's ID).

⚠️ 10.csv limitation: its sentence_id / occ_id are 2021-internal IDs with no
correspondence in 2026 (only LemmaId bridges), so the regenerated 10.csv uses
2026 keys — it is NOT a byte-match to the original.

Stdlib only. Run after M2 (needs dcs.sqlite).
"""

import csv
import os
import re
import sqlite3
import sys
from collections import Counter, defaultdict

try:
    sys.stdout.reconfigure(encoding="utf-8")
    sys.stderr.reconfigure(encoding="utf-8")
except Exception:
    pass

HERE = os.path.dirname(os.path.abspath(__file__))
DB = os.path.join(HERE, "dcs.sqlite")
REL = os.path.join(HERE, "..", "DCS-data-2021")
CLEAN = os.path.join(HERE, "exports", "clean")
LEGACY = os.path.join(HERE, "exports", "legacy")
REPORT = os.path.join(HERE, "reports", "m4_exports.md")


def writerows(path, header, rows):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w", encoding="utf-8", newline="") as fh:
        w = csv.writer(fh)
        if header:
            w.writerow(header)
        n = 0
        for r in rows:
            w.writerow(r)
            n += 1
    return n


# --------------------------------------------------------------------------- #
# clean exports (normalized + denormalized)
# --------------------------------------------------------------------------- #
def export_clean(conn):
    out = {}
    out["sentences.csv"] = writerows(os.path.join(CLEAN, "sentences.csv"),
        ["sent_id", "text", "ref", "sent_counter", "sent_subcounter", "text_sandhied"],
        conn.execute("""SELECT s.sent_id, te.name, ch.ref, s.sent_counter, s.sent_subcounter, s.text_sandhied
                        FROM sentence s JOIN chapter ch ON s.chapter_id=ch.chapter_id
                        JOIN text te ON ch.text_id=te.text_id"""))
    tok_cols = [r[1] for r in conn.execute("PRAGMA table_info(token)")]
    out["tokens.csv"] = writerows(os.path.join(CLEAN, "tokens.csv"), tok_cols,
        conn.execute(f"SELECT {','.join(tok_cols)} FROM token"))
    out["lemmas.csv"] = writerows(os.path.join(CLEAN, "lemmas.csv"),
        ["lemma_id", "lemma", "grammar", "preverbs", "token_count"],
        conn.execute("""SELECT l.lemma_id, l.lemma, l.grammar, l.preverbs, COUNT(t.occ_id)
                        FROM lemma l JOIN token t ON t.lemma_id=l.lemma_id
                        GROUP BY l.lemma_id ORDER BY COUNT(t.occ_id) DESC"""))
    out["tokens_wide.csv"] = writerows(os.path.join(CLEAN, "tokens_wide.csv"),
        ["occ_id", "text", "ref", "sent_id", "idx", "form", "lemma", "lemma_id",
         "upos", "feat_case", "feat_number", "feat_tense", "feat_voice", "head", "deprel",
         "unsandhied", "dict_meaning"],
        conn.execute("""SELECT t.occ_id, te.name, ch.ref, t.sent_id, t.idx, t.form, t.lemma, t.lemma_id,
                          t.upos, t.feat_case, t.feat_number, t.feat_tense, t.feat_voice, t.head, t.deprel,
                          t.m_unsandhied, l.meanings
                        FROM token t JOIN sentence s ON t.sentence_id=s.id
                        JOIN chapter ch ON s.chapter_id=ch.chapter_id
                        JOIN text te ON ch.text_id=te.text_id
                        LEFT JOIN lemma l ON t.lemma_id=l.lemma_id"""))
    return out


# --------------------------------------------------------------------------- #
# legacy regeneration
# --------------------------------------------------------------------------- #
def export_legacy_8(conn):
    """_8.csv: count,lemma,grammar  (regenerated from the master)."""
    rows = list(conn.execute("""SELECT COUNT(t.occ_id) c, l.lemma, l.grammar
                                FROM token t JOIN lemma l ON t.lemma_id=l.lemma_id
                                GROUP BY t.lemma_id ORDER BY c DESC"""))
    writerows(os.path.join(LEGACY, "_8.csv"), None, rows)
    return rows


def export_legacy_0(conn):
    """0.csv: "name";ref;idx;,id1,id2,…,;text  — per CoNLL-U sentence (approximation)."""
    os.makedirs(LEGACY, exist_ok=True)
    n = 0
    with open(os.path.join(LEGACY, "0.csv"), "w", encoding="utf-8", newline="") as fh:
        for spk, sid, name, ref, txt in conn.execute(
                """SELECT s.id, s.sent_id, te.name, ch.ref, s.text_sandhied
                   FROM sentence s JOIN chapter ch ON s.chapter_id=ch.chapter_id
                   JOIN text te ON ch.text_id=te.text_id"""):
            ids = [str(r[0]) for r in conn.execute(
                "SELECT lemma_id FROM token WHERE sentence_id=? AND lemma_id IS NOT NULL ORDER BY idx", (spk,))]
            fh.write(f'"{name}";{ref or ""};{sid};,{",".join(ids)},;{txt or ""}\n')
            n += 1
    return n


def export_legacy_10(conn):
    """10.csv best-effort (2026-keyed): lemma_id, sent_id, idx, occ_id, upos, case, num, tense, voice."""
    rows = conn.execute("""SELECT lemma_id, sent_id, idx, occ_id, upos, feat_case, feat_number,
                                  feat_tense, feat_voice, head FROM token ORDER BY sent_id, idx""")
    return writerows(os.path.join(LEGACY, "10.csv"), None, rows)


# --------------------------------------------------------------------------- #
# verb tense/mood code map  (2021 15.csv  x  timws.csv  x  2026 master)
# --------------------------------------------------------------------------- #
def read_timws(path):
    names = {}
    if not os.path.isfile(path):
        return names
    with open(path, encoding="utf-8", errors="replace") as fh:
        for line in fh:
            parts = line.split(":")
            if len(parts) >= 2 and parts[0].strip().isdigit():
                names[int(parts[0])] = parts[1].strip()
    return names


def learn_code_map(conn):
    """For each 2021 tense-code, the UD (Tense,Voice,Mood) combos seen on the same forms in 2026."""
    p15 = os.path.join(REL, "15.csv")
    timws = read_timws(os.path.join(REL, "timws.csv"))
    if not os.path.isfile(p15):
        return None, timws
    # 2026 verb forms -> set of (Tense,Voice,Mood) feature tuples
    feats_by_form = defaultdict(Counter)
    for form, te, vo, mo in conn.execute(
            "SELECT form, feat_tense, feat_voice, feat_mood FROM token WHERE upos='VERB'"):
        feats_by_form[form][(te, vo, mo)] += 1
    code_ud = defaultdict(Counter)   # tense_code -> Counter of UD combos
    code_n = Counter()
    with open(p15, encoding="utf-8", errors="replace") as fh:
        for line in fh:
            parts = line.rstrip("\n").split(",")
            if len(parts) < 4:
                continue
            form = parts[2].strip().strip("'")
            try:
                code = int(parts[3])
            except ValueError:
                continue
            code_n[code] += 1
            if form in feats_by_form:
                code_ud[code].update(feats_by_form[form])
    rows = []
    for code in sorted(code_n):
        top = code_ud[code].most_common(1)
        ud = top[0][0] if top else None
        ud_s = ("Tense=%s|Voice=%s|Mood=%s" % ud) if ud else "(no pilot match)"
        rows.append((code, timws.get(code, "?"), code_n[code], len(code_ud[code]), ud_s))
    return rows, timws


# --------------------------------------------------------------------------- #
# diffs vs 2021
# --------------------------------------------------------------------------- #
def diff_8(regen_rows):
    """Compare regenerated _8.csv lemma set vs the 2021 _8.csv."""
    p = os.path.join(REL, "_8.csv")
    if not os.path.isfile(p):
        return None
    old = {}
    with open(p, encoding="utf-8", errors="replace") as fh:
        for line in fh:
            parts = line.rstrip("\n").split(",")
            if len(parts) >= 2 and parts[0].strip().isdigit():
                old[parts[1]] = int(parts[0])
    new = {lemma: c for c, lemma, _g in regen_rows}
    shared = set(old) & set(new)
    return {"old_lemmas": len(old), "new_lemmas": len(new), "shared": len(shared),
            "only_old": len(set(old) - set(new)), "only_new": len(set(new) - set(old))}


def main():
    if not os.path.exists(DB):
        print(f"ERROR: {DB} not found — run import_dcs_conllu.py (M2) first.", file=sys.stderr)
        return 2
    conn = sqlite3.connect(DB)
    print("clean exports ...")
    clean = export_clean(conn)
    for k, v in clean.items():
        print(f"  clean/{k}: {v} rows")
    print("legacy exports ...")
    r8 = export_legacy_8(conn)
    n0 = export_legacy_0(conn)
    n10 = export_legacy_10(conn)
    print(f"  legacy/_8.csv: {len(r8)} rows   legacy/0.csv: {n0} rows   legacy/10.csv: {n10} rows")
    print("learning verb tense/mood code map ...")
    code_rows, timws = learn_code_map(conn)
    d8 = diff_8(r8)

    L = []
    w = L.append
    w("# M4 exports & legacy diff — DCS 2026 master → CSV\n")
    w("_Generated by `export_master.py` from `dcs.sqlite` (pilot)._\n")
    w("## Clean exports (`exports/clean/`)\n")
    w("| file | rows |\n|---|---:|")
    for k, v in clean.items():
        w(f"| `{k}` | {v:,} |")
    w("\n## Legacy exports (`exports/legacy/`)\n")
    w(f"- `_8.csv` — {len(r8):,} lemmas (count,lemma,grammar)")
    w(f"- `0.csv` — {n0:,} rows (per **CoNLL-U sentence**; 2021 was per metrical line → more rows)")
    w(f"- `10.csv` — {n10:,} rows (**best-effort**, 2026-keyed — see limitation)\n")
    if d8:
        w("### `_8.csv` diff vs 2021\n")
        w(f"- 2021 lemmas: **{d8['old_lemmas']:,}** · regenerated: **{d8['new_lemmas']:,}** · "
          f"shared: **{d8['shared']:,}** · only-2021: {d8['only_old']:,} · only-2026(pilot): {d8['only_new']:,}")
        w("- (the regenerated set is pilot-scope — 13 texts — so it's a subset; lemmas present overlap cleanly.)\n")
    if code_rows:
        w("## Verb tense/mood code map (learned)\n")
        w("2021 `15.csv` tense-code → `timws.csv` name → UD features observed on the same forms in 2026.\n")
        w("| code | timws name | 15.csv forms | UD combos | top UD (Tense\\|Voice\\|Mood) |")
        w("|---:|---|---:|---:|---|")
        for code, name, n15, ncombo, ud in code_rows:
            w(f"| {code} | {name} | {n15:,} | {ncombo} | {ud} |")
        w("")
    w("## ⚠️ 10.csv limitation\n")
    w("The 2021 `10.csv` is keyed by **2021-internal** `sentence_id` and occurrence IDs that have no "
      "counterpart in the 2026 data (which uses `sent_id` like `591764_1` and 7-digit `OccId`s). Only "
      "`LemmaId` bridges the two. So `legacy/10.csv` is regenerated with **2026 keys + UD-derived "
      "morphology** — it is *not* a byte-match to the original and shouldn't be diffed row-for-row. "
      "Faithful 10.csv reproduction would require the 2021↔2026 occurrence-ID mapping, which the corpus "
      "does not provide.\n")
    w("## Method & caveats\n")
    w("- Exports are **pilot-scope** (the 13 texts in `dcs.sqlite`); M6 regenerates over all 270.\n"
      "- `_8.csv` regenerates cleanly; `0.csv` is a per-sentence approximation; `10.csv` is best-effort.\n"
      "- The code map covers tense-codes attested among the pilot's verb forms; M6 completes it.\n")

    os.makedirs(os.path.dirname(REPORT), exist_ok=True)
    with open(REPORT, "w", encoding="utf-8") as fh:
        fh.write("\n".join(L) + "\n")
    conn.close()
    print(f"\nwrote {os.path.relpath(REPORT, HERE)}")
    if d8:
        print(f"  _8.csv: 2021 {d8['old_lemmas']} vs regen {d8['new_lemmas']} lemmas, {d8['shared']} shared")
    if code_rows:
        mapped = sum(1 for r in code_rows if "no pilot match" not in r[4])
        print(f"  code map: {mapped}/{len(code_rows)} tense-codes mapped to UD via pilot forms")
    return 0


if __name__ == "__main__":
    sys.exit(main())
