/**
 * Headless render test for sanskrit_paradigm_builder.html (roadmap drain A27).
 *
 * Same pattern as test_morphostatistics.js / test_concordance.js: extract the page's
 * inline <script>s and run them against a minimal DOM stub. This page has TWO inline
 * scripts: the first embeds a verbatim copy of visual/paradigm_endings.json, the second
 * renders the heat map + person x number grids. The data copy is checked byte-deep
 * against the published JSON asset so the two cannot silently drift.
 *
 *   node tests/test_paradigm_builder.js
 */
'use strict';
const fs = require('fs');
const path = require('path');
const vm = require('vm');
const assert = require('assert');

const REPO = path.resolve(__dirname, '..');
const HTML = path.join(REPO, 'sanskrit_paradigm_builder.html');
const JSON_SRC = path.join(REPO, 'visual', 'paradigm_endings.json');

let failures = 0;
function check(name, fn) {
  try { fn(); console.log('  ok   ' + name); }
  catch (e) { failures++; console.log('  FAIL ' + name + '\n       ' + e.message); }
}

// --- minimal DOM stub -------------------------------------------------------------
function makeEl(tag) {
  return { tagName: tag, innerHTML: '', textContent: '', _attrs: {},
    setAttribute(k, v) { this._attrs[k] = v; },
    getAttribute(k) { return this._attrs[k]; } };
}
const els = { app: makeEl('div') };
const document = { getElementById: (id) => els[id] || (els[id] = makeEl('div')) };
const sandbox = { document, console };
vm.createContext(sandbox);

const html = fs.readFileSync(HTML, 'utf8');
const scripts = [...html.matchAll(/<script(?![^>]*\bsrc=)[^>]*>([\s\S]*?)<\/script>/g)]
  .map(m => m[1]);
assert.strictEqual(scripts.length, 2, 'expected exactly two inline <script>s (data + app)');

const published = JSON.parse(fs.readFileSync(JSON_SRC, 'utf8'));

console.log('sanskrit_paradigm_builder.html — headless render');

check('embedded ENDINGS_DATA is a verbatim copy of visual/paradigm_endings.json', () => {
  const m = scripts[0].match(/var ENDINGS_DATA = ([\s\S]*?);\s*$/);
  assert.ok(m, 'ENDINGS_DATA assignment not found in the data script');
  const embedded = JSON.parse(m[1]);
  assert.deepStrictEqual(embedded, published, 'embedded data drifted from the JSON asset');
});

check('the app script runs without throwing', () => {
  // Run both inline scripts in the same context: the data script defines
  // ENDINGS_DATA, the app script renders into #app.
  vm.runInContext(scripts[0], sandbox, { filename: 'sanskrit_paradigm_builder.html#data' });
  vm.runInContext(scripts[1], sandbox, { filename: 'sanskrit_paradigm_builder.html#app' });
});

const out = () => els.app.innerHTML;

check('two heat strips (category A + category B) render all 25 categories twice', () => {
  assert.strictEqual((out().match(/class="heatrow"/g) || []).length, 2, 'expected 2 heat strips');
  assert.strictEqual((out().match(/class="heat[ "]/g) || []).length, 50,
    'expected 25 chips per strip');
});

check('initial category A is the top-pct one (Present Ind.) and its grid renders', () => {
  const cats = Object.entries(published).sort((a, b) => b[1].pct - a[1].pct);
  assert.strictEqual(cats[0][0], 'Present Ind.', 'fixture assumption changed');
  assert.ok(out().includes('>Present Ind.<'), 'category A name missing');
  assert.ok(out().includes(cats[0][1].pct + '%'), 'pct label missing');
  assert.ok(out().includes('Сетка категории A'), 'single-grid heading missing');
  assert.ok((out().match(/class="pgrid"/g) || []).length === 1, 'expected exactly 1 grid');
  ['ед.', 'дв.', 'мн.'].forEach(n => assert.ok(out().includes(n), `number row ${n} missing`));
});

check('selectA/selectB build a two-grid comparison and B toggles off again', () => {
  sandbox.selectA(encodeURIComponent('Perfect Ind.'));
  sandbox.selectB(encodeURIComponent('Imperfect ind'));
  assert.ok(out().includes('Сравнение: Perfect Ind. vs Imperfect ind'),
    'comparison heading missing');
  assert.strictEqual((out().match(/class="gridbox"/g) || []).length, 2, 'expected 2 grid boxes');
  assert.strictEqual((out().match(/class="pgrid"/g) || []).length, 2, 'expected 2 grids');
  sandbox.selectB(encodeURIComponent('Imperfect ind'));
  assert.ok(!out().includes('Сравнение:'), 'B did not toggle off');
  assert.strictEqual((out().match(/class="pgrid"/g) || []).length, 1, 'expected 1 grid again');
});

check('grid cells show attested endings with counts formatted like the app formats them', () => {
  sandbox.selectA(encodeURIComponent('Present Ind.')); // reset from the comparison check above
  // Present Ind. 3sg top entry from the published asset, rendered by the app itself.
  const cell = published['Present Ind.'].sg['3'][0];
  const fmt = cell[0].toLocaleString('ru-RU');
  assert.ok(out().includes('>' + cell[1] + '</span>'), 'top ending text missing');
  assert.ok(out().includes(fmt), 'count not rendered with the app formatting: ' + fmt);
});

check('per-category cell totals (Σ ячеек) match a recomputation from the data', () => {
  const total = ['sg', 'du', 'pl'].reduce((acc, g) => acc + ['1', '2', '3'].reduce((a2, n) =>
    a2 + published['Present Ind.'][g][n].reduce((a3, pair) => a3 + pair[0], 0), 0), 0);
  assert.ok(out().includes(total.toLocaleString('ru-RU')),
    'Σ ячеек total missing: ' + total);
});

check('coverage stat states the pct sum over the embedded categories', () => {
  const sum = Object.values(published).reduce((a, e) => a + e.pct, 0).toFixed(1);
  assert.ok(out().includes(sum + '%'), 'pct sum label missing: ' + sum + '%');
});

check('no NaN/undefined/Infinity leaked into the rendered output', () => {
  assert.ok(!/NaN|undefined|Infinity/.test(out()), 'placeholder artifact found in output');
});

console.log(failures ? `\n${failures} check(s) FAILED` : '\nall checks passed');
process.exit(failures ? 1 : 0);
