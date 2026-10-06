#!/usr/bin/env bash
# Hash of all uncommitted work in the current repo: the tracked diff plus untracked files.
# Shared by /finish (writes it as the stamp) and require-finish.sh (compares against it), so both agree exactly.
set -uo pipefail

{
  git diff HEAD --binary 2>/dev/null
  git ls-files --others --exclude-standard -z | xargs -0 shasum 2>/dev/null
} | shasum | cut -d' ' -f1
