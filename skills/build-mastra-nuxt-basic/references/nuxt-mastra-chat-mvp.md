# Nuxt + Mastra Chat MVP (pnpm, non-weather)

This reference is adapted from Mastra Nuxt getting-started flow and constrained to a plain chat assistant.

## 1. Prerequisites

- Node.js `>= 22.13.0`
- `pnpm`
- One model provider API key (DeepSeek for this skill)

## 2. Create app (optional)

```bash
pnpm create nuxt mastra-nuxt-chat --template minimal --packageManager pnpm --gitInit
cd mastra-nuxt-chat
```

## 3. Initialize Mastra

```bash
pnpm dlx mastra@latest init
```

After init, Mastra creates default example files. Replace weather-oriented naming with plain chat naming.

## 4. Replace weather agent with chat agent

Minimum change strategy:

1. Keep generated Mastra project structure.
2. Rename agent file and id to `chat-agent`.
3. Set model explicitly to `deepseek/deepseek-chat`.
4. Replace system prompt with generic assistant prompt.
5. Remove weather-specific tool dependencies from this agent.

Suggested prompt:

```text
You are a concise and helpful general assistant. Answer clearly and ask follow-up questions when requirements are ambiguous.
```

Minimal model setting example:

```ts
model="deepseek/deepseek-chat"
```

## 5. Install UI dependencies

```bash
pnpm add @mastra/ai-sdk@latest @ai-sdk/vue ai
```

## 6. Create `server/api/chat.ts`

Use the Nuxt server route pattern from Mastra guide, but set:

- `agentId: 'chat-agent'`
- memory `resource` value as chat-specific (for example `nuxt-chat`)

If your Mastra export path is not `../../src/mastra`, use actual project path.

## 7. Update `app/app.vue`

Use AI SDK UI `Chat` and point transport API to `/api/chat`.

MVP UI requirements:

- render message list
- input + submit
- initial hydration from `GET /api/chat`

## 8. Run

```bash
pnpm dev
```

Open `http://localhost:3000`, send a normal question, and confirm model reply is returned.

## Acceptance Checklist

- `POST /api/chat` streams assistant text response.
- `GET /api/chat` returns message history.
- No weather wording in prompt/UI placeholders/agent id.
- No secrets committed to codebase.

## Rollback

- Revert only modified Nuxt files:
  - `server/api/chat.ts`
  - `app/app.vue`
  - Mastra agent file(s) renamed/edited
