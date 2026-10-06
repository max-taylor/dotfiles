# Coding Standards

Rule files in `~/.claude/rules/` (symlinked from `dotfiles/.claude/rules/`) load automatically in every project:

- **engineering.md**: process. Search before writing, reuse and mirror siblings, derive once, `/finish` before reporting done.
- **react.md**: controller-view-hook pattern, folder structure, state and data flow.
- **typescript.md**: TypeScript patterns and type conventions.
- **style.md**: code style and naming.
- **documentation.md**: keeping READMEs in sync.

Add a rule by creating a `.md` file there. Scope it to certain files with frontmatter:

```markdown
---
paths: "**/*.tsx"
---
```

## Quality workflow

- `/finish` (skill): checks plus two fresh-context Sonnet reviewers (reuse and simplification; efficiency and altitude) before a change is reported done. The Stop hook (`hooks/require-finish.sh`) blocks finishing a turn once the uncommitted change has grown by more than 250 lines since `/finish` last passed.
- `/harden` (skill): adds jscpd, knip, ESLint size and complexity limits, a test runner, a `check` script and CI to a repo. Run it once per project.
