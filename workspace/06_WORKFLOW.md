# Workflow — End-to-End Process Flow

Executed by the [Lobster runtime](https://github.com/openclaw/lobster) via `lobster run workflows/main.yaml`.
Steps run **sequentially** in the order shown below.

## Workflow Steps

1. **provision-schema** → `run: python3 scripts/data_writer.py provision` (timeout_ms=30000)
2. **browser-login** → skill `browser-login`
3. **flow-execution** → skill `flow-execution`
4. **validation-checks** → skill `validation-checks`
5. **evidence-capture** → skill `evidence-capture`
6. **bug-reporting** → skill `bug-reporting`
7. **result-summary** → skill `result-summary`

## Diagram

```
provision-schema → browser-login → flow-execution → validation-checks → evidence-capture → bug-reporting → result-summary
```
