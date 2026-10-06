#!/usr/bin/env bash
# Lines added by the uncommitted work in the current repo (tracked diff plus untracked files), counting only reviewable
# code. Shared by /finish (records it in the stamp) and require-finish.sh (compares against it), so both agree exactly.
set -uo pipefail

# Lockfiles, generated code, docs, config and snapshots inflate the count without being reviewable.
EXCLUDES=(':!*.lock' ':!pnpm-lock.yaml' ':!package-lock.json' ':!**/generated.ts' ':!**/generated/**'
  ':!*.md' ':!*.json' ':!**/__snapshots__/**')

tracked=$(git diff HEAD --numstat -- . "${EXCLUDES[@]}" 2>/dev/null | awk '{ s += $1 } END { print s + 0 }')
untracked=$(git ls-files --others --exclude-standard -z -- . "${EXCLUDES[@]}" | xargs -0 cat 2>/dev/null | wc -l | tr -d ' ')
echo $((tracked + untracked))
