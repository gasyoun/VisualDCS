# -*- coding: utf-8 -*-
"""generated_table_contract.py -- H5096: reusable round-trip + determinism
contract for generated TSV/CSV artifacts.

Generalizes the defensive method proven in PR #136 (Kompozity
mw_h3_parent_compounds.tsv: non-colliding child separator, LF-explicit write,
re-read-and-assert round trip) from one table into a shared validator.

What it enforces, per artifact (spec in SPECS below):
  1. byte hygiene       UTF-8, no BOM, LF-only (no CR anywhere), ends with \n
  2. delimiter safety   exact header, exact field count per row, no delimiter /
                        quote / CR / LF smuggled inside a TSV field
  3. encode/decode
     round-trip         re-serialize the parsed rows canonically and require
                        byte-identical output (catches quoting / escaping /
                        line-ending drift)
  4. row + key
     preservation       row count reported, key uniqueness per spec
  5. declared-count
     reconciliation     per-artifact rules: mw_h3 n_children == tokenized
                        children; per_text tok_delta == tok_2026 - tok_2021;
                        hapax trio all == single + compound (disjoint)
  6. domain rules       int columns (optionally empty), enum columns

Modes:
  --check [NAME ...]   validate committed artifacts (CI-safe: reads the
                       committed bytes only, needs no corpus/DB)
  --rebuild NAME       run the spec's rebuild command TWICE, require
                       run1-hash == run2-hash == committed-hash (two-build
                       determinism; needs the builder's real inputs, so it is
                       a local gate, not CI)
  --mutate             plant information-loss mutations in TEMP COPIES (the
                       committed file is hashed before and after and must not
                       change) and require every mutation to FAIL the check
                       -- the RED receipt
  --selftest           synthetic fixtures exercising every check, happy and
                       failing

Exit codes: 0 = all green, 1 = any check failed / a mutation was NOT caught.

Pilot set (census + rationale: reports/h5096_generated_table_contract.md):
  mw_h3_parent_compounds.tsv   anchor (PR #136), list-field + count column
  dcs2026_hapax_{all,single_morpheme,compound}.tsv
                               free-text fields (tab-in-text risk) +
                               cross-artifact count identity
  per_text_token_delta.csv     comma-CSV quoting round-trip + arithmetic
                               reconciliation columns
  uttarapada_dict_vs_corpus.tsv
                               csv.DictWriter path, enum + 8 numeric columns
"""
import argparse
import csv
import hashlib
import io
import os
import shutil
import subprocess
import sys
import tempfile

for _stream in (sys.stdout, sys.stderr):
    _reconf = getattr(_stream, "reconfigure", None)
    if _reconf is not None:
        _reconf(encoding="utf-8")

HERE = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.dirname(HERE)

ENUM_UTTARAPADA_STATUS = ("final", "form_variant", "nonfinal_only", "absent")


class CheckFailure(Exception):
    pass


def _fail(path, label, msg):
    raise CheckFailure(f"{path}: {label}: {msg}")


# ---------------------------------------------------------------- parsing
def parse_table(raw_bytes, path, dialect, columns):
    """Strict parse + canonical re-serialization. Returns (rows, canonical_bytes).

    rows = list of dicts keyed by column name. Raises CheckFailure on any
    byte-hygiene / delimiter-safety violation or round-trip mismatch.
    """
    label = "byte-hygiene"
    if raw_bytes.startswith(b"\xef\xbb\xbf"):
        _fail(path, label, "file starts with a UTF-8 BOM")
    if b"\r" in raw_bytes:
        _fail(path, label, "CR byte found -- line endings must be LF-only")
    if not raw_bytes.endswith(b"\n"):
        _fail(path, label, "file does not end with a newline")
    try:
        text = raw_bytes.decode("utf-8")
    except UnicodeDecodeError as exc:
        _fail(path, label, f"not valid UTF-8: {exc}")
        raise  # _fail always raises; this line only satisfies the type checker

    lines = text.split("\n")
    if lines and lines[-1] == "":
        lines.pop()  # trailing newline, already checked

    header, data_lines = lines[0], lines[1:]

    rows = []
    if dialect == "tsv":
        if header != "\t".join(columns):
            _fail(path, "delimiter-safety",
                  f"header is {header!r}, expected {chr(9).join(columns)!r}")
        for lineno, line in enumerate(data_lines, start=2):
            fields = line.split("\t")
            if len(fields) != len(columns):
                _fail(path, "delimiter-safety",
                      f"line {lineno}: expected {len(columns)} tab-separated "
                      f"fields, got {len(fields)}")
            for f_i, field in enumerate(fields):
                if any(c in field for c in ("\t", "\r", "\n")):
                    _fail(path, "delimiter-safety",
                          f"line {lineno}: field {columns[f_i]!r} contains a "
                          f"control/delimiter character")
            rows.append(dict(zip(columns, fields)))
        canonical = "\t".join(columns) + "\n" + "".join(
            "\t".join(r[c] for c in columns) + "\n" for r in rows)
    else:  # csv
        reader = csv.reader(io.StringIO(text, newline=""), delimiter=",",
                            quotechar='"')
        try:
            parsed = list(reader)
        except csv.Error as exc:
            _fail(path, "delimiter-safety", f"csv parse error: {exc}")
            raise
        if not parsed or parsed[0] != columns:
            _fail(path, "delimiter-safety",
                  f"header is {parsed[0] if parsed else None!r}, "
                  f"expected {columns!r}")
        for lineno, fields in enumerate(parsed[1:], start=2):
            if len(fields) != len(columns):
                _fail(path, "delimiter-safety",
                      f"line {lineno}: expected {len(columns)} fields, "
                      f"got {len(fields)} ({fields[:3]}...)")
            rows.append(dict(zip(columns, fields)))
        buf = io.StringIO(newline="")
        writer = csv.writer(buf, delimiter=",", quotechar='"',
                            lineterminator="\n")
        writer.writerow(columns)
        writer.writerows([[r[c] for c in columns] for r in rows])
        canonical = buf.getvalue()

    if canonical.encode("utf-8") != raw_bytes:
        _fail(path, "round-trip",
              "canonical re-serialization differs from the file bytes "
              "(quoting/escaping/line-ending drift)")
    return rows, canonical.encode("utf-8")


# ---------------------------------------------------------------- rules
def rule_int(col, allow_empty=False, nonneg=True):
    def check(path, row, lineno):
        v = row[col]
        if v == "" and allow_empty:
            return
        try:
            n = int(v)
        except ValueError:
            _fail(path, f"int:{col}", f"line {lineno}: {v!r} is not an int")
            raise
        if nonneg and n < 0:
            _fail(path, f"int:{col}", f"line {lineno}: negative value {n}")
    return check


def rule_enum(col, domain):
    def check(path, row, lineno):
        if row[col] not in domain:
            _fail(path, f"enum:{col}",
                  f"line {lineno}: {row[col]!r} not in {domain}")
    return check


def rule_unique(key_cols):
    def check(path, rows):
        seen = {}
        for lineno, row in enumerate(rows, start=2):
            k = tuple(row[c] for c in key_cols)
            if k in seen:
                _fail(path, "key-unique",
                      f"line {lineno}: duplicate key {k} (first at line "
                      f"{seen[k]})")
            seen[k] = lineno
    return check


def rule_mw_h3_children(path, rows):
    """Declared-count reconciliation: n_children == tokenized children."""
    for lineno, row in enumerate(rows, start=2):
        n = int(row["n_children"])
        toks = row["children"].split("|") if row["children"] else []
        if len(toks) != n:
            _fail(path, "count-reconcile",
                  f"line {lineno} (parent {row['parent']!r}): children "
                  f"tokenize to {len(toks)} tokens, n_children declares {n}")
        if any(t == "" for t in toks):
            _fail(path, "count-reconcile",
                  f"line {lineno}: empty child token (double separator?)")


def rule_per_text_arith(path, rows):
    """tok_delta == tok_2026 - tok_2021 on matched rows; only-* rows carry
    blanks on the absent side and an empty tok_delta."""
    for lineno, row in enumerate(rows, start=2):
        t21, t26 = row["text_2021"], row["text_2026"]
        if not t21 and not t26:
            _fail(path, "count-reconcile",
                  f"line {lineno}: both text columns empty")
        if t21 and t26:
            for c in ("sent_2021", "sent_2026", "tok_2021", "tok_2026",
                      "tok_delta"):
                if row[c] == "":
                    _fail(path, "count-reconcile",
                          f"line {lineno}: matched row has empty {c}")
            delta = int(row["tok_2026"]) - int(row["tok_2021"])
            if int(row["tok_delta"]) != delta:
                _fail(path, "count-reconcile",
                      f"line {lineno}: tok_delta {row['tok_delta']} != "
                      f"tok_2026 - tok_2021 = {delta}")
        else:
            for c in ("sent_2021", "tok_2021", "tok_delta") if not t21 else \
                     ("sent_2026", "tok_2026", "tok_delta"):
                if row[c] != "":
                    _fail(path, "count-reconcile",
                          f"line {lineno}: only-one-side row has non-empty {c}")


def _int_or_empty(v):
    return int(v) if v != "" else None


# ---------------------------------------------------------------- specs
class Spec:
    def __init__(self, path, dialect, columns, row_rules=(), table_rules=(),
                 rebuild=None, rebuild_inputs=()):
        self.path = path              # repo-relative
        self.dialect = dialect        # 'tsv' | 'csv'
        self.columns = columns
        self.row_rules = row_rules    # fn(path, row, lineno)
        self.table_rules = table_rules  # fn(path, rows)
        self.rebuild = rebuild        # shell command run from repo root
        self.rebuild_inputs = rebuild_inputs  # repo-relative input files


SPECS = {
    # --- pilot 1: the PR #136 anchor -------------------------------------
    # Occurrence-keyed by upstream design: the same (parent, children) row
    # legitimately recurs (e.g. 'ota' -> 'otaprota' at source lines 1537 and
    # 2131); 12,609 occurrences over 12,326 distinct headwords. Row
    # preservation = no row lost or altered, so NO uniqueness rule here --
    # the byte round-trip pins the exact multiset.
    "derived-data/Kompozity/mw_h3_parent_compounds.tsv": Spec(
        path="derived-data/Kompozity/mw_h3_parent_compounds.tsv",
        dialect="tsv",
        columns=["parent", "n_children", "children"],
        row_rules=(rule_int("n_children"),),
        table_rules=(rule_mw_h3_children,),
        rebuild="{py} derived-data/Kompozity/build_mw_h3_parent_compounds.py",
        rebuild_inputs=("derived-data/Kompozity/compounds.txt",
                        "derived-data/Kompozity/cmps.csv"),
    ),
    # --- pilot 2: hapax trio (free text + cross-artifact count identity) --
    "derived-data/Leksicheskie-issledovaniya/Gapaksy-DCS-2026/dcs2026_hapax_all.tsv": Spec(
        path="derived-data/Leksicheskie-issledovaniya/Gapaksy-DCS-2026/dcs2026_hapax_all.tsv",
        dialect="tsv",
        columns=["lemma_id", "lemma", "upos", "grammar", "meaning"],
        row_rules=(rule_int("lemma_id"),),
        table_rules=(rule_unique(["lemma_id"]),),
        rebuild="{py} derived-data/Leksicheskie-issledovaniya/Gapaksy-DCS-2026/gen_dcs_hapax.py",
        rebuild_inputs=("src/DCS-data-2026/dcs_full.sqlite",),
    ),
    "derived-data/Leksicheskie-issledovaniya/Gapaksy-DCS-2026/dcs2026_hapax_single_morpheme.tsv": Spec(
        path="derived-data/Leksicheskie-issledovaniya/Gapaksy-DCS-2026/dcs2026_hapax_single_morpheme.tsv",
        dialect="tsv",
        columns=["lemma_id", "lemma", "upos", "grammar", "meaning"],
        row_rules=(rule_int("lemma_id"),),
        table_rules=(rule_unique(["lemma_id"]),),
    ),
    "derived-data/Leksicheskie-issledovaniya/Gapaksy-DCS-2026/dcs2026_hapax_compound.tsv": Spec(
        path="derived-data/Leksicheskie-issledovaniya/Gapaksy-DCS-2026/dcs2026_hapax_compound.tsv",
        dialect="tsv",
        columns=["lemma_id", "lemma", "upos", "grammar", "meaning"],
        row_rules=(rule_int("lemma_id"),),
        table_rules=(rule_unique(["lemma_id"]),),
    ),
    # --- pilot 3: comma-CSV with arithmetic reconciliation ---------------
    "derived-data/Corpus-Delta-2021-2026/per_text_token_delta.csv": Spec(
        path="derived-data/Corpus-Delta-2021-2026/per_text_token_delta.csv",
        dialect="csv",
        columns=["text_2021", "text_2026", "sent_2021", "sent_2026",
                 "tok_2021", "tok_2026", "tok_delta"],
        row_rules=(rule_int("sent_2021", allow_empty=True),
                   rule_int("sent_2026", allow_empty=True),
                   rule_int("tok_2021", allow_empty=True),
                   rule_int("tok_2026", allow_empty=True),
                   rule_int("tok_delta", allow_empty=True, nonneg=False)),
        table_rules=(rule_per_text_arith,
                     rule_unique(["text_2021", "text_2026"])),
        rebuild="{py} derived-data/Corpus-Delta-2021-2026/delta_supplement.py",
        rebuild_inputs=("src/DCS-data-2021/0.csv",
                        "src/DCS-data-2021/_8.csv",
                        "src/DCS-data-2026/dcs_full.sqlite"),
    ),
    # --- pilot 4: csv.DictWriter path, enum + numeric columns ------------
    "derived-data/Kompozity/uttarapada_dict_vs_corpus.tsv": Spec(
        path="derived-data/Kompozity/uttarapada_dict_vs_corpus.tsv",
        dialect="tsv",
        columns=["final_member", "mw_class", "mw_first_members",
                 "corpus_compounds", "corpus_tokens", "corpus_first_members",
                 "overlap_first", "mw_only_first", "corpus_only_first",
                 "corpus_status"],
        row_rules=(rule_int("mw_first_members"), rule_int("corpus_compounds"),
                   rule_int("corpus_tokens"), rule_int("corpus_first_members"),
                   rule_int("overlap_first"), rule_int("mw_only_first"),
                   rule_int("corpus_only_first"),
                   rule_enum("corpus_status", ENUM_UTTARAPADA_STATUS)),
        table_rules=(rule_unique(["final_member"]),),
        rebuild="{py} derived-data/Kompozity/build_uttarapada_dict_vs_corpus.py",
        rebuild_inputs=("derived-data/Kompozity/cmps.csv",
                        "derived-data/Kompozity/names.csv",
                        "../MWderivations/issue15/compounds_reverse_classified.tsv"),
    ),
}

# Cross-artifact group: the hapax trio must partition exactly.
HAPAX_DIR = "derived-data/Leksicheskie-issledovaniya/Gapaksy-DCS-2026"
GROUPS = {
    "hapax-trio": {
        "members": [f"{HAPAX_DIR}/dcs2026_hapax_all.tsv",
                    f"{HAPAX_DIR}/dcs2026_hapax_single_morpheme.tsv",
                    f"{HAPAX_DIR}/dcs2026_hapax_compound.tsv"],
        "check": None,  # set below
    },
}


def check_hapax_partition(root):
    """all.lemma_ids == single ∪ compound, pairwise disjoint, sizes add up."""
    ids = {}
    for name, short in (("all", "all"), ("single_morpheme", "single"),
                        ("compound", "compound")):
        p = os.path.join(root, HAPAX_DIR, f"dcs2026_hapax_{name}.tsv")
        with open(p, "rb") as fh:
            rows, _ = parse_table(fh.read(), p, "tsv",
                                  ["lemma_id", "lemma", "upos", "grammar",
                                   "meaning"])
        ids[short] = {r["lemma_id"] for r in rows}
    path = f"{HAPAX_DIR}/dcs2026_hapax_*.tsv (group)"
    if ids["single"] & ids["compound"]:
        _fail(path, "count-reconcile",
              f"single/compound overlap: {len(ids['single'] & ids['compound'])} "
              f"lemma_id(s) in both")
    if ids["all"] != ids["single"] | ids["compound"]:
        _fail(path, "count-reconcile",
              f"all ({len(ids['all'])}) != single ({len(ids['single'])}) + "
              f"compound ({len(ids['compound'])}) union "
              f"({len(ids['single'] | ids['compound'])})")
    return len(ids["all"])


GROUPS["hapax-trio"]["check"] = check_hapax_partition


# ---------------------------------------------------------------- runner
def validate_spec(root, spec):
    """Run all checks for one artifact. Returns rows/keys summary line."""
    p = os.path.join(root, spec.path)
    if not os.path.exists(p):
        _fail(spec.path, "presence", "file does not exist")
    with open(p, "rb") as fh:
        raw = fh.read()
    rows, canonical = parse_table(raw, spec.path, spec.dialect, spec.columns)
    if raw != canonical:
        _fail(spec.path, "round-trip", "byte mismatch")
    for lineno, row in enumerate(rows, start=2):
        for rule in spec.row_rules:
            rule(spec.path, row, lineno)
    for rule in spec.table_rules:
        rule(spec.path, rows)
    n_keys = len({tuple(r[c] for c in spec.columns) for r in rows})
    return f"{len(rows)} rows / {n_keys} distinct full rows"


def run_checks(root, only=None):
    """Validate specs (and any group whose members are all in scope).

    Returns list of summary lines. Raises CheckFailure on first violation.
    """
    names = only if only else sorted(SPECS)
    unknown = [n for n in names if n not in SPECS]
    if unknown:
        raise CheckFailure(f"unknown artifact(s): {unknown}; "
                           f"known: {sorted(SPECS)}")
    summaries = []
    for name in names:
        summaries.append(f"  PASS {name}: {validate_spec(root, SPECS[name])}")
    for gname, grp in GROUPS.items():
        if only and not any(m in only for m in grp["members"]):
            continue
        if not all(os.path.exists(os.path.join(root, m))
                   for m in grp["members"]):
            continue
        n = grp["check"](root)
        summaries.append(f"  PASS group {gname}: partition holds over {n} ids")
    return summaries


def sha256(path):
    h = hashlib.sha256()
    with open(path, "rb") as fh:
        for chunk in iter(lambda: fh.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def rebuild_check(name):
    """Two-build determinism: rebuild twice, both hashes equal, equal to the
    committed artifact. Targets rebuilt by the command may span several files
    (the hapax builder writes three); every SPECS entry sharing the rebuild
    command is checked."""
    spec = SPECS[name]
    if not spec.rebuild:
        raise CheckFailure(f"{name}: no rebuild command in spec")
    missing = [i for i in spec.rebuild_inputs
               if not os.path.exists(os.path.join(REPO, i))]
    if missing:
        print(f"  SKIP {name}: rebuild inputs absent on this box: {missing}")
        return "skip"
    targets = sorted(set(
        s.path for s in SPECS.values() if s.rebuild == spec.rebuild))

    def head_hash(rel):
        """sha256 of the committed blob -- NOT the working file, which an
        earlier rebuild in the same session may already have overwritten."""
        r = subprocess.run(["git", "show", f"HEAD:{rel}"], cwd=REPO,
                           capture_output=True)
        if r.returncode != 0:
            raise CheckFailure(f"{rel}: git show HEAD failed: "
                               f"{r.stderr.decode(errors='replace')[:200]}")
        return hashlib.sha256(r.stdout).hexdigest()

    committed = {t: head_hash(t) for t in targets}
    hashes = []
    for run in (1, 2):
        r = subprocess.run(spec.rebuild.format(py=sys.executable), shell=True,
                           cwd=REPO, capture_output=True, text=True)
        if r.returncode != 0:
            print(r.stdout[-2000:])
            print(r.stderr[-2000:], file=sys.stderr)
            raise CheckFailure(f"{name}: rebuild run {run} exited "
                               f"{r.returncode}")
        hashes.append({t: sha256(os.path.join(REPO, t)) for t in targets})
        print(f"  rebuild run {run}: exit 0")
    for t in targets:
        if hashes[0][t] != hashes[1][t]:
            raise CheckFailure(
                f"{t}: two rebuilds disagree (run1 {hashes[0][t][:12]} vs "
                f"run2 {hashes[1][t][:12]}) -- build is not deterministic")
        if hashes[0][t] != committed[t]:
            raise CheckFailure(
                f"{t}: rebuilt bytes differ from the committed artifact "
                f"(committed {committed[t][:12]}, rebuilt {hashes[0][t][:12]}) "
                f"-- rebuild the artifact in the same PR or fix the builder")
        print(f"  DETERMINISTIC {t}: sha256 {committed[t][:16]}... "
              f"(2 runs == committed)")
    return "ok"


# ---------------------------------------------------------------- mutate
def _read(rel):
    with open(os.path.join(REPO, rel), "rb") as fh:
        return fh.read()


def _write_tmp(tmp, rel, data):
    dst = os.path.join(tmp, rel)
    os.makedirs(os.path.dirname(dst), exist_ok=True)
    with open(dst, "wb") as fh:
        fh.write(data)


def _edit_data_line(raw, fn):
    """Apply fn to the second line (first data row); return new bytes."""
    lines = raw.split(b"\n")
    lines[1] = fn(lines[1])
    return b"\n".join(lines)


def build_mutations():
    """(label, {rel_path: bytes}) -- every mutation must FAIL the checks."""
    muts = []
    mw = "derived-data/Kompozity/mw_h3_parent_compounds.tsv"
    mw_raw = _read(mw)

    def drop_child(line):
        f = line.split(b"\t")
        toks = f[2].split(b"|")
        f[2] = b"|".join(toks[:-1])  # lose one child, keep declared count
        return b"\t".join(f)
    muts.append(("mw_h3: child token dropped, n_children stale "
                 "(declared-count break)",
                 {mw: _edit_data_line(mw_raw, drop_child)}))

    def tab_in_children(line):
        f = line.split(b"\t")
        f[2] += b"\tplanted"  # smuggle a literal TAB -> 4 fields on the row
        return b"\t".join(f)
    muts.append(("mw_h3: literal TAB inside children field "
                 "(delimiter break)",
                 {mw: _edit_data_line(mw_raw, tab_in_children)}))

    hax = f"{HAPAX_DIR}/dcs2026_hapax_all.tsv"
    hax_raw = _read(hax)

    def tab_in_meaning(line):
        f = line.split(b"\t")
        f[4] += b"\tplanted"
        return b"\t".join(f)
    muts.append(("hapax_all: TAB smuggled into meaning field "
                 "(delimiter break)",
                 {hax: _edit_data_line(hax_raw, tab_in_meaning)}))

    def drop_row(raw):
        lines = raw.split(b"\n")
        del lines[1]  # one hapax vanishes -> trio identity breaks
        return b"\n".join(lines)
    muts.append(("hapax trio: one row deleted from _all "
                 "(cross-artifact count break)",
                 {hax: drop_row(hax_raw),
                  f"{HAPAX_DIR}/dcs2026_hapax_single_morpheme.tsv": _read(f"{HAPAX_DIR}/dcs2026_hapax_single_morpheme.tsv"),
                  f"{HAPAX_DIR}/dcs2026_hapax_compound.tsv": _read(f"{HAPAX_DIR}/dcs2026_hapax_compound.tsv")}))

    ptx = "derived-data/Corpus-Delta-2021-2026/per_text_token_delta.csv"
    ptx_raw = _read(ptx)

    def flip_delta(line):
        f = line.split(b",")
        f[6] = str(int(f[6]) + 7).encode()  # arithmetic no longer reconciles
        return b",".join(f)
    muts.append(("per_text_delta: tok_delta no longer == tok_2026-tok_2021 "
                 "(reconciliation break)",
                 {ptx: _edit_data_line(ptx_raw, flip_delta)}))

    def unquoted_comma(line):
        f = line.split(b",")
        f[1] = b"Planted,Text"  # comma smuggled in unquoted -> 8 fields
        return b",".join(f)
    muts.append(("per_text_delta: unquoted comma in text name "
                 "(CSV delimiter break)",
                 {ptx: _edit_data_line(ptx_raw, unquoted_comma)}))

    utt = "derived-data/Kompozity/uttarapada_dict_vs_corpus.tsv"
    utt_raw = _read(utt)

    def bad_enum(line):
        f = line.split(b"\t")
        f[9] = b"ghosted"  # corpus_status outside the domain
        return b"\t".join(f)
    muts.append(("uttarapada: corpus_status outside enum domain "
                 "(domain break)",
                 {utt: _edit_data_line(utt_raw, bad_enum)}))
    return muts


def run_mutations():
    """Every planted mutation must be CAUGHT; committed bytes untouched."""
    print("RED receipt -- planted information-loss mutations (temp copies):")
    caught, missed = 0, []
    for label, files in build_mutations():
        with tempfile.TemporaryDirectory() as tmp:
            for rel, data in files.items():
                _write_tmp(tmp, rel, data)
            try:
                run_checks(tmp, only=sorted(files))
                missed.append(label)
                print(f"  MISS {label}")
            except CheckFailure as exc:
                caught += 1
                first = str(exc).splitlines()[0]
                print(f"  CAUGHT {label}\n         -> {first[:150]}")
    print(f"mutations caught: {caught}, missed: {len(missed)}")
    if missed:
        raise CheckFailure(f"validator accepted information loss: {missed}")
    return caught


# ---------------------------------------------------------------- selftest
def selftest():
    """Synthetic happy + failing fixtures for every check class."""
    print("selftest -- synthetic fixtures:")
    ok = True

    def expect_fail(label, root, only=None):
        nonlocal ok
        try:
            run_checks(root, only=only)
            print(f"  FAIL(not caught) {label}")
            ok = False
        except CheckFailure as exc:
            print(f"  CAUGHT {label}: {str(exc).splitlines()[0][:110]}")

    def expect_pass(label, root, only=None):
        nonlocal ok
        try:
            run_checks(root, only=only)
            print(f"  PASS {label}")
        except CheckFailure as exc:
            print(f"  FAIL {label}: {exc}")
            ok = False

    good_tsv = (b"parent\tn_children\tchildren\n"
                b"deva\t2\tx|y\n"
                b"b\t0\t\n")
    good_csv = (b"text_2021,text_2026,sent_2021,sent_2026,tok_2021,"
                b"tok_2026,tok_delta\nA,A,1,2,10,25,15\n,B,,2,,25,\n")
    with tempfile.TemporaryDirectory() as tmp:
        spec = Spec("t.tsv", "tsv", ["parent", "n_children", "children"],
                    row_rules=(rule_int("n_children"),),
                    table_rules=(rule_mw_h3_children,
                                 rule_unique(["parent", "children"])))
        SPECS["_selftest_tsv"] = spec
        _write_tmp(tmp, "t.tsv", good_tsv)
        expect_pass("happy TSV round-trip + rules", tmp, only=["_selftest_tsv"])
        _write_tmp(tmp, "t.tsv",
                   good_tsv.replace(b"x|y", b"x y"))
        expect_fail("TSV: space-joined children vs declared count", tmp,
                    only=["_selftest_tsv"])
        _write_tmp(tmp, "t.tsv", b"parent\tn_children\tchildren\ndeva\t2\tx|y\ndeva\t2\tx|y\n")
        expect_fail("TSV: duplicate full row", tmp, only=["_selftest_tsv"])
        _write_tmp(tmp, "t.tsv", good_tsv.replace(b"y\n", b"y\r\n"))
        expect_fail("TSV: CRLF line ending", tmp, only=["_selftest_tsv"])
        _write_tmp(tmp, "t.tsv", b"\xef\xbb\xbf" + good_tsv)
        expect_fail("TSV: BOM", tmp, only=["_selftest_tsv"])
        _write_tmp(tmp, "t.tsv", good_tsv.rstrip(b"\n"))
        expect_fail("TSV: missing trailing newline", tmp, only=["_selftest_tsv"])
        _write_tmp(tmp, "t.tsv", good_tsv.replace(b"deva\t2", b"deva\ttwo"))
        expect_fail("TSV: non-int declared count", tmp, only=["_selftest_tsv"])
        _write_tmp(tmp, "t.tsv", good_tsv.replace(b"deva\t2\tx|y", b"deva\t2\tx||y"))
        expect_fail("TSV: empty child token (double separator)", tmp,
                    only=["_selftest_tsv"])
        _write_tmp(tmp, "t.tsv",
                   good_tsv.replace(b"parent\tn_children\tchildren",
                                    b"c1\tn\tlst"))
        expect_fail("TSV: header drift", tmp, only=["_selftest_tsv"])
        _write_tmp(tmp, "t.tsv", good_tsv.replace(b"deva\t2\tx|y",
                                                  b"deva\t2\tx|y|z"))
        expect_fail("TSV: tokenized children != declared count", tmp,
                    only=["_selftest_tsv"])
        _write_tmp(tmp, "t.tsv", good_tsv.replace(b"x|y", b"x\ty"))
        expect_fail("TSV: TAB smuggled into a field", tmp,
                    only=["_selftest_tsv"])
        del SPECS["_selftest_tsv"]

        spec_csv = Spec(
            "t.csv", "csv",
            ["text_2021", "text_2026", "sent_2021", "sent_2026", "tok_2021",
             "tok_2026", "tok_delta"],
            row_rules=(rule_int("tok_delta", allow_empty=True),),
            table_rules=(rule_per_text_arith,))
        SPECS["_selftest_csv"] = spec_csv
        _write_tmp(tmp, "t.csv", good_csv)
        expect_pass("happy CSV: matched + only-one-side rows", tmp,
                    only=["_selftest_csv"])
        quoted = (b"text_2021,text_2026,sent_2021,sent_2026,tok_2021,"
                  b"tok_2026,tok_delta\n"
                  b'"Planted,Text",A,1,2,10,25,15\n')
        _write_tmp(tmp, "t.csv", quoted)
        expect_pass("happy CSV: quoted comma round-trips", tmp,
                    only=["_selftest_csv"])
        _write_tmp(tmp, "t.csv", quoted.replace(b'"Planted,Text"',
                                               b"Planted,Text"))
        expect_fail("CSV: unquoted comma shifts fields", tmp,
                    only=["_selftest_csv"])
        _write_tmp(tmp, "t.csv",
                   good_csv.replace(b"10,25,15", b"10,25,16"))
        expect_fail("CSV: tok_delta arithmetic break", tmp,
                    only=["_selftest_csv"])
        del SPECS["_selftest_csv"]
    print("selftest:", "ALL GREEN" if ok else "FAILURES -- fix the contract")
    return ok


# ---------------------------------------------------------------- builder API
def enforce(rel_path, repo_root=REPO):
    """Post-write hook for builders (the PR #136 pattern, generalized).

    Validates one just-written artifact (+ any group it belongs to) against
    its committed spec and exits non-zero on violation. A missing spec is a
    build failure, not a silent pass.
    """
    rel = os.path.relpath(rel_path, repo_root).replace(os.sep, "/")
    if rel not in SPECS:
        sys.exit(f"generated-table contract: no spec for {rel}; "
                 f"add one to scripts/generated_table_contract.py SPECS")
    try:
        for line in run_checks(repo_root, only=[rel]):
            print(line)
        for gname, grp in GROUPS.items():
            if rel in grp["members"] and all(
                    os.path.exists(os.path.join(repo_root, m))
                    for m in grp["members"]):
                grp["check"](repo_root)
                print(f"  PASS group {gname}")
    except CheckFailure as exc:
        sys.exit(f"generated-table contract: FAIL\n{exc}")


# ---------------------------------------------------------------- main
def main():
    ap = argparse.ArgumentParser(
        description=(__doc__ or "generated-table contract").splitlines()[0])
    ap.add_argument("--check", nargs="*", metavar="NAME",
                    help="validate committed artifacts (default: all)")
    ap.add_argument("--rebuild", metavar="NAME",
                    help="two-build determinism gate for one artifact")
    ap.add_argument("--mutate", action="store_true",
                    help="plant mutations in temp copies, require RED")
    ap.add_argument("--selftest", action="store_true",
                    help="synthetic fixtures, happy + failing")
    args = ap.parse_args()

    if args.selftest:
        sys.exit(0 if selftest() else 1)
    if args.mutate:
        n_before = {rel: sha256(os.path.join(REPO, rel))
                    for rel in sorted(SPECS)}
        try:
            run_mutations()
        except CheckFailure as exc:
            sys.exit(f"MUTATION GATE: {exc}")
        n_after = {rel: sha256(os.path.join(REPO, rel))
                   for rel in sorted(SPECS)}
        untouched = [k for k in n_before
                     if n_before[k] != n_after[k]]
        if untouched:
            sys.exit(f"MUTATION GATE: committed file(s) changed: {untouched}")
        print("committed artifacts untouched: verified by hash")
        return
    if args.rebuild:
        try:
            outcome = rebuild_check(args.rebuild)
        except CheckFailure as exc:
            sys.exit(f"REBUILD GATE: {exc}")
        if outcome == "skip":
            sys.exit(2)
        return
    # default / --check
    try:
        lines = run_checks(REPO, only=args.check or None)
    except CheckFailure as exc:
        sys.exit(f"GENERATED-TABLE CONTRACT: FAIL\n{exc}")
    print("GENERATED-TABLE CONTRACT: GREEN")
    for line in lines:
        print(line)


if __name__ == "__main__":
    main()
