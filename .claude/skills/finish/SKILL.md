---
description: Quality pass before reporting a change done. Runs the project's checks and two fresh-context Sonnet reviewers (reuse and simplification; efficiency and altitude), fixes what they find, then stamps the diff. Use after any change adding more than 250 lines.
allowed-tools: Read, Edit, Write, Glob, Grep, Bash, Agent
---

Run this before reporting work as done. Every step works on the uncommitted change (tracked diff plus untracked files).

Work silently: don't narrate steps or relay the reviewers' reports as they arrive. The only output is the step 7 report.

## 1. Scope

```bash
git status --porcelain
git diff HEAD --stat
```

Note the changed files and what the change is for. Ignore lockfiles and generated files (e.g. `generated.ts`) in every later step.

## 2. Checks

Find the package manager from the lockfile (`pnpm-lock.yaml` → pnpm, `package-lock.json` → npm, `yarn.lock` → yarn, `bun.lock` → bun).

- If the root `package.json` has a `check` script, run it.
- Otherwise run whichever of `typecheck`, `lint`, `format`, `test`, `dup`, `knip` exist, in parallel.
- If none exist, say so in the report and suggest `/harden`.

Fix every failure before continuing. Fix lint warnings in changed files too; a `complexity` or `max-lines-per-function` warning means extract, not suppress.

## 3. Review

Spawn two `general-purpose` subagents with `model: "sonnet"`, in one message so they run in parallel. They start with fresh context, so they aren't anchored to how the code was written. Give each the shared header plus its own questions, filled in:

> Review an uncommitted change in `<repo path>` for tech debt. Read-only: do not edit anything.
> Purpose of the change: `<one line>`. Changed files: `<list>`. See the diff with `git diff HEAD` and read the untracked files directly.
> Cite `file:line` for both the new code and any existing code you compare it with. Return findings most impactful first, each with a concrete fix, in under 300 words. Say "none" for an empty question. No style nits, no correctness bugs.

**Reviewer A: reuse and simplification**

> 1. **Re-implemented:** what does the change add that already exists in the repo (helpers, formatters, hooks, types, components, constants, contract-mirror maths)? Grep for it; only report matches you found.
> 2. **Derived twice:** what state or value is computed in more than one place, or recomputed inside a loop, where one pure function could produce it once?
> 3. **Simpler form:** redundant or derivable state, copy-paste with slight variation, dead code, unused exports or fields.
> 4. **Unrequested scope:** what does the change add beyond its purpose?
>
> Also name the closest existing sibling feature and compare it: file sizes, structure, handler style. Report deviations that aren't justified by a real difference in behaviour.

**Reviewer B: efficiency and altitude**

> 1. **Wasted work:** redundant computation or I/O, O(n²) lookups in render or loops, duplicate queries or timers, independent async steps run in sequence, unnecessary storage reads/writes or calldata in contracts. Only report real cost at realistic sizes.
> 2. **Altitude:** is each change made at the right depth? Flag special cases bolted onto shared code, workarounds where changing the underlying mechanism would be simpler, and code at the wrong level (route-local but shared, or shared with one caller, or a contract mirror outside the project's mirror location).

## 4. Apply

- Fix each finding you agree with. For one you reject, give the reason in the report.
- Scope findings (reviewer A, question 4) are the user's call: list them in the report instead of deleting code.
- If you changed anything, rerun step 2.

## 5. Learn

If a finding repeats a mistake that a lint rule could catch, or one already covered by `~/.claude/rules/engineering.md`, propose (don't apply) one of:

- a lint rule in the project's shared config, or
- a line in the project `CLAUDE.md` or `~/.claude/rules/engineering.md`.

## 6. Stamp

```bash
~/dotfiles/.claude/hooks/stamp-finish.sh
```

This tells the Stop hook that `/finish` passed on exactly this diff. Write it only when every step above passed. The hook only blocks again once the work grows by more than 250 lines past this pass, or after a commit.

## 7. Report

Use the normal completion format and keep it short: one line per item, grouped, no per-reviewer breakdown. Under SURPRISES, list findings that were fixed. Under CALLS, list rejected findings with the reason, scope findings left for the user, and any proposed lint or rule additions.
