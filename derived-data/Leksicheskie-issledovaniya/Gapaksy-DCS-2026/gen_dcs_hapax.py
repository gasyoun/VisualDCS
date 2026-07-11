"""Reproducible DCS-2026 hapax census: all hapax lemmas + single-vs-compound split.

A hapax legomenon here = a DCS-disambiguated lemma (lemma_id) whose total
frequency over the whole corpus is exactly 1, counted over content tokens
(punctuation excluded).

Outputs (written next to this script):
  dcs2026_hapax_all.tsv             every hapax lemma
  dcs2026_hapax_single_morpheme.tsv hapaxes NOT segmentable into attested lemmas
  dcs2026_hapax_compound.tsv        hapaxes segmentable into >=2 attested lemmas

Source: VisualDCS/src/DCS-data-2026/dcs_full.sqlite (Oliver Hellwig / DCS,
release 2026, CC BY-SA). 5,688,416 content tokens. Deterministic — no network,
no randomness; re-running on the same DB reproduces the files byte-for-byte.

Compound heuristic (see README manifest for the honest limitation list):
  a hapax is COMPOUND if its IAST string splits into >=2 members, each an
  independently attested base lemma (corpus freq >= 2, len >= MINLEN), by
  DIRECT stem concatenation (no vowel-sandhi resolution at the seam).

Model provenance: authored under Opus 4.8 (claude-opus-4-8), 12-07-2026.
"""
import sqlite3, sys, os, csv
sys.stdout.reconfigure(encoding='utf-8')
sys.stderr.reconfigure(encoding='utf-8')

HERE = os.path.dirname(os.path.abspath(__file__))
DB = os.path.normpath(os.path.join(
    HERE, "..", "..", "..", "src", "DCS-data-2026", "dcs_full.sqlite"))
MINLEN = 3


def load_lemma_freqs(c):
    """lemma_id -> (repr lemma string, corpus freq, repr upos), content tokens only."""
    return c.execute("""
        select lemma_id, min(lemma) as lemma, count(*) as freq, min(upos) as upos
        from token
        where lemma is not null and lemma <> ''
          and (upos is null or upos <> 'PUNCT')
          and (m_punctuation is null or m_punctuation = '')
        group by lemma_id
    """).fetchall()


def build_dict(rows):
    """Segmentation dictionary: attested base lemmas, freq>=2, len>=MINLEN."""
    d = set()
    for lid, lem, f, up in rows:
        if f >= 2 and len(lem) >= MINLEN and lem.replace('-', '').isalpha():
            d.add(lem.lower())
    return d


def make_is_compound(DICT):
    def segmentable(s):
        s = s.lower(); n = len(s)
        dp = [False] * (n + 1); dp[n] = True
        for i in range(n - 1, -1, -1):
            for j in range(i + MINLEN, n + 1):
                if s[i:j] in DICT and dp[j]:
                    dp[i] = True; break
        return dp[0]

    def is_compound(lem):
        s = lem.lower()
        if '-' in s:
            return True
        if not s.isalpha() or len(s) < 2 * MINLEN:
            return False
        n = len(s)
        for k in range(MINLEN, n - MINLEN + 1):
            if s[:k] in DICT and (s[k:] in DICT or segmentable(s[k:])):
                return True
        return False
    return is_compound


def write_tsv(path, items, meta):
    with open(path, 'w', encoding='utf-8', newline='') as f:
        w = csv.writer(f, delimiter='\t')
        w.writerow(['lemma_id', 'lemma', 'upos', 'grammar', 'meaning'])
        for lid, lem, up in sorted(items, key=lambda r: r[1]):
            g, m = meta.get(lid, ('', ''))
            w.writerow([lid, lem, up or '', g or '', (m or '').replace('\n', ' ')])


def main():
    c = sqlite3.connect(DB)
    rows = load_lemma_freqs(c)
    meta = {lid: (g, m) for (lid, g, m)
            in c.execute("select lemma_id, grammar, meanings from lemma")}

    vocab = len(rows)
    hapax = [(lid, lem, up) for (lid, lem, f, up) in rows if f == 1]
    DICT = build_dict(rows)
    is_compound = make_is_compound(DICT)

    compound = [h for h in hapax if is_compound(h[1])]
    single = [h for h in hapax if not is_compound(h[1])]

    write_tsv(os.path.join(HERE, "dcs2026_hapax_all.tsv"),
              hapax, meta)
    write_tsv(os.path.join(HERE, "dcs2026_hapax_single_morpheme.tsv"),
              single, meta)
    write_tsv(os.path.join(HERE, "dcs2026_hapax_compound.tsv"),
              compound, meta)

    print(f"vocabulary (distinct lemma_id) : {vocab:,}")
    print(f"hapax lemmas (freq == 1)       : {len(hapax):,} "
          f"({100*len(hapax)/vocab:.1f}% of vocab)")
    print(f"  compound (segmentable)       : {len(compound):,} "
          f"({100*len(compound)/len(hapax):.1f}% of hapaxes)")
    print(f"  single-morpheme (kept)       : {len(single):,} "
          f"({100*len(single)/len(hapax):.1f}% of hapaxes)")


if __name__ == "__main__":
    main()
