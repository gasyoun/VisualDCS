"""Convert the publisher's two TTFs to WOFF2 for the static HTML edition.

Both source fonts have proper Unicode cmaps (checked with fontTools): this is
typographic fidelity, not an encoding fix — the harvested text is Unicode.
"""

from __future__ import annotations

import pathlib
from fontTools.ttLib import TTFont

root = pathlib.Path(__file__).resolve().parent
src = root / "raw" / "fonts" / "FONT"
dst = root / "html" / "fonts"
dst.mkdir(parents=True, exist_ok=True)
for p in sorted(src.glob("*.ttf")):
    out = dst / (p.stem + ".woff2")
    font = TTFont(p)
    font.flavor = "woff2"
    font.save(out)
    print(out.relative_to(root).as_posix(), out.stat().st_size, "bytes")
