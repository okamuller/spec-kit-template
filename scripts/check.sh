#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

required_files=(
  README.md
  AGENTS.md
  Makefile
  .specify-version
  .devcontainer/devcontainer.json
  scripts/bootstrap.sh
  scripts/setup.sh
  scripts/check.sh
  scripts/test.sh
  scripts/ci.sh
)

for path in "${required_files[@]}"; do
  [[ -e "$path" ]] || { echo "Missing required file: $path" >&2; exit 1; }
done

while IFS= read -r -d '' script; do
  bash -n "$script"
done < <(find scripts .devcontainer -type f -name '*.sh' -print0)

python3 - <<'PY'
import json
from pathlib import Path

json.loads(Path('.devcontainer/devcontainer.json').read_text(encoding='utf-8'))
PY

if [[ -f .template-initialized ]]; then
  [[ -d .specify ]] || { echo 'Missing .specify after initialization' >&2; exit 1; }
  [[ -d .agents/skills ]] || { echo 'Missing Codex skills after initialization' >&2; exit 1; }
  if grep -R --exclude-dir=.git --exclude='.template-initialized' -n '__PROJECT_NAME__' README.md AGENTS.md CLAUDE.md >/dev/null; then
    echo 'Unexpanded project-name placeholder found' >&2
    exit 1
  fi
fi

if [[ -f package.json ]] && node -e "const p=require('./package.json'); process.exit(p.scripts?.lint ? 0 : 1)"; then
  if [[ -f pnpm-lock.yaml ]]; then pnpm run lint;
  elif [[ -f yarn.lock ]]; then yarn lint;
  else npm run lint; fi
fi

if [[ -f pyproject.toml ]] && command -v uv >/dev/null 2>&1; then
  if uv run --no-sync ruff --version >/dev/null 2>&1; then
    uv run --no-sync ruff check .
  fi
fi

if command -v shellcheck >/dev/null 2>&1; then
  find scripts .devcontainer -type f -name '*.sh' -print0 | xargs -0 shellcheck
fi

echo 'Checks passed.'
