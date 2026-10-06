# Engineering Process

Tech debt grows when every change adds its own helpers and derivations. These rules keep new code lean.

## Before writing

- Search first. Before adding a helper, formatter, hook, type or component, grep for an existing one, then reuse or extend it.
- Every plan has a **Reuse** section: what is reused (with paths) and what is new (one-line reason each).
- Mirror the closest existing feature: structure, handler style, file layout. Call out deviations in the plan.
- Build only what was asked. Ask before adding derived values, stats or UI nobody requested.

## While writing

- Derive state once. Business rules live in one pure, tested function; hooks and components call it and format the result.
- Extract a function that passes ~150 lines, and any logic that appears twice.
- Split large work (e.g. contract + refactor + feature) into separately reviewable steps.

## Before reporting done

- Run `/finish` when a change touches more than 3 files or adds more than 150 lines.
- If the project has no `check` script, suggest `/harden`.
