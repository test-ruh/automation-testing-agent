# Review — Final Summary Before Save

## Agent Card

| Field              | Value                          |
|--------------------|--------------------------------|
| **Name**           | 🤖 Automation Testing Agent |
| **ID**             | `automation-testing-agent`           |
| **Version**        | 1.0.0 |
| **Scope**          | Runs end-to-end browser tests for the My Agents flow, including login, positive and negative checks, failure evidence, bug reports, and final results.      |
| **Tone**           | professional, precise, test-focused             |
| **Model**          | gpt-4.1 (primary), gpt-4o-mini (fallback) |
| **Token Budget**   | 200000 tokens/month |

## Skills Summary

| Skill                     | Mode         |
|---------------------------|--------------|
| Data Writer | 🟢 Auto |
| Result Query | 🟢 Auto |
| GitHub Action | 🟢 Auto |
| Browser login | 🟢 Auto |
| Flow execution | 🟢 Auto |
| Validation checks | 🟢 Auto |
| Evidence capture | 🟢 Auto |
| Bug reporting | 🟢 Auto |
| Result summary | 🟢 Auto |

## Post-Save Checklist

- [ ] Confirm the workflow references only packaged approved skills.
- [ ] Verify env-manifest, README, and .env.example all use the same variable names.
- [ ] Run validation for the generated OpenClaw bundle.
- [ ] Confirm the result schema includes run, step, bug, and evidence records.
- [ ] Ensure failed steps capture screenshots and link them in the final summary.
