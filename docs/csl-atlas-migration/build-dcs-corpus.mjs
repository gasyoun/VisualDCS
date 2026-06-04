// Build the DCS corpus manifest + grammar-category distribution (Phase 3b).
//
// Per docs/DCS_SCHEMA.md, the local DCS export is REFERENCE DATA, not a
// passage-level corpus: a 189-text abbreviation list, a short bibliography, and
// a 78k word -> grammar-category list. This build produces the text inventory
// (UC-CG-01) and the aggregate grammar-category distribution. It does NOT build
// CorpusOccurrence / passage dashboards — those need the full corpus.
//
// Usage: npm run build-dcs-corpus. No LLM inference.

import fs from "node:fs";
import path from "node:path";
import { pathToFileURL } from "node:url";

const SCHEMA_VERSION = "1.0.0";
const DCS_DIR = path.resolve(process.cwd(), "..", "DCS");
const ABBREV = path.join(DCS_DIR, "DCS-abbreviation-list.txt");
const BIBLIO = path.join(DCS_DIR, "DCS-Corpus-Bibliography");
const GRAM_CSV = path.join(DCS_DIR, "DCS-72034-gramm-tag-stats.csv");
const OUT = path.resolve(process.cwd(), "src", "data", "corpus", "dcs-manifest.json");

export function classifyGram(g) {
  const v = (g || "").trim();
  if (v === "") return "unspecified";
  if (["m", "f", "n", "mn", "mf", "fn", "nm", "nf"].includes(v)) return "nominal";
  if (v === "adj") return "adjectival";
  if (v === "ind") return "indeclinable";
  if (/^\d+\.|Denom|Caus|Desid|Intens|\bP\.|\bĀ\.|\?\./.test(v)) return "verbal";
  return "other";
}

function readTexts(warnings) {
  if (!fs.existsSync(ABBREV)) {
    warnings.push(`Missing ${path.relative(process.cwd(), ABBREV)}`);
    return [];
  }
  const lines = fs.readFileSync(ABBREV, "utf8").split(/\r?\n/);
  const texts = [];
  for (const line of lines) {
    if (!line.includes("\t")) continue; // skip the header line and blanks
    const [title, code] = line.split("\t");
    if (title && code) texts.push({ code: code.trim(), title: title.trim() });
  }
  return texts;
}

function enrichFromBibliography(texts, warnings) {
  if (!fs.existsSync(BIBLIO)) {
    warnings.push(`Missing ${path.relative(process.cwd(), BIBLIO)}; manifest not enriched.`);
    return 0;
  }
  const text = fs.readFileSync(BIBLIO, "utf8");
  const byCode = new Map(texts.map(t => [t.code, t]));
  let enriched = 0;
  // entries look like: "Title Year — (= CODE) full citation."
  for (const para of text.split(/\n\s*\n/)) {
    const m = para.match(/\(=\s*([^)]+)\)\s*(.+)/s);
    if (!m) continue;
    const code = m[1].trim();
    const citation = m[2].replace(/\s+/g, " ").trim();
    const t = byCode.get(code);
    if (t && !t.citation) {
      t.citation = citation;
      enriched += 1;
    }
  }
  return enriched;
}

function readGrammar(warnings) {
  if (!fs.existsSync(GRAM_CSV)) {
    warnings.push(`Missing ${path.relative(process.cwd(), GRAM_CSV)}`);
    return { totalWords: 0, byGroup: {}, categories: [] };
  }
  const lines = fs.readFileSync(GRAM_CSV, "utf8").split(/\r?\n/);
  const catCounts = new Map();
  const groupCounts = new Map();
  let totalWords = 0;
  let lossyWords = 0;
  for (let i = 1; i < lines.length; i++) {
    const line = lines[i];
    if (!line) continue;
    const parts = line.split(";");
    if (parts.length < 3) continue;
    const word = parts[1].trim();
    const gram = parts[2].trim();
    totalWords += 1;
    if (word.includes("?")) lossyWords += 1;
    catCounts.set(gram, (catCounts.get(gram) || 0) + 1);
    const group = classifyGram(gram);
    groupCounts.set(group, (groupCounts.get(group) || 0) + 1);
  }
  const categories = [...catCounts.entries()]
    .map(([gram, count]) => ({ gram: gram || "(blank)", count, group: classifyGram(gram) }))
    .sort((a, b) => b.count - a.count);
  return {
    totalWords,
    lossyWords,
    byGroup: Object.fromEntries([...groupCounts.entries()].sort((a, b) => b[1] - a[1])),
    categories
  };
}

function main() {
  if (!fs.existsSync(DCS_DIR)) {
    console.error(`Missing DCS export at ${DCS_DIR}. See docs/DCS_SCHEMA.md.`);
    process.exit(1);
  }
  fs.mkdirSync(path.dirname(OUT), { recursive: true });
  const warnings = [];

  const texts = readTexts(warnings).sort((a, b) => a.code.localeCompare(b.code));
  const enriched = enrichFromBibliography(texts, warnings);
  const grammar = readGrammar(warnings);

  if (grammar.lossyWords) {
    warnings.push(`${grammar.lossyWords} of ${grammar.totalWords} CSV words contain '?' (diacritic loss); excluded from any future SLP1 join.`);
  }

  const payload = {
    schemaVersion: SCHEMA_VERSION,
    generatedAt: new Date().toISOString(),
    corpusId: "dcs",
    sourcePath: "../DCS/",
    textCount: texts.length,
    textsEnrichedFromBibliography: enriched,
    texts,
    wordGrammar: grammar,
    assumptions: [
      "The DCS export is reference data, not a passage-level corpus (see docs/DCS_SCHEMA.md): a text inventory, a bibliography, and a word -> grammar-category list.",
      "texts come from DCS-abbreviation-list.txt (title -> DCS code); a few are enriched with bibliographic detail.",
      "wordGrammar is the aggregate distribution of the 78k DCS words by grammar category; it has no passages, frequency, or period.",
      "No CorpusOccurrence, lemma-frequency-by-text, or genre/period grammar is produced — those need the full DCS corpus."
    ],
    warnings
  };

  fs.writeFileSync(OUT, `${JSON.stringify(payload, null, 2)}\n`);
  console.log(`Wrote DCS manifest: ${texts.length} texts (${enriched} enriched), ${grammar.totalWords} words, ${grammar.categories.length} grammar categories.`);
  console.log(`- ${path.relative(process.cwd(), OUT)}`);
  if (warnings.length) for (const w of warnings) console.log(`  ! ${w}`);
}

// Run only when executed directly, not when imported by tests.
if (import.meta.url === pathToFileURL(process.argv[1]).href) main();
