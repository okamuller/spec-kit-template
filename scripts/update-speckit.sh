#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

VERSION="${1:-}"
if [[ ! "$VERSION" =~ ^v[0-9]+\.[0-9]+\.[0-9]+([-.+][A-Za-z0-9.-]+)?$ ]]; then
  echo 'Usage: scripts/update-speckit.sh vX.Y.Z' >&2
  exit 1
fi

printf '%s\n' "$VERSION" > .specify-version
./scripts/install-speckit.sh
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"

if [[ -f .template-initialized ]]; then
  specify init --here --force \
    --integration codex \
    --integration-options='--skills' \
    --ignore-agent-tools
  python3 - "$VERSION" <<'PY'
from pathlib import Path
import sys

path = Path('.template-initialized')
version = sys.argv[1]
lines = path.read_text(encoding='utf-8').splitlines()
updated = []
seen = False
for line in lines:
    if line.startswith('spec_kit='):
        updated.append(f'spec_kit={version}')
        seen = True
    else:
        updated.append(line)
if not seen:
    updated.append(f'spec_kit={version}')
path.write_text('\n'.join(updated) + '\n', encoding='utf-8')
PY
else
  echo 'Template pin updated. Generated Spec Kit files are created only in initialized derived repositories.'
fi

./scripts/check.sh
