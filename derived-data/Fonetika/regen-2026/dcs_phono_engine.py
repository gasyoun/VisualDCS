"""Shared DCS surface-phonology engine: IAST->SLP1 word split + orthographic
segmentation (akshara/varna/ligature) + chapter-info.xml lookup, consumed by
this directory's ``build_akshara_ligature_freq.py`` and by
``SanskritGrammar/GasunsDhatu_2014/revision-2026/dcs_text_phonostats.py``.

Phoneme-class sets (VOWELS/CONS/MODIF) are sourced from the sanskrit-util
package (SLP1_VOWELS/SLP1_CONSONANTS/SLP1_MARKS v0.4.0), not re-hand-rolled —
the two sites' local copies were byte-identical to sanskrit-util's own sets
(H926 adversarial confirmation). `segment()` returns the richer (aksharas,
varnas, ligatures, ligatures2) tuple; a caller that only wants vowel/consonant
counts derives them from the varna list (see dcs_text_phonostats.py). The two
chapter-info loaders (by dcsTimeSlot vs by textName) are co-located verbatim,
unchanged, since they read different fields with independently-tuned lazy
regexes. Extracted — H926, Port 2 of the cross-repo dev-status + reuse review.
"""
import importlib.util as _ilu
import os
import re
import unicodedata

from indic_transliteration import sanscript
from indic_transliteration.sanscript import transliterate as tr

_HERE = os.path.dirname(os.path.abspath(__file__))
_SANSKRIT_UTIL_INIT = os.path.abspath(os.path.join(
    _HERE, '..', '..', '..', '..', 'sanskrit-util', 'py', 'sanskrit_util', '__init__.py'))

if not os.path.exists(_SANSKRIT_UTIL_INIT):
    raise ImportError(
        "shared 'sanskrit-util' package not found at %s — restore the sibling repo "
        "(GitHub-root layout required)." % _SANSKRIT_UTIL_INIT
    )

_spec = _ilu.spec_from_file_location('_sanskrit_util_shared', _SANSKRIT_UTIL_INIT)
_sanskrit_util = _ilu.module_from_spec(_spec)
_spec.loader.exec_module(_sanskrit_util)

# --- SLP1 phoneme classes (sourced from sanskrit-util, not re-hand-rolled) --
VOWELS = set(_sanskrit_util.SLP1_VOWELS)
CONS = set(_sanskrit_util.SLP1_CONSONANTS)
MODIF = set(_sanskrit_util.SLP1_MARKS)   # anusvāra, visarga, candrabindu (attach to preceding akshara)
# avagraha ' and anything else -> ignored / boundary

_SPLIT = re.compile("[^" + re.escape(_sanskrit_util.SLP1_ALPHABET) + "]+")


def slp1_words(text_iast):
    """IAST surface line -> list of SLP1 word strings (recognised phonemes only).

    Transliterate the whole line once (avagraha ' , daṇḍa, digits become
    separators), then split into maximal phoneme runs.
    """
    slp = tr(text_iast, sanscript.IAST, sanscript.SLP1)
    return [c for c in _SPLIT.split(slp) if c]


def segment(word):
    """Return (aksharas, varnas, ligatures, ligatures2) as SLP1-string lists.

    akshara = maximal run of consonants + one vowel + trailing modifiers,
              OR a word-final consonant run with no following vowel (coda).
    varna   = every phoneme (consonant / vowel / modifier) individually.
    ligature= a consonant run of length >= 2 (rendered as a conjunct).
    """
    aksharas, varnas, ligs, ligs2 = [], [], [], []
    i, n = 0, len(word)
    while i < n:
        c = word[i]
        if c in CONS:
            j = i
            while j < n and word[j] in CONS:
                j += 1
            cluster = word[i:j]            # one or more consonants
            varnas.extend(cluster)
            if len(cluster) >= 2:
                ligs.append(cluster)
                if len(cluster) == 2:
                    ligs2.append(cluster)
            if j < n and word[j] in VOWELS:  # onset + vowel -> akshara
                k = j + 1
                while k < n and word[k] in MODIF:
                    k += 1
                aksharas.append(word[i:k])
                varnas.append(word[j])
                varnas.extend(m for m in word[j+1:k])
                i = k
            else:                            # word-final consonant coda -> its own unit
                aksharas.append(cluster)     # rendered with halanta
                i = j
        elif c in VOWELS:                    # independent vowel akshara
            k = i + 1
            while k < n and word[k] in MODIF:
                k += 1
            aksharas.append(word[i:k])
            varnas.append(c)
            varnas.extend(m for m in word[i+1:k])
            i = k
        else:                                # stray modifier or unknown -> count as varna, skip
            if c in MODIF:
                varnas.append(c)
            i += 1
    return aksharas, varnas, ligs, ligs2


def load_slots(chapter_info_path):
    """basename(.conllu) -> dcsTimeSlot ('1'..'5'), from chapter-info.xml."""
    txt = open(chapter_info_path, encoding="utf-8").read()
    slot = {}
    for m in re.finditer(r"<path>(.*?)</path>\s*.*?<dcsTimeSlot>(.*?)</dcsTimeSlot>", txt, re.S):
        path, s = m.group(1), m.group(2)
        base = unicodedata.normalize("NFC", os.path.basename(path))
        slot[base] = s
    return slot


def load_textname_map(chapter_info_path):
    """basename(.conllu) -> textName, from chapter-info.xml."""
    txt = open(chapter_info_path, encoding="utf-8").read()
    m = {}
    for chap in re.finditer(r"<path>(.*?)</path>.*?<textName>(.*?)</textName>", txt, re.S):
        base = unicodedata.normalize("NFC", os.path.basename(chap.group(1)))
        m[base] = unicodedata.normalize("NFC", chap.group(2))
    return m
