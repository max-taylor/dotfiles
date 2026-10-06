# Claude Code config

Global Claude Code setup, shared by every project. `setup.sh` links it into `~/.claude`.

| Path                  | Linked to                     | Purpose                                                         |
| --------------------- | ----------------------------- | --------------------------------------------------------------- |
| `claude.md`           | `~/.claude/CLAUDE.md`         | Global instructions: index of the rules and quality workflow    |
| `rules/`              | `~/.claude/rules`             | Rule files, auto-loaded in every session                        |
| `output-styles/`      | `~/.claude/output-styles`     | `terse`, the default style                                      |
| `settings.local.json` | `~/.claude/settings.local.json` | Output style, permissions, hooks                              |
| `skills/<name>/`      | `~/.claude/skills/<name>`     | Slash-command skills, one link each                             |
| `hooks/`              | (used in place)               | Hook scripts, referenced as `$HOME/dotfiles/.claude/hooks/...` |

## Rules

- `engineering.md`: process. Search before writing, reuse, mirror the closest sibling feature, derive state once, build only what was asked, `/finish` before done.
- `react.md`: controller-view-hook pattern and folder structure.
- `typescript.md`: type conventions, no `any`.
- `style.md`: naming and simplicity.
- `documentation.md`: keep READMEs in sync with code.

Rules load at session start, then get buried as the context grows. The key lines are re-sent on every prompt by the `UserPromptSubmit` hook (below).

## Quality workflow

Goal: stop tech debt building up from changes that re-implement existing code, derive the same state in several places, or add unrequested scope. There are three layers, each catching what the previous one misses.

**1. Prevent: rules plus a per-prompt reminder.** `rules/engineering.md` holds the full process. Its summary is appended to the terse-style reminder that `settings.local.json` echoes on every prompt, so it stays in recent context.

**2. Detect: `/harden`, once per repo.** It adds mechanical checks that apply to every change, whoever wrote it:

- `jscpd` (duplication) and `knip` (dead code)
- ESLint `complexity` and `max-lines` warnings
- `vitest` for pure modules
- one `check` script, run in CI

It proposes the changes first and applies them only after approval. Existing violations are baselined, so only new code is held to the limits.

**3. Review: `/finish`, before a large change is reported done.** It runs:

- the project's checks
- two fresh-context reviewer subagents on Sonnet, in parallel:
  - reuse and simplification: re-implemented code, repeated derivations, dead code, unrequested scope, drift from the closest sibling feature
  - efficiency and altitude: wasted work (renders, queries, gas) and fixes made at the wrong depth

They replace the built-in `/simplify`, which runs four agents on the session model (Opus) and costs about three times as much.

It fixes what they find, proposes lint or rule additions for recurring issues, then stamps the diff.

### Enforcement: the Stop hook

`hooks/require-finish.sh` runs twice per turn:

- `start` (`UserPromptSubmit`): records a hash of the uncommitted work (`hooks/diff-hash.sh`).
- `stop` (`Stop`): blocks the end of the turn when all of these are true:
  - the turn changed code (the hash moved), and
  - the change adds more than 150 lines, not counting lockfiles and generated files (override with `FINISH_LINE_THRESHOLD`), and
  - `/finish` hasn't stamped the current diff.

Blocking makes Claude carry on and run `/finish`. Any edit after the stamp changes the hash, so it needs another `/finish`.

The state files live in the repo's git dir, so nothing needs gitignoring: `finish-stamp`, plus one `finish-turn-start-<session>` per session, so concurrent sessions don't clash. The hook allows the stop rather than guessing when it can't tell: outside git, with no turn-start record, or when the turn was already blocked once (no loops).

Requires `jq` and `shasum` (both ship with macOS).

## Other skills

- `/check`: run the repo's CI checks locally.
- `/pr`: write the PR description and create or update the PR.
- `/create-prd`, `/prd-to-tasks`, `/next-task`: PRD → task list → implement one task at a time.
- `/testing-plan`: unit testing plan for a file.

## Adding things

- **Rule:** add a `.md` to `rules/` (scope it with `paths:` frontmatter if needed), and list it in `claude.md` and above.
- **Skill:** add `skills/<name>/SKILL.md`, then rerun `setup.sh` (or `ln -s` it into `~/.claude/skills`).
- **Hook:** add the script to `hooks/` and register it in `settings.local.json` by its `$HOME/dotfiles/.claude/hooks/...` path.
