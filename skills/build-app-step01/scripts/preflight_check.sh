#!/usr/bin/env bash
set -euo pipefail

ROOT="${1:-.}"
cd "$ROOT"

pass() { printf "[PASS] %s\n" "$1"; }
warn() { printf "[WARN] %s\n" "$1"; }
fail() {
    printf "[FAIL] %s\n" "$1"
    exit 1
}

# 1) Secret scan (simple, defensive pattern)
if command -v rg >/dev/null 2>&1; then
    if rg -n \
        --glob '!skills/build-app-step01/references/code-patterns.md' \
        "(sk-[A-Za-z0-9]{20,}|OPENAI_API_KEY\s*=|BEGIN (RSA|EC|OPENSSH) PRIVATE KEY)" . >/tmp/build-app-step01-secrets.txt 2>/dev/null; then
        warn "Possible secrets detected. Review /tmp/build-app-step01-secrets.txt"
    else
        pass "No obvious hardcoded secrets found"
    fi
else
    warn "ripgrep (rg) not installed; skip secret scan"
fi

# 2) Reproducible build lockfile presence
if [ -f pnpm-lock.yaml ] || [ -f uv.lock ] || [ -f Cargo.lock ]; then
    pass "At least one lockfile is present"
else
    warn "No lockfile found (pnpm-lock.yaml / uv.lock / Cargo.lock)"
fi

# 3) Rollback signal: git status available
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    pass "Git repository detected"
    git status --short >/tmp/build-app-step01-gitstatus.txt || true
    pass "Saved git status snapshot to /tmp/build-app-step01-gitstatus.txt"
else
    warn "Not a git repository; rollback workflow may be weaker"
fi

# 4) Test command hints (non-failing suggestions)
if [ -f package.json ]; then
    if rg -n "\"test\"\\s*:" package.json >/dev/null 2>&1; then
        pass "Node test script detected: run 'pnpm test'"
    else
        warn "package.json exists but no test script found"
    fi
fi

if [ -f pyproject.toml ]; then
    pass "Python project detected: consider 'uv run pytest'"
fi

if [ -f Cargo.toml ]; then
    pass "Rust project detected: consider 'cargo test'"
fi

printf "\nPreflight completed. Warnings should be triaged before production release.\n"
