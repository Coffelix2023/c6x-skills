# Adapter: Tauri + Vue + Rust

Use this adapter when repository contains both frontend and Rust/Tauri layers.

## Typical verify sequence

1. `pnpm lint`
2. `pnpm test` (if configured)
3. `cargo fmt --check`
4. `cargo clippy --all-targets --all-features -- -D warnings`
5. `cargo test`
6. `pnpm build`

## Notes

- Keep frontend and Rust contract changes synchronized.
- Prefer shared version pinning and lockfiles.
- Add smoke test steps for desktop packaging workflows.
