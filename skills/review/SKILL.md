---
description: Review code with parallel specialized agents, adversarial verification, and mandatory human approval
when_to_use: When the user asks for a code review, review my changes, or check code quality
argument-hint: <path-to-unit.md | file | dir>
context: fork
allowed-tools: Read, Grep, Glob, Bash, Agent
---

# Review: $ARGUMENTS

This skill identifies issues. It does NOT fix, refactor, or rewrite code. Present findings and let the user decide what to act on.

IMPORTANT: Review is never complete without explicit user approval (see Human Gate below).

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

Follow the shared review workflow defined in `${CLAUDE_SKILL_DIR}/reference.md`, substituting the detected language parameters.

### Agent Delegation

Brief each agent like a smart colleague who just walked in -- they have no prior context.

IMPORTANT: Every agent prompt MUST include:

- The full list of files in scope (paths, not just names)
- The diff content or a summary of what changed
- The detected language and file extension filters
- If unit-scoped: the unit's Scope IN/OUT and Acceptance Criteria sections

Do NOT delegate with vague references like "review the recent changes." Always include specific file paths and what to look for.

## When Things Go Wrong

- **Agent returns empty results**: This is valid -- it means no issues in that agent's domain. Include it in the report as "No issues found."
- **Agent fails or times out**: Report the failure transparently. Do NOT silently skip the agent. Re-run it once. If it fails again, note the gap in the final report.
- **Agents contradict each other**: Apply the conflict resolution rules in `${CLAUDE_SKILL_DIR}/reference.md`. If no rule covers the case, present both findings and let the user decide.

Do NOT retry a failed agent with the identical prompt. Adjust the scope or context before retrying.

## Transparency

IMPORTANT: After all agents complete and the skeptic-reviewer runs:

1. Show findings from **each agent** individually
2. Show what the **skeptic-reviewer rejected** and why
3. The user can override any rejection

## Human Gate

CRITICAL: Agent review is not final. After presenting findings, ask the user to review and approve. The review is only complete when the user explicitly approves. Do NOT declare the review complete without user confirmation.

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

## Anti-Patterns

- Do NOT fix or refactor code during review. Report findings only.
- Do NOT flag issues without `file:line` references and evidence.
- Do NOT skip the skeptic-reviewer phase to save time.
- Do NOT present agent findings without attribution (source agent name).
