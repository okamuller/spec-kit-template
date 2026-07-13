#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

printf '%s\n' '==> Preparing Codespace'
chmod +x .devcontainer/*.sh scripts/*.sh

./scripts/install-speckit.sh
./scripts/setup.sh

printf '\n%s\n' 'Codespace setup completed.'
if [[ -f .template-initialized ]]; then
  printf '%s\n' 'This repository is already initialized. Run: make ci'
else
  printf '%s\n' 'Initialize this repository once by running: make init'
fi
