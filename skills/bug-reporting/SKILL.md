---
id: bug-reporting
name: Bug Reporting
version: 1.0.0
description: Summarize confirmed defects with clear reproduction steps.
user_invocable: true
always: true
requires:
  bins: [bash, python3]
  env: [RUN_ID]
primary_env: RUN_ID
input_path: /tmp/evidence-capture_${RUN_ID}.json
output_path: /tmp/bug-reporting_${RUN_ID}.json
depends_on: ["evidence-capture"]
---

## Purpose
Summarize confirmed defects with clear reproduction steps.

## I/O Contract

- **Input:** /tmp/evidence-capture_${RUN_ID}.json, with confirmed defects and evidence references.
- **Output:** /tmp/bug-reporting_${RUN_ID}.json, with bug titles, severity, reproduction steps, and evidence links.
- **DB Write:** result_bug_reports via data_writer.py upsert on test_run_id + title.

## Notes
- Use the app URL, credentials, and feature name supplied in the run input.
- Keep results clear, structured, and evidence-based.
