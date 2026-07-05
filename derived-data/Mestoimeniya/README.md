# Mestoimeniya

_Created: 05-07-2026 · Last updated: 05-07-2026_

"Pronouns" — corpus data on Sanskrit pronoun forms: case/number combinations, cross-pronoun
combination frequencies, and a study of the indefinite pronoun **kaścit** (from
[Wiktionary-style](https://en.wiktionary.org/wiki/kaścit) *ka-* + *-cit*) across gender/case/
number. See the parent [`../README.md`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/README.md)
for how this folder fits into the wider research archive, and
[`../INDEX.md`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/INDEX.md) for the
size/file-count table (12MB / 8 files).

## Data schema

- **[`kaShcid.txt`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Mestoimeniya/kaShcid.txt)**
  — tab/space-delimited rows: `form  frequency  grammaticalTag`, e.g. `kaścit  1470  m.Nom.sg.`,
  `kecit  1248  m.Nom.pl`, `kācit  274  f.Nom.sg.`. Covers the full masculine and (at least
  partially) feminine paradigm of **kaścit** ("someone/a certain") across case × number, with
  raw corpus occurrence counts per form. The file also embeds a stray chat-log line
  (`Виктор Кочергин, [11.05.2024 21:26]`) partway through — evidence this was pasted from a
  Telegram conversation rather than exported programmatically.
- **[`Комбинации местоимений по падежам.xlsx`](<https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Mestoimeniya/Комбинации%20местоимений%20по%20падежам.xlsx>)**
  — "pronoun combinations by case" — not opened (binary); likely a cross-tabulation of which
  pronoun pairs co-occur per grammatical case.
- **[`Общие сведения о комбинациях местоимений 1.xlsx`](<https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Mestoimeniya/Общие%20сведения%20о%20комбинациях%20местоимений%201.xlsx>)**
  — "general data on pronoun combinations" — not opened; likely a summary/overview workbook
  companion to the above.
- **[`распределение 1.xltx`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Mestoimeniya/распределение%201.xltx)**
  — "distribution 1", an Excel **template** (`.xltx`), not opened.
- **[`Pron04012022.htm`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Mestoimeniya/Pron04012022.htm)**,
  **[`pron_rus.htm`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Mestoimeniya/pron_rus.htm)**,
  **[`pronstat.htm`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Mestoimeniya/pronstat.htm)**
  — HTML exports (likely from Excel "Save as Web Page"), not opened; filenames suggest a dated
  pronoun snapshot, a Russian-language pronoun table, and pronoun statistics respectively.
- **[`!Местоимения с Рамаяной.doc`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Mestoimeniya/!Местоимения%20с%20Рамаяной.doc)**
  — "pronouns with the Rāmāyaṇa" — a Word document, not opened; likely a write-up comparing
  general-corpus pronoun usage against the Rāmāyaṇa specifically (cf. the separate
  `Ramayana/` topic folder listed in [`../INDEX.md`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/INDEX.md)).

## Usage example

```python
# kaShcid.txt: form <whitespace> frequency <whitespace> grammatical tag
rows = []
with open("kaShcid.txt", encoding="utf-8") as f:
    for line in f:
        line = line.strip()
        if not line or line.startswith("Виктор") or line.startswith("Местоим"):
            continue  # skip embedded chat-log line and header
        parts = line.split()
        if len(parts) >= 3:
            form, freq, tag = parts[0], parts[1], " ".join(parts[2:])
            rows.append((form, int(freq), tag))
print(rows[:5])
```

## Caveats (observed)

- `kaShcid.txt` has an embedded, non-data line (a Telegram forward header:
  `Виктор Кочергин, [11.05.2024 21:26]`) partway through the file — parse defensively (skip
  lines that don't match the 3-field pattern) rather than assuming uniform rows throughout.
- Most spreadsheet/HTML/Word files in this folder were not opened in this pass — descriptions
  above are inferred from Russian filenames only.

## Provenance

Generating script not found (one targeted repo-wide grep for `Mestoimeniya` turned up no
matching pipeline code). The embedded chat-log fragment in `kaShcid.txt` indicates at least
this file was manually compiled/pasted rather than machine-generated. Part of
[`derived-data/`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/README.md), the
DCS-corpus half of a personal Sanskrit-linguistics research archive. **Not** wired into the
VisualDCS dashboard pipeline (`../src/DCS-data-2021/`, `../src/DCS-data-2026/`) — treat as
reference material to mine for ideas or figures.

_Dr. Mārcis Gasūns_
