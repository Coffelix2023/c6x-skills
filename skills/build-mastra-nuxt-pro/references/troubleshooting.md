# Troubleshooting (Pro)

## Symptom: `Cannot find module '@mastra/ai-sdk'`

Cause:

- dependency not installed in current workspace

Fix:

```bash
pnpm add @mastra/ai-sdk@latest @ai-sdk/vue ai
```

## Symptom: route works but no streamed output

Cause:

- wrong `agentId`
- request payload shape mismatch

Fix:

1. Ensure `agentId: 'chat-agent'`.
2. Confirm route uses Mastra guide stream handler path.

## Symptom: old weather behavior still appears

Cause:

- stale file references to weather agent or weather prompt

Fix:

```bash
rg "weather-agent|weather|Ask about the weather" -n
```

Remove remaining weather-specific strings in app-facing flow.

## Symptom: no memory history on refresh

Cause:

- `GET /api/chat` recall path not connected
- inconsistent thread/resource IDs

Fix:

1. Use same `threadId` and `resourceId` for write/read path.
2. Ensure GET returns UI messages compatible with frontend hydration.
