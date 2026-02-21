#!/usr/bin/env bash
set -euo pipefail

TASK_ID="${1:-unknown-task}"
ROOT="${2:-.}"
NOW="$(date '+%Y-%m-%d %H:%M:%S')"
OUT="/tmp/build-app-workflow-postmortem-${TASK_ID}-$(date '+%Y%m%d-%H%M%S').md"

cd "$ROOT"

cat > "$OUT" <<MARKDOWN
# build-app-workflow postmortem

- task_id: ${TASK_ID}
- generated_at: ${NOW}
- repo: $(pwd)

## Failure summary
- [ ] Verification failed with reproducible command output attached.
- [ ] Scope and changed files are listed.

## Root cause category
- [ ] Environment/toolchain issue
- [ ] Contract/schema mismatch
- [ ] Test assumption drift
- [ ] Build/configuration issue
- [ ] Other (describe)

## Recovery actions
1. Reproduce with exact command.
2. Minimize fix scope.
3. Re-run only affected checks.
4. Run full verify again.
5. Update docs/rollback notes if needed.

## Rollback plan
- rollback_unit: [single commit / file group]
- command_or_method: [document exact rollback method]
- verification_after_rollback: [which checks prove recovery]

## Evidence
- command_output_path:
- related_logs_path:
- artifacts_path:
MARKDOWN

printf "Postmortem template generated: %s\n" "$OUT"
