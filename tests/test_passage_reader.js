/**
 * Headless render test for sanskrit_passage_reader.html (H1537).
 *
 * Same pattern as test_concordance.js / test_nominal_dashboard.js: extract the page's
 * own inline <script> (data is embedded inline here, no companion data file) and run
 * it against a minimal DOM stub, then assert on the filtering / highlighting behaviour
 * it produces.
 *
 *   node tests/test_passage_reader.js
 */
'use strict';
const fs = require('fs');
const path = require('path');
const vm = require('vm');
const assert = require('assert');

const REPO = path.resolve(__dirname, '..');
const HTML = path.join(REPO, 'sanskrit_passage_reader.html');

let failures = 0;
function check(name, fn) {
  try { fn(); console.log('  ok   ' + name); }
  catch (e) { failures++; console.log('  FAIL ' + name + '\n       ' + e.message); }
}

// --- minimal DOM stub -------------------------------------------------------------
function makeEl(tag) {
  return {
    tagName: tag, innerHTML: '', textContent: '', value: '', disabled: false, style: {}, _attrs: {}, classList: {
      _set: new Set(),
      add(c) { this._set.add(c); }, remove(c) { this._set.delete(c); }, contains(c) { return this._set.has(c); },
    },
    addEventListener() {}, appendChild() {},
    setAttribute(k, v) { this._attrs[k] = v; },
    getAttribute(k) { return this._attrs[k]; },
  };
}
const els = { hdrnote: makeEl('div'), list: makeEl('div'), 'count-note': makeEl('span') };
const document = {
  getElementById: (id) => els[id] || (els[id] = makeEl('div')),
  querySelector: () => makeEl('div'),
  querySelectorAll: () => [],
  createElement: makeEl,
};

const sandbox = { window: {}, document, console };
vm.createContext(sandbox);

const html = fs.readFileSync(HTML, 'utf8');
const scripts = [...html.matchAll(/<script(?![^>]*\bsrc=)[^>]*>([\s\S]*?)<\/script>/g)].map(m => m[1]);
assert.strictEqual(scripts.length, 1, 'expected exactly one inline <script> in the page');

// top-level `const` in a vm script is scoped to that script, not exposed on the sandbox
// object, so pull PASSAGES/VF straight out of the source text for expected-value checks.
const dataMatch = html.match(/const PASSAGES = (\[[\s\S]*?\]);\s*\nconst VF = (\{[\s\S]*?\});\s*\nconst VF_MAX = (\d+);/);
assert.ok(dataMatch, 'could not locate embedded PASSAGES/VF data in the page');
const PASSAGES = JSON.parse(dataMatch[1]);
const VF = JSON.parse(dataMatch[2]);

console.log('sanskrit_passage_reader.html — headless render');

check('the page\'s inline script runs without throwing', () => {
  vm.runInContext(scripts[0], sandbox, { filename: 'sanskrit_passage_reader.html' });
});

check('40 curated passages are embedded', () => {
  assert.strictEqual(PASSAGES.length, 40, 'expected 40 passages');
});

check('header states the passage count and matched verb-form count', () => {
  assert.ok(els.hdrnote.innerHTML.includes('40'), 'passage count not displayed');
  assert.ok(els.hdrnote.innerHTML.includes(String(Object.keys(VF).length)), 'verb-form count not displayed');
});

check('unfiltered render lists all 40 passages and colour-codes verb forms', () => {
  assert.ok(els.list.innerHTML.includes('class="card"'), 'no passage cards rendered');
  assert.ok((els.list.innerHTML.match(/class="card"/g) || []).length === 40, 'expected 40 cards');
  assert.ok(/class="vf" style="background:rgb\(/.test(els.list.innerHTML), 'no colour-coded verb forms rendered');
  assert.ok(els['count-note'].textContent.includes('40 из 40'), 'count note wrong for unfiltered view');
});

check('a high-frequency verb form gets a tooltip with root/tense/count', () => {
  assert.ok(/title="√vac · Perfect · 12.?986/.test(els.list.innerHTML), 'expected uvāca tooltip not found');
});

check('genre filter narrows the list', () => {
  sandbox.setGenre('Philosophy', makeEl('button'));
  const philCount = PASSAGES.filter(p => p.genre === 'Philosophy').length;
  assert.ok((els.list.innerHTML.match(/class="card"/g) || []).length === philCount, 'genre filter did not narrow correctly');
  assert.ok(els['count-note'].textContent.includes(`${philCount} из 40`), 'count note wrong after genre filter');
  sandbox.setGenre('all', makeEl('button'));
});

check('difficulty filter narrows the list', () => {
  sandbox.setDiff(1, makeEl('button'));
  const d1Count = PASSAGES.filter(p => p.diff === 1).length;
  assert.ok((els.list.innerHTML.match(/class="card"/g) || []).length === d1Count, 'difficulty filter did not narrow correctly');
  sandbox.setDiff('all', makeEl('button'));
});

check('genre and difficulty filters combine (AND, not OR)', () => {
  sandbox.setGenre('Narrative Prose', makeEl('button'));
  sandbox.setDiff(1, makeEl('button'));
  const expected = PASSAGES.filter(p => p.genre === 'Narrative Prose' && p.diff === 1).length;
  assert.ok((els.list.innerHTML.match(/class="card"/g) || []).length === expected, 'combined filter mismatch');
  sandbox.setGenre('all', makeEl('button'));
  sandbox.setDiff('all', makeEl('button'));
});

check('the in-page note excludes freeform IAST input as unbuilt', () => {
  assert.ok(/произвольного[\s\S]*IAST/.test(html), 'freeform-IAST-unbuilt note not found in page');
});

// --- deep link from the paradigm contexts panel (roadmap «панель контекстов → пассаж в D3») ---
// Independent oracle: exact word-form token match (same policy the page documents).
const TOKEN_RE = /[A-Za-zāĀīĪūŪṛṚṝṜḷḶḹḸṃṂḥḤśŚṣṢṭṬḍḌṇṆñÑṅṄ']+/g;
function passagesWith(form) {
  const f = form.toLowerCase();
  return PASSAGES.filter(p => (p.txt.toLowerCase().match(TOKEN_RE) || []).indexOf(f) !== -1);
}
function cardCount() {
  return (els.list.innerHTML.match(/class="card"/g) || []).length;
}

check('seam: sanskrit_pxn_v4.html context panel links to this page with ?form=', () => {
  const pxn = fs.readFileSync(path.join(REPO, 'sanskrit_pxn_v4.html'), 'utf8');
  assert.ok(pxn.includes('sanskrit_passage_reader.html?form='), 'pxn_v4 context panel emits no ?form= deep link');
  assert.ok(pxn.includes("encodeURIComponent(form)"), 'pxn_v4 deep link does not URL-encode the form');
});

check('parseFormParam reads ?form= and tolerates junk', () => {
  assert.strictEqual(sandbox.parseFormParam('?form=kuru'), 'kuru');
  assert.strictEqual(sandbox.parseFormParam('?form=%C4%81sa'), 'āsa');
  assert.strictEqual(sandbox.parseFormParam('?genre=Epic&form=kuru'), 'kuru');
  assert.strictEqual(sandbox.parseFormParam(''), null, 'empty search must not deep-link');
  assert.strictEqual(sandbox.parseFormParam('?x=1'), null, 'no form param must not deep-link');
  assert.strictEqual(sandbox.parseFormParam('?form='), null, 'empty form value must not deep-link');
});

check('applyFormFilter narrows to passages containing the form and marks matches', () => {
  sandbox.applyFormFilter('kuru');
  const expected = passagesWith('kuru').length;
  assert.ok(expected > 0 && expected < PASSAGES.length, 'kuru oracle count is degenerate — fix the oracle');
  assert.strictEqual(cardCount(), expected, 'form filter did not narrow to matching passages');
  assert.ok(els['form-note'].innerHTML.includes('kuru'), 'form note does not name the form');
  assert.ok(els['form-note'].innerHTML.includes(`${expected} из ${PASSAGES.length}`), 'form note count wrong');
  assert.ok(/class="vf fm"/.test(els.list.innerHTML), 'matched verb form not outlined (vf fm)');
});

check('a matched non-verb form is outlined without a frequency tooltip', () => {
  // first token present in some passage but not a VF-keyed verb form
  let probe = null;
  for (const p of PASSAGES) {
    for (const t of (p.txt.toLowerCase().match(TOKEN_RE) || [])) {
      if (!VF[t] && !passagesWith(t).length) continue;
      if (!VF[t] && t.length > 4) { probe = t; break; }
    }
    if (probe) break;
  }
  assert.ok(probe, 'no non-verb passage token found for the probe');
  sandbox.applyFormFilter(probe);
  const expected = passagesWith(probe).length;
  assert.strictEqual(cardCount(), expected, 'non-verb form filter did not narrow correctly');
  assert.ok(/class="fm"/.test(els.list.innerHTML), 'non-verb matched form not outlined');
});

check('clearFormFilter restores the full unfiltered list', () => {
  sandbox.clearFormFilter();
  assert.strictEqual(cardCount(), PASSAGES.length, 'reset did not restore all 40 passages');
  assert.strictEqual(els['form-note'].style.display, 'none', 'form note still visible after reset');
  assert.ok(!els.list.innerHTML.includes('class="fm"'), 'match outline leaked after reset');
});

console.log(failures ? `\n${failures} check(s) FAILED` : '\nall checks passed');
process.exit(failures ? 1 : 0);
