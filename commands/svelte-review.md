---
description: Review Svelte/SvelteKit code with parallel specialized agents and adversarial verification
argument-hint: [file.svelte | path/to/dir]
---

# Svelte/SvelteKit Code Review

## Language Parameters

| Parameter       | Value                               |
| --------------- | ----------------------------------- |
| LANGUAGE        | Svelte/SvelteKit                    |
| IDIOM_REVIEWER  | svelte-idiom-reviewer               |
| FILE_EXTENSIONS | `.svelte`, `.ts`, `.js` files (include `*.test.ts` only if explicitly reviewing tests) |

## Workflow

Follow the shared review workflow defined in `skills/review-workflow/SKILL.md`, substituting the parameters above.

The svelte-idiom-reviewer focuses on Svelte 5 patterns, reactivity, and SvelteKit conventions.

### Large Scope Filter Options

When scope > 10 files, offer these language-specific filters:

- All files
- Components only (`.svelte`)
- Server routes only (`+server`, `+page.server`)
- Let me specify

## Quick Mode

```txt
/svelte-review path/to/Component.svelte
```

Skips git diff and reviews only the specified file.
