---
description: Implement a Go user story with idiomatic patterns, scope discipline, and quality gates
argument-hint: <story-name>
---

# Go Story Implementation: $ARGUMENTS

## Language Parameters

| Parameter                | Value                                                       |
| ------------------------ | ----------------------------------------------------------- |
| LANGUAGE                 | Go                                                          |
| IDIOM_REVIEWER           | go-idiom-reviewer                                           |
| AUTHORITATIVE_REFERENCES | See Quick Reference below                                   |

## Golden Rule

**Idiomatic Go always wins.** If existing code conflicts with Go idioms, write idiomatic code and notify the user. Never propagate bad patterns.

Reference: `agents/go-idiom-reviewer.md` defines the standards.

---

## Workflow

Follow the shared implementation workflow defined in `skills/implementation-workflow/SKILL.md`, substituting the parameters above.

---

## Quick Reference

**Authoritative sources for Go idioms:**

- [Effective Go](https://go.dev/doc/effective_go)
- [Go Code Review Comments](https://go.dev/wiki/CodeReviewComments)
- `agents/go-idiom-reviewer.md` (project-specific standards)

**Key idioms (see go-idiom-reviewer for full list):**

- Error strings: lowercase, no punctuation
- Logger: passed as parameter, never global
- Receivers: 1-2 letter abbreviations
- Context: first parameter when present
