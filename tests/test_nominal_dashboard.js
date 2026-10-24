/**
 * Headless render test for sanskrit_nominal_dashboard.html (H1472).
 *
 * The repo's dashboards are standalone, dependency-free pages with all JS inline, so
 * there is no bundler or test runner to hook into. This test loads the page's local
 * data <script src> files and executes every inline <script> against a minimal DOM stub
 * with the REAL generated data, then asserts on the HTML it produces. It catches what a
 * JSON-schema check cannot: a runtime error in the render path, a field the page reads
 * but the generator never writes, and a silently empty grid.
 *
 * H5741 (03-10-2026) added a SECOND inline <script> — the class-split panel — so the old
 * "exactly one inline <script>" contract went red and stayed red because no workflow ran
 * this file. Both panels are covered now: the test loads every local data script the page
 * references and asserts the class-split panel renders from its own data file.
 *
 *   node tests/test_nominal_dashboard.js
 */
'use strict';
const fs = require('fs');
const path = require('path');
const vm = require('vm');
const assert = require('assert');

const REPO = path.resolve(__dirname, '..');
const HTML = path.join(REPO, 'sanskrit_nominal_dashboard.html');

let failures = 0;
function check(name, fn) {
  try { fn(); console.log('  ok   ' + name); }
  catch (e) { failures++; console.log('  FAIL ' + name + '\n       ' + e.message); }
}

// --- minimal DOM stub -------------------------------------------------------------
function makeEl(tag) {
  return {
    tagName: tag, innerHTML: '', value: '', disabled: false, _attrs: {},
    addEventListener() {}, appendChild() {}, scrollIntoView() {},
    setAttribute(k, v) { this._attrs[k] = v; },
    getAttribute(k) { return this._attrs[k]; },
  };
}
const els = { app: makeEl('div'), detail: makeEl('div'), clsSel: makeEl('select') };
const document = {
  getElementById: (id) => els[id] || (els[id] = makeEl('div')),
  querySelector: () => makeEl('div'),
  querySelectorAll: () => [],
  createElement: makeEl,
};

const sandbox = { window: {}, document, console };
vm.createContext(sandbox);

// Load the page the way a browser does: its local data <script src> files in page
// order, then every inline <script> in page order. Asserting on "exactly one inline
// script" is what broke on H5741; the contract is "every panel renders", not the count.
const html = fs.readFileSync(HTML, 'utf8');
const localSrcs = [...html.matchAll(/<script[^>]*\bsrc="([^"]+)"/g)]
  .map(m => m[1])
  .filter(src => !/^(https?:)?\/\//.test(src));
const inlineScripts = [...html.matchAll(/<script(?![^>]*\bsrc=)[^>]*>([\s\S]*?)<\/script>/g)]
  .map(m => m[1]);
assert.ok(localSrcs.length >= 1, 'the page carries at least one local data script');
assert.ok(inlineScripts.length >= 1, 'the page carries at least one inline <script>');
for (const src of localSrcs) {
  const p = path.join(REPO, src);
  assert.ok(fs.existsSync(p), 'missing local data script: ' + src);
  vm.runInContext(fs.readFileSync(p, 'utf8'), sandbox, { filename: src });
}

console.log('sanskrit_nominal_dashboard.html — headless render');

check('every inline script runs without throwing', () => {
  inlineScripts.forEach((code, i) =>
    vm.runInContext(code, sandbox, { filename: 'inline#' + i }));
});

const out = els.app.innerHTML;
const splitOut = els.classsplitApp ? els.classsplitApp.innerHTML : '';
const D = sandbox.window.PARADIGM_NOMINAL;

check('the class-split panel rendered from its own data file', () => {
  assert.ok(sandbox.window.NOMINAL_CLASS_SPLIT_ADJ,
    'visual/paradigm_nominal_class_split_adj_data.js did not run');
  assert.ok(splitOut.length > 1000,
    'class-split panel rendered only ' + splitOut.length + ' chars');
  assert.ok(!/Данные не загрузились/.test(splitOut),
    'class-split panel fell back to its no-data message');
});
check('the class-split trust block is present', () => {
  assert.ok(/Доверие к данным/.test(splitOut), 'class-split trust block missing');
});

check('it rendered something substantial', () => {
  assert.ok(out.length > 5000, 'rendered only ' + out.length + ' chars');
});
check('the data file was actually consumed (no fallback error state)', () => {
  assert.ok(!/Данные не загрузились/.test(out), 'page fell back to its no-data message');
});
check('the 8 x 3 grid is populated, not empty', () => {
  const cells = (out.match(/class="cell"/g) || []).length;
  assert.ok(cells >= 20, 'only ' + cells + ' populated cells in the default class');
});
check('every case row and number column is present', () => {
  D.cases.forEach(c => assert.ok(out.includes(c), 'missing case ' + c));
  assert.ok(/Sg · ед\./.test(out) && /Du · дв\./.test(out) && /Pl · мн\./.test(out));
});
// Digit grouping is compared with every kind of space folded to a plain one: the page
// formats through toLocaleString('ru-RU'), whose separator is U+00A0, so asserting on the
// exact code point fails on a formatting detail rather than on the thing this guards --
// that the number reaches the page at all.
const flat = (s) => String(s).replace(/\s+/g, ' ');
const outFlat = flat(out);
const shown = (n) => flat(n.toLocaleString('ru-RU'));

check('the Cpd exclusion is stated on the page, not silently dropped', () => {
  assert.ok(/без падежа/.test(out), 'no statement that compound members carry no case');
  assert.ok(outFlat.includes(shown(D.totals.cpdTokens)),
    'the Cpd token count is not displayed');
});
check('the grid and universe denominators are both printed on the page', () => {
  assert.ok(outFlat.includes(shown(D.totals.gridTokens)), 'grid total not displayed');
  assert.ok(outFlat.includes(shown(D.totals.nominalUniverseTokens)),
    'the closing NOUN/ADJ universe total not displayed');
});
check('the class-is-a-heuristic caveat is on the page', () => {
  assert.ok(/эвристика/.test(out), 'the heuristic caveat is missing from the rendered page');
});
check('the reconstructed-unsandhied share is disclosed', () => {
  assert.ok(/m_unsandhiedreconstructed/.test(out), 'reconstruction caveat missing');
});

// --- data contract the page depends on --------------------------------------------
console.log('visual/paradigm_nominal.json — contract the page reads');

check('top-level fields the page reads all exist', () => {
  ['cases', 'numbers', 'classes', 'totals', 'source', 'corpusRelease'].forEach(k =>
    assert.ok(D[k] !== undefined, 'missing ' + k));
  ['gridTokens', 'cpdTokens', 'lemmaIds', 'nominalUniverseTokens',
   'unplaceableTokens', 'reconstructedUnsandhiedTokens'].forEach(k =>
    assert.ok(typeof D.totals[k] === 'number', 'missing totals.' + k));
});
check('denominators close (grid + Cpd + unplaceable = the nominal universe)', () => {
  assert.strictEqual(D.totals.gridTokens + D.totals.cpdTokens + D.totals.unplaceableTokens,
    D.totals.nominalUniverseTokens);
});
check('every class carries the fields the page renders', () => {
  Object.entries(D.classes).forEach(([k, c]) => {
    ['label', 'exemplar', 'note', 'n', 'lemmas', 'upos', 'cpdTokens', 'genders'].forEach(f =>
      assert.ok(c[f] !== undefined, k + ' missing ' + f));
    assert.ok(Object.keys(c.genders).length > 0, k + ' has no gender bucket');
  });
});
check('every cell carries n / forms / endings / examples / segmentable', () => {
  Object.entries(D.classes).forEach(([k, c]) =>
    Object.entries(c.genders).forEach(([g, gd]) =>
      Object.entries(gd.cells).forEach(([cell, cd]) => {
        ['n', 'lemmas', 'segmentable'].forEach(f =>
          assert.ok(typeof cd[f] === 'number', `${k}/${g}/${cell} missing ${f}`));
        ['forms', 'endings', 'examples'].forEach(f =>
          assert.ok(Array.isArray(cd[f]), `${k}/${g}/${cell} missing ${f}`));
      })));
});
check('cell token counts sum to the gender total, and gender totals to the class', () => {
  Object.entries(D.classes).forEach(([k, c]) => {
    let clsSum = 0;
    Object.entries(c.genders).forEach(([g, gd]) => {
      const sum = Object.values(gd.cells).reduce((a, cd) => a + cd.n, 0);
      assert.strictEqual(sum, gd.n, `${k}/${g}: cells ${sum} != gender ${gd.n}`);
      clsSum += gd.n;
    });
    assert.strictEqual(clsSum, c.n, `${k}: genders ${clsSum} != class ${c.n}`);
  });
});
check('class totals sum to the grid total', () => {
  const sum = Object.values(D.classes).reduce((a, c) => a + c.n, 0);
  assert.strictEqual(sum, D.totals.gridTokens);
});
check('segmentable never exceeds the cell it belongs to', () => {
  Object.entries(D.classes).forEach(([k, c]) =>
    Object.entries(c.genders).forEach(([g, gd]) =>
      Object.entries(gd.cells).forEach(([cell, cd]) =>
        assert.ok(cd.segmentable <= cd.n, `${k}/${g}/${cell} segmentable > n`))));
});
check('no cell is keyed outside the declared 8 x 3 matrix', () => {
  const valid = new Set(D.cellsOrder);
  Object.entries(D.classes).forEach(([k, c]) =>
    Object.entries(c.genders).forEach(([g, gd]) =>
      Object.keys(gd.cells).forEach(cell =>
        assert.ok(valid.has(cell), `${k}/${g}: stray cell ${cell}`))));
});
check('the class heuristic is flagged in the data, not only in the prose', () => {
  assert.strictEqual(D.classIsHeuristic, true);
  assert.ok(D.ceilingNote && D.ceilingNote.length > 400, 'ceilingNote missing or stubbed');
});
check('the -ant class exists and is marked as the H1472 extension', () => {
  assert.ok(D.classes.ant, 'no -ant class');
  assert.strictEqual(D.classes.ant.extendsG2, true);
  assert.ok(D.classes.ant.n > 0);
});
check('the snapshot is pinned (provenance + checksum), per the G2 C3 contract', () => {
  assert.ok(D.source.sourceCommit, 'no source commit pin');
  assert.ok(D.source.sha256 && D.source.sha256 !== 'skipped',
    'the committed asset must carry a real SHA-256, not "skipped"');
});
check('examples reference a real form of their own cell', () => {
  let seen = 0;
  Object.values(D.classes).forEach(c =>
    Object.values(c.genders).forEach(gd =>
      Object.values(gd.cells).forEach(cd => {
        const forms = new Set(cd.forms.map(f => f[1]));
        cd.examples.forEach(ex => {
          seen++;
          assert.ok(forms.has(ex.form), 'example form not among the cell forms: ' + ex.form);
          assert.ok(ex.sent && ex.sent.length > 0, 'empty example sentence');
        });
      })));
  assert.ok(seen > 500, 'only ' + seen + ' examples across the whole asset');
});

console.log(failures ? `\n${failures} check(s) FAILED` : '\nall checks passed');
process.exit(failures ? 1 : 0);
