#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

ran=false

if [[ -f package.json ]] && node -e "const p=require('./package.json'); process.exit(p.scripts?.test ? 0 : 1)"; then
  if [[ -f pnpm-lock.yaml ]]; then pnpm test;
  elif [[ -f yarn.lock ]]; then yarn test;
  else npm test; fi
  ran=true
fi

if [[ -d tests ]] && [[ -f pyproject.toml || -f requirements.txt ]]; then
  if command -v uv >/dev/null 2>&1 && [[ -f pyproject.toml ]]; then
    uv run pytest
  else
    python3 -m pytest
  fi
  ran=true
fi

if [[ -f Cargo.toml ]]; then
  cargo test
  ran=true
fi

if [[ -f go.mod ]]; then
  go test ./...
  ran=true
fi

if [[ "$ran" == false ]]; then
  echo 'No supported test suite detected; test is a no-op.'
fi
