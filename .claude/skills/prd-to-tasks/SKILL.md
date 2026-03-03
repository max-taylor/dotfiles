---
description: Convert docs/prd.md into a structured, dependency-aware task list with test criteria and requirement traceability.
argument-hint: "[optional: additional context or constraints]"
allowed-tools: Read, Write, Glob, Grep
disable-model-invocation: true
---

# PRD Content

!`cat docs/prd.md 2>/dev/null || echo "ERROR: No PRD found at docs/prd.md. Run /create-prd first."`

# Existing codebase patterns

Test patterns:
!`find . -maxdepth 3 -name "*.test.*" -o -name "*.spec.*" | grep -v node_modules | head -10`

Source structure:
!`find ./src -maxdepth 2 -type d 2>/dev/null | head -20 || echo "No src/ directory"`

---

You are a senior developer breaking down a PRD into an implementable task list. The PRD and codebase context are above — use them.

## Additional context (if provided)

$ARGUMENTS

## Process

1. **Verify PRD exists.** If the preprocessed PRD content above says ERROR, tell the user to run `/create-prd` first and stop.
2. **Identify logical work phases** — setup, core implementation, integration, testing.
3. **Phase 1 — Generate parent tasks.** Create 4-8 high-level tasks covering the full PRD scope. Present them and say: "Here are the high-level tasks. Reply 'go' to generate sub-tasks, or suggest changes."
4. **Wait for user confirmation.**
5. **Phase 2 — Generate sub-tasks.** Break each parent into 2-6 atomic sub-tasks. Each should be completable in a single Claude Code session.
6. **Save** to `tasks/tasks-[feature-name].md`.

## Output Format

```markdown
# Tasks: [Feature Name]

> Source: docs/prd.md
> Generated: [date]

## Relevant Files

- `path/to/file.ts` - Why this file is relevant
- `path/to/file.test.ts` - Tests for the above

## Tasks

- [ ] 1.0 [Parent Task Title]
  - **Dependencies:** none
  - **Requirements:** REQ-001, REQ-002
  - **Test:** [Concrete verification — command to run, endpoint to hit, behavior to confirm]
  - Sub-tasks:
  - [ ] 1.1 [Sub-task description]
  - [ ] 1.2 [Sub-task description]

- [ ] 2.0 [Parent Task Title]
  - **Dependencies:** 1.0
  - **Requirements:** REQ-003
  - **Test:** [Concrete verification]
  - Sub-tasks:
  - [ ] 2.1 [Sub-task description]
  - [ ] 2.2 [Sub-task description]
```

## Rules

### Task Design
- Each sub-task: one clear thing, verifiable, completable in one session.
- Tasks >30min of work should be split further.
- Final task should always be integration testing / smoke test.
- Group by feature area, not by file type.

### Dependencies
- Only list true blockers, not soft preferences.
- Tasks with no dependencies can be parallelized.

### Test Strategy
- Every parent task needs a **Test** field with a concrete check.
- Prefer: "Run `npm test`, hit endpoint X, confirm Y" over "ensure it works."
- Match existing test patterns from the codebase context above.

### Traceability
- Every parent task references which PRD requirements (REQ-XXX) it fulfills.
- All PRD requirements must be covered by at least one task.
- Uncoverable requirements go under "## Deferred / Out of Scope" at the bottom.

### Completion Tracking
Mark done: `- [ ]` → `- [x]`. Update after each sub-task.
