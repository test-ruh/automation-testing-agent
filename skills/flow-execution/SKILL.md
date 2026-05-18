---
id: flow-execution
name: Flow Execution
version: 1.0.0
description: Navigate and execute the My Agents feature flow after login.
user_invocable: true
always: true
requires:
  bins: [bash, python3]
  env: [APP_URL, APP_USERNAME, APP_PASSWORD, FEATURE_NAME, RUN_ID]
primary_env: FEATURE_NAME
input_path: /tmp/browser-login_${RUN_ID}.json
output_path: /tmp/flow-execution_${RUN_ID}.json
depends_on: ["browser-login"]
---

## Purpose
Navigate and execute the My Agents feature flow after login.

## I/O Contract

- **Input:** /tmp/browser-login_${RUN_ID}.json, with login confirmation and run metadata.
- **Output:** /tmp/flow-execution_${RUN_ID}.json, with feature navigation steps, checks, and notes.
- **DB Write:** result_test_steps via data_writer.py upsert on test_run_id + step_name.

## Notes
- Use the app URL, credentials, and feature name supplied in the run input.
- Keep results clear, structured, and evidence-based.
