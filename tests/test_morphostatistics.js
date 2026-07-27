/**
 * Headless render test for sanskrit_morphostatistics.html (H1538).
 *
 * Same pattern as test_nominal_dashboard.js / test_concordance.js: extract the page's
 * own inline <script> and run it against a minimal DOM stub, then assert on the three
 * sections it renders (person x number, case x number, prefix productivity). Unlike the
 * other two, this page has no companion data file — everything is embedded inline, so
 * there is nothing to load from disk beyond the HTML itself.
 *
 *   node tests/test_morphostatistics.js
 */
'use strict';
const fs = require('fs');
const path = require('path');
const vm = require('vm');
const assert = require('assert');

const REPO = path.resolve(__dirname, '..');
const HTML = path.join(REPO, 'sanskrit_morphostatistics.html');

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
const scripts = [...html.matchAll(/<script(?![^>]*\bsrc=)[^>]*>([\s\S]*?)<\/script>/g)].map(m => m[1]);
assert.strictEqual(scripts.length, 1, 'expected exactly one inline <script> in the page');

console.log('sanskrit_morphostatistics.html — headless render');

check('the page\'s inline script runs without throwing', () => {
  vm.runInContext(scripts[0], sandbox, { filename: 'sanskrit_morphostatistics.html' });
});

const out = els.app.innerHTML;

check('no NaN/undefined/Infinity leaked into the rendered output', () => {
  assert.ok(!/NaN|undefined|Infinity/.test(out), 'placeholder artifact found in output');
});

check('person x number section renders 16 finite tense rows, 5 excluded as non-finite', () => {
  assert.ok(out.includes('Лицо × число'), 'section heading missing');
  assert.ok(out.includes('Optative') && out.includes('Imperative') && out.includes('Perfect'),
    'expected finite tense rows missing');
  assert.ok(out.includes('PPP') === false || !/rowh"[^>]*>PPP/.test(out),
    'PPP (non-finite) leaked into the person x number grid rows');
  assert.ok(/16 категор/.test(out), 'finite-category count not stated');
  assert.ok(/5 неличных категорий/.test(out), 'excluded non-finite count not stated');
});

check('case x number section renders all 8 cases summing to the stated total', () => {
  ['Nominative', 'Accusative', 'Instrumental', 'Genitive', 'Locative', 'Vocative', 'Ablative', 'Dative']
    .forEach(c => assert.ok(out.includes(c), `case ${c} missing from table`));
  assert.ok(out.includes('2 277 509'), 'case total not shown');
});

check('prefix section renders bars for the top preverbs with meanings', () => {
  assert.ok(out.includes('>sam<') || out.includes('sam<span'), 'top prefix "sam" missing');
  assert.ok(out.includes('together, completely'), 'prefix meaning not shown');
  assert.ok((out.match(/class="barrow"/g) || []).length === 25, 'expected 25 prefix bars');
});

check('headline stats tiles show the three section totals', () => {
  assert.ok(out.includes('423 771'), 'finite verb-token total not shown');
  assert.ok(out.includes('2 277 509'), 'case-token total not shown');
  assert.ok(out.includes('923'), 'prefixed-lemma total not shown');
});

console.log(failures ? `\n${failures} check(s) FAILED` : '\nall checks passed');
process.exit(failures ? 1 : 0);
