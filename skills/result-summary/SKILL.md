---
id: result-summary
name: Result Summary
version: 1.0.0
description: Produce the final pass/fail test report for the run.
user_invocable: true
always: true
requires:
  bins: [bash, python3]
  env: [RUN_ID]
primary_env: RUN_ID
input_path: /tmp/bug-reporting_${RUN_ID}.json
output_path: /tmp/result-summary_${RUN_ID}.json
depends_on: ["bug-reporting"]
---

## Purpose
Produce the final pass/fail test report for the run.

## I/O Contract

- **Input:** /tmp/bug-reporting_${RUN_ID}.json, with step outcomes, bugs, and evidence references.
- **Output:** /tmp/result-summary_${RUN_ID}.json, with the final execution summary.
- **DB Write:** result_test_runs via data_writer.py upsert on run identity.

## Notes
- Use the app URL, credentials, and feature name supplied in the run input.
- Keep results clear, structured, and evidence-based.
