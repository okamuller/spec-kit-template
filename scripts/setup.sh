#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

installed=false

if [[ -f pnpm-lock.yaml ]]; then
  corepack enable
  pnpm install --frozen-lockfile
  installed=true
elif [[ -f package-lock.json ]]; then
  npm ci
  installed=true
elif [[ -f yarn.lock ]]; then
  corepack enable
  yarn install --immutable
  installed=true
elif [[ -f package.json ]]; then
  npm install
  installed=true
fi

if [[ -f uv.lock ]]; then
  command -v uv >/dev/null 2>&1 || { echo 'uv is required for uv.lock' >&2; exit 1; }
  uv sync --frozen --all-extras
  installed=true
elif [[ -f pyproject.toml ]]; then
  command -v uv >/dev/null 2>&1 || { echo 'uv is required for pyproject.toml' >&2; exit 1; }
  uv sync --all-extras
  installed=true
elif [[ -f requirements.txt ]]; then
  python3 -m pip install -r requirements.txt
  installed=true
fi

if [[ -f Cargo.toml ]]; then
  cargo fetch
  installed=true
fi

if [[ -f go.mod ]]; then
  go mod download
  installed=true
fi

if [[ "$installed" == false ]]; then
  echo 'No project dependency manifest detected; setup is a no-op.'
fi
