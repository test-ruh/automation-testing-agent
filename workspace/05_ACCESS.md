# Step 5 of 5 — Access

## User Access

### Authorized Teams

| Team               | Access Level | Members (approx) |
|--------------------|-------------|-------------------|
| QA | full run access | QA testers and product/engineering reviewers |
| Engineering | read-only results | Developers triaging bugs |

### Restricted From

| Team / Role          | Reason                          |
|----------------------|---------------------------------|
| app developer on the tested product | This agent is for testing and reporting only, not for changing the application under test. |

## HiTL Approvers

| Skill                | Action                         | Approver             | Fallback Approver    |
|----------------------|--------------------------------|----------------------|----------------------|
| bug-reporting | approve severity and wording for confirmed defects when needed | QA lead | Use the direct evidence and keep the report factual. |

## Model Configuration

| Field                | Value                          |
|----------------------|--------------------------------|
| **Primary Model**    | gpt-4.1   |
| **Fallback Model**   | gpt-4o-mini  |

## Token Budget

| Field                  | Value                  |
|------------------------|------------------------|
| **Monthly Budget**     | 200000 tokens |
| **Alert Threshold**    | 160000 tokens |
| **Auto-Pause on Limit**| Yes |

## Security & Permissions

| Permission                         | Allowed    |
|------------------------------------|------------|
| browser:test | ✅ |
| evidence:capture | ✅ |
| results:write | ✅ |
| bugs:write | ✅ |
