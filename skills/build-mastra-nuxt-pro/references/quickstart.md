# Quickstart (Pro)

## Preflight

```bash
bash skills/build-mastra-nuxt-pro/scripts/preflight.sh
```

Expected:

- Node version is `>= 22.13.0`
- `pnpm` exists

## Bootstrap

```bash
pnpm create nuxt mastra-nuxt-chat --template minimal --packageManager pnpm --gitInit
cd mastra-nuxt-chat
pnpm dlx mastra@latest init
pnpm add @mastra/ai-sdk@latest @ai-sdk/vue ai
```

## Convert default weather assistant

1. Rename default weather-oriented agent to `chat-agent`.
2. Keep only plain assistant prompt.
3. Remove weather-only tools from this agent unless explicitly requested.

## Integrate API route

Create `server/api/chat.ts` based on Mastra Nuxt guide pattern:

- `POST` route streams response using `handleChatStream`.
- `GET` route hydrates history from memory.
- use `agentId: 'chat-agent'`.

## Integrate UI

In `app/app.vue`:

- initialize `Chat` with `api: '/api/chat'`
- hydrate from `GET /api/chat`
- submit user input with streaming render

## Run and test

```bash
pnpm dev
```

Pass condition:

- regular question gets a streamed assistant response
- reload page and message history remains available (if memory configured)
