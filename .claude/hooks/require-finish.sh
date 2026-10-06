#!/usr/bin/env bash
# Keeps large changes from being reported done before /finish has passed on them.
#
#   require-finish.sh start   UserPromptSubmit: records the diff hash at the start of the turn.
#   require-finish.sh stop    Stop: blocks the end of the turn if this turn changed code and the uncommitted change has
#                             grown by more than THRESHOLD lines since /finish last passed (or since HEAD).
#
# Only turns that edit code are checked, so Q&A over an already-large diff isn't blocked.
# State lives in the repo's git dir (never committed): finish-stamp (written by /finish) and one turn-start file per
# session, so concurrent sessions in the same repo don't clash.
set -uo pipefail

MODE=${1:-stop}
THRESHOLD=250
HOOKS_DIR="$(cd "$(dirname "$0")" && pwd)"

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

# Measure growth since /finish last passed, unless a commit has happened since (then the stamp is stale).
stamp_hash="" stamp_lines=0 stamp_head=""
[ -f "$git_dir/finish-stamp" ] && read -r stamp_hash stamp_lines stamp_head <"$git_dir/finish-stamp"
[ "$stamp_hash" = "$current" ] && exit 0
[ "$stamp_head" = "$(git rev-parse HEAD 2>/dev/null)" ] || stamp_lines=0

added=$(( $("$HOOKS_DIR/diff-lines.sh") - ${stamp_lines:-0} ))
[ "$added" -le "$THRESHOLD" ] && exit 0

jq -n --arg added "$added" '{
  decision: "block",
  reason: ("This change adds \($added) lines that /finish has not passed on. Run /finish, fix what it finds, then report.")
}'
