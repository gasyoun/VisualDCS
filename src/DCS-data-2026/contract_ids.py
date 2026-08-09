"""Shared stable-ID helper for the v1 learner-contract packagers (H2481).

Implements the ID grammar from
docs/ARCHITECTURE_VISUALDCS_SYSTEMA_LEARNER_CONTRACTS.md:

    vdcs:v1:verb:<root-id>:<cell-id>
    vdcs:v1:nominal:<lemma-id>:<case-number-cell>
    vdcs:v1:passage:<text-id>:<passage-id>

IDs are opaque to the UI but readable in evidence. Display labels,
transliteration, rank and frequency may change without changing identity.
Do not recompute these once a release has shipped a given source key --
that would break the identity contract this module exists to protect.
"""
import re

_SLUG_RE = re.compile(r"[^a-z0-9]+")


def slug(text: str) -> str:
    """Stable lowercase-dash slug for embedding a display-ish name inside an
    opaque v1 ID. Not reversible and not intended to be -- identity comes
    from the source key, not from the slug."""
    return _SLUG_RE.sub("-", text.strip().lower()).strip("-")


def verb_cell_id(root_id: str, category: str, number: str = "", person: str = "") -> str:
    """A verb paradigm cell. Finite cells carry number+person; nonfinite
    (participle etc.) categories do not."""
    parts = [slug(category)]
    if number:
        parts.append(number)
    if person:
        parts.append(person)
    cell = ".".join(parts)
    return f"vdcs:v1:verb:{root_id}:{cell}"


def nominal_cell_id(lemma_id: str, cell_name: str) -> str:
    """A nominal paradigm cell, e.g. cell_name='Nom.Sing'."""
    return f"vdcs:v1:nominal:{lemma_id}:{slug(cell_name)}"


def passage_id(text_title: str, passage_source_id) -> str:
    """A curated concordance passage. text_title is the passage_library.json
    'title' field; passage_source_id is its 'id' field (stable within the
    source file)."""
    return f"vdcs:v1:passage:{slug(text_title)}:{passage_source_id}"
