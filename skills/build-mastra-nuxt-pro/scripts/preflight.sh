#!/usr/bin/env bash
set -euo pipefail

echo "[preflight] checking Node.js version..."
if ! command -v node >/dev/null 2>&1; then
    echo "ERROR: node is not installed"
    exit 1
fi

NODE_VERSION_RAW="$(node -v | sed 's/^v//')"
NODE_MAJOR="$(echo "$NODE_VERSION_RAW" | cut -d. -f1)"
NODE_MINOR="$(echo "$NODE_VERSION_RAW" | cut -d. -f2)"

if [ "$NODE_MAJOR" -lt 22 ] || { [ "$NODE_MAJOR" -eq 22 ] && [ "$NODE_MINOR" -lt 13 ]; }; then
    echo "ERROR: Node.js >= 22.13.0 required, current: v$NODE_VERSION_RAW"
    exit 1
fi
echo "OK: node v$NODE_VERSION_RAW"

echo "[preflight] checking pnpm..."
if ! command -v pnpm >/dev/null 2>&1; then
    echo "ERROR: pnpm is not installed"
    exit 1
fi
echo "OK: pnpm $(pnpm -v)"

echo "[preflight] complete"
