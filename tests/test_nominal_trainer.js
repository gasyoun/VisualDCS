/**
 * Headless render test for sanskrit_nominal_trainer.html (H2321).
 * Mirrors tests/test_nominal_dashboard.js: execute the page's inline script
 * against the real generated data and assert the render path works.
 *
 *   node tests/test_nominal_trainer.js
 */
'use strict';
const fs = require('fs');
const path = require('path');
const vm = require('vm');
const assert = require('assert');

const REPO = path.resolve(__dirname, '..');
const HTML = path.join(REPO, 'sanskrit_nominal_trainer.html');
const DATA = path.join(REPO, 'visual', 'paradigm_nominal_lemmas_data.js');

let failures = 0;
function check(name, fn) {
  try { fn(); console.log('  ok   ' + name); }
  catch (e) { failures++; console.log('  FAIL ' + name + '\n       ' + e.message); }
}

function makeEl(tag) {
  return {
    tagName: tag, innerHTML: '', value: '', textContent: '', style: {display:''},
    classList: { _s: new Set(), add(c){this._s.add(c)}, remove(c){this._s.delete(c)},
                 toggle(c,on){ if(on===undefined){ if(this._s.has(c)) this._s.delete(c); else this._s.add(c);} else if(on) this._s.add(c); else this._s.delete(c);} },
    addEventListener() {}, appendChild() {}, click() {},
    setAttribute() {}, getAttribute() { return null; },
  };
}
const els = {};
const document = {
  getElementById: (id) => els[id] || (els[id] = makeEl('div')),
  querySelector: () => makeEl('div'),
  querySelectorAll: () => [],
  createElement: makeEl,
};
const sandbox = {
  window: {}, document, console, Math,
  URL: { createObjectURL: () => 'blob:test' },
};
vm.createContext(sandbox);
vm.runInContext(fs.readFileSync(DATA, 'utf8'), sandbox, { filename: 'paradigm_nominal_lemmas_data.js' });

const html = fs.readFileSync(HTML, 'utf8');
const scripts = [...html.matchAll(/<script(?![^>]*\bsrc=)[^>]*>([\s\S]*?)<\/script>/g)].map(m => m[1]);
assert.strictEqual(scripts.length, 1, 'expected exactly one inline <script>');

console.log('sanskrit_nominal_trainer.html — headless render');

check('inline script runs without throwing', () => {
  vm.runInContext(scripts[0], sandbox, { filename: 'sanskrit_nominal_trainer.html' });
});

const D = sandbox.window.PARADIGM_NOMINAL_LEMMAS;
check('data file loaded', () => {
  assert.ok(D && D.lemmas, 'PARADIGM_NOMINAL_LEMMAS missing');
});
check('admitted lemmas >= top tier', () => {
  assert.ok(D.lemmaCount >= D.tierBoundary, 'lemmaCount ' + D.lemmaCount);
});
check('coverage oracle is G2, not a re-derivation', () => {
  assert.ok(/lemma_cell_coverage/.test(D.source.coverageOracle), D.source.coverageOracle);
});
check('top lemma (deva) has G2 cells and forms', () => {
  // G2 top row is deva lemma_id 86559
  const rec = D.lemmas['86559'];
  assert.ok(rec, 'missing lemma_id 86559 (deva)');
  assert.strictEqual(rec.lemma, 'deva');
  assert.ok(rec.cellsAttested >= 20, 'cellsAttested ' + rec.cellsAttested);
  assert.ok(rec.cells['Nom.Sing'] && rec.cells['Nom.Sing'].length, 'Nom.Sing empty');
  assert.ok(rec.cells['Nom.Sing'][0][1], 'Nom.Sing form missing');
});
check('lemma list rendered something', () => {
  const list = els['lemma-list'];
  assert.ok(list && list.innerHTML.length > 100, 'lemma list empty');
  assert.ok(/deva/.test(list.innerHTML), 'top lemma not in list');
});
check('lemma detail has 8x3 grid', () => {
  const det = els['lemma-detail'];
  assert.ok(det && det.innerHTML.length > 500, 'detail empty');
  assert.ok(/Nom/.test(det.innerHTML) && /Sg/.test(det.innerHTML));
});
check('frequency-weighted deck builds non-empty', () => {
  // `function buildDeck` is a global; `let deck` is not (block-scoped) — assert via DOM side effect
  assert.strictEqual(typeof sandbox.buildDeck, 'function', 'buildDeck not global');
  sandbox.deckScope = 'top';
  sandbox.buildDeck();
  const stats = (els['deck-stats'].textContent || els['deck-stats'].innerHTML || '');
  assert.ok(/карточек/.test(stats), 'deck stats: ' + stats);
  const n = parseInt(stats.replace(/\s/g, '').match(/(\d+)/)[1], 10);
  assert.ok(n > 100, 'deck size from stats ' + n);
});

if (failures) { console.log('\n' + failures + ' failure(s)'); process.exit(1); }
console.log('\nall checks passed');
