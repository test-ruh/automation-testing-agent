#!/usr/bin/env bash
set -euo pipefail

INPUT_FILE="${INPUT_FILE:-/dev/stdin}"
OUTPUT_FILE="${OUTPUT_FILE:-/tmp/bug-reporting_${RUN_ID}.json}"
PROJECT_ROOT="${PROJECT_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
SKILL_ID="bug-reporting"

if [[ ! -r "$INPUT_FILE" && "$INPUT_FILE" != "/dev/stdin" ]]; then
  echo "[$SKILL_ID] input file is not readable: $INPUT_FILE" >&2
  exit 1
fi

node - "$INPUT_FILE" "$OUTPUT_FILE" "$PROJECT_ROOT" "$SKILL_ID" <<'NODE'
const fs = require('fs');
const [inputFile, outputFile, projectRoot, skillId] = process.argv.slice(2);
function readJson(path) { return JSON.parse(fs.readFileSync(path, 'utf8')); }
function writeJson(path, data) { fs.writeFileSync(path, JSON.stringify(data, null, 2)); }
const input = readJson(inputFile);
const bugs = (input.evidence || []).map((e, i) => ({
  id: `${skillId}-${i + 1}`,
  title: `Failed step: ${input.step || 'validation-checks'}`,
  severity: 'medium',
  reproduction_steps: 'Open the app, sign in with the provided credentials, and repeat the failed step shown in the evidence output.',
  expected_result: 'The flow should complete without blocking validation or navigation issues.',
  actual_result: 'The test run recorded a failure and attached evidence for review.',
  evidence: e
}));
writeJson(outputFile, { skill_id: skillId, step: 'bug-reporting', status: 'passed', bugs, notes: bugs.length ? ['Bug reports were assembled from failed evidence.'] : ['No confirmed defects were available to report.'] });
NODE
