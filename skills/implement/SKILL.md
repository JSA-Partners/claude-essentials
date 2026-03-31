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

### Python

| Parameter                | Value                    |
| ------------------------ | ------------------------ |
| LANGUAGE                 | Python                   |
| IDIOM_REVIEWER           | python-idiom-reviewer    |
| AUTHORITATIVE_REFERENCES | [PEP 8](https://peps.python.org/pep-0008/), [Python Docs](https://docs.python.org/3/) |

### TypeScript

| Parameter                | Value                      |
| ------------------------ | -------------------------- |
| LANGUAGE                 | TypeScript                 |
| IDIOM_REVIEWER           | typescript-idiom-reviewer  |
| AUTHORITATIVE_REFERENCES | [TypeScript Handbook](https://www.typescriptlang.org/docs/handbook/), [Google TS Style Guide](https://google.github.io/styleguide/tsguide.html) |

### Default (Fallback)

If the project language does not match any above:

| Parameter                | Value                    |
| ------------------------ | ------------------------ |
| LANGUAGE                 | (detected language)      |
| IDIOM_REVIEWER           | general-idiom-reviewer   |
| AUTHORITATIVE_REFERENCES | (discovered via WebSearch)|

### Detection Order

Check in this order: Go > Svelte > Python > TypeScript > Default. Svelte takes priority over TypeScript because Svelte projects contain `.ts` files. Detection checks CLAUDE.md `Tech Stack` first, then marker files (`go.mod`, `svelte.config.*`, `pyproject.toml`/`setup.py`, `tsconfig.json`).

## Golden Rule

**Idiomatic code always wins.** If existing code conflicts with language idioms, write idiomatic code and notify the user. Never propagate bad patterns.

## Workflow

Follow the shared implementation workflow defined in `${CLAUDE_SKILL_DIR}/reference.md`, substituting the detected language parameters.

## Tests

After implementation, run the project's test suite. If tests fail, fix them before completing. There is no point in proceeding to `/essentials:review` with failing tests.

## Output

When implementation and tests pass, end with **exactly** this structure:

```markdown
## Done
Implementation complete. Tests passing.

## Next Step
1. Scan the changes for completeness
2. Run `/clear`
3. Run `/essentials:review <path-to-unit-file>`
```

Include the full unit file path so `/essentials:review` can read it for scope boundaries.
