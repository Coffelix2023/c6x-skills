#!/usr/bin/env bash
set -euo pipefail

STACK="auto"
ROOT="."

usage() {
    cat <<USAGE
Usage:
  bash scripts/verify.sh [--stack auto|node|python|rust] [--root <path>]
  bash scripts/verify.sh [root]

Examples:
  bash scripts/verify.sh
  bash scripts/verify.sh --stack auto
  bash scripts/verify.sh --stack rust
  bash scripts/verify.sh --stack node --root .
USAGE
}

while [ "$#" -gt 0 ]; do
    case "$1" in
    --stack)
        [ "$#" -ge 2 ] || {
            echo "[FAIL] --stack requires a value"
            exit 2
        }
        STACK="$2"
        shift 2
        ;;
    --root)
        [ "$#" -ge 2 ] || {
            echo "[FAIL] --root requires a path"
            exit 2
        }
        ROOT="$2"
        shift 2
        ;;
    -h | --help)
        usage
        exit 0
        ;;
    -*)
        echo "[FAIL] Unknown option: $1"
        usage
        exit 2
        ;;
    *)
        ROOT="$1"
        shift
        ;;
    esac
done

case "$STACK" in
auto | node | python | rust) ;;
*)
    echo "[FAIL] Invalid --stack value: $STACK"
    usage
    exit 2
    ;;
esac

cd "$ROOT"

step=0
fail_count=0
ran_any=0

run_step() {
    local label="$1"
    shift
    step=$((step + 1))
    printf "\n[%d] %s\n" "$step" "$label"
    if "$@"; then
        printf "[PASS] %s\n" "$label"
    else
        printf "[FAIL] %s\n" "$label"
        fail_count=$((fail_count + 1))
    fi
}

has_npm_script() {
    local script_name="$1"
    [ -f package.json ] && rg -n "\"${script_name}\"\s*:" package.json >/dev/null 2>&1
}

run_node() {
    if [ ! -f package.json ]; then
        printf "[WARN] --stack node selected but package.json not found\n"
        return 2
    fi
    ran_any=1
    if command -v pnpm >/dev/null 2>&1; then
        has_npm_script lint && run_step "pnpm lint" pnpm lint || true
        has_npm_script test && run_step "pnpm test" pnpm test || true
        has_npm_script build && run_step "pnpm build" pnpm build || true
    else
        printf "[WARN] package.json exists but pnpm is unavailable\n"
        fail_count=$((fail_count + 1))
    fi
}

run_python() {
    if [ ! -f pyproject.toml ]; then
        printf "[WARN] --stack python selected but pyproject.toml not found\n"
        return 2
    fi
    ran_any=1
    if command -v uv >/dev/null 2>&1; then
        run_step "uv run pytest" uv run pytest
    elif command -v pytest >/dev/null 2>&1; then
        run_step "pytest" pytest
    else
        printf "[WARN] pyproject.toml exists but neither uv nor pytest is available\n"
        fail_count=$((fail_count + 1))
    fi
}

run_rust() {
    if [ ! -f Cargo.toml ]; then
        printf "[WARN] --stack rust selected but Cargo.toml not found\n"
        return 2
    fi
    ran_any=1
    if command -v cargo >/dev/null 2>&1; then
        run_step "cargo fmt --check" cargo fmt --check
        run_step "cargo clippy --all-targets --all-features -- -D warnings" cargo clippy --all-targets --all-features -- -D warnings
        run_step "cargo test" cargo test
    else
        printf "[WARN] Cargo.toml exists but cargo is unavailable\n"
        fail_count=$((fail_count + 1))
    fi
}

printf "build-app-workflow verify in: %s (stack=%s)\n" "$(pwd)" "$STACK"

case "$STACK" in
auto)
    [ -f package.json ] && run_node || true
    [ -f pyproject.toml ] && run_python || true
    [ -f Cargo.toml ] && run_rust || true
    ;;
node)
    run_node || true
    ;;
python)
    run_python || true
    ;;
rust)
    run_rust || true
    ;;
esac

if [ "$ran_any" -eq 0 ]; then
    printf "[WARN] No applicable checks ran for stack '%s' (manifests missing)\n" "$STACK"
    exit 2
fi

if [ "$fail_count" -gt 0 ]; then
    printf "\nVerification failed: %d step(s) failed.\n" "$fail_count"
    exit 1
fi

printf "\nVerification passed.\n"
