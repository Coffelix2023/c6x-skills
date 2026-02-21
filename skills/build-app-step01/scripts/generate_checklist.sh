#!/usr/bin/env bash
set -euo pipefail

PROJECT_NAME="${1:-your-project}"
DATE="$(date +%F)"

cat <<MARKDOWN
# build-app-step01 checklist

- project: ${PROJECT_NAME}
- generated_at: ${DATE}

## Stage 1 - Scope & Architecture
- [ ] Product goal in one sentence is written.
- [ ] Product track and engineering track are separated.
- [ ] Architecture mode selected: stateless / stateful / hybrid.
- [ ] Request-level observability plan exists.

## Stage 2 - Prompt & Context
- [ ] Prompt is short, ordered, and conflict-free.
- [ ] Context budget defined for key user flows.
- [ ] Eval set defined before merge.
- [ ] Trace fields include requestId, model, promptVersion.

## Stage 3 - Tooling & Integration
- [ ] Tool input/output schema is explicit.
- [ ] Timeout + retry + fallback behavior is defined.
- [ ] Model output is validated before privileged actions.
- [ ] MCP/tool boundaries are documented.

## Stage 4 - Ship
- [ ] Secret scan is clean or triaged.
- [ ] Lockfile strategy confirmed.
- [ ] Smoke test scenarios pass.
- [ ] Rollback command/path is documented and tested.

## Stage 5 - Growth & Ops
- [ ] Quality KPIs and product KPIs are both tracked.
- [ ] Experiment loop has explicit win/loss metric.
- [ ] PDCA review cadence is scheduled.
- [ ] Runbook owner is assigned.

## Release decision
- [ ] GO
- [ ] NO-GO (list blockers)
MARKDOWN
