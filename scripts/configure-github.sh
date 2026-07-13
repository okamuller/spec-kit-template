#!/usr/bin/env bash
set -euo pipefail

command -v gh >/dev/null 2>&1 || { echo 'GitHub CLI (gh) is required.' >&2; exit 1; }

# Codespaces injects a short-lived repository token. It is sufficient for normal
# source control operations, but it usually cannot update repository settings.
# An explicitly supplied admin token takes precedence when available.
if [[ -n "${GH_ADMIN_TOKEN:-}" ]]; then
  export GH_TOKEN="$GH_ADMIN_TOKEN"
  unset GITHUB_TOKEN
fi

gh auth status >/dev/null
REPOSITORY="$(gh repo view --json nameWithOwner --jq '.nameWithOwner')"

echo "==> Configuring $REPOSITORY"

if ! ERROR_OUTPUT="$(
  gh api --method PATCH "repos/$REPOSITORY" \
    -F is_template=true \
    -F has_issues=true \
    -F has_wiki=false \
    -F delete_branch_on_merge=true \
    -F allow_squash_merge=true \
    -F allow_merge_commit=false \
    -F allow_rebase_merge=false \
    2>&1
)"; then
  if [[ "$ERROR_OUTPUT" == *'Resource not accessible by integration'* ]]; then
    cat >&2 <<EOF
GitHub rejected the Codespaces integration token because changing repository
settings requires Administration (write) permission.

Use either method below.

A. Recommended one-time UI setup
   1. Open https://github.com/$REPOSITORY/settings
   2. Under General, enable "Template repository".
   3. Under Pull Requests, enable squash merging and disable merge commits and rebasing.
   4. Enable automatic deletion of head branches.

B. Run this command with a fine-grained personal access token
   - Repository access: $REPOSITORY
   - Repository permission: Administration = Read and write

   Save it as a Codespaces secret named GH_ADMIN_TOKEN, reopen the Codespace,
   then run:

     make github-config

No source-code change is required when method A is used.
EOF
    exit 2
  fi

  echo "$ERROR_OUTPUT" >&2
  exit 1
fi

cat <<EOF
Configured $REPOSITORY as a template repository with squash-only merging.

Recommended manual follow-up:
- Add a main-branch ruleset requiring pull requests and CI.
- Require conversation resolution before merging.
- Disable force pushes and branch deletion for main.
EOF
