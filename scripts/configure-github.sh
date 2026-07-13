#!/usr/bin/env bash
set -euo pipefail

command -v gh >/dev/null 2>&1 || { echo 'GitHub CLI (gh) is required.' >&2; exit 1; }
gh auth status >/dev/null

REPOSITORY="$(gh repo view --json nameWithOwner --jq '.nameWithOwner')"

echo "==> Configuring $REPOSITORY"
gh api --method PATCH "repos/$REPOSITORY" \
  -F is_template=true \
  -F has_issues=true \
  -F has_wiki=false \
  -F delete_branch_on_merge=true \
  -F allow_squash_merge=true \
  -F allow_merge_commit=false \
  -F allow_rebase_merge=false \
  >/dev/null

cat <<EOF
Configured $REPOSITORY as a template repository with squash-only merging.

Recommended manual follow-up:
- Add a main-branch ruleset requiring pull requests and CI.
- Require conversation resolution before merging.
- Disable force pushes and branch deletion for main.
EOF
