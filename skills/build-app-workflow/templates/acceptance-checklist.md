# build-app-workflow acceptance checklist

- [ ] Goal is explicit and scope is bounded.
- [ ] Changes are minimal and reversible.
- [ ] API/type/caller/docs are synchronized when interfaces changed.
- [ ] `scripts/preflight.sh` executed and warnings triaged.
- [ ] `scripts/verify.sh` passed.
- [ ] Smoke test (if applicable) passed.
- [ ] Risk and rollback path documented.
- [ ] Final report follows `templates/agent-report.md`.
