# 15 Lessons -> Preventive Workflow Mapping

Source article: https://developers.openai.com/blog/15-lessons-building-chatgpt-apps (2026-02-04)

This file translates each lesson into: signal, pitfall, preventive action, and verification gate.

## L1-L3: Product and architecture decomposition

### L1. Split work into product track and engineering track
- Signal: requirements and implementation are mixed in one thread.
- Pitfall: unclear ownership and rework.
- Preventive action: keep two artifacts: product spec and technical execution plan.
- Verification: both artifacts exist and reference each other.

### L2. Decouple business logic from model layer
- Signal: prompt text contains core business rules.
- Pitfall: brittle behavior and hidden policy drift.
- Preventive action: encode hard rules in code, keep model for reasoning/generation.
- Verification: rule violations are blocked before model output reaches user.

### L3. Start simple, then add complexity by evidence
- Signal: multiple tools/agents added before baseline quality.
- Pitfall: difficult debugging and unclear root cause.
- Preventive action: single-model baseline first, add components behind metrics.
- Verification: each added component has measurable gain.

## L4-L8: Prompt, context, and evaluation discipline

### L4. Keep prompts concise and explicit
- Signal: prompts keep growing after each bug.
- Pitfall: instruction conflict and unstable behavior.
- Preventive action: short, structured prompts with strict priorities.
- Verification: prompt diff is small and test cases pass.

### L5. Choose architecture mode intentionally
- Signal: team cannot explain when state is required.
- Pitfall: unnecessary complexity or lost conversation context.
- Preventive action: pick stateless/stateful/hybrid with clear criteria.
- Verification: mode decision recorded in design doc.

### L6. Treat context window as a budget
- Signal: large raw documents always injected.
- Pitfall: truncation, degraded quality, rising cost.
- Preventive action: retrieval, summarization, and schema-first context packing.
- Verification: token budget report exists for top flows.

### L7. Build evals early, not after launch
- Signal: quality judged only by manual spot checks.
- Pitfall: regressions go unnoticed.
- Preventive action: define acceptance eval set before feature merge.
- Verification: CI or local command runs eval set and reports deltas.

### L8. Use tracing to debug model+tool behavior
- Signal: failures are hard to reproduce.
- Pitfall: random fixes and no learning loop.
- Preventive action: trace prompt/tool/config per request ID.
- Verification: one failing request can be replayed with trace data.

## L9-L12: Tooling and production hardening

### L9. Make tool contracts strict
- Signal: tools return ad-hoc text blobs.
- Pitfall: parsing errors and unsafe actions.
- Preventive action: typed I/O schema, timeout, retry, idempotency.
- Verification: invalid payloads fail fast with clear errors.

### L10. Design for failures first
- Signal: happy-path demos only.
- Pitfall: cascading outages in production.
- Preventive action: fallback response, circuit breaker, partial degradation.
- Verification: chaos/smoke tests cover tool timeout and 5xx paths.

### L11. Security boundaries are explicit
- Signal: model can directly trigger privileged operations.
- Pitfall: prompt injection and data exfiltration.
- Preventive action: policy checks between model output and execution.
- Verification: blocked-action tests exist and pass.

### L12. Deployment and rollback are first-class
- Signal: no release gate beyond "looks good".
- Pitfall: slow recovery and prolonged incidents.
- Preventive action: version pinning, staged rollout, rollback command documented.
- Verification: rollback drill completed at least once.

## L13-L15: Growth loop and long-term reliability

### L13. Instrument user journeys end-to-end
- Signal: only infrastructure metrics are tracked.
- Pitfall: product quality issues hidden by healthy infra.
- Preventive action: measure task success, correction rate, abandonment.
- Verification: dashboard includes product and model-quality KPIs.

### L14. Optimize for iteration speed
- Signal: each change needs broad manual coordination.
- Pitfall: slow learning and missed opportunities.
- Preventive action: narrow experiments with explicit success metrics.
- Verification: weekly experiment cadence with documented outcomes.

### L15. Build operations as a continuous loop
- Signal: post-launch process is ad-hoc.
- Pitfall: repeated incidents and no compounding improvement.
- Preventive action: PDCA cycle with regular risk review and eval refresh.
- Verification: recurring review calendar and updated runbook.
