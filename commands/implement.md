---
description: Implement one decomposed unit with idiomatic patterns, scope discipline, and quality gates
argument-hint: <path-to-unit.md or unit-number>
---

# Implement: $ARGUMENTS

If `$ARGUMENTS` is a file path (e.g., `/tmp/decompose-auth/unit-01.md`), read that file as the unit description. If it's a number, look for the unit in the current conversation context. If the file is not found or the unit number has no match, use `AskUserQuestion` to request the unit description.

## Language Detection

Detect the project language from CLAUDE.md `Tech Stack` section or file extensions in the working directory. Set parameters accordingly:

### Go

| Parameter                | Value                 |
| ------------------------ | --------------------- |
| LANGUAGE                 | Go                    |
| IDIOM_REVIEWER           | go-idiom-reviewer     |
| AUTHORITATIVE_REFERENCES | [Effective Go](https://go.dev/doc/effective_go), [Go Code Review Comments](https://go.dev/wiki/CodeReviewComments) |

### Svelte

| Parameter                | Value                   |
| ------------------------ | ----------------------- |
| LANGUAGE                 | Svelte 5                |
| IDIOM_REVIEWER           | svelte-idiom-reviewer   |
| AUTHORITATIVE_REFERENCES | [Svelte 5 Docs](https://svelte.dev/docs), [SvelteKit Docs](https://svelte.dev/docs/kit) |

## Golden Rule

**Idiomatic code always wins.** If existing code conflicts with language idioms, write idiomatic code and notify the user. Never propagate bad patterns.

## Workflow

Follow the shared implementation workflow defined in `skills/implement/SKILL.md`, substituting the detected language parameters.

## Tests

After implementation, run the project's test suite. If tests fail, fix them before completing. There is no point in proceeding to `/review` with failing tests.

## Next Step

When implementation and tests pass, end with:

```markdown
## Next Step
Ready to proceed with `/review`. Unit scope: `<path-to-unit-file>`
```

Include the unit file path so `/review` can read it for scope boundaries.
