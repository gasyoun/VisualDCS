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
# The ~40.5M-row stop-word run lives in its own DB: it is 20-30x the size of everything
# else and is fully regenerable from the committed Stopovye/ CSVs, so it is kept out of the
# compact primary archive.sqlite (the asset the bridges actually download).
STOPWORD_DB = os.path.join(HERE, "archive_stopword.sqlite")
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


def _iter_para_files(folder, extra=None):
    files = sorted(glob.glob(os.path.join(folder, "*.csv")))
    if extra:
        files += list(extra)
    return files


def build_source_id_map(files):
    """para_text_id -> (modal source abbrev, n_source_rows). Abbrev = field0 before comma."""
    from collections import Counter, defaultdict
    counts = defaultdict(Counter)
    rows = defaultdict(int)
    for fp in files:
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


_PAR_INSERT = (
    "INSERT INTO parallels(source_text_id,source_text_name,target_text_id,"
    "target_text_name,source_ref,source_verse,target_ref,target_verse,"
    "absolute_verse,quality,matched_words,method,run,recovered) "
    "VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?)")


def load_parallels(con, folder, method, run, extra=None, store_text=True):
    """store_text=False drops source/target verse strings (used for the ~40M-row noisy
    stop-word run to keep the DB a practical size); structured columns are still stored."""
    con.executescript(PARALLELS_DDL)
    con.execute("CREATE TABLE IF NOT EXISTS _id_fullname "
                "(para_text_id INTEGER, fullname TEXT, n INTEGER, PRIMARY KEY(para_text_id, fullname))")
    cur = con.cursor()
    stats = dict(files=0, source_rows=0, parallels=0, recovered_rows=0, malformed_skipped=0)
    con.execute("DELETE FROM parallels WHERE method=? AND run=?", (method, run))  # idempotent
    con.commit()
    files = _iter_para_files(folder, extra)
    id_map = build_source_id_map(files)
    name_by_id = {fid: v[0] for fid, v in id_map.items()}

    # target resolver: match a target head's trailing abbrev to a source id, at load time
    # (bounded to a few hundred distinct heads — avoids a post-hoc UPDATE over tens of millions)
    id_by_abbrev = {ab: fid for fid, (ab, _n) in id_map.items()}
    known_abbrevs = sorted(id_by_abbrev, key=len, reverse=True)
    head_cache = {}
    from collections import Counter
    fullname_votes = Counter()  # (tid, fullname) -> n

    def resolve_target(t_ref):
        head = (t_ref or "").split(",")[0].strip()
        hit = head_cache.get(head)
        if hit is None:
            tid, fullname = None, None
            for ab in known_abbrevs:
                if head == ab or head.endswith(" " + ab):
                    tid = id_by_abbrev[ab]
                    fullname = head[: len(head) - len(ab)].strip() if head != ab else None
                    break
            hit = head_cache[head] = (tid, fullname or head or None)
        return hit

    since_commit = [0]

    def flush(force=False):
        if batch and (force or len(batch) >= 5000):
            cur.executemany(_PAR_INSERT, batch)
            since_commit[0] += len(batch)
            batch.clear()
        if since_commit[0] >= 500000 or (force and since_commit[0]):
            con.commit()
            con.execute("PRAGMA wal_checkpoint(TRUNCATE)")
            since_commit[0] = 0

    batch = []
    for fp in files:
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
                source_verse = (src_fields[2] if len(src_fields) >= 3 else (
                    src_fields[1] if len(src_fields) == 2 else None)) if store_text else None
                for (t_ref, t_text, q, matched) in parallels:
                    stats["parallels"] += 1
                    tid, t_full = resolve_target(t_ref)
                    if tid is not None and t_full:
                        fullname_votes[(tid, t_full)] += 1
                    batch.append((
                        fid, src_name, tid, t_full,
                        source_ref, source_verse, t_ref,
                        (t_text.strip() if t_text else None) if store_text else None,
                        parse_abs_verse(t_ref), q, (matched or "").strip() or None,
                        method, run, 1 if recovered else 0,
                    ))
                    flush()
    flush(force=True)
    # persist fullname votes (merge across runs) for build_crosswalk
    for (tid, fullname), n in fullname_votes.items():
        con.execute(
            "INSERT INTO _id_fullname(para_text_id,fullname,n) VALUES(?,?,?) "
            "ON CONFLICT(para_text_id,fullname) DO UPDATE SET n=n+excluded.n", (tid, fullname, n))
    con.commit()
    return stats, id_map


def cmd_parallels(args):
    con = connect()
    stats, _ = load_parallels(con, POLNO, "fulltext", "2026")
    build_crosswalk(con)
    _index_parallels(con)
    con.close()
    print("[D1 parallels/fulltext]", stats)


def _find_7z():
    import shutil
    for c in ("7z", "7za", r"C:\Program Files\7-Zip\7z.exe", r"C:\Program Files (x86)\7-Zip\7z.exe"):
        p = shutil.which(c) if os.sep not in c else (c if os.path.exists(c) else None)
        if p:
            return p
    return None


def _reassemble_split_csvs(folder, dest):
    """Extract every <name>.csv.7z.001 in `folder` into `dest`; return list of .csv paths.
    Archives store the original relative path, so we glob recursively under dest."""
    import subprocess
    sevenz = _find_7z()
    volumes = sorted(glob.glob(os.path.join(folder, "*.7z.001")))
    if not volumes:
        return []
    if not sevenz:
        raise RuntimeError(
            "7-Zip not found — install it (https://www.7-zip.org/) to reassemble the "
            "oversize Stopovye CSVs, or see RESTORE_SPLIT_FILES.md")
    os.makedirs(dest, exist_ok=True)
    for vol in volumes:
        subprocess.run([sevenz, "x", "-y", f"-o{dest}", vol],
                       stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, check=True)
    return sorted(glob.glob(os.path.join(dest, "**", "*.csv"), recursive=True))


def cmd_stopword(args):
    import shutil, tempfile
    if not os.path.isdir(STOPO):
        print(f"[D2] {STOPO} not present — skipping", file=sys.stderr)
        return
    tmp = tempfile.mkdtemp(prefix="m9_stopo_")
    try:
        extra = _reassemble_split_csvs(STOPO, tmp)
        print(f"[D2] reassembled {len(extra)} oversize CSVs into temp", file=sys.stderr)
        con = connect(STOPWORD_DB)  # separate DB — regenerable, not shipped
        stats, _ = load_parallels(con, STOPO, "stopword", "2022-partial", extra=extra, store_text=False)
        build_crosswalk(con)
        # copy the authoritative id->name list from the core DB for standalone usability
        if os.path.exists(ARCHIVE_DB):
            con.execute("ATTACH DATABASE ? AS core", (ARCHIVE_DB,))
            if _table_exists(con, "text_names"):
                con.execute("DELETE FROM text_names")
            con.executescript("CREATE TABLE IF NOT EXISTS text_names (text_id INTEGER PRIMARY KEY, text_name TEXT)")
            con.execute("INSERT OR REPLACE INTO text_names SELECT text_id,text_name FROM core.text_names")
            con.commit()
            con.execute("DETACH DATABASE core")
        _index_parallels(con)
        con.close()
        print("[D2 parallels/stopword]", stats)
    finally:
        shutil.rmtree(tmp, ignore_errors=True)


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
    fn = fn.replace("(", " ").replace(")", " ").replace('"', " ").replace("'", " ")
    fn = re.sub(r"\s+", " ", fn).strip(" ,;")
    return fn


def build_crosswalk(con):
    """Populate parallel_text: para_text_id -> abbrev/fullname/dcs linkage.

    Scales to tens of millions of parallel rows: target_text_id/name are resolved at LOAD
    time, and fullnames are read from the small _id_fullname vote table (bounded by the
    number of texts). Here we only build the ~150-row parallel_text and its dcs linkage.
    dcs linkage matches (cleaned) fullname/abbrev against dcs_full.text.name, exact then
    diacritic-insensitive (sanskrit_util.norm).
    """
    con.executescript(PARALLEL_TEXT_DDL)

    # per-id source abbrev + parallel/source-row counts (indexed GROUP BY — cheap)
    counts = {fid: (ab, npar) for fid, ab, npar in con.execute(
        "SELECT source_text_id, source_text_name, COUNT(*) FROM parallels "
        "WHERE source_text_id IS NOT NULL GROUP BY source_text_id")}

    # voted fullname per id from the accumulator table (falls back to target_text_name mode)
    fullname_by_id = {}
    if _table_exists(con, "_id_fullname"):
        for fid, fn in con.execute(
            "SELECT para_text_id, fullname FROM _id_fullname WHERE (para_text_id, n) IN "
            "(SELECT para_text_id, MAX(n) FROM _id_fullname GROUP BY para_text_id)"):
            fullname_by_id[fid] = fn

    dcs = _dcs_names()
    dcs_exact = dict(dcs)
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

    con.execute("DELETE FROM parallel_text")
    recs = []
    for fid, (abbrev, npar) in counts.items():
        fullname = fullname_by_id.get(fid)
        dcs_id, dcs_name = link(fullname, abbrev)
        recs.append((fid, abbrev, fullname, dcs_id, dcs_name, None, npar))
    con.executemany(
        "INSERT OR REPLACE INTO parallel_text(para_text_id,abbrev,fullname,dcs_text_id,"
        "dcs_name,n_source_rows,n_parallels) VALUES(?,?,?,?,?,?,?)", recs)
    con.commit()
    tot = con.execute("SELECT COUNT(*) FROM parallels").fetchone()[0]
    resolved = con.execute("SELECT COUNT(*) FROM parallels WHERE target_text_id IS NOT NULL").fetchone()[0]
    return dict(texts=len(recs), dcs_linked=sum(1 for r in recs if r[3] is not None),
                target_ids_resolved=resolved, target_rows=tot)


def cmd_crosswalk(args):
    con = connect()
    print("[crosswalk]", build_crosswalk(con))
    con.close()


# --------------------------------------------------------------------------- #
# spreadsheet readers (xls via xlrd, xlsx via openpyxl)
# --------------------------------------------------------------------------- #
def read_rows(path, sheet=None):
    """Yield row tuples of cell values from an .xls or .xlsx file."""
    if path.lower().endswith("x"):
        import openpyxl
        wb = openpyxl.load_workbook(path, read_only=True, data_only=True)
        ws = wb[sheet] if sheet else wb.worksheets[0]
        for row in ws.iter_rows(values_only=True):
            yield row
        wb.close()
    else:
        import xlrd
        wb = xlrd.open_workbook(path)
        ws = wb.sheet_by_name(sheet) if sheet else wb.sheet_by_index(0)
        for i in range(ws.nrows):
            yield tuple(ws.cell_value(i, j) for j in range(ws.ncols))


def _first(pattern, root):
    hits = glob.glob(os.path.join(root, pattern))
    return hits[0] if hits else None


def _clean_lemma(v):
    if v is None:
        return None
    s = str(v).strip().strip("'\"").strip()
    return s or None


def _as_int(v):
    if v is None or v == "":
        return None
    try:
        return int(float(str(v).replace(",", ".")))
    except Exception:
        return None


# --------------------------------------------------------------------------- #
# D3 — period / text frequency dictionaries + core vocabulary
# --------------------------------------------------------------------------- #
FREQ_DDL = """
CREATE TABLE IF NOT EXISTS text_names (
    text_id   INTEGER PRIMARY KEY,   -- project-internal id (from Приложение 2 headers)
    text_name TEXT
);
CREATE TABLE IF NOT EXISTS period_freq (
    id         INTEGER PRIMARY KEY,
    lemma_slp1 TEXT,
    lemma_raw  TEXT,       -- original spelling (IAST) as written in the workbook
    grammar    TEXT,       -- part-of-speech tag where the source carries one
    period     TEXT,       -- raw period label from the column header
    rank       INTEGER,    -- 1-based rank within (period, source)
    count      INTEGER,    -- absolute corpus frequency
    source     TEXT        -- provenance: which workbook/sheet
);
CREATE TABLE IF NOT EXISTS text_freq (
    id         INTEGER PRIMARY KEY,
    lemma_slp1 TEXT,
    lemma_raw  TEXT,
    text_id    INTEGER,
    text_name  TEXT,
    rank       INTEGER,
    count      INTEGER,
    source     TEXT
);
CREATE TABLE IF NOT EXISTS core_vocab (
    id           INTEGER PRIMARY KEY,
    lemma_slp1   TEXT,
    lemma_raw    TEXT,
    grammar      TEXT,
    period       TEXT,
    rank         INTEGER,
    coverage_pct REAL,
    source       TEXT
);
"""

HDR2_RE = re.compile(r'^\s*"*\s*(\d+)\s+"*([^"]+?)"*\s*$')


def _load_text_names(con, prilozhenie2):
    """Приложение 2 headers '<id> "<Name>"' -> text_names crosswalk (authoritative list)."""
    header = next(read_rows(prilozhenie2))
    recs = []
    for j in range(0, len(header), 2):
        h = header[j]
        if h is None:
            continue
        m = HDR2_RE.match(str(h))
        if m:
            recs.append((int(m.group(1)), m.group(2).strip()))
    con.executemany("INSERT OR REPLACE INTO text_names(text_id,text_name) VALUES(?,?)", recs)
    return recs


def _load_paired_freq(con, path, source, target="period_freq", sheet=None,
                      label_from_header=True, text_name_map=None):
    """Generic loader for the '(lemma, WD FRQ)' paired-column layout.

    Header row names each period/text; each subsequent even column is a ranked lemma
    list, the odd column to its right the frequency. Blank cells end a column's list.
    """
    rows = list(read_rows(path, sheet))
    if not rows:
        return 0
    header = rows[0]
    ncol = max(len(r) for r in rows)
    ranks = {}
    batch = []
    n = 0
    for j in range(0, ncol, 2):
        raw_label = header[j] if j < len(header) else None
        if raw_label is None:
            continue
        # resolve the period/text label from the header
        text_id = None
        label = str(raw_label).strip()
        if target == "text_freq":
            m = HDR2_RE.match(label)
            if not m:
                continue
            text_id = int(m.group(1))
            label = (text_name_map or {}).get(text_id, m.group(2).strip())
        for r in rows[1:]:
            if j >= len(r):
                continue
            lem = _clean_lemma(r[j])
            cnt = _as_int(r[j + 1]) if j + 1 < len(r) else None
            if not lem:
                continue
            ranks[j] = ranks.get(j, 0) + 1
            slp1 = to_slp1(lem)
            if target == "text_freq":
                batch.append((slp1, lem, text_id, label, ranks[j], cnt, source))
            else:
                batch.append((slp1, lem, None, label, ranks[j], cnt, source))
            n += 1
            if len(batch) >= 5000:
                _flush_freq(con, target, batch)
    _flush_freq(con, target, batch)
    return n


def _flush_freq(con, target, batch):
    if not batch:
        return
    if target == "text_freq":
        con.executemany(
            "INSERT INTO text_freq(lemma_slp1,lemma_raw,text_id,text_name,rank,count,source) "
            "VALUES(?,?,?,?,?,?,?)", batch)
    else:
        con.executemany(
            "INSERT INTO period_freq(lemma_slp1,lemma_raw,grammar,period,rank,count,source) "
            "VALUES(?,?,?,?,?,?,?)", [(b[0], b[1], None, b[3], b[4], b[5], b[6]) for b in batch])
    batch.clear()


def _load_corpus_freq_with_grammar(con, path, source):
    """Приложение 3: (Лемма, Грамм., Абс.частота) -> period_freq period='ALL-corpus'."""
    rows = list(read_rows(path))
    batch = []
    rank = 0
    for r in rows[1:]:
        lem = _clean_lemma(r[0] if len(r) > 0 else None)
        if not lem:
            continue
        gram = (str(r[1]).strip() if len(r) > 1 and r[1] not in (None, "") else None)
        cnt = _as_int(r[2]) if len(r) > 2 else None
        rank += 1
        batch.append((to_slp1(lem), lem, gram, "ALL-corpus", rank, cnt, source))
    con.executemany(
        "INSERT INTO period_freq(lemma_slp1,lemma_raw,grammar,period,rank,count,source) "
        "VALUES(?,?,?,?,?,?,?)", batch)
    return len(batch)


def _load_core_paired(con, path, source):
    """Приложение 5: paired (lemma, Грм.) columns of core vocab per period."""
    rows = list(read_rows(path))
    header = rows[0]
    ncol = max(len(r) for r in rows)
    ranks = {}
    batch = []
    for j in range(0, ncol, 2):
        if j >= len(header) or header[j] is None:
            continue
        period = str(header[j]).strip()
        for r in rows[1:]:
            if j >= len(r):
                continue
            lem = _clean_lemma(r[j])
            if not lem:
                continue
            gram = (str(r[j + 1]).strip() if j + 1 < len(r) and r[j + 1] not in (None, "") else None)
            ranks[j] = ranks.get(j, 0) + 1
            batch.append((to_slp1(lem), lem, gram, period, ranks[j], None, source))
    con.executemany(
        "INSERT INTO core_vocab(lemma_slp1,lemma_raw,grammar,period,rank,coverage_pct,source) "
        "VALUES(?,?,?,?,?,?,?)", batch)
    return len(batch)


def _load_core_simple(con, path, source, period, cov_col=None):
    """Приложение 10 / Сборное ядро: (Лемма, Грамм.[, %Покрытия]) single list."""
    rows = list(read_rows(path))
    batch = []
    rank = 0
    for r in rows[1:]:
        lem = _clean_lemma(r[0] if len(r) > 0 else None)
        if not lem:
            continue
        gram = (str(r[1]).strip() if len(r) > 1 and r[1] not in (None, "") else None)
        cov = None
        if cov_col is not None and len(r) > cov_col and r[cov_col] not in (None, ""):
            try:
                cov = float(r[cov_col])
            except Exception:
                cov = None
        rank += 1
        batch.append((to_slp1(lem), lem, gram, period, rank, cov, source))
    con.executemany(
        "INSERT INTO core_vocab(lemma_slp1,lemma_raw,grammar,period,rank,coverage_pct,source) "
        "VALUES(?,?,?,?,?,?,?)", batch)
    return len(batch)


def cmd_freq(args):
    ql = os.path.join(DERIVED, "QL")
    lc = os.path.join(DERIVED, "Lexical-Cores")
    con = connect()
    con.executescript(FREQ_DDL)
    for t in ("text_names", "period_freq", "text_freq", "core_vocab"):
        con.execute(f"DELETE FROM {t}")
    stats = {}

    p2 = _first("Приложение 2.*", lc)
    tmap = {}
    if p2:
        recs = _load_text_names(con, p2)
        tmap = {tid: nm for tid, nm in recs}
        stats["text_names"] = len(recs)

    ql_frq = _first("Частотный словарь санскрита по периодам.xlsx", ql)
    if ql_frq:
        stats["period_freq_QL"] = _load_paired_freq(con, ql_frq, "QL/FRQ_P", sheet="FRQ_P")
    p4 = _first("Приложение 4.*", lc)
    if p4:
        stats["period_freq_P4"] = _load_paired_freq(con, p4, "Leonchenko/Прил4")
    p3 = _first("Приложение 3.*", lc)
    if p3:
        stats["corpus_freq_P3"] = _load_corpus_freq_with_grammar(con, p3, "Leonchenko/Прил3")
    if p2:
        stats["text_freq_P2"] = _load_paired_freq(con, p2, "Leonchenko/Прил2",
                                                  target="text_freq", text_name_map=tmap)

    p5 = _first("Приложение 5.*", lc)
    if p5:
        stats["core_P5"] = _load_core_paired(con, p5, "Leonchenko/Прил5")
    p10 = _first("Prilozhenie-10-*", lc)
    if p10:
        stats["core_P10_stable"] = _load_core_simple(con, p10, "Leonchenko/Прил10", "STABLE-ALL-HISTORY")
    sbor = _first("Сборное ядро.xlsx", lc)
    if sbor:
        stats["core_Sbornoe"] = _load_core_simple(con, sbor, "Leonchenko/Сборное", "COMBINED-CORE", cov_col=2)

    for stmt in (
        "CREATE INDEX IF NOT EXISTS ix_pf_lemma ON period_freq(lemma_slp1)",
        "CREATE INDEX IF NOT EXISTS ix_pf_period ON period_freq(period)",
        "CREATE INDEX IF NOT EXISTS ix_tf_lemma ON text_freq(lemma_slp1)",
        "CREATE INDEX IF NOT EXISTS ix_tf_text ON text_freq(text_id)",
        "CREATE INDEX IF NOT EXISTS ix_cv_lemma ON core_vocab(lemma_slp1)",
    ):
        con.execute(stmt)
    con.commit()
    con.close()
    print("[D3 freq]", stats)


# --------------------------------------------------------------------------- #
# D4 — subhāṣita (Böhtlingk, Indische Sprüche)
# --------------------------------------------------------------------------- #
SUBHASHITA_DDL = """
CREATE TABLE IF NOT EXISTS subhashita (
    id                 INTEGER PRIMARY KEY,
    saying_id          TEXT,   -- 'Saying N'
    page               TEXT,   -- 'Page X.Y'
    text_sa_deva       TEXT,   -- Sanskrit in Devanāgarī
    text_sa_iast       TEXT,   -- Sanskrit in IAST (from the Btlnk IAST sheet where available)
    translation_de     TEXT,   -- Böhtlingk's German translation (the actual language present)
    source_attribution TEXT,   -- e.g. 'MBH. 3, 1209.', 'BHARTṚ. ...'
    notes              TEXT,   -- concatenated apparatus/variant notes
    source_file        TEXT
);
CREATE TABLE IF NOT EXISTS subhashita_ramayana (
    id           INTEGER PRIMARY KEY,
    saying_id    TEXT,
    btlnk_iast   TEXT,
    ram_ref      TEXT,
    ram_text     TEXT,
    ram_rus      TEXT     -- Russian translation of the matched Rāmāyaṇa verse
);
"""

SAYING_RE = re.compile(r"(Saying\s+\d+)\s*,\s*(Page\s+[\d.]+)", re.I)


def cmd_subhashita(args):
    root = os.path.join(NONDERIVED, "Sanskritskie-izrecheniya")
    main = _first("Subhash_Bt.xlsx", root) or _first("Subhash_*.xlsx", root)
    if not main:
        print("[D4] subhāṣita workbook not found — skipping", file=sys.stderr)
        return
    con = connect()
    con.executescript(SUBHASHITA_DDL)
    con.execute("DELETE FROM subhashita")
    con.execute("DELETE FROM subhashita_ramayana")

    # IAST lookup from the 'Btlnk, Ram, Mh' sheet (col0=saying id, col1=Btlnk_Text IAST)
    iast_by_saying = {}
    ram_batch = []
    try:
        for r in read_rows(main, "Btlnk, Ram, Mh"):
            sid = str(r[0]).strip() if r and r[0] else None
            if not sid or not sid.lower().startswith("saying"):
                continue
            key = SAYING_RE.match(sid)
            skey = key.group(1) if key else sid
            iast = str(r[1]).strip() if len(r) > 1 and r[1] else None
            if iast and skey not in iast_by_saying:
                iast_by_saying[skey] = iast
            ram_ref = str(r[2]).strip() if len(r) > 2 and r[2] else None
            if ram_ref:
                ram_batch.append((skey, iast,
                                  ram_ref,
                                  str(r[3]).strip() if len(r) > 3 and r[3] else None,
                                  str(r[4]).strip() if len(r) > 4 and r[4] else None))
    except Exception as e:
        print(f"[D4] Ram sheet skipped: {e}", file=sys.stderr)

    n = 0
    batch = []
    for r in read_rows(main, "Лист1"):
        c0 = str(r[0]).strip() if r and r[0] else ""
        m = SAYING_RE.match(c0)
        if not m:
            continue
        saying_id, page = m.group(1), m.group(2)
        deva = str(r[1]).strip() if len(r) > 1 and r[1] else None
        de = str(r[2]).strip() if len(r) > 2 and r[2] else None
        src = str(r[3]).strip() if len(r) > 3 and r[3] else None
        notes = " | ".join(str(r[k]).strip() for k in range(4, min(len(r), 9))
                           if r[k] not in (None, "")) or None
        iast = iast_by_saying.get(saying_id)
        if not iast and deva and HAVE_SU:
            try:
                iast = su.deva_to_iast(deva)
            except Exception:
                iast = None
        batch.append((saying_id, page, deva, iast, de, src, notes, os.path.basename(main)))
        n += 1
        if len(batch) >= 3000:
            con.executemany(
                "INSERT INTO subhashita(saying_id,page,text_sa_deva,text_sa_iast,translation_de,"
                "source_attribution,notes,source_file) VALUES(?,?,?,?,?,?,?,?)", batch)
            batch.clear()
    if batch:
        con.executemany(
            "INSERT INTO subhashita(saying_id,page,text_sa_deva,text_sa_iast,translation_de,"
            "source_attribution,notes,source_file) VALUES(?,?,?,?,?,?,?,?)", batch)
    if ram_batch:
        con.executemany(
            "INSERT INTO subhashita_ramayana(saying_id,btlnk_iast,ram_ref,ram_text,ram_rus) "
            "VALUES(?,?,?,?,?)", ram_batch)
    con.execute("CREATE INDEX IF NOT EXISTS ix_sub_saying ON subhashita(saying_id)")
    con.commit()
    con.close()
    print("[D4 subhashita]", dict(sayings=n, ram_links=len(ram_batch)))


def cmd_all(args):
    cmd_parallels(args)
    cmd_stopword(args)
    cmd_freq(args)
    cmd_subhashita(args)


# --------------------------------------------------------------------------- #
# validation (D5)
# --------------------------------------------------------------------------- #
def _table_exists(con, name):
    return con.execute(
        "SELECT 1 FROM sqlite_master WHERE type='table' AND name=?", (name,)).fetchone() is not None


def cmd_validate(args):
    con = connect()
    out = []
    def p(s):
        out.append(s)
        print(s)

    p("# M9 archive.sqlite — validation")
    p("")
    if _table_exists(con, "parallels"):
        for method, run in con.execute("SELECT DISTINCT method, run FROM parallels").fetchall():
            tot = con.execute("SELECT COUNT(*) FROM parallels WHERE method=? AND run=?", (method, run)).fetchone()[0]
            good = con.execute("SELECT COUNT(*) FROM parallels WHERE method=? AND run=? AND quality='GOOD'", (method, run)).fetchone()[0]
            rec = con.execute("SELECT COUNT(*) FROM parallels WHERE method=? AND run=? AND recovered=1", (method, run)).fetchone()[0]
            tid = con.execute("SELECT COUNT(*) FROM parallels WHERE method=? AND run=? AND target_text_id IS NOT NULL", (method, run)).fetchone()[0]
            p(f"- parallels [{method}/{run}]: {tot:,} matches | GOOD {good:,} / PARTLY {tot-good:,} "
              f"| target_id resolved {100*tid/tot:.1f}% | recovered rows {rec}")
    if _table_exists(con, "parallel_text"):
        n = con.execute("SELECT COUNT(*) FROM parallel_text").fetchone()[0]
        linked = con.execute("SELECT COUNT(*) FROM parallel_text WHERE dcs_text_id IS NOT NULL").fetchone()[0]
        p(f"- crosswalk parallel_text: {n} texts | dcs_full-linked {linked} ({100*linked/n:.1f}%)")
        # cross-validate against the authoritative Приложение 2 text_names list
        if _table_exists(con, "text_names"):
            both = con.execute(
                "SELECT COUNT(*) FROM parallel_text pt JOIN text_names tn ON pt.para_text_id=tn.text_id "
                "WHERE pt.abbrev IS NOT NULL").fetchone()[0]
            agree = con.execute(
                "SELECT COUNT(*) FROM parallel_text pt JOIN text_names tn ON pt.para_text_id=tn.text_id "
                "WHERE pt.fullname=tn.text_name OR pt.dcs_name=tn.text_name").fetchone()[0]
            p(f"  - vs Приложение 2 authoritative id-list: {both} ids present, {agree} names agree")
    for t in ("period_freq", "text_freq", "core_vocab", "text_names", "subhashita", "subhashita_ramayana"):
        if _table_exists(con, t):
            n = con.execute(f"SELECT COUNT(*) FROM {t}").fetchone()[0]
            p(f"- {t}: {n:,} rows")
    # separate stop-word DB (regenerable, not shipped)
    if os.path.exists(STOPWORD_DB):
        sc = sqlite3.connect(STOPWORD_DB)
        try:
            if _table_exists(sc, "parallels"):
                tot = sc.execute("SELECT COUNT(*) FROM parallels").fetchone()[0]
                good = sc.execute("SELECT COUNT(*) FROM parallels WHERE quality='GOOD'").fetchone()[0]
                tid = sc.execute("SELECT COUNT(*) FROM parallels WHERE target_text_id IS NOT NULL").fetchone()[0]
                p(f"- [archive_stopword.sqlite] parallels [stopword/2022-partial]: {tot:,} matches | "
                  f"GOOD {good:,} / PARTLY {tot-good:,} | target_id resolved {100*tid/tot:.1f}%")
        finally:
            sc.close()
    if _table_exists(con, "period_freq"):
        p("  - period_freq SLP1 coverage: " + str(dict(con.execute(
            "SELECT source, ROUND(100.0*SUM(lemma_slp1 IS NOT NULL)/COUNT(*),1) FROM period_freq GROUP BY source"))))
        periods = [r[0] for r in con.execute("SELECT DISTINCT period FROM period_freq ORDER BY period")]
        p(f"  - periods: {periods}")
    con.close()
    if getattr(args, "outfile", None):
        with open(args.outfile, "w", encoding="utf-8") as f:
            f.write("\n".join(out) + "\n")


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = ap.add_subparsers(dest="cmd", required=True)
    sub.add_parser("parallels").set_defaults(func=cmd_parallels)
    sub.add_parser("stopword").set_defaults(func=cmd_stopword)
    sub.add_parser("freq").set_defaults(func=cmd_freq)
    sub.add_parser("subhashita").set_defaults(func=cmd_subhashita)
    sub.add_parser("crosswalk").set_defaults(func=cmd_crosswalk)
    sub.add_parser("all").set_defaults(func=cmd_all)
    vp = sub.add_parser("validate")
    vp.add_argument("--outfile", default=None)
    vp.set_defaults(func=cmd_validate)
    args = ap.parse_args()
    args.func(args)


if __name__ == "__main__":
    main()
