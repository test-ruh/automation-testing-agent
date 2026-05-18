---
id: validation-checks
name: Validation Checks
version: 1.0.0
description: Verify positive and negative scenarios for the My Agents flow.
user_invocable: true
always: true
requires:
  bins: [bash, python3]
  env: [APP_URL, APP_USERNAME, APP_PASSWORD, FEATURE_NAME, RUN_ID]
primary_env: FEATURE_NAME
input_path: /tmp/flow-execution_${RUN_ID}.json
output_path: /tmp/validation-checks_${RUN_ID}.json
depends_on: ["flow-execution"]
---

## Purpose
Verify positive and negative scenarios for the My Agents flow.

## I/O Contract

- **Input:** /tmp/flow-execution_${RUN_ID}.json, with flow results and run metadata.
- **Output:** /tmp/validation-checks_${RUN_ID}.json, with positive and negative validation findings.
- **DB Write:** result_test_steps and result_bug_reports via data_writer.py upsert.

## Notes
- Use the app URL, credentials, and feature name supplied in the run input.
- Keep results clear, structured, and evidence-based.
