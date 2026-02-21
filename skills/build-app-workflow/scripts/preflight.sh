#!/usr/bin/env bash
set -euo pipefail

ROOT="${1:-.}"
cd "$ROOT"

pass() { printf "[PASS] %s\n" "$1"; }
warn() { printf "[WARN] %s\n" "$1"; }
fail() { printf "[FAIL] %s\n" "$1"; exit 1; }

printf "build-app-workflow preflight in: %s\n" "$(pwd)"

# 1) Repo sanity
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  pass "Git repository detected"
  git status --short > /tmp/build-app-workflow-gitstatus.txt || true
  pass "Saved git snapshot: /tmp/build-app-workflow-gitstatus.txt"
else
  warn "Not a git repository; rollback discipline may be weaker"
fi

# 2) Secret leakage scan (defensive, low-noise)
if command -v rg >/dev/null 2>&1; then
  if rg -n \
    --glob '!skills/build-app-workflow/references/**' \
    "(sk-[A-Za-z0-9]{20,}|OPENAI_API_KEY\\s*=|BEGIN (RSA|EC|OPENSSH) PRIVATE KEY)" . \
    >/tmp/build-app-workflow-secrets.txt 2>/dev/null; then
    warn "Possible secrets detected: /tmp/build-app-workflow-secrets.txt"
  else
    pass "No obvious hardcoded secrets found"
  fi
else
  warn "ripgrep not installed; skip secret scan"
fi

# 3) Lockfile and manifest hints
if [ -f pnpm-lock.yaml ] || [ -f package-lock.json ] || [ -f yarn.lock ] || [ -f uv.lock ] || [ -f Cargo.lock ] || [ -f poetry.lock ]; then
  pass "At least one lockfile found"
else
  warn "No common lockfile found"
fi

[ -f package.json ] && pass "Node manifest: package.json"
[ -f pyproject.toml ] && pass "Python manifest: pyproject.toml"
[ -f Cargo.toml ] && pass "Rust manifest: Cargo.toml"

# 4) Toolchain availability hints (non-blocking)
command -v pnpm >/dev/null 2>&1 && pass "pnpm available" || warn "pnpm not found"
command -v uv >/dev/null 2>&1 && pass "uv available" || warn "uv not found"
command -v cargo >/dev/null 2>&1 && pass "cargo available" || warn "cargo not found"

printf "\nPreflight completed. Triaging warnings before implementation is recommended.\n"
