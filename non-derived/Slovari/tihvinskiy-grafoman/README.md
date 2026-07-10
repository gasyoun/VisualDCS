# tihvinskiy-grafoman

_Created: 10-07-2026 · Last updated: 10-07-2026_

Materials for the Tikhvinsky–Gustyakov electronic Sanskrit dictionary — a self-published
("grafoman") companion to their monograph *Совершенство (Санскрит)*. Part of
[`non-derived/Slovari/`](https://github.com/gasyoun/VisualDCS/tree/main/non-derived/Slovari);
see [`non-derived/README.md`](https://github.com/gasyoun/VisualDCS/blob/main/non-derived/README.md)
for how this folder fits into the wider archive.

## Contents

| File | What it is |
|---|---|
| [tihvinskiy_slovar_2022_ed4.txt](https://github.com/gasyoun/VisualDCS/blob/main/non-derived/Slovari/tihvinskiy-grafoman/tihvinskiy_slovar_2022_ed4.txt) | The dictionary text itself — see the naming note below for its original title. |
| [Тихвинский В.И., Густяков Ю.М., Руководство к электронному словарю.pdf](https://github.com/gasyoun/VisualDCS/blob/main/non-derived/Slovari/tihvinskiy-grafoman/Тихвинский%20В.И.%2C%20Густяков%20Ю.М.%2C%20Руководство%20к%20электронному%20словарю.pdf) | User guide to the electronic dictionary. |
| [Установка и удаление Словаря.doc](https://github.com/gasyoun/VisualDCS/blob/main/non-derived/Slovari/tihvinskiy-grafoman/Установка%20и%20удаление%20Словаря.doc) | Install/uninstall instructions. |
| [Словарь.dot](https://github.com/gasyoun/VisualDCS/blob/main/non-derived/Slovari/tihvinskiy-grafoman/Словарь.dot) | Word template the dictionary ships with. |
| [Словарь(Расширение базы)1.xls](https://github.com/gasyoun/VisualDCS/blob/main/non-derived/Slovari/tihvinskiy-grafoman/Словарь(Расширение%20базы)1.xls) | Database-extension workbook. |
| `timesTrRu.ttf`, `timesTrans.ttf` | Custom transliteration fonts the dictionary depends on. |

## File naming

`tihvinskiy_slovar_2022_ed4.txt` was renamed from its original filename on 10-07-2026.
The original title, preserved here in full, was:

> Электронный словарь к монографии_ _В.И. Тихвинский, Ю.М. Густяков, संस्कृतं,
> Совершенство(Санскрит), интернет-издание, издание 4-е исправленное и дополненное,
> 02-02-2022_.txt

That name mixed Cyrillic and Devanagari, so it encoded to **308 UTF-8 bytes** — past the
255-byte per-component limit on Linux filesystems. Every GitHub Actions job in this repo
failed at `actions/checkout` with `File name too long` before any lint could run, which
is why the file was renamed. Nothing was deleted, and no content changed. Keep new
filenames in this folder short and ASCII.

_Dr. Mārcis Gasūns_
