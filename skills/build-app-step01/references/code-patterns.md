# Code Patterns (Minimal, Reusable)

Use these as starting patterns when applying build-app-step01.

## Prompt + context

```ts
// Keep system instructions short and ordered by priority.
const SYSTEM_PROMPT = [
  "Follow policy constraints first.",
  "Use tools only when required.",
  "Return JSON when schema is provided.",
].join("\n");

function packContext(input: { summary: string; facts: string[] }) {
  return {
    summary: input.summary.slice(0, 1200),
    facts: input.facts.slice(0, 20),
  };
}
```

## Tool contracts

```ts
type ToolInput = { query: string; userId: string };
type ToolOutput = { ok: true; data: unknown } | { ok: false; error: string };

async function callTool(input: ToolInput): Promise<ToolOutput> {
  if (!input.query || !input.userId) return { ok: false, error: "invalid_input" };

  const controller = new AbortController();
  const timeout = setTimeout(() => controller.abort(), 8000);

  try {
    const res = await fetch("https://api.example.com/tool", {
      method: "POST",
      body: JSON.stringify(input),
      headers: { "content-type": "application/json" },
      signal: controller.signal,
    });

    if (!res.ok) return { ok: false, error: `http_${res.status}` };
    return { ok: true, data: await res.json() };
  } catch {
    return { ok: false, error: "tool_unavailable" };
  } finally {
    clearTimeout(timeout);
  }
}
```

## Tracing

```ts
function logTrace(event: {
  requestId: string;
  model: string;
  promptVersion: string;
  tool?: string;
  latencyMs?: number;
  status: "ok" | "error";
}) {
  console.log(JSON.stringify({ ts: new Date().toISOString(), ...event }));
}
```

## Preflight checks in CI

```bash
#!/usr/bin/env bash
set -euo pipefail

# 1) No hardcoded secrets
! rg -n "(sk-[a-zA-Z0-9]{20,}|OPENAI_API_KEY=)" .

# 2) Ensure lock files exist for reproducible builds
[ -f pnpm-lock.yaml ] || [ -f uv.lock ] || [ -f Cargo.lock ]

# 3) Run project tests if available
[ -f package.json ] && pnpm test || true
[ -f pyproject.toml ] && uv run pytest || true
[ -f Cargo.toml ] && cargo test || true
```
