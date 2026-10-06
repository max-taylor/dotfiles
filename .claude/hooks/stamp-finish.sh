#!/usr/bin/env bash
# Run by /finish once it passes: records the diff hash, its line count and HEAD, so require-finish.sh only blocks again
# once the work grows past the threshold since this pass (or after a commit).
set -uo pipefail

HOOKS_DIR="$(cd "$(dirname "$0")" && pwd)"
echo "$("$HOOKS_DIR/diff-hash.sh") $("$HOOKS_DIR/diff-lines.sh") $(git rev-parse HEAD 2>/dev/null)" \
  >"$(git rev-parse --absolute-git-dir)/finish-stamp"
