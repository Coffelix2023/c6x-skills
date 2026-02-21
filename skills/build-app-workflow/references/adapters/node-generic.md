# Adapter: Node generic

Use this adapter for Node.js repositories.

## Typical verify sequence

1. `pnpm lint` (or project equivalent)
2. `pnpm test`
3. `pnpm build`

## Notes

- Ensure lockfile consistency in CI and local runs.
- Validate script names in `package.json` before invoking.
