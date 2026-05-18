# 🤖 Automation Testing Agent

Runs end-to-end browser tests for the My Agents flow, including login, positive and negative checks, failure evidence, bug reports, and final results.

## Quick Start

```bash
git clone git@github.com:${GITHUB_OWNER}/automation-testing-agent.git
cd automation-testing-agent

# 1. Configure
cp .env.example .env
# Edit .env with your credentials (see "Required Environment Variables" below)

# 2. One-shot setup: validates env, installs deps, provisions DB, registers cron
chmod +x setup.sh
./setup.sh
```

## Manual Setup (if you prefer step-by-step)

```bash
cp .env.example .env             # then edit it
set -a; source .env; set +a       # load vars into the current shell
bash check-environment.sh         # verify everything required is set
bash install-dependencies.sh      # pip install psycopg2-binary, pyyaml
python3 scripts/data_writer.py provision   # create tables in your schema

```

## Running

```bash
bash test-workflow.sh             # run every skill in order locally (smoke test)

openclaw cron list                # see registered jobs
openclaw cron runs                # see run history
```

## Required Environment Variables

| Variable | Description |
|----------|-------------|
| `APP_URL` | App URL |
| `APP_USERNAME` | Username or email |
| `APP_PASSWORD` | Password |
| `FEATURE_NAME` | Feature name |
| `WEB_BROWSER` | Web browser |
| `RESULTS_REPORT` | Results report |

## Skills

| Skill | Mode | Description |
|-------|------|-------------|
| `data-writer` | Auto | Provision, write, and query the agent database schema via scripts/data_writer.py. Use for all PostgreSQL operations and any result-table persistence. |
| `result-query` | User-invocable | Read stored records from the agent result tables for inspection and follow-up questions. |
| `github-action` | User-invocable | Git branch + PR workflow for syncing agent changes to GitHub. Creates feature branches, commits changes, and opens pull requests against main. NEVER pushes to main directly. MANDATORY for every agent. |
| `browser-login` | Auto | Open the app URL, sign in with provided credentials, and confirm the authenticated session is active. |
| `flow-execution` | Auto | Navigate the My Agents flow and complete the requested user journey in the authenticated app. |
| `validation-checks` | Auto | Verify positive and negative scenarios, field validations, incorrect input handling, submission behavior, navigation, and redirection. |
| `evidence-capture` | Auto | Capture screenshots and evidence for failed steps and produce evidence references. |
| `bug-reporting` | Auto | Compile confirmed defects into structured bug reports with reproduction steps, expected and actual results, and severity. |
| `result-summary` | Auto | Produce the final execution summary with pass/fail status, step outcomes, bugs, and evidence references. |



## Architecture

- **Runtime**: OpenClaw AI agent framework
- **Data Layer**: PostgreSQL via `scripts/data_writer.py`
- **Scheduling**: OpenClaw cron
- **Schema**: `org_{org_id}_a_automation_testing_agent`

## Directory Structure

```
automation-testing-agent/
├── README.md
├── openclaw.json
├── result-schema.yml
├── env-manifest.yml
├── .env.example
├── requirements.txt
├── .gitignore
├── check-environment.sh
├── install-dependencies.sh
├── test-workflow.sh
├── cron/
├── workflows/
├── scripts/
│   ├── data_writer.py
│   └── github_action.py
├── skills/
└── workspace/
    ├── SOUL.md
    ├── 01_IDENTITY.md
    ├── 02_RULES.md
    ├── 03_SKILLS.md
    ├── 04_TRIGGERS.md
    ├── 05_ACCESS.md
    ├── 06_WORKFLOW.md
    └── 07_REVIEW.md
```
