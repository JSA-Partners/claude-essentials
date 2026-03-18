---
description: Review code for YAGNI, AHA, Rule of Three, SRP, DAMP, SOLID, and DRY violations
argument-hint: [--staged | --all | --branch | path/to/file]
---

# Complexity Review

Reviews code changes for complexity violations using 7 simplicity principles.

## Input: $ARGUMENTS

| Argument   | Scope             | Description                          |
| ---------- | ----------------- | ------------------------------------ |
| _(empty)_  | Staged changes    | Review `git diff --cached` (default) |
| `--all`    | All uncommitted   | Review `git diff HEAD`               |
| `--branch` | Branch vs main    | Review `git diff main...HEAD`        |
| `<path>`   | Specific file/dir | Review only the specified path       |

## Phase 1: Determine Scope

Based on `$ARGUMENTS`:

1. **Default (empty)**: Run `git diff --cached --name-only` for staged files
2. **`--all`**: Run `git diff HEAD --name-only` for all uncommitted
3. **`--branch`**: Run `git diff main...HEAD --name-only` (try `master` if no `main`)
4. **Path provided**: Use that path directly

If no changes found, report "No changes to review."

## Phase 2: Gather Changes

Run the appropriate git diff command to get the actual changes:

- `git diff --cached` for staged
- `git diff HEAD` for all uncommitted
- `git diff main...HEAD` for branch
- `git diff HEAD -- <path>` for specific path

Identify:

- Changed files and their languages
- Added/modified code sections
- Lines changed count

## Phase 3: Run Complexity Review

Use the Task tool to invoke the `complexity-reviewer` agent with this context:

```txt
Analyze the following code changes for complexity violations.

Scope: [staged | all uncommitted | branch vs main | specific path]
Files: [list of changed files]
Languages: [detected languages]

Changes:
[git diff output]

Apply all 7 principles: YAGNI, AHA, Rule of Three, SRP, DAMP, SOLID, DRY.
Adapt SOLID checks based on language (full for OOP, function-level for scripts).
```

## Phase 4: Present Findings

Display the agent's findings organized by severity:

```txt
# COMPLEXITY REVIEW

**Scope**: [what was reviewed]
**Files**: X files, Y lines changed

## BLOCKING (CRITICAL)
- [PRINCIPLE] `file:line` - issue

## SHOULD FIX (MAJOR)
- [PRINCIPLE] `file:line` - issue

## CONSIDER (MEDIUM)
- [PRINCIPLE] `file:line` - suggestion

---
Clean. (if no violations found)
```

## Quick Examples

```txt
/complexity-review                  # Review staged changes
/complexity-review --all            # Review all uncommitted
/complexity-review --branch         # Review current branch vs main
/complexity-review src/handlers/    # Review specific directory
/complexity-review api/user.go      # Review specific file
```
