#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

if [[ ! -f .specify-version ]]; then
  echo 'Missing .specify-version' >&2
  exit 1
fi

SPECIFY_VERSION="$(tr -d '[:space:]' < .specify-version)"
if [[ ! "$SPECIFY_VERSION" =~ ^v[0-9]+\.[0-9]+\.[0-9]+([-.+][A-Za-z0-9.-]+)?$ ]]; then
  echo "Invalid Spec Kit version: $SPECIFY_VERSION" >&2
  exit 1
fi

if ! command -v uv >/dev/null 2>&1; then
  echo '==> Installing uv'
  curl -LsSf https://astral.sh/uv/install.sh | sh
fi

export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"

EXPECTED_VERSION="${SPECIFY_VERSION#v}"
CURRENT_VERSION=''
if command -v specify >/dev/null 2>&1; then
  CURRENT_VERSION="$(specify --version 2>/dev/null | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+([-.+][A-Za-z0-9.-]+)?' | head -n 1 || true)"
fi

if [[ "$CURRENT_VERSION" == "$EXPECTED_VERSION" ]]; then
  echo "==> Spec Kit $SPECIFY_VERSION is already installed"
else
  echo "==> Installing Spec Kit $SPECIFY_VERSION"
  uv tool install specify-cli --force \
    --from "git+https://github.com/github/spec-kit.git@${SPECIFY_VERSION}"
fi

specify --version
