# Step 3 of 5 — Skills

## Added Skills

| #    | Skill ID                  | Skill Name               | Mode   | Risk Level | Description                |
|------|---------------------------|--------------------------|--------|------------|----------------------------|
| S1   | `data-writer` | Data Writer | Auto | Low | Provision, write, and query the agent database schema via scripts/data_writer.py. Use for all PostgreSQL operations and any result-table persistence. |
| S2   | `result-query` | Result Query | Auto | Low | Read stored records from the agent result tables for inspection and follow-up questions. |
| S3   | `github-action` | GitHub Action | Auto | Low | Git branch + PR workflow for syncing agent changes to GitHub. Creates feature branches, commits changes, and opens pull requests against main. NEVER pushes to main directly. MANDATORY for every agent. |
| S4   | `browser-login` | Browser login | Auto | Low | Open the app URL, sign in with provided credentials, and confirm the authenticated session is active. |
| S5   | `flow-execution` | Flow execution | Auto | Low | Navigate the My Agents flow and complete the requested user journey in the authenticated app. |
| S6   | `validation-checks` | Validation checks | Auto | Low | Verify positive and negative scenarios, field validations, incorrect input handling, submission behavior, navigation, and redirection. |
| S7   | `evidence-capture` | Evidence capture | Auto | Low | Capture screenshots and evidence for failed steps and produce evidence references. |
| S8   | `bug-reporting` | Bug reporting | Auto | Low | Compile confirmed defects into structured bug reports with reproduction steps, expected and actual results, and severity. |
| S9   | `result-summary` | Result summary | Auto | Low | Produce the final execution summary with pass/fail status, step outcomes, bugs, and evidence references. |

## Skill Dependencies (Execution Order)

```
data-writer
result-query
github-action
browser-login
flow-execution ← depends on browser-login
validation-checks ← depends on flow-execution
evidence-capture ← depends on validation-checks
bug-reporting ← depends on evidence-capture
result-summary ← depends on bug-reporting
```

## Execution Mode Summary

| Mode  | Count          |
|-------|----------------|
| HiTL  | 0              |
| Auto  | 9 |
