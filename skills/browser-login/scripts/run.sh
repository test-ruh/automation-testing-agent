#!/usr/bin/env bash
set -euo pipefail

INPUT_FILE="${INPUT_FILE:-/dev/stdin}"
OUTPUT_FILE="${OUTPUT_FILE:-/tmp/browser-login_${RUN_ID}.json}"
PROJECT_ROOT="${PROJECT_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
SKILL_ID="browser-login"

if [[ ! -r "$INPUT_FILE" && "$INPUT_FILE" != "/dev/stdin" ]]; then
  echo "[$SKILL_ID] input file is not readable: $INPUT_FILE" >&2
  exit 1
fi

node <<'NODE' "$INPUT_FILE" "$OUTPUT_FILE" "$PROJECT_ROOT" "$SKILL_ID"
const fs = require('fs');
const [inputFile, outputFile, projectRoot, skillId] = process.argv.slice(1);
function readJson(path) { return JSON.parse(fs.readFileSync(path, 'utf8')); }
function writeJson(path, data) { fs.writeFileSync(path, JSON.stringify(data, null, 2)); }
function redact(s) { return String(s || '').replace(/([A-Za-z0-9._%+-]+)@([A-Za-z0-9.-]+)/g, '***@$2'); }
(async () => {
  const input = readJson(inputFile);
  const appUrl = input.app_url || process.env.APP_URL;
  const username = input.username_or_email || process.env.APP_USERNAME;
  const password = input.password || process.env.APP_PASSWORD;
  const featureName = input.feature_name || process.env.FEATURE_NAME || 'My Agents';
  const result = { skill_id: skillId, step: 'browser-login', app_url: appUrl, feature_name: featureName, status: 'failed', checks: [], evidence: [], notes: [] };
  try {
    const resp = await fetch(appUrl, { redirect: 'follow' });
    if (!resp.ok) {
      const body = redact(await resp.text().catch(() => ''));
      throw new Error(`App request failed with HTTP ${resp.status}: ${body.slice(0, 300)}`);
    }
    result.checks.push({ name: 'open-app', status: 'passed', http_status: resp.status });
    const pw = await import('playwright').catch(() => null);
    if (!pw) throw new Error('Playwright is not available in this runtime');
    const browser = await pw.chromium.launch({ headless: true });
    const page = await browser.newPage();
    await page.goto(appUrl, { waitUntil: 'domcontentloaded', timeout: 60000 });
    result.checks.push({ name: 'open-app-browser', status: 'passed' });
    await page.fill('input[type="email"], input[name*="email" i], input[name*="username" i], input[type="text"]', username);
    await page.fill('input[type="password"]', password);
    await page.click('button[type="submit"], button:has-text("Log in"), button:has-text("Login"), button:has-text("Sign in")');
    await page.waitForLoadState('networkidle', { timeout: 60000 }).catch(() => {});
    const text = await page.textContent('body').catch(() => '');
    const loginOk = /logout|dashboard|my agents|welcome|sign out/i.test(text || '');
    if (!loginOk) throw new Error('Login confirmation text was not found');
    result.status = 'passed';
    result.checks.push({ name: 'login-confirmed', status: 'passed' });
    result.session = { authenticated: true };
    await browser.close();
  } catch (err) {
    result.error = redact(err && err.message ? err.message : String(err));
    result.notes.push('Login automation could not complete in the browser runtime.');
  }
  writeJson(outputFile, result);
})().catch(err => { console.error('[browser-login] fatal:', redact(err && err.message ? err.message : String(err))); process.exit(1); });
NODE
