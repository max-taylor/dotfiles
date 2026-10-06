# Coding Standards

This directory contains modular coding standards organized by topic. Each rule
file is explicitly imported below so Claude Code reliably loads it (the
"`rules/` is auto-loaded" claim previously here was aspirational — only
`@path` imports actually load).

## Rules Overview

- **react.md** - React controller-view-hook pattern, folder structures, state management, and data flow
- **typescript.md** - TypeScript patterns and type conventions
- **style.md** - Code style principles and naming conventions
- **documentation.md** - README maintenance guidelines
- **thirdweb.md** - Thirdweb SDK / indexer gotchas

@rules/thirdweb.md

## Usage

These rules are automatically loaded when working in this repository. To view or edit:

```bash
/memory  # View all loaded memory files in Claude Code
```

To add new rules, create `.md` files in `.claude/rules/`.

For path-specific rules, use YAML frontmatter:

```markdown
---
paths: "**/*.tsx"
---

# React-specific rules here
```
