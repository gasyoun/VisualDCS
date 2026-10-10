#!/usr/bin/env python3
"""Extract the three legacy ligature inventories into committed CSV sources.

One-time extraction (H6391). Inputs are NOT in any git repo as clean text —
after this script writes sources/*.csv, build_ligature_canon.py reads only the
committed CSVs and needs none of these inputs.

Sources
-------
1. Ustav-chat appendix «Сводный список лигатур» (yadisk
   Sanskrityatina/10_Узелки/!Узелки письма деванагари 2022.docx, read-only
   WebDAV, H4677 pattern). Entries = Devanāgarī cluster (rendered in three
   fonts: Sanskrit 2003 / Siddhanta / Santipur 2014 — same Unicode cluster)
   + Latin (IAST) cluster, grouped "2/3/4/5 Konsonanten".
   NOTE: the chapter quote says the pre-revolutionary textbook has «около 280
   лигатур»; the appendix ACTUALLY collected in the chat is a much larger
   Zimmermann-tradition list — the measured count is recorded, not 280.
2. gasyoun/Nagari Varnamala `Liste-807-Sanskrit-Ligaturen-D.txt` (UTF-8 BOM,
   one cluster per line, some lines carry several clusters) — 807 attested.
3. gasyoun/Nagari Varnamala `Liste-460-Rigveda-Ligaturen.txt` (UTF-8 BOM,
   cluster<TAB>count) — 460 Rigveda ligatures with frequencies.

Usage
-----
    python3 extract_sources.py \
        --docx /path/to/uzelki_2022.docx \
        --varnamala /path/to/Nagari/Varnamala

Writes sources/ustavchat_appendix.csv, sources/attested807.csv,
sources/rigveda460.csv (+ prints sha256 of each input for provenance).
"""
import csv
import hashlib
import os
import re
import sys
import unicodedata
import zipfile

sys.stdout.reconfigure(encoding="utf-8")
sys.stderr.reconfigure(encoding="utf-8")
import xml.etree.ElementTree as ET

HERE = os.path.dirname(os.path.abspath(__file__))
SRC = os.path.join(HERE, "sources")
W = "{http://schemas.openxmlformats.org/wordprocessingml/2006/main}"

# IAST consonant-cluster token (Zimmermann tradition alphabet), full-token match
TOK = r"(?<![\wāīūṛṝḷṃḥśṣṭḍṅñṇ])[a-zāīūṛṝḷṃḥśṣṭḍṅñṇ]{2,8}(?![\wāīūṛṝḷṃḥśṣṭḍṅñṇ])"


def sha256(path):
    h = hashlib.sha256()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def nfc(s):
    return unicodedata.normalize("NFC", s.strip())


def parse_docx_appendix(path):
    """-> list of (iast, devanagari, group_n) in document order."""
    z = zipfile.ZipFile(path)
    body = ET.fromstring(z.read("word/document.xml")).find(W + "body")
    paras = ["".join(x.text or "" for x in e.iter(W + "t")).strip()
             for e in body if e.tag == W + "p"]
    paras = [p for p in paras if p]
    heads = [i for i, p in enumerate(paras) if "Сводный список лигатур" in p]
    if not heads:
        raise SystemExit("appendix heading not found in docx")
    start = heads[-1]
    out = []
    seen = set()
    for p in paras[start + 1:start + 8]:
        m = re.match(r"^([2-5]) Konsonanten[:\s]", p)
        if not m:
            if out:
                break
            continue
        grp = int(m.group(1))
        for seg in re.split(r",|\.", p):
            latin = re.findall(TOK, seg)
            if not latin:
                continue
            tok = nfc(latin[-1])
            if tok in seen or not re.fullmatch(r"[a-zāīūṛṝḷṃḥśṣṭḍṅñṇ]{2,8}", tok):
                continue
            devas = re.findall(r"[\u0900-\u097F][\u0900-\u097F‍]*", seg)
            dev = "".join(devas[:1]) if devas else ""
            seen.add(tok)
            out.append((tok, dev, grp))
    return out


def parse_liste807(path):
    """One cluster per line; some lines hold several — regex all tokens."""
    out, seen = [], set()
    for line in open(path, encoding="utf-8-sig"):
        for tok in re.findall(TOK, line):
            tok = nfc(tok)
            if tok not in seen:
                seen.add(tok)
                out.append(tok)
    return out


def parse_rigveda460(path):
    out, seen = [], set()
    for line in open(path, encoding="utf-8-sig"):
        m = re.match(r"([a-zāīūṛṝḷṃḥśṣṭḍṅñṇ]{2,8})\s+(\d+)", line.strip())
        if not m:
            continue
        tok = nfc(m.group(1))
        if tok not in seen:
            seen.add(tok)
            out.append((tok, int(m.group(2))))
    return out


def write_csv(name, header, rows):
    os.makedirs(SRC, exist_ok=True)
    p = os.path.join(SRC, name)
    with open(p, "w", newline="", encoding="utf-8") as f:
        w = csv.writer(f, lineterminator="\n")
        w.writerow(header)
        w.writerows(rows)
    print(f"wrote {p}: {len(rows)} rows")


def main():
    import argparse
    ap = argparse.ArgumentParser()
    ap.add_argument("--docx", required=True)
    ap.add_argument("--varnamala", required=True)
    a = ap.parse_args()

    print("docx sha256:", sha256(a.docx))
    app = parse_docx_appendix(a.docx)
    write_csv("ustavchat_appendix.csv", ["iast", "devanagari", "group_n_consonants"],
              [(t, d, g) for t, d, g in app])

    l807 = os.path.join(a.varnamala, "Liste-807-Sanskrit-Ligaturen-D.txt")
    print("liste807 sha256:", sha256(l807))
    a807 = parse_liste807(l807)
    write_csv("attested807.csv", ["iast", "file_order"], [(t, i) for i, t in enumerate(a807, 1)])

    l460 = os.path.join(a.varnamala, "Liste-460-Rigveda-Ligaturen.txt")
    print("rigveda460 sha256:", sha256(l460))
    r460 = parse_rigveda460(l460)
    write_csv("rigveda460.csv", ["iast", "rigveda_count"],
              [(t, c) for t, c in r460])

    print(f"SUMMARY ustavchat={len(app)} attested807={len(a807)} rigveda460={len(r460)}")


if __name__ == "__main__":
    main()
