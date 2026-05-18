#!/usr/bin/env bash
set -euo pipefail

INPUT_FILE="${INPUT_FILE:-/dev/stdin}"
OUTPUT_FILE="${OUTPUT_FILE:-/tmp/evidence-capture_${RUN_ID}.json}"
PROJECT_ROOT="${PROJECT_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
SKILL_ID="evidence-capture"

if [[ ! -r "$INPUT_FILE" && "$INPUT_FILE" != "/dev/stdin" ]]; then
  echo "[$SKILL_ID] input file is not readable: $INPUT_FILE" >&2
  exit 1
fi

node - "$INPUT_FILE" "$OUTPUT_FILE" "$PROJECT_ROOT" "$SKILL_ID" <<'NODE'
const fs = require('fs');
const path = require('path');
const [inputFile, outputFile, projectRoot, skillId] = process.argv.slice(2);
function readJson(pathName) { return JSON.parse(fs.readFileSync(pathName, 'utf8')); }
function writeJson(pathName, data) { fs.writeFileSync(pathName, JSON.stringify(data, null, 2)); }
const input = readJson(inputFile);
const evidenceDir = path.join('/tmp', `${skillId}_${process.env.RUN_ID || 'run'}`);
fs.mkdirSync(evidenceDir, { recursive: true });
const screenshot = path.join(evidenceDir, 'failed-step.png');
const result = { skill_id: skillId, step: 'evidence-capture', status: 'passed', evidence: [], notes: [] };
if (input && input.validations && input.validations.some(v => v.status === 'failed')) {
  result.evidence.push({ type: 'screenshot', path: screenshot, step: input.step || 'validation-checks' });
  fs.writeFileSync(screenshot, '');
  result.notes.push('Captured a placeholder screenshot artifact path for the failed step.');
}
writeJson(outputFile, result);
NODE
