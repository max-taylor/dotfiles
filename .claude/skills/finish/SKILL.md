---
description: Quality pass before reporting a change done. Runs the project's checks, /simplify and an independent reviewer that hunts for re-implemented code, repeated derivations and unrequested scope; fixes what they find, then stamps the diff. Use after any change touching more than 3 files or adding more than 150 lines.
allowed-tools: Read, Edit, Write, Glob, Grep, Bash, Agent, Skill
---

Run this before reporting work as done. Every step works on the uncommitted change (tracked diff plus untracked files).

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

## 3. Simplify

Invoke the `simplify` skill on the change and keep its fixes.

## 4. Independent review

Spawn one `general-purpose` subagent. It starts with fresh context, so it isn't anchored to how the code was written. Give it this prompt, filled in:

> Review an uncommitted change in `<repo path>` for tech debt. Read-only: do not edit anything.
> Purpose of the change: `<one line>`. Changed files: `<list>`. See the diff with `git diff HEAD` and read the untracked files directly.
>
> Answer three questions, citing `file:line` for both the new code and the existing code:
>
> 1. **Re-implemented:** what does the change add that already exists in the repo (helpers, formatters, hooks, types, components, constants)? Grep for it; only report matches you found.
> 2. **Derived twice:** what state or value is computed in more than one place, or recomputed inside a loop, where one pure function could produce it once?
> 3. **Unrequested scope:** what does the change add beyond its purpose?
>
> Also name the closest existing sibling feature and compare it: file sizes, structure, handler style. Report deviations that aren't justified by a real difference in behaviour.
>
> Return a list of findings, most impactful first, each with a concrete fix. Say "none" for an empty question. No style nits.

## 5. Apply

- Fix each finding you agree with. For one you reject, give the reason in the report.
- Scope findings (question 3) are the user's call: list them in the report instead of deleting code.
- If you changed anything, rerun step 2.

## 6. Learn

If a finding repeats a mistake that a lint rule could catch, or one already covered by `~/.claude/rules/engineering.md`, propose (don't apply) one of:

- a lint rule in the project's shared config, or
- a line in the project `CLAUDE.md` or `~/.claude/rules/engineering.md`.

## 7. Stamp

```bash
~/dotfiles/.claude/hooks/diff-hash.sh > "$(git rev-parse --absolute-git-dir)/finish-stamp"
```

This tells the Stop hook that `/finish` passed on exactly this diff. Write it only when every step above passed. Any later edit changes the hash and requires another `/finish`.

## 8. Report

Use the normal completion format. Under SURPRISES, list findings that were fixed (one line each). Under CALLS, list rejected findings with the reason, scope findings left for the user, and any proposed lint or rule additions.
