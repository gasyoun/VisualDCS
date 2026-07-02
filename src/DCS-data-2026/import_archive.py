#!/usr/bin/env python3
"""import_archive.py — M9: research-archive datasets -> queryable SQLite (archive.sqlite).

One loader, one subcommand per dataset. Builds an additive sidecar DB alongside the
M1-M8 dcs_full.sqlite stack; nothing here touches the DCS corpus loaders or the
shipped dashboards.

Subcommands
    parallels    D1  full-text-match parallels  (Polnorazmernye/, method='fulltext', run='2026')
    stopword     D2  stop-word-match parallels   (Stopovye/,     method='stopword', run='2022-partial')
    freq         D3  period frequency dicts + core vocabulary (QL/, Lexical-Cores/)
    subhashita   D4  Sanskrit subhāṣita sayings (non-derived/Sanskritskie-izrecheniya/)
    crosswalk    build/refresh the parallels text-id <-> name crosswalk + dcs_full linkage
    all          run every dataset in order
    validate     row-count / crosswalk-coverage / spot-check report helper (used by D5)

Model provenance: authored under Opus 4.8 (claude-opus-4-8), 2026-07-02.

Encoding discipline (org CLAUDE.md): utf-8 everywhere, never utf-8-sig; no BOM.
"""
import argparse
import glob
import os
import re
import sqlite3
import sys

sys.stdout.reconfigure(encoding="utf-8")
sys.stderr.reconfigure(encoding="utf-8")

HERE = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(HERE, "..", ".."))
ARCHIVE_DB = os.path.join(HERE, "archive.sqlite")
DCS_FULL = os.path.join(HERE, "dcs_full.sqlite")

DERIVED = os.path.join(REPO, "derived-data")
NONDERIVED = os.path.join(REPO, "non-derived")
PARA_ROOT = os.path.join(DERIVED, "Paralleli-v-tekstah-korpusa-SRC", "PARA")
POLNO = os.path.join(PARA_ROOT, "Polnorazmernye")
STOPO = os.path.join(PARA_ROOT, "Stopovye")

# sanskrit-util is the canonical transcoder (SHARED_CODE.md); never re-type SLP1 tables.
sys.path.insert(0, os.path.join(REPO, "..", "sanskrit-util", "py"))
try:
    import sanskrit_util as su
    HAVE_SU = True
except Exception as e:  # pragma: no cover
    HAVE_SU = False
    print(f"[warn] sanskrit-util unavailable ({e}); lemma_slp1 will be left NULL", file=sys.stderr)


# --------------------------------------------------------------------------- #
# helpers
# --------------------------------------------------------------------------- #
def connect(db=ARCHIVE_DB):
    con = sqlite3.connect(db)
    con.execute("PRAGMA journal_mode=WAL")
    con.execute("PRAGMA synchronous=NORMAL")
    return con


def to_slp1(iast):
    if not iast or not HAVE_SU:
        return None
    try:
        return su.to_slp1(iast)
    except Exception:
        return None


# --------------------------------------------------------------------------- #
# D1/D2 — parallels
# --------------------------------------------------------------------------- #
PARALLELS_DDL = """
CREATE TABLE IF NOT EXISTS parallels (
    id                INTEGER PRIMARY KEY,
    source_text_id    INTEGER,      -- project-internal numeric id from the filename
    source_text_name  TEXT,         -- resolved via crosswalk (modal abbrev per file)
    target_text_id    INTEGER,      -- project-internal id (NULL if target never a source)
    target_text_name  TEXT,         -- fullname parsed from the parallel ref
    source_ref        TEXT,         -- e.g. 'Divyāv, 1: 1'
    source_verse      TEXT,         -- the source verse text
    target_ref        TEXT,         -- e.g. 'Divyāvadāna Divyāv, 13: 13 1'
    target_verse      TEXT,         -- the matched verse text
    absolute_verse    INTEGER,      -- target absolute verse (number after ':')
    quality           TEXT,         -- GOOD | PARTLY
    matched_words     TEXT,         -- '+ x - y' token diff (empty for most GOOD)
    method            TEXT,         -- 'fulltext' | 'stopword'
    run               TEXT,         -- '2026' | '2022-partial'
    recovered         INTEGER DEFAULT 0  -- 1 if parsed via the malformed-row fallback
);
"""

PARALLEL_TEXT_DDL = """
CREATE TABLE IF NOT EXISTS parallel_text (
    para_text_id   INTEGER PRIMARY KEY,  -- project-internal numeric id
    abbrev         TEXT,                 -- modal source abbrev (field0 before comma)
    fullname       TEXT,                 -- resolved full text name (from parallel refs)
    dcs_text_id    INTEGER,              -- linked dcs_full.text.text_id (NULL if unmatched)
    dcs_name       TEXT,
    n_source_rows  INTEGER,              -- source verses scanned in this text's files
    n_parallels    INTEGER               -- parallel matches sourced from this text
);
"""

QUALITY = {"GOOD", "PARTLY"}


def parse_parallel_row(fields):
    """Quality-anchored parser. Returns (source_fields, parallels, recovered).

    Normal grammar: [src_ref, src_pada, src_text] + k*[ref, text, GOOD|PARTLY, matched].
    Robust to a missing pada field or a stray ';' because each GOOD/PARTLY token is an
    exact anchor: its ref=fields[i-2], text=fields[i-1], matched=fields[i+1].
    """
    qpos = [i for i, f in enumerate(fields) if f in QUALITY]
    parallels = []
    for i in qpos:
        if i >= 2 and i + 1 < len(fields):
            parallels.append((fields[i - 2], fields[i - 1], fields[i], fields[i + 1]))
    if not qpos:
        return fields, [], False
    src_end = min(qpos) - 2
    recovered = (min(qpos) != 5)  # normal source-prefix length is 3 -> first quality at idx 5
    source_fields = fields[:max(src_end, 1)]
    return source_fields, parallels, recovered


ABS_VERSE_RE = re.compile(r":\s*(-?\d+)")


def parse_abs_verse(ref):
    m = ABS_VERSE_RE.search(ref or "")
    return int(m.group(1)) if m else None


def split_target_name(target_ref):
    """'Divyāvadāna Divyāv, 13: 13 1' -> ('Divyāvadāna', 'Divyāv').
    Commentary heads ('X zu Y') keep the whole head as fullname, last token as abbrev."""
    head = (target_ref or "").split(",")[0].strip()
    if not head:
        return None, None
    toks = head.split()
    if len(toks) == 1:
        return head, head
    return " ".join(toks[:-1]), toks[-1]


def _iter_para_files(folder):
    return sorted(glob.glob(os.path.join(folder, "*.csv")))


def build_source_id_map(folder):
    """para_text_id -> (modal source abbrev, n_source_rows). Abbrev = field0 before comma."""
    from collections import Counter, defaultdict
    counts = defaultdict(Counter)
    rows = defaultdict(int)
    for fp in _iter_para_files(folder):
        fid = int(os.path.basename(fp).split("_")[0])
        with open(fp, encoding="utf-8") as f:
            for line in f:
                line = line.rstrip("\r\n")
                if not line.strip():
                    continue
                rows[fid] += 1
                f0 = line.split(";", 1)[0]
                abbrev = f0.split(",")[0].strip()
                if abbrev:
                    counts[fid][abbrev] += 1
    id_map = {}
    for fid, c in counts.items():
        id_map[fid] = (c.most_common(1)[0][0], rows[fid])
    return id_map


def load_parallels(con, folder, method, run):
    con.executescript(PARALLELS_DDL)
    cur = con.cursor()
    stats = dict(files=0, source_rows=0, parallels=0, recovered_rows=0, malformed_skipped=0)
    id_map = build_source_id_map(folder)
    name_by_id = {fid: v[0] for fid, v in id_map.items()}

    batch = []
    for fp in _iter_para_files(folder):
        stats["files"] += 1
        fid = int(os.path.basename(fp).split("_")[0])
        src_name = name_by_id.get(fid)
        with open(fp, encoding="utf-8") as f:
            for line in f:
                line = line.rstrip("\r\n")
                if not line.strip():
                    continue
                stats["source_rows"] += 1
                fields = line.split(";")
                if fields and fields[-1] == "":
                    fields = fields[:-1]
                normal = (len(fields) >= 3 and (len(fields) - 3) % 4 == 0)
                src_fields, parallels, recovered = parse_parallel_row(fields)
                if recovered or not normal:
                    if parallels:
                        stats["recovered_rows"] += 1
                    else:
                        stats["malformed_skipped"] += 1
                source_ref = src_fields[0] if src_fields else None
                source_verse = src_fields[2] if len(src_fields) >= 3 else (
                    src_fields[1] if len(src_fields) == 2 else None)
                for (t_ref, t_text, q, matched) in parallels:
                    stats["parallels"] += 1
                    t_full, _t_abbr = split_target_name(t_ref)
                    batch.append((
                        fid, src_name, None, t_full,
                        source_ref, source_verse, t_ref, t_text.strip() if t_text else None,
                        parse_abs_verse(t_ref), q, (matched or "").strip() or None,
                        method, run, 1 if recovered else 0,
                    ))
                    if len(batch) >= 5000:
                        cur.executemany(
                            "INSERT INTO parallels(source_text_id,source_text_name,target_text_id,"
                            "target_text_name,source_ref,source_verse,target_ref,target_verse,"
                            "absolute_verse,quality,matched_words,method,run,recovered) "
                            "VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?)", batch)
                        batch.clear()
    if batch:
        cur.executemany(
            "INSERT INTO parallels(source_text_id,source_text_name,target_text_id,"
            "target_text_name,source_ref,source_verse,target_ref,target_verse,"
            "absolute_verse,quality,matched_words,method,run,recovered) "
            "VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?)", batch)
    con.commit()
    return stats, id_map


def cmd_parallels(args):
    con = connect()
    stats, _ = load_parallels(con, POLNO, "fulltext", "2026")
    build_crosswalk(con)
    _index_parallels(con)
    con.close()
    print("[D1 parallels/fulltext]", stats)


def cmd_stopword(args):
    if not os.path.isdir(STOPO):
        print(f"[D2] {STOPO} not present — skipping", file=sys.stderr)
        return
    # only .csv present after 7z reassembly; oversize volumes handled by --reassemble upstream
    con = connect()
    stats, _ = load_parallels(con, STOPO, "stopword", "2022-partial")
    build_crosswalk(con)
    _index_parallels(con)
    con.close()
    print("[D2 parallels/stopword]", stats)


def _index_parallels(con):
    for stmt in (
        "CREATE INDEX IF NOT EXISTS ix_par_src ON parallels(source_text_id)",
        "CREATE INDEX IF NOT EXISTS ix_par_tgt ON parallels(target_text_id)",
        "CREATE INDEX IF NOT EXISTS ix_par_tgtname ON parallels(target_text_name)",
        "CREATE INDEX IF NOT EXISTS ix_par_quality ON parallels(quality)",
        "CREATE INDEX IF NOT EXISTS ix_par_method ON parallels(method)",
    ):
        con.execute(stmt)
    con.commit()


# --------------------------------------------------------------------------- #
# crosswalk
# --------------------------------------------------------------------------- #
def _dcs_names():
    if not os.path.exists(DCS_FULL) or os.path.getsize(DCS_FULL) == 0:
        return {}
    d = sqlite3.connect(DCS_FULL)
    try:
        return {name: tid for tid, name in d.execute("SELECT text_id,name FROM text")}
    finally:
        d.close()


def _clean_fullname(fn):
    """Strip editorial tags ('NEW'), stray brackets, trailing punctuation for dcs matching."""
    if not fn:
        return fn
    fn = re.sub(r"\bNEW\b", "", fn)
    fn = fn.replace("(", " ").replace(")", " ")
    fn = re.sub(r"\s+", " ", fn).strip(" ,;")
    return fn


def build_crosswalk(con):
    """Populate parallel_text: para_text_id -> abbrev/fullname/dcs linkage.

    fullname is learned from target refs, which carry '<Fullname> <Abbrev>, ...' where
    <Abbrev> is exactly the source field0-before-comma of that text. So for each known
    source abbrev A we collect target heads ending in A and take fullname = head minus A.
    dcs linkage matches (cleaned) fullname/abbrev against dcs_full.text.name, exact then
    diacritic-insensitive (sanskrit_util.norm).
    """
    con.executescript(PARALLEL_TEXT_DDL)
    from collections import Counter, defaultdict

    # per-id source abbrev + parallel count
    rows = con.execute(
        "SELECT source_text_id, source_text_name, COUNT(*) FROM parallels GROUP BY source_text_id"
    ).fetchall()
    abbrevs = {fid: ab for fid, ab, _ in rows if ab}
    known_abbrevs = sorted(set(abbrevs.values()), key=len, reverse=True)

    # harvest all distinct target heads once
    heads = Counter()
    for (t_ref,) in con.execute("SELECT target_ref FROM parallels"):
        h = (t_ref or "").split(",")[0].strip()
        if h:
            heads[h] += 1
    # abbrev -> voted fullname (head with the abbrev suffix removed)
    full_votes = defaultdict(Counter)
    for h, ct in heads.items():
        for ab in known_abbrevs:
            if h == ab:
                full_votes[ab][h] += ct  # head IS the abbrev -> no distinct fullname
                break
            if h.endswith(" " + ab):
                fn = h[: len(h) - len(ab)].strip()
                full_votes[ab][fn] += ct
                break

    dcs = _dcs_names()
    dcs_exact = {k: v for k, v in dcs.items()}
    dcs_norm = {}
    for nm, tid in dcs.items():
        if HAVE_SU:
            dcs_norm.setdefault(su.norm(nm), (tid, nm))

    def link(fullname, abbrev):
        for cand in (fullname, _clean_fullname(fullname), abbrev, _clean_fullname(abbrev)):
            if cand and cand in dcs_exact:
                return dcs_exact[cand], cand
        if HAVE_SU:
            for cand in (_clean_fullname(fullname), _clean_fullname(abbrev)):
                if cand:
                    hit = dcs_norm.get(su.norm(cand))
                    if hit:
                        return hit
        return None, None

    src_rows_by_id = {}
    for fid, in_ct in con.execute(
        "SELECT source_text_id, COUNT(DISTINCT source_ref||source_verse) FROM parallels GROUP BY source_text_id"
    ):
        src_rows_by_id[fid] = in_ct

    con.execute("DELETE FROM parallel_text")
    recs = []
    for fid, abbrev, npar in rows:
        fullname = None
        if abbrev and abbrev in full_votes and full_votes[abbrev]:
            top = full_votes[abbrev].most_common(1)[0][0]
            fullname = top if top != abbrev else None
        dcs_id, dcs_name = link(fullname, abbrev)
        recs.append((fid, abbrev, fullname, dcs_id, dcs_name, src_rows_by_id.get(fid), npar))
    con.executemany(
        "INSERT OR REPLACE INTO parallel_text(para_text_id,abbrev,fullname,dcs_text_id,"
        "dcs_name,n_source_rows,n_parallels) VALUES(?,?,?,?,?,?,?)", recs)

    # resolve target_text_id + clean target_text_name from each target head, using the same
    # abbrev-suffix logic (a target head ends with the source abbrev of its own text).
    id_by_abbrev = {ab: fid for fid, ab in abbrevs.items()}
    fullname_by_id = {r[0]: r[2] for r in recs}
    head_cache = {}  # head -> (target_text_id or None, fullname or head)

    def resolve_head(h):
        if h in head_cache:
            return head_cache[h]
        tid, tname = None, h
        for ab in known_abbrevs:
            if h == ab or h.endswith(" " + ab):
                tid = id_by_abbrev.get(ab)
                tname = fullname_by_id.get(tid) or (h[: len(h) - len(ab)].strip() if h != ab else h)
                break
        head_cache[h] = (tid, tname)
        return head_cache[h]

    upd = []
    for rid, t_ref in con.execute("SELECT id, target_ref FROM parallels"):
        h = (t_ref or "").split(",")[0].strip()
        tid, tname = resolve_head(h)
        upd.append((tid, tname, rid))
    con.executemany("UPDATE parallels SET target_text_id=?, target_text_name=? WHERE id=?", upd)
    con.commit()
    resolved = sum(1 for u in upd if u[0] is not None)
    return dict(texts=len(recs), dcs_linked=sum(1 for r in recs if r[3] is not None),
                target_ids_resolved=resolved, target_rows=len(upd))


def cmd_crosswalk(args):
    con = connect()
    print("[crosswalk]", build_crosswalk(con))
    con.close()


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = ap.add_subparsers(dest="cmd", required=True)
    sub.add_parser("parallels").set_defaults(func=cmd_parallels)
    sub.add_parser("stopword").set_defaults(func=cmd_stopword)
    sub.add_parser("crosswalk").set_defaults(func=cmd_crosswalk)
    args = ap.parse_args()
    args.func(args)


if __name__ == "__main__":
    main()
