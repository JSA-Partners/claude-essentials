---
name: review-workflow
description: Shared parallel review orchestration with adversarial verification for language-specific code review commands
---

# {LANGUAGE} Code Review

Systematic code review for {LANGUAGE} projects using specialized agents with skeptical verification.

## Execution Flow

### Phase 1: Identify Changes

1. If `$ARGUMENTS` provided, review that file/path
2. Otherwise, use `git diff --name-only HEAD~1` for recent changes
3. Filter to {FILE_EXTENSIONS} (include test files only if explicitly reviewing tests)

### Edge Cases

| Scenario                      | Behavior                                                    |
| ----------------------------- | ----------------------------------------------------------- |
| No files match filter         | Report "No {LANGUAGE} files found in scope" and exit        |
| Invalid path provided         | Report "Path not found: [path]" and exit                    |
| Not a git repo (no arguments) | Report "No git repository found. Provide a file path."      |
| git diff returns empty        | Report "No changes in HEAD~1. Provide a file path."         |

### Large Scope Handling

If scope > 10 files, use AskUserQuestion:

- "Found [N] files. Review all or focus on specific areas?"
- Offer language-appropriate filter options (e.g., by file type or module)

### Phase 2: Parallel Review

Run these 5 agents **in parallel** on identified changes:

| Agent                  | Focus                                 |
| ---------------------- | ------------------------------------- |
| `{IDIOM_REVIEWER}`    | {LANGUAGE} patterns and idioms        |
| `complexity-reviewer`  | YAGNI, AHA, Rule of Three, SRP       |
| `technical-reviewer`   | Security, performance, data integrity |
| `scope-reviewer`       | Scope creep, requirement tracing      |
| `architecture-advisor` | Design patterns (only when confident) |

Each agent outputs findings with `file:line` references and severity levels.

> Before flagging issues, agents should check if project CLAUDE.md documents intentional exceptions to standard patterns.

### Phase 3: Verification

After collecting all findings, run `skeptic-reviewer`:

- Input: All findings from Phase 2
- Task: Challenge every finding, demand evidence, verify by reading actual code
- Output: Only findings that survive adversarial scrutiny

### Phase 4: Final Output

Present verified findings:

```txt
# {LANGUAGE} REVIEW: [scope summary]

## CRITICAL (must fix)
- `file:line` - issue (source: agent)

## HIGH (strongly recommended)
- `file:line` - issue (source: agent)

## MEDIUM/LOW (optional)
- `file:line` - suggestion (source: agent)

## CLEAN
Code passes review with no issues.

---
Verification: N verified, N rejected as false positives
```

## Agent Conflict Resolution

When agents flag the same `file:line`:

1. `{IDIOM_REVIEWER}` wins on {LANGUAGE} style/patterns
2. `technical-reviewer` wins on security/performance
3. `complexity-reviewer` wins on abstraction questions
4. `scope-reviewer` wins on requirement boundaries

## Quick Mode

For focused reviews, specify file directly. Skips git diff and reviews only the specified file.

## Severity Levels

All agents use the standardized severity taxonomy: CRITICAL, HIGH, MEDIUM, LOW.
