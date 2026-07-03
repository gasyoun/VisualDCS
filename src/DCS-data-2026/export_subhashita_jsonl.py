#!/usr/bin/env python3
"""export_subhashita_jsonl.py — export the D4 `subhashita` table (archive.sqlite)
to a plain-text JSONL edition in the sibling SanskritLexicography repo.

Böhtlingk, Indische Sprüche (2nd ed., St. Petersburg 1870-1873) is a separate
publication from his dictionaries (PWG/PWK), not part of the Cologne XML corpus,
so it lives as a data asset in SanskritLexicography rather than a csl-orig
dictionary folder. Source pipeline: non-derived/Sanskritskie-izrecheniya/Subhash_Bt.xlsx
-> import_archive.py `subhashita` cmd (D4) -> archive.sqlite -> this script -> JSONL.

`subhashita_ramayana` (the "Btlnk, Ram, Mh" sheet) is a separate cross-corpus
pairing artifact, not part of Böhtlingk's own apparatus, and is intentionally
excluded here.

Model provenance: authored under Sonnet 5 (claude-sonnet-5), 2026-07-03.
"""
import json
import os
import sqlite3
import sys

sys.stdout.reconfigure(encoding="utf-8")
sys.stderr.reconfigure(encoding="utf-8")

HERE = os.path.dirname(os.path.abspath(__file__))
ARCHIVE_DB = os.path.join(HERE, "archive.sqlite")
REPO = os.path.abspath(os.path.join(HERE, "..", "..", ".."))
OUT_PATH = os.path.join(
    REPO, "SanskritLexicography", "IndischeSprueche", "data", "indische_sprueche.jsonl"
)


def main():
    con = sqlite3.connect(ARCHIVE_DB)
    cur = con.cursor()
    cur.execute(
        "SELECT saying_id, page, text_sa_deva, text_sa_iast, translation_de, "
        "source_attribution, notes FROM subhashita ORDER BY id"
    )
    os.makedirs(os.path.dirname(OUT_PATH), exist_ok=True)
    n = 0
    with open(OUT_PATH, "w", encoding="utf-8") as f:
        for saying_id, page, deva, iast, de, src, notes in cur.fetchall():
            num = int(saying_id.split()[-1]) if saying_id else None
            rec = {
                "num": num,
                "saying_id": saying_id,
                "page": page,
                "deva": deva,
                "iast": iast,
                "translation_de": de,
                "source_attribution": src,
                "notes": notes,
            }
            f.write(json.dumps(rec, ensure_ascii=False) + "\n")
            n += 1
    con.close()
    print(f"wrote {n} sayings -> {OUT_PATH}")


if __name__ == "__main__":
    main()
