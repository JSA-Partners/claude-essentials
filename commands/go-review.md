---
description: Review Go code with parallel specialized agents and adversarial verification
argument-hint: [file.go | path/to/dir]
---

# Go Code Review

## Language Parameters

| Parameter       | Value                               |
| --------------- | ----------------------------------- |
| LANGUAGE        | Go                                  |
| IDIOM_REVIEWER  | go-idiom-reviewer                   |
| FILE_EXTENSIONS | `.go` files (include `_test.go` only if explicitly reviewing tests) |

## Workflow

Follow the shared review workflow defined in `skills/review-workflow/SKILL.md`, substituting the parameters above.

The go-idiom-reviewer focuses on Go patterns, error handling, and naming conventions.

## Quick Mode

```txt
/go-review path/to/file.go
```

Skips git diff and reviews only the specified file.
