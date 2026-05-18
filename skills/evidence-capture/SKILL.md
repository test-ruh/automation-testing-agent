---
id: evidence-capture
name: Evidence Capture
version: 1.0.0
description: Capture screenshots and failure evidence for failed steps.
user_invocable: true
always: true
requires:
  bins: [bash, python3]
  env: [RUN_ID]
primary_env: RUN_ID
input_path: /tmp/validation-checks_${RUN_ID}.json
output_path: /tmp/evidence-capture_${RUN_ID}.json
depends_on: ["validation-checks"]
---

## Purpose
Capture screenshots and failure evidence for failed steps.

## I/O Contract

- **Input:** /tmp/validation-checks_${RUN_ID}.json, with failed step details and screenshot needs.
- **Output:** /tmp/evidence-capture_${RUN_ID}.json, with screenshot paths and evidence references.
- **DB Write:** result_evidence_assets via data_writer.py upsert on test_run_id + test_step_id + asset_type.

## Notes
- Use the app URL, credentials, and feature name supplied in the run input.
- Keep results clear, structured, and evidence-based.
