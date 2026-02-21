# Adapter: Python generic

Use this adapter for Python repositories.

## Typical verify sequence

1. `uv run pytest` (preferred) or `pytest`
2. project-specific lint/type checks if configured

## Notes

- Keep dependency management centralized (`uv.lock` preferred).
- Validate Python version constraints before running tests.
