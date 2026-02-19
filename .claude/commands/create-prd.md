---
description: Generate a PRD from a feature description. Asks clarifying questions if needed, then writes docs/prd.md.
argument-hint: [feature description]
allowed-tools: Read, Write, Glob, Grep
disable-model-invocation: true
---

# Existing project context

Current codebase structure:
!`find . -maxdepth 3 -type f \( -name "*.ts" -o -name "*.tsx" -o -name "*.json" -o -name "*.md" \) | grep -v node_modules | grep -v .git | head -60`

CLAUDE.md (if exists):
!`cat CLAUDE.md 2>/dev/null || echo "No CLAUDE.md found"`

Package dependencies (if exists):
!`cat package.json 2>/dev/null | head -40 || echo "No package.json found"`

---

You are an experienced technical product manager. Generate a focused PRD from the provided description, grounded in the actual codebase context above.

## Input

$ARGUMENTS

## Process

1. **Analyze the description** against the existing codebase. Identify the core problem, target users, and scope.
2. **Ask 3-5 clarifying questions** ONLY if critical information is genuinely missing or ambiguous. Present as multiple choice where possible. If the description is detailed enough, skip straight to generation.
3. **Generate the PRD** in the structure below.
4. **Save** to `docs/prd.md` (create `docs/` if needed).

## PRD Structure

```markdown
# PRD: [Feature/Project Name]

## Overview
One paragraph — what we're building and why.

## Problem Statement
What problem this solves. Who has it. What the current workaround is.

## Goals
- Primary goal
- Secondary goals
- Measurable success criteria

## Non-Goals
What this does NOT cover. Be explicit to prevent scope creep.

## User Stories
- As a [user type], I want [action] so that [benefit]
- 3-8 stories. Each maps to implementable work.

## Functional Requirements
- REQ-001: [Requirement]
- REQ-002: [Requirement]
- Group by feature area if >8.

## Non-Functional Requirements
- Performance targets
- Security considerations
- Scalability expectations

## Technical Considerations
- Architecture approach (informed by existing codebase patterns above)
- Key decisions or constraints
- Integration points with existing code
- Data models or state management

## Open Questions
Unresolved decisions needing input before or during implementation.
```

## Rules

- Be specific and actionable. Every requirement must be implementable.
- Don't pad with boilerplate. Omit irrelevant sections.
- Number all functional requirements (REQ-001, REQ-002...) for task traceability.
- Ground technical considerations in the actual stack from the codebase context above.
- Target 1-3 pages.
