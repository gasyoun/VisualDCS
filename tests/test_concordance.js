/**
 * Headless render test for sanskrit_concordance.html (H1505).
 *
 * Same pattern as test_nominal_dashboard.js: extract the page's own inline <script>
 * and run it against a minimal DOM stub with the REAL generated data
 * (visual/conc_data.js), then assert on the search behaviour it produces.
 *
 *   node tests/test_concordance.js
 */
'use strict';
const fs = require('fs');
const path = require('path');
const vm = require('vm');
const assert = require('assert');

const REPO = path.resolve(__dirname, '..');
const HTML = path.join(REPO, 'sanskrit_concordance.html');
const DATA = path.join(REPO, 'visual', 'conc_data.js');

let failures = 0;
function check(name, fn) {
  try { fn(); console.log('  ok   ' + name); }
  catch (e) { failures++; console.log('  FAIL ' + name + '\n       ' + e.message); }
}

// --- minimal DOM stub -------------------------------------------------------------
function makeEl(tag) {
  return {
    tagName: tag, innerHTML: '', textContent: '', value: '', disabled: false, _attrs: {},
    addEventListener() {}, appendChild() {},
    setAttribute(k, v) { this._attrs[k] = v; },
    getAttribute(k) { return this._attrs[k]; },
  };
}
const els = { hdrnote: makeEl('div'), q: makeEl('input'), results: makeEl('div'), 'meta-row': makeEl('div') };
const document = {
  getElementById: (id) => els[id] || (els[id] = makeEl('div')),
  querySelector: () => makeEl('div'),
  querySelectorAll: () => [],
  createElement: makeEl,
};

const sandbox = { window: {}, document, console };
vm.createContext(sandbox);
vm.runInContext(fs.readFileSync(DATA, 'utf8'), sandbox, { filename: 'conc_data.js' });

const html = fs.readFileSync(HTML, 'utf8');
const scripts = [...html.matchAll(/<script(?![^>]*\bsrc=)[^>]*>([\s\S]*?)<\/script>/g)].map(m => m[1]);
assert.strictEqual(scripts.length, 1, 'expected exactly one inline <script> in the page');

console.log('sanskrit_concordance.html — headless render');

check('the page\'s inline script runs without throwing', () => {
  vm.runInContext(scripts[0], sandbox, { filename: 'sanskrit_concordance.html' });
});

const D = sandbox.window.CONC_DATA;

check('the data file was actually consumed (no fallback error state)', () => {
  assert.ok(!/не найден или пуст/.test(els.hdrnote.innerHTML), 'page fell back to its no-data message');
});
check('header states the form count and total occurrences', () => {
  assert.ok(els.hdrnote.innerHTML.includes(D.formCount.toLocaleString()), 'form count not displayed');
});

// --- search behaviour ---------------------------------------------------------------
function search(query) {
  els.q.value = query;
  sandbox.onQuery();
  return els.results.innerHTML;
}

check('an exact form returns its total count and example strophes', () => {
  const out = search('uvāca');
  assert.ok(out.includes('uvāca'), 'form not shown');
  assert.ok(out.includes((10368).toLocaleString()), 'total occurrence count not shown');
  assert.ok((out.match(/class="example"/g) || []).length > 0, 'no example strophes rendered');
  assert.ok(/class="src"/.test(out), 'no source citation rendered');
});

check('a root-like substring returns multiple matched forms', () => {
  const out = search('gam');
  const forms = (out.match(/class="form-name"/g) || []).length;
  assert.ok(forms > 1, 'expected multiple matched forms for a root substring, got ' + forms);
});

check('an ASCII query without diacritics still matches an IAST-keyed form', () => {
  const out = search('kuryat'); // ASCII for kuryāt (macron on the ā)
  assert.ok(out.includes('kuryāt'), 'diacritic-insensitive match failed for kuryat -> kuryāt');
});

check('an unmatched query shows the no-results message, not a crash', () => {
  const out = search('zzzzznonexistent');
  assert.ok(/Ничего не найдено/.test(out), 'no-results message missing');
});

check('clearing the query clears the results', () => {
  search('uvāca');
  const out = search('');
  assert.strictEqual(out, '', 'results not cleared on empty query');
});

console.log(failures ? `\n${failures} check(s) FAILED` : '\nall checks passed');
process.exit(failures ? 1 : 0);
