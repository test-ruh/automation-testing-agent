---
id: browser-login
name: Browser Login
version: 1.0.0
description: Open the app and authenticate with the provided credentials.
user_invocable: true
always: true
requires:
  bins: [bash, python3]
  env: [APP_URL, APP_USERNAME, APP_PASSWORD, FEATURE_NAME, RUN_ID]
primary_env: APP_URL
input_path: /tmp/browser-login_${RUN_ID}.json
output_path: /tmp/browser-login_${RUN_ID}.json
depends_on: []
---

## Purpose
Open the app and authenticate with the provided credentials.

## I/O Contract

- **Input:** /tmp/browser-login_${RUN_ID}.json, with app_url, username_or_email, password, feature_name, and run metadata.
- **Output:** /tmp/browser-login_${RUN_ID}.json, with login status, session details, and any step notes.
- **DB Write:** result_test_steps via data_writer.py upsert on test_run_id + step_name.

## Notes
- Use the app URL, credentials, and feature name supplied in the run input.
- Keep results clear, structured, and evidence-based.
