#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
import_dcs_conllu.py — M2 of the DCS CoNLL-U import (see DCS_CONLLU_IMPORT_PLAN.md).

Builds the SQLite master `dcs.sqlite` from the CoNLL-U corpus:

  lemma                                  <- lookup/dictionary.csv  (authoritative
                                            LemmaId -> lemma lexicon, 180k entries)
  text / chapter / sentence / token / mwt <- parsed CoNLL-U  (via parse_conllu.py)

Schema style = **flatten all**: every FEATS key becomes a `feat_<key>` column and
every MISC key its own column (LemmaId -> token.lemma_id FK, OccId -> token.occ_id
PK). Columns are added dynamically (ALTER TABLE) as new keys appear, so the schema
adapts to whatever the corpus contains.

Pilot-first: loads a ~15-text representative sample by default (incl. the Ṛgveda
treebank, capped). `--all` loads every text (that's M6).

Stdlib only (sqlite3). The output `dcs.sqlite` is gitignored (regenerable).

Usage:
    python import_dcs_conllu.py                  # build the pilot master
    python import_dcs_conllu.py --all            # every text (big!)
    python import_dcs_conllu.py Meghadūta Ṛgveda # named texts
    python import_dcs_conllu.py --db dcs.sqlite
"""

import argparse
import csv
import os
import re
import sqlite3
import sys
from datetime import datetime, timezone

try:
    sys.stdout.reconfigure(encoding="utf-8")
    sys.stderr.reconfigure(encoding="utf-8")
except Exception:
    pass

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from parse_conllu import parse_text, HERE          # reuse the M1 parser

DICT_PATH = os.path.join(HERE, "conllu", "lookup", "dictionary.csv")
DEFAULT_DB = os.path.join(HERE, "dcs.sqlite")
SOURCE_REPO = "gasyoun/dcs-conllu (OliverHellwig/sanskrit)"
SOURCE_COMMIT = "04e0778d3dc971030229179e25eea043d06ff397"

# ~15-text representative pilot: (text, file-limit). Ṛgveda is the treebank, capped.
PILOT = [
    ("Meghadūta", None), ("Kumārasaṃbhava", None), ("Amaruśataka", None),
    ("Gītagovinda", None), ("Hitopadeśa", None), ("Daśakumāracarita", None),
    ("Arthaśāstra", None), ("Aṣṭāvakragīta", None), ("Abhidhānacintāmaṇi", None),
    ("Dhanurveda", None), ("Ayurvedarasāyana", None), ("Atharvavedapariśiṣṭa", None),
    ("Ṛgveda", 80),
]

_SANITIZE = re.compile(r"[^0-9a-zA-Z]+")
def colname(prefix, key):
    return prefix + _SANITIZE.sub("_", key).strip("_").lower()


def load_lemmas(conn):
    """lemma table <- dictionary.csv (TSV: id, word, grammar, preverbs, meanings)."""
    conn.execute("CREATE TABLE lemma (lemma_id INTEGER PRIMARY KEY, lemma TEXT, "
                 "grammar TEXT, preverbs TEXT, meanings TEXT)")
    n, batch = 0, []
    with open(DICT_PATH, encoding="utf-8", newline="") as fh:
        rdr = csv.reader(fh, delimiter="\t")
        next(rdr, None)                                  # header
        for row in rdr:
            if not row:
                continue
            row = (row + ["", "", "", "", ""])[:5]
            try:
                lid = int(row[0])
            except ValueError:
                continue
            batch.append((lid, row[1], row[2], row[3], row[4]))
            if len(batch) >= 10000:
                conn.executemany("INSERT OR IGNORE INTO lemma VALUES (?,?,?,?,?)", batch)
                n += len(batch); batch = []
    if batch:
        conn.executemany("INSERT OR IGNORE INTO lemma VALUES (?,?,?,?,?)", batch); n += len(batch)
    return n


def create_schema(conn):
    conn.executescript("""
    CREATE TABLE text     (text_id INTEGER PRIMARY KEY, name TEXT, has_dependencies INTEGER DEFAULT 0);
    CREATE TABLE chapter  (chapter_id INTEGER PRIMARY KEY, text_id INTEGER, ref TEXT);
    CREATE TABLE sentence (sent_id TEXT PRIMARY KEY, chapter_id INTEGER, sent_counter TEXT,
                           sent_subcounter TEXT, text_sandhied TEXT);
    CREATE TABLE mwt      (id INTEGER PRIMARY KEY AUTOINCREMENT, sent_id TEXT, span TEXT, form TEXT);
    CREATE TABLE token    (id INTEGER PRIMARY KEY AUTOINCREMENT, occ_id INTEGER, sent_id TEXT,
                           idx INTEGER, form TEXT, lemma TEXT, lemma_id INTEGER, upos TEXT,
                           xpos TEXT, head INTEGER, deprel TEXT, deps TEXT);
    CREATE TABLE provenance (key TEXT PRIMARY KEY, value TEXT);
    """)


class Tokens:
    """Insert tokens, growing the `token` table with feat_*/misc columns on demand."""
    BASE = {"occ_id", "sent_id", "idx", "form", "lemma", "lemma_id",
            "upos", "xpos", "head", "deprel", "deps"}

    def __init__(self, conn):
        self.conn = conn
        self.cols = set(self.BASE)

    def _ensure(self, col):
        if col not in self.cols:
            self.conn.execute(f'ALTER TABLE token ADD COLUMN "{col}" TEXT')
            self.cols.add(col)

    def add(self, sent_id, t):
        misc = t["misc"]
        occ = misc.get("OccId")
        # OccId is NOT a reliable PK — the corpus reuses some across sub-sentences of a
        # line — so it's a plain column and every token is kept (synthetic `id` PK).
        row = {"occ_id": int(occ) if occ not in (None, True) else None,
               "sent_id": sent_id, "idx": t["id"], "form": t["form"],
               "lemma": t["lemma"], "upos": t["upos"], "xpos": t["xpos"],
               "head": t["head"], "deprel": t["deprel"], "deps": t["deps"]}
        lid = misc.get("LemmaId")
        row["lemma_id"] = int(lid) if lid not in (None, True) else None
        for k, v in t["feats"].items():
            c = colname("feat_", k)
            if c == "feat_":                         # malformed/empty FEATS key (rare artifact)
                continue
            self._ensure(c); row[c] = "Yes" if v is True else v
        for k, v in misc.items():
            if k in ("LemmaId", "OccId"):
                continue
            c = colname("m_", k)
            if c == "m_":
                continue
            self._ensure(c); row[c] = "Yes" if v is True else v
        cols = ", ".join(f'"{c}"' for c in row)
        ph = ", ".join("?" * len(row))
        self.conn.execute(f"INSERT INTO token ({cols}) VALUES ({ph})", list(row.values()))
        return True


def load_text(conn, tokens, name, sents):
    """Insert one text's sentences/tokens/mwt; return (n_tok, has_deps)."""
    n_tok = 0
    has_deps = 0
    for s in sents:
        doc, meta = s["doc"], s["meta"]
        tid = int(doc["text_id"]) if doc.get("text_id", "").isdigit() else None
        cid = int(doc["chapter_id"]) if doc.get("chapter_id", "").isdigit() else None
        if tid is not None:
            conn.execute("INSERT OR IGNORE INTO text (text_id, name) VALUES (?,?)", (tid, doc.get("text", name)))
        if cid is not None:
            conn.execute("INSERT OR IGNORE INTO chapter (chapter_id, text_id, ref) VALUES (?,?,?)",
                         (cid, tid, doc.get("chapter")))
        sid = meta.get("sent_id")
        if sid:
            conn.execute("INSERT OR IGNORE INTO sentence "
                         "(sent_id, chapter_id, sent_counter, sent_subcounter, text_sandhied) VALUES (?,?,?,?,?)",
                         (sid, cid, meta.get("sent_counter"), meta.get("sent_subcounter"), meta.get("text")))
        for span in s["mwt"]:
            conn.execute("INSERT INTO mwt (sent_id, span, form) VALUES (?,?,?)",
                         (sid, span["range"], span["form"]))
        for t in s["tokens"]:
            if tokens.add(sid, t):
                n_tok += 1
            if t["head"] is not None:
                has_deps = 1
    return n_tok, has_deps


def verify(conn):
    cur = conn.cursor()
    def one(q, *a): return cur.execute(q, a).fetchone()[0]
    print("=== gate checks ===")
    tables = [r[0] for r in cur.execute("SELECT name FROM sqlite_master WHERE type='table' ORDER BY name")]
    print(f"  tables: {', '.join(tables)}")
    print(f"  lemma rows:    {one('SELECT COUNT(*) FROM lemma'):>8}")
    print(f"  text/chapter/sentence: {one('SELECT COUNT(*) FROM text')} / "
          f"{one('SELECT COUNT(*) FROM chapter')} / {one('SELECT COUNT(*) FROM sentence')}")
    n_tok = one("SELECT COUNT(*) FROM token")
    print(f"  token rows:    {n_tok:>8}")
    orphan = one("SELECT COUNT(*) FROM token WHERE lemma_id IS NOT NULL "
                 "AND lemma_id NOT IN (SELECT lemma_id FROM lemma)")
    print(f"  tokens whose lemma_id is missing from lemma: {orphan} "
          f"({'FK OK' if orphan == 0 else 'check'})")
    tb = one("SELECT COUNT(*) FROM text WHERE has_dependencies=1")
    print(f"  treebank texts (has_dependencies): {tb}")
    ncols = len(cur.execute("PRAGMA table_info(token)").fetchall())
    print(f"  token columns (flattened): {ncols}")
    print("\n  top lemmas by token count (token JOIN lemma):")
    for lemma, gram, c in cur.execute(
            "SELECT l.lemma, l.grammar, COUNT(*) c FROM token t JOIN lemma l ON t.lemma_id=l.lemma_id "
            "GROUP BY t.lemma_id ORDER BY c DESC LIMIT 8"):
        print(f"    {c:>6}  {lemma}  ({gram})")
    gate_ok = set(tables) >= {"lemma","text","chapter","sentence","token","mwt"} and one('SELECT COUNT(*) FROM lemma') > 0 and n_tok > 0
    print(f"\n  GATE: {'PASS' if gate_ok else 'FAIL'}")
    return gate_ok


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("texts", nargs="*", help="text names (default: pilot set)")
    ap.add_argument("--db", default=DEFAULT_DB)
    ap.add_argument("--all", action="store_true", help="load every text under conllu/files")
    ap.add_argument("--conllu-root", default=os.path.join(HERE, "conllu", "files"))
    args = ap.parse_args()

    if not os.path.isfile(DICT_PATH):
        print(f"ERROR: dictionary.csv not found ({DICT_PATH}); init the submodule.", file=sys.stderr)
        return 2

    if args.all:
        plan = [(d, None) for d in sorted(os.listdir(args.conllu_root))
                if os.path.isdir(os.path.join(args.conllu_root, d))]
    elif args.texts:
        plan = [(t, None) for t in args.texts]
    else:
        plan = PILOT

    if os.path.exists(args.db):
        os.remove(args.db)
    conn = sqlite3.connect(args.db)
    conn.execute("PRAGMA journal_mode=OFF")
    conn.execute("PRAGMA synchronous=OFF")
    create_schema(conn)

    print(f"DB: {args.db}")
    print("loading lemma lexicon from dictionary.csv ...")
    n_lemma = load_lemmas(conn)
    print(f"  {n_lemma} lemmas\n")

    tokens = Tokens(conn)
    grand_tok = 0
    print(f"loading {len(plan)} texts:")
    with conn:                                           # one transaction
        for name, limit in plan:
            errs = []
            sents, err = parse_text(name, args.conllu_root, limit=limit, errors=errs)
            if err:
                print(f"  [skip] {err}")
                continue
            n_tok, has_deps = load_text(conn, tokens, name, sents)
            if has_deps and sents:
                tid = sents[0]["doc"].get("text_id")
                if tid and tid.isdigit():
                    conn.execute("UPDATE text SET has_dependencies=1 WHERE text_id=?", (int(tid),))
            grand_tok += n_tok
            tag = " [treebank]" if has_deps else ""
            print(f"  ■ {name:<22} {len(sents):>5} sent  {n_tok:>7} tok{tag}"
                  + (f"  (first {limit} files)" if limit else ""))

    now = datetime.now(timezone.utc).isoformat(timespec="seconds")
    conn.executemany("INSERT OR REPLACE INTO provenance VALUES (?,?)", [
        ("source_repo", SOURCE_REPO), ("source_commit", SOURCE_COMMIT),
        ("imported_at", now), ("n_texts", str(conn.execute('SELECT COUNT(*) FROM text').fetchone()[0])),
        ("n_tokens", str(grand_tok)), ("schema", "flatten-all; lemma<-dictionary.csv"),
    ])
    conn.commit()
    conn.execute("CREATE INDEX ix_token_sent ON token(sent_id)")
    conn.execute("CREATE INDEX ix_token_lemma ON token(lemma_id)")
    conn.execute("CREATE INDEX ix_token_occ ON token(occ_id)")
    conn.execute("CREATE INDEX ix_sentence_chapter ON sentence(chapter_id)")
    conn.commit()

    print()
    ok = verify(conn)
    conn.close()
    print(f"\nWrote {args.db} ({os.path.getsize(args.db)//1024} KB)")
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
