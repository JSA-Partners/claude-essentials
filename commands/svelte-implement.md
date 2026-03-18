---
description: Implement a Svelte/SvelteKit user story with idiomatic patterns, scope discipline, and quality gates
argument-hint: <story-name>
---

# Svelte Story Implementation: $ARGUMENTS

## Language Parameters

| Parameter                | Value                                                       |
| ------------------------ | ----------------------------------------------------------- |
| LANGUAGE                 | Svelte 5                                                    |
| IDIOM_REVIEWER           | svelte-idiom-reviewer                                       |
| AUTHORITATIVE_REFERENCES | See Quick Reference below                                   |

## Golden Rule

**Idiomatic Svelte always wins.** If existing code conflicts with Svelte 5 idioms, write idiomatic code and notify the user. Never propagate bad patterns.

Reference: `agents/svelte-idiom-reviewer.md` defines the standards.

---

## Workflow

Follow the shared implementation workflow defined in `skills/implementation-workflow/SKILL.md`, substituting the parameters above.

---

## Quick Reference

**Authoritative sources for Svelte idioms:**

- [Svelte 5 Docs](https://svelte.dev/docs) | [SvelteKit Docs](https://svelte.dev/docs/kit)
- `agents/svelte-idiom-reviewer.md` (comprehensive idiom coverage)
