---
description: Add tech-debt guardrails to a repo - duplication (jscpd) and dead-code (knip) scans, ESLint complexity and size limits, a unit test runner, and a single `check` script wired into CI. Proposes the changes first, applies them after approval, and baselines existing violations so only new code is held to the limits.
argument-hint: "[optional: packages or paths to focus on]"
allowed-tools: Read, Edit, Write, Glob, Grep, Bash
disable-model-invocation: true
---

Set up guardrails that catch tech debt mechanically, for every change, whoever wrote it. JS/TS projects only; for anything else, list the equivalent tools for that stack and stop.

## 1. Inspect

Work out, without changing anything:

- Package manager (from the lockfile) and workspace layout: single package, or a pnpm/yarn/npm workspace, with or without turbo or nx.
- Lint setup: ESLint version, flat config or legacy, and whether there's a shared config package (e.g. `tooling/eslint-config`).
- Format, typecheck and test scripts per package, and which packages have pure logic (`lib/`, `_lib/`, `utils/`) without tests.
- CI: `.github/workflows/*`.
- Generated code, build output and fixtures that the scans must ignore.

## 2. Propose

Show the plan as a short list of files to add or change, then wait for approval. Use the shared catalog (`catalog:`) or the existing version-pinning convention for new dependencies.

1. **Duplication: `jscpd`.** Dev dependency at the root, `.jscpd.json` with `"gitignore": true`, `minLines: 10`, `minTokens: 70`, `ignore` for tests, stories, mocks and generated files, `reporters: ["console"]`, and a root `dup` script.
2. **Dead code: `knip`.** Dev dependency at the root, `knip.json` (with `workspaces` in a monorepo; let its plugins detect Next, Vite, Storybook, Vitest etc.), and a root `knip` script.
3. **Size and complexity: ESLint.** In the shared config (or the root config if there isn't one), as warnings:
   - `complexity: ["warn", 15]`
   - `max-lines-per-function: ["warn", { max: 150, skipBlankLines: true, skipComments: true }]`
   - `max-lines: ["warn", { max: 400, skipBlankLines: true, skipComments: true }]`

   Turn them off for tests, stories, mocks, config and generated files.
4. **Tests: `vitest`.** For each package with pure logic and no runner: a dev dependency, a minimal config (reusing the package's path aliases), and a `test` script. Don't write tests; just make them possible.
5. **One entry point: `check`.** A root script that runs format, lint, typecheck, test, `dup` and `knip`, through turbo or nx when present (add the tasks to `turbo.json`).
6. **CI.** Run `check` on pull requests: extend the existing workflow, or add `.github/workflows/check.yml` using the project's Node version and package manager.
7. **Docs.** One line in the project `CLAUDE.md`: run `<pm> check` before reporting work done.

## 3. Apply

After approval, make the changes and install the dependencies.

## 4. Baseline

Run `check` once. Don't mass-fix existing violations; that's a separate decision for the user. Make it pass on the current code instead:

- **jscpd:** set `threshold` to the current duplication percentage, rounded up.
- **knip:** for findings in old code, add narrow `ignore` / `ignoreDependencies` entries with a `// baseline` note where the format allows it.
- **ESLint:** the limits are warnings, so they don't fail `check`; just count them.

Then any new duplication, dead code or oversized function shows up against a clean baseline.

## 5. Report

Use the normal completion format. List the baseline numbers (duplication %, knip entries ignored, ESLint warning count) and the worst offenders as candidates for later cleanup.
