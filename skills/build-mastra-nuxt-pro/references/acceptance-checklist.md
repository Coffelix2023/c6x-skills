# Acceptance Checklist (Pro)

## Functional

- `pnpm dev` starts Nuxt successfully.
- `POST /api/chat` returns streamed assistant response.
- `GET /api/chat` hydrates prior messages when available.
- agent id in runtime path is `chat-agent`.

## Naming/Scope

- No weather-specific naming in assistant entry path.
- Prompt is generic chat assistant prompt.

## Safety

- No API key/token committed in files.
- Environment variables are documented, not hardcoded.

## Quality

- Change list is small and explainable.
- Rollback points are clear.
- Commands in docs are runnable on macOS/Linux.
