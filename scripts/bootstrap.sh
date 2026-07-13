#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

MARKER_FILE='.template-initialized'

if [[ -f "$MARKER_FILE" ]]; then
  echo 'This repository has already been initialized.'
  exit 0
fi

./scripts/install-speckit.sh
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"

if command -v gh >/dev/null 2>&1; then
  PROJECT_NAME="$(gh repo view --json name --jq '.name' 2>/dev/null || basename "$ROOT_DIR")"
else
  PROJECT_NAME="$(basename "$ROOT_DIR")"
fi

if [[ "$PROJECT_NAME" == 'spec-kit-template' ]]; then
  echo 'Refusing to initialize the template source repository.' >&2
  echo 'Create a repository from this template, then run make init there.' >&2
  exit 1
fi

echo "==> Initializing Spec Kit for $PROJECT_NAME"
specify init --here --force \
  --integration codex \
  --integration-options='--skills' \
  --ignore-agent-tools

python3 - "$PROJECT_NAME" <<'PY'
from pathlib import Path
import sys

project_name = sys.argv[1]
for relative in ("README.md", "AGENTS.md", "CLAUDE.md"):
    path = Path(relative)
    if not path.exists():
        continue
    content = path.read_text(encoding="utf-8")
    path.write_text(content.replace("__PROJECT_NAME__", project_name), encoding="utf-8")
PY

cat > "$MARKER_FILE" <<EOF
project=${PROJECT_NAME}
spec_kit=$(tr -d '[:space:]' < .specify-version)
initialized_at=$(date -u +'%Y-%m-%dT%H:%M:%SZ')
EOF

./scripts/check.sh

cat <<'EOF'

Repository initialization completed.

Next steps:
1. Ask Codex to run $speckit-constitution.
2. Review .specify/memory/constitution.md.
3. Run make ci.
4. Commit and push the initialization changes.
EOF
