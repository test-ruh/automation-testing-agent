#!/usr/bin/env bash
set -euo pipefail

INPUT_FILE="${INPUT_FILE:-/dev/stdin}"
OUTPUT_FILE="${OUTPUT_FILE:-/tmp/result-summary_${RUN_ID}.json}"
PROJECT_ROOT="${PROJECT_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
SKILL_ID="result-summary"

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
const summary = {
  skill_id: skillId,
  status: (input.bugs && input.bugs.length) ? 'failed' : 'passed',
  summary: (input.bugs && input.bugs.length) ? `Completed with ${input.bugs.length} bug(s).` : 'Completed without confirmed defects.',
  step_outcomes: input,
};
writeJson(outputFile, summary);
NODE
