/**
 * Headless render test for sanskrit_collocations.html (roadmap drain A27).
 *
 * Same pattern as test_concordance.js: load the page's script-twin data
 * (visual/coll_data.js, packed by gen_collocations_data.py from the published
 * visual/coll_compact.json), run the page's inline <script> against a minimal DOM
 * stub, then assert on the lemma list, POS/search filters, collocate groups, and the
 * click-through navigation between lemmas that are themselves in the top-800.
 *
 *   node tests/test_collocations.js
 */
'use strict';
const fs = require('fs');
const path = require('path');
const vm = require('vm');
const assert = require('assert');

const REPO = path.resolve(__dirname, '..');
const HTML = path.join(REPO, 'sanskrit_collocations.html');
const TWIN = path.join(REPO, 'visual', 'coll_data.js');
const SRC_JSON = path.join(REPO, 'visual', 'coll_compact.json');

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
const sandbox = { document, console, window: null };
sandbox.window = sandbox;
vm.createContext(sandbox);

const html = fs.readFileSync(HTML, 'utf8');
const scripts = [...html.matchAll(/<script(?![^>]*\bsrc=)[^>]*>([\s\S]*?)<\/script>/g)]
  .map(m => m[1]);
assert.strictEqual(scripts.length, 1, 'expected exactly one inline <script> in the page');

console.log('sanskrit_collocations.html — headless render');

let COLL = null;
check('coll_data.js twin loads and matches the published coll_compact.json', () => {
  vm.runInContext(fs.readFileSync(TWIN, 'utf8'), sandbox, { filename: 'visual/coll_data.js' });
  COLL = sandbox.window.COLL_DATA;
  assert.ok(COLL, 'window.COLL_DATA not set by the twin');
  assert.strictEqual(COLL.lemmaCount, 800, 'twin lemmaCount drifted');
  const src = JSON.parse(fs.readFileSync(SRC_JSON, 'utf8'));
  // JSON round-trip: the twin's objects live in the vm realm, so their prototypes
  // differ from the host realm and deepStrictEqual would fail on that alone.
  const twin = JSON.parse(JSON.stringify(COLL.lemmas));
  assert.deepStrictEqual(twin, src, 'twin lemmas drifted from coll_compact.json');
});

check('the page inline script runs without throwing', () => {
  vm.runInContext(scripts[0], sandbox, { filename: 'sanskrit_collocations.html' });
});

// The page nests its panes inside #app; the stub renders each element separately,
// so the effective output is the concatenation of the three rendered containers.
const out = () => els.app.innerHTML
  + (els.lemmallist ? els.lemmallist.innerHTML : '')
  + (els.detail ? els.detail.innerHTML : '');
const fmt = (n) => n.toLocaleString('ru-RU');

check('stats header shows 800 lemmas and the packed collocate-ref total', () => {
  assert.ok(out().includes(fmt(COLL.lemmaCount)), 'lemma count missing');
  assert.ok(out().includes(fmt(COLL.collocateRefs)), 'collocate refs missing');
  assert.ok(out().includes('n ≥ ' + fmt(COLL.minFreq)), 'min-freq note missing');
});

check('lemma list renders all 800 rows and preselects the first (kṛ)', () => {
  assert.strictEqual((out().match(/class="lemmarow/g) || []).length, 800,
    'expected 800 lemma rows');
  assert.ok(/class="lemmarow sel"/.test(out()), 'no selected row');
  assert.ok(out().includes('>kṛ</span>'), 'first lemma kṛ missing');
});

check('detail panel renders the selected lemma with POS-grouped collocates', () => {
  const e = COLL.lemmas['kṛ'];
  assert.ok(e && e.v.length, 'fixture assumption: kṛ has verb collocates');
  assert.ok(out().includes('Глаголы'), 'verb group heading missing');
  assert.ok(out().includes('Существительные'), 'noun group heading missing');
  assert.ok(out().includes('>' + e.v[0][0] + '</b>'), 'top verb collocate missing');
  assert.ok(out().includes(fmt(e.v[0][1])), 'top verb collocate count missing');
});

check('POS filter narrows the list to the verb slice (300 rows)', () => {
  sandbox.setPos('verb');
  const rows = (out().match(/class="lemmarow/g) || []).length;
  const verbs = Object.values(COLL.lemmas).filter(e => e.pos === 'verb').length;
  assert.strictEqual(rows, verbs, 'verb filter row count wrong');
  sandbox.setPos('all');
});

check('diacritic-insensitive search narrows the list (asju → dakṣiṇa etc.)', () => {
  sandbox.setSearch('daksi');
  const rows = (out().match(/class="lemmarow/g) || []).length;
  assert.ok(rows > 0 && rows < 800, 'search did not narrow the list');
  assert.ok(out().includes('dakṣiṇa'), 'dakṣiṇa not matched by "daksi"');
  sandbox.setSearch('');
});

check('selectLemma navigates between lemmas; goBack returns', () => {
  sandbox.selectLemma(encodeURIComponent('dakṣiṇa'));
  assert.ok(out().includes('>dakṣiṇa</span>'), 'dakṣiṇa detail missing');
  const navTarget = (COLL.lemmas['dakṣiṇa'].nn.find(p => COLL.lemmas[p[0]]) || [])[0];
  assert.ok(navTarget, 'fixture assumption: dakṣiṇa has an in-top-800 noun collocate');
  sandbox.selectLemma(encodeURIComponent(navTarget));
  assert.ok(out().includes('>' + navTarget + '</span>'), 'navigation to collocate failed');
  sandbox.goBack();
  assert.ok(out().includes('>dakṣiṇa</span>'), 'goBack did not restore dakṣiṇa');
});

check('unknown lemma navigation is a no-op', () => {
  const before = out();
  sandbox.selectLemma(encodeURIComponent('zzz-not-a-lemma'));
  assert.strictEqual(out(), before, 'unknown lemma changed the render');
});

check('no NaN/undefined/Infinity leaked into the rendered output', () => {
  assert.ok(!/NaN|undefined|Infinity/.test(out()), 'placeholder artifact found in output');
});

console.log(failures ? `\n${failures} check(s) FAILED` : '\nall checks passed');
process.exit(failures ? 1 : 0);
