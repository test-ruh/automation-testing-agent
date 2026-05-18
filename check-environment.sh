#!/usr/bin/env bash
# Check required environment variables are set.
set -euo pipefail

missing=0
if [ -z "${APP_URL:-}" ]; then echo "MISSING: APP_URL"; missing=$((missing+1)); fi
if [ -z "${APP_USERNAME:-}" ]; then echo "MISSING: APP_USERNAME"; missing=$((missing+1)); fi
if [ -z "${APP_PASSWORD:-}" ]; then echo "MISSING: APP_PASSWORD"; missing=$((missing+1)); fi
if [ -z "${FEATURE_NAME:-}" ]; then echo "MISSING: FEATURE_NAME"; missing=$((missing+1)); fi
if [ -z "${WEB_BROWSER:-}" ]; then echo "MISSING: WEB_BROWSER"; missing=$((missing+1)); fi
if [ -z "${RESULTS_REPORT:-}" ]; then echo "MISSING: RESULTS_REPORT"; missing=$((missing+1)); fi

if [ $missing -gt 0 ]; then
    echo "$missing required env var(s) missing"
    exit 1
fi
echo "OK: all required env vars set"
