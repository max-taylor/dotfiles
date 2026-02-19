---
description: Pick the next unblocked task from the task list and implement it with quality gates, code review, and progress tracking.
argument-hint: "[optional: specific task number e.g. 2.1, or path to task file]"
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
disable-model-invocation: true
---

# Project context

CLAUDE.md:
!`cat CLAUDE.md 2>/dev/null || echo "No CLAUDE.md found"`

Available scripts:
!`cat package.json 2>/dev/null | python3 -c "import sys,json; scripts=json.load(sys.stdin).get('scripts',{}); [print(f'  {k}: {v}') for k,v in scripts.items()]" 2>/dev/null || echo "No package.json scripts found"`

Task files:
!`ls tasks/tasks-*.md 2>/dev/null || echo "No task files found in tasks/"`

---

You are an autonomous coding agent. You will pick ONE task, implement it, pass all quality gates, and commit.

## Additional context (if provided)

$ARGUMENTS

## Step 0: Load Task List

1. Read all task files in `tasks/`. If a specific task file or number was provided in arguments, use that.
2. If no task files exist, tell the user to run `/generate-tasks` first and stop.
3. Parse the markdown checkboxes to identify task status:
   - `- [ ]` = pending
   - `- [x]` = complete
   - `- [~]` = in progress (treat as pending)

## Step 1: Select Task

If a specific task number was provided in arguments, use that task.

Otherwise, find the **next available task** by:

1. Scan parent tasks in order (1.0, 2.0, 3.0...)
2. Check **Dependencies** — all listed dependencies must be `[x]` complete
3. Pick the first parent task where dependencies are satisfied and task is `- [ ]`
4. If the parent has sub-tasks, pick the first incomplete sub-task

**Announce the selected task** — print its number, title, dependencies, requirements, and test criteria. Then proceed.

## Step 2: Complexity Assessment

Before writing code, assess:

- How many files will this touch?
- Does it modify shared utilities, state, or APIs?
- Is it a UI change?

If the task touches **3+ files or modifies shared code**, write an implementation plan first:

- List files to create/modify
- Describe changes per file
- Identify risks

Then execute the plan.

## Step 3: Implement

Write the code. Follow existing codebase patterns. Keep changes minimal and focused on this single task.

## Step 4: Quality Gate — Hard Checks

Run ALL available checks. Determine what's available from CLAUDE.md and package.json scripts above:

- **Typecheck**: `tsc --noEmit`, `next build`, or equivalent
- **Lint**: `eslint`, `biome`, or equivalent
- **Tests**: `vitest`, `jest`, `npm test`, or equivalent
- **Format**: `prettier --check`, `biome check`, or equivalent

Run what exists. Skip what doesn't. **Do NOT proceed if any check fails. Fix issues first.**

## Step 5: Quality Gate — Static Analysis

Run secondary tools IF they're already installed in the project:

- `knip` — dead code / unused exports
- `jscpd` — copy-paste detection

If not installed, skip. Do NOT install new tools. **Fix any issues found.**

## Step 6: Diff Size Gate

Run `git diff --stat`. If the diff exceeds **15 files changed** or **500 lines added**:

- Log a warning in `progress.txt`
- Note the task should be split in future iterations
- Continue, but flag it

## Step 7: Code Review

Invoke `/review` to review your changes.

**If review returns critical issues:** Fix them, then re-run from Step 4.
**If review passes:** Proceed to Step 8.

## Step 8: Browser QA (UI Stories Only)

If the task touches any file under `src/components/`, `app/`, `pages/`, or modifies JSX/TSX:

1. Start the dev server if not running
2. Navigate to the affected page
3. Verify the change works visually
4. Check for regressions on the same page

**A UI task is NOT complete without browser verification.**

## Step 9: Fix Loop (Max 3 Cycles)

If any step above fails:

- Fix the issue
- Re-run from Step 4
- Maximum 3 cycles

If still failing after 3 cycles:

- `git checkout -- .` to reset changes
- Log the failure in `progress.txt` with what went wrong
- Do NOT mark the task complete
- Stop execution

## Step 10: Commit

Only after ALL gates pass:

1. Stage changes: `git add -A`
2. Commit: `feat(tasks): [task number] - [task title]`
3. Update the task file — change `- [ ]` to `- [x]` for the completed task
4. If all sub-tasks of a parent are `[x]`, mark the parent `[x]` too
5. Commit task file update: `chore: mark task [number] complete`

## Step 11: Update Progress

Create `progress.txt` if it doesn't exist. **Append** (never replace):

```
## [Date] - Task [number]: [title]
- What was implemented
- Files changed
- Checks run and results
- Requirements covered: REQ-XXX
- **Learnings:**
  - Patterns discovered
  - Gotchas encountered
---
```

If you discovered a **reusable pattern**, also add it to `## Codebase Patterns` at the top of `progress.txt`.

## Step 12: Status Report

After completion, report:

- ✅ Task completed: [number] - [title]
- Files changed: [count]
- All checks passed: [list what ran]
- Remaining tasks: [count of incomplete tasks]

Check if ALL tasks across all task files are `[x]`:

- If yes: "🎉 All tasks complete!"
- If tasks remain: "Next available task: [number] - [title]"

## Rules

- **ONE task per invocation.** Do not chain tasks.
- **NEVER commit broken code.** All gates must pass.
- **NEVER skip quality gates.**
- **If unsure about a check command**, read package.json or CLAUDE.md before guessing.
- **Match existing patterns.** Read surrounding code before writing new code.
