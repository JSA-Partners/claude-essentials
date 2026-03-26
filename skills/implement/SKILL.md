---
description: Implement one decomposed unit with idiomatic patterns, scope discipline, and quality gates
argument-hint: <path-to-unit.md>
context: fork
allowed-tools: Read, Write, Edit, Bash, Grep, Glob, Agent
---

# Implement: $ARGUMENTS

## Resolve Unit

1. If `$ARGUMENTS` is a file path (e.g., `~/.cache/claude-essentials/2026-03-26-auth/unit-01.md`), read that file as the unit description.
2. If `$ARGUMENTS` is a partial or vague reference (e.g., `auth`, `unit-02`, `api-routes`), glob `~/.cache/claude-essentials/` to find matching unit files. If exactly one match, use it. If multiple matches, show options via `AskUserQuestion`.
3. If `$ARGUMENTS` is empty or the file is not found, use `AskUserQuestion` to request the unit file path or a description.

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

Follow the shared implementation workflow defined in `skills/implement/reference.md`, substituting the detected language parameters.

## Tests

After implementation, run the project's test suite. If tests fail, fix them before completing. There is no point in proceeding to `/review` with failing tests.

## Output

When implementation and tests pass, end with **exactly** this structure:

```markdown
## Done
Implementation complete. Tests passing.

## Next Step
1. Scan the changes for completeness
2. Run `/clear`
3. Run `/review <path-to-unit-file>`
```

Include the full unit file path so `/review` can read it for scope boundaries.
