---
description: Review code with parallel specialized agents, adversarial verification, and mandatory human approval
argument-hint: [file | path/to/dir]
---

# Review: $ARGUMENTS

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

### Large Scope Filter (Svelte only)

When scope > 10 files, offer language-specific filters:

- All files
- Components only (`.svelte`)
- Server routes only (`+server`, `+page.server`)
- Let me specify

## Workflow

Follow the shared review workflow defined in `skills/review/SKILL.md`, substituting the detected language parameters.

## Transparency

After all agents complete and the skeptic-reviewer runs:

1. Show findings from **each agent** individually
2. Show what the **skeptic-reviewer rejected** and why
3. The user can override any rejection

## Human Gate

Agent review is not final. After presenting findings, ask the user to review and approve. The review is only complete when the user explicitly approves.

## Quick Mode

```txt
/review path/to/file
```

Skips git diff and reviews only the specified file.

## Next Step

When the user approves the review, end with:

```markdown
## Next Step
Ready to proceed with `/document` to capture learnings.
```
