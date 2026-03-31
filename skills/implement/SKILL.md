---
description: Implement one decomposed unit with idiomatic patterns, scope discipline, and quality gates
when_to_use: When the user wants to implement a decomposed unit file from /essentials:decompose
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

## Phase 1: Understand

**DO NOT WRITE CODE YET.**

1. Read the unit description and extract scope boundaries:
   - IN: What this unit delivers (one concern, one commit)
   - OUT: Everything else
2. Explore the codebase using the Explore agent for affected areas
3. Identify files you will modify

Load `${CLAUDE_SKILL_DIR}/reference.md` for the detailed workflow and checkpoint guidance.

## Phase 2: Plan

CRITICAL: **Call `EnterPlanMode` before any implementation.** Do not proceed until the plan is approved. Skipping plan mode doubles or triples failure rate.

1. Run the IDIOM_REVIEWER agent on reference files to evaluate existing patterns
2. Categorize each reference as IDIOMATIC (follow exactly) or UNIDIOMATIC (do not copy; notify user what you will do instead)
3. Present your plan and wait for approval

## Phase 3: Pre-flight

Before writing any code, verify the environment works:

1. Run the project's lint command (see CLAUDE.md)
2. Run the project's test suite to establish a passing baseline
3. If either fails, notify the user before proceeding. Do not silently fix pre-existing failures.

## Phase 4: Implement

For each component:

1. Write idiomatic code -- do not copy-paste from unidiomatic reference files
2. Run project lint/test after each logical change (see CLAUDE.md for commands)
3. Stay in scope -- only implement what the unit describes

IMPORTANT: **Scope discipline is non-negotiable.** No "while we're here" improvements. No adding docs/comments to unchanged code. No speculative features. If you are unsure whether something is in scope, use `AskUserQuestion`.

## Anti-Patterns

| Don't | Why | Instead |
| --- | --- | --- |
| Skip plan mode | Doubles failure rate | Always call EnterPlanMode |
| Copy unidiomatic code | "It exists" is not justification | Write idiomatic code, notify user |
| Expand scope | Scope creep kills projects | Ask if unsure |
| Skip lint/test | Catch failures early, not in review | Run after each logical change |
| Hardcode build commands | Goes stale across projects | Reference CLAUDE.md |

## When Things Go Wrong

1. **Environment/build failures**: Check CLAUDE.md setup instructions. If the project cannot build, use `AskUserQuestion` to ask the user rather than guessing at fixes.
2. **Pre-existing test failures**: Flag to the user. Do not silently fix tests unrelated to your unit.
3. **Scope ambiguity**: Stop and ask. Do not guess whether something is in scope.
4. **Idiom conflicts**: If existing code is unidiomatic, write idiomatic code and explain the deviation to the user.

Do NOT retry the identical action after failure. Diagnose first, then fix.

## Tests

After implementation, run the project's test suite. If tests fail due to your changes, fix them before completing. There is no point proceeding to review with failing tests.

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
