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
    tagName: tag, innerHTML: '', textContent: '', value: '', disabled: false, _attrs: {}, classList: {
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

console.log(failures ? `\n${failures} check(s) FAILED` : '\nall checks passed');
process.exit(failures ? 1 : 0);
