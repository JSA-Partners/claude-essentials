---
name: review
description: Parallel review orchestration with adversarial verification and human approval
---

# Review Skill

Systematic code review using specialized agents in parallel, with skeptical verification and mandatory human approval. The calling skill detects the project language and selects the appropriate idiom reviewer.

## Execution Flow

### Phase 1: Identify Changes

1. If a file/path is provided, review that scope
2. Otherwise, use `git diff --name-only HEAD~1` for recent changes
3. Filter to language-appropriate file extensions (include test files only if explicitly reviewing tests)

### Edge Cases

| Scenario | Behavior |
| --- | --- |
| No files match filter | Report "No files found in scope" and exit |
| Invalid path provided | Report "Path not found: [path]" and exit |
| Not a git repo (no arguments) | Report "No git repository found. Provide a file path." |
| git diff returns empty | Report "No changes in HEAD~1. Provide a file path." |

### Large Scope Handling

If scope > 10 files, use `AskUserQuestion`: "Found [N] files. Review all or focus on specific areas?"

### Unit-Scoped Review

If the changes were produced by `/essentials:implement` from a decomposed unit file, read the unit file to establish scope boundaries. Pass the unit's **Scope > IN**, **Scope > OUT**, and **Acceptance Criteria** sections to the `scope-reviewer` agent. The scope-reviewer must only check the unit's acceptance criteria, not the full parent story. Work belonging to other units is intentionally deferred and must not be flagged.

### Phase 2: Parallel Review

Run these 5 agents **in parallel** on identified changes:

| Agent | Focus |
| --- | --- |
| `[idiom-reviewer]` | Language patterns and idioms |
| `complexity-reviewer` | YAGNI, AHA, Rule of Three, SRP |
| `technical-reviewer` | Security, performance, data integrity |
| `scope-reviewer` | Scope creep, requirement tracing |
| `architecture-advisor` | Design patterns (only when confident) |

Each agent outputs findings with `file:line` references and severity levels.

> Before flagging issues, agents should check if project CLAUDE.md documents intentional exceptions to standard patterns.

### Phase 3: Verification

After collecting all findings, run `skeptic-reviewer`:

- Input: All findings from Phase 2
- Task: Challenge every finding, demand evidence, verify by reading actual code
- Output: Only findings that survive adversarial scrutiny

### Phase 4: Final Output

Present verified findings grouped by severity:

```txt
## P1 (must fix)
- `file:line` - issue (source: agent)

## P2 (should fix)
- `file:line` - issue (source: agent)

## P3 (optional)
- `file:line` - suggestion (source: agent)

## CLEAN
Code passes review with no issues.

---
Verification: N verified, N rejected as false positives
```

## Agent Conflict Resolution

When agents flag the same `file:line`:

1. Idiom reviewer wins on language style/patterns
2. `technical-reviewer` wins on security/performance
3. `complexity-reviewer` wins on abstraction questions
4. `scope-reviewer` wins on requirement boundaries

## Severity Levels

All agents use the standardized severity taxonomy: P1, P2, P3.
