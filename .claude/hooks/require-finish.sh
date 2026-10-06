#!/usr/bin/env bash
# Keeps large changes from being reported done before /finish has passed on them.
#
#   require-finish.sh start   UserPromptSubmit: records the diff hash at the start of the turn.
#   require-finish.sh stop    Stop: blocks the end of the turn if this turn changed code, the uncommitted change is
#                             large, and /finish hasn't stamped the current diff.
#
# Only turns that edit code are checked, so Q&A over an already-large diff isn't blocked.
# State lives in the repo's git dir (never committed): finish-stamp (written by /finish) and one turn-start file per
# session, so concurrent sessions in the same repo don't clash.
set -uo pipefail

MODE=${1:-stop}
THRESHOLD=${FINISH_LINE_THRESHOLD:-150}
HOOKS_DIR="$(cd "$(dirname "$0")" && pwd)"
# Lockfiles and generated code inflate the count without being reviewable.
EXCLUDES=(':!*.lock' ':!pnpm-lock.yaml' ':!package-lock.json' ':!**/generated.ts' ':!**/generated/**')

input=$(cat)
field() { jq -r ".$1 // empty" <<<"$input"; }

cd "$(field cwd)" 2>/dev/null || exit 0
git_dir=$(git rev-parse --absolute-git-dir 2>/dev/null) || exit 0
session=$(field session_id)
turn_start="$git_dir/finish-turn-start-${session:-default}"
current=$("$HOOKS_DIR/diff-hash.sh")

if [ "$MODE" = "start" ]; then
  echo "$current" >"$turn_start"
  exit 0
fi

# Blocked once already this turn: let it stop rather than loop.
[ "$(field stop_hook_active)" = "true" ] && exit 0
# No record of the turn's start (e.g. the hook was registered mid-session): don't guess, let it stop.
[ -f "$turn_start" ] || exit 0
# Nothing changed this turn.
[ "$(cat "$turn_start")" = "$current" ] && exit 0
# /finish already passed on exactly this diff.
[ -f "$git_dir/finish-stamp" ] && [ "$(cat "$git_dir/finish-stamp")" = "$current" ] && exit 0

tracked=$(git diff HEAD --numstat -- . "${EXCLUDES[@]}" 2>/dev/null | awk '{ s += $1 } END { print s + 0 }')
untracked=$(git ls-files --others --exclude-standard -z -- . "${EXCLUDES[@]}" | xargs -0 cat 2>/dev/null | wc -l | tr -d ' ')
added=$((tracked + untracked))
[ "$added" -le "$THRESHOLD" ] && exit 0

jq -n --arg added "$added" '{
  decision: "block",
  reason: ("This change adds \($added) lines and /finish has not passed on it. Run /finish, fix what it finds, then report.")
}'
