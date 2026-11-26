"""Local-only DOC -> TXT conversion for the slovari.ru grammar archives.

antiword handles legacy binary .doc; pandoc only handles .docx. All output
stays under derived/ (gitignored). Reports replacement-character counts so a
font-cmap problem cannot pass silently as clean text.
"""

from __future__ import annotations

import pathlib
import subprocess

root = pathlib.Path(__file__).resolve().parent
out = root / "derived" / "doc"
out.mkdir(parents=True, exist_ok=True)
stats = []
for p in sorted((root / "raw" / "doc").rglob("*.doc")):
    r = subprocess.run(["antiword", "-m", "UTF-8.txt", str(p)], capture_output=True)
    text = r.stdout.decode("utf-8", errors="replace")
    stem = p.stem + "_" + p.parent.name
    (out / (stem + ".txt")).write_text(text, encoding="utf-8")
    stats.append(
        {
            "file": p.relative_to(root).as_posix(),
            "chars": len(text),
            "replacements": text.count("\ufffd"),
            "stderr": r.stderr.decode("utf-8", errors="replace").strip(),
        }
    )
print(
    "files=%d chars=%d replacements=%d"
    % (len(stats), sum(s["chars"] for s in stats), sum(s["replacements"] for s in stats))
)
for s in sorted(stats, key=lambda x: -x["replacements"])[:5]:
    print(s)
