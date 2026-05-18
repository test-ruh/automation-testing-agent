#!/usr/bin/env bash
set -euo pipefail

INPUT_FILE="${INPUT_FILE:-/dev/stdin}"
OUTPUT_FILE="${OUTPUT_FILE:-/tmp/flow-execution_${RUN_ID}.json}"
PROJECT_ROOT="${PROJECT_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
SKILL_ID="flow-execution"

if [[ ! -r "$INPUT_FILE" && "$INPUT_FILE" != "/dev/stdin" ]]; then
  echo "[$SKILL_ID] input file is not readable: $INPUT_FILE" >&2
  exit 1
fi

node - "$INPUT_FILE" "$OUTPUT_FILE" "$PROJECT_ROOT" "$SKILL_ID" <<'NODE'
const fs = require('fs');
const [inputFile, outputFile, projectRoot, skillId] = process.argv.slice(2);
function readJson(path) { return JSON.parse(fs.readFileSync(path, 'utf8')); }
function writeJson(path, data) { fs.writeFileSync(path, JSON.stringify(data, null, 2)); }
(async () => {
  const input = readJson(inputFile);
  const result = { skill_id: skillId, step: 'flow-execution', status: 'failed', checks: [], evidence: [], notes: [] };
  try {
    const resp = await fetch(input.app_url, { redirect: 'follow' });
    if (!resp.ok) throw new Error(`HTTP ${resp.status} while opening feature page: ${(await resp.text().catch(() => '')).slice(0, 300)}`);
    const pw = await import('playwright').catch(() => null);
    if (!pw) throw new Error('Playwright is not available in this runtime');
    const browser = await pw.chromium.launch({ headless: true });
    const page = await browser.newPage();
    await page.goto(input.app_url, { waitUntil: 'domcontentloaded', timeout: 60000 });
    await page.waitForLoadState('networkidle', { timeout: 30000 }).catch(() => {});
    const bodyText = await page.textContent('body').catch(() => '');
    if (!/my agents/i.test(bodyText || '')) throw new Error('My Agents page content was not detected after login');
    result.status = 'passed';
    result.checks.push({ name: 'feature-visible', status: 'passed' });
    result.notes.push('Navigated to the requested feature area and confirmed it is visible.');
    await browser.close();
  } catch (err) {
    result.error = String(err && err.message ? err.message : err);
    result.notes.push('Feature navigation could not be fully exercised.');
  }
  writeJson(outputFile, result);
})();
NODE
