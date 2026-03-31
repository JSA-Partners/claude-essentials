---
description: Review code with parallel specialized agents, adversarial verification, and mandatory human approval
argument-hint: <path-to-unit.md | file | dir>
context: fork
allowed-tools: Read, Grep, Glob, Bash, Agent
---

# Review: $ARGUMENTS

## Resolve Scope

1. If `$ARGUMENTS` is a unit file path (e.g., `~/.cache/claude-essentials/2026-03-26-auth/unit-01.md`), read that file for scope boundaries and review all uncommitted changes matching the unit's **Scope > IN** files.
2. If `$ARGUMENTS` is a partial or vague reference (e.g., `auth`, `unit-02`), glob `~/.cache/claude-essentials/` to find matching unit files. If exactly one match, use it. If multiple matches, show options via `AskUserQuestion`.
3. If `$ARGUMENTS` is a file or directory path in the project, review that scope directly (quick mode).
4. If `$ARGUMENTS` is empty, review all uncommitted changes via `git diff --name-only` (staged and unstaged).

## Language Detection

Detect the project language from CLAUDE.md `Tech Stack` section or file extensions. Set parameters accordingly:

### Go

| Parameter       | Value               |
| --------------- | ------------------- |
| LANGUAGE        | Go                  |
| IDIOM_REVIEWER  | go-idiom-reviewer   |
| FILE_EXTENSIONS | `.go` files (include `_test.go` only if explicitly reviewing tests) |

### Svelte

| Parameter       | Value                 |
| --------------- | --------------------- |
| LANGUAGE        | Svelte/SvelteKit      |
| IDIOM_REVIEWER  | svelte-idiom-reviewer |
| FILE_EXTENSIONS | `.svelte`, `.ts`, `.js` files (include `*.test.ts` only if explicitly reviewing tests) |

### Python

| Parameter       | Value                    |
| --------------- | ------------------------ |
| LANGUAGE        | Python                   |
| IDIOM_REVIEWER  | python-idiom-reviewer    |
| FILE_EXTENSIONS | `.py` files (include `test_*.py` / `*_test.py` only if explicitly reviewing tests) |

### TypeScript

| Parameter       | Value                      |
| --------------- | -------------------------- |
| LANGUAGE        | TypeScript                 |
| IDIOM_REVIEWER  | typescript-idiom-reviewer  |
| FILE_EXTENSIONS | `.ts`, `.tsx` files (include `*.test.ts`, `*.spec.ts` only if explicitly reviewing tests) |

### Default (Fallback)

If the project language does not match any of the above, use the general-purpose reviewer:

| Parameter       | Value                    |
| --------------- | ------------------------ |
| LANGUAGE        | (detected language)      |
| IDIOM_REVIEWER  | general-idiom-reviewer   |
| FILE_EXTENSIONS | (all changed files)      |

### Detection Order

Check in this order: Go > Svelte > Python > TypeScript > Default. Svelte takes priority over TypeScript because Svelte projects contain `.ts` files. Detection checks CLAUDE.md `Tech Stack` first, then marker files (`go.mod`, `svelte.config.*`, `pyproject.toml`/`setup.py`, `tsconfig.json`).

### Large Scope Filter (Svelte only)

When scope > 10 files, offer language-specific filters:

- All files
- Components only (`.svelte`)
- Server routes only (`+server`, `+page.server`)
- Let me specify

## Workflow

Follow the shared review workflow defined in `skills/review/reference.md`, substituting the detected language parameters.

## Transparency

After all agents complete and the skeptic-reviewer runs:

1. Show findings from **each agent** individually
2. Show what the **skeptic-reviewer rejected** and why
3. The user can override any rejection

## Human Gate

Agent review is not final. After presenting findings, ask the user to review and approve. The review is only complete when the user explicitly approves.

## Output

When the user approves the review, end with **exactly** this structure:

```markdown
## Done
Review complete. N findings (P1: X, P2: Y, P3: Z).

## Next Step
1. Address any P1/P2 findings, then do a manual review of the diff
2. Run `/clear`
3. Run `/essentials:document <path-to-unit-file or topic>`
```

Include the full unit file path if one was used for scoping.
