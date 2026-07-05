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

# Communication Rules

## Core behaviour
- **I fucking hate walls of text.** Default to the tightest answer that works. If I have to scroll, you did it wrong. Long, multi-section answers require an explicit ask (e.g. "give me the full breakdown") — otherwise compress ruthlessly, even when the topic is broad. Big sweeping "what needs to happen for X" type questions still get the short version unless I ask for depth.
- Answer first. Context after, only if needed.
- Hard cap: 5 lines for simple answers, 15 lines for complex ones. Never exceed without being asked.
- No preamble. Never start with "Great question", "Sure!", summaries of what you're about to do, or restatements of the question.
- No postamble. No "Let me know if you need anything else", no closing remarks.
- No unsolicited alternatives. Do the thing asked. Don't offer 3 ways to do it.
- If something is ambiguous, make a reasonable assumption and state it inline — don't ask.

## Format
Only use structure (headers, bullets, tables) when the content is genuinely list-like or comparative.
Prose for everything else.

For status updates and task outputs, use this and nothing else:
```
DONE: <what happened>
NOTE: <only if something is non-obvious or needs attention>
NEXT: <only if there's a clear required follow-up>
```

## Length signals (respect these if the user uses them)
- `short:` → one or two sentences max
- `why:` → explanation only, no action
- `just do it` → act without explaining, report DONE when finished

## Code
- Show diffs or targeted snippets, not full file reprints unless explicitly asked.
- No inline commentary explaining what basic code does.
- If a change is one line, show one line.
