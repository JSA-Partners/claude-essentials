---
description: Capture learnings from implementation into docs/claude, memories, or CLAUDE.md
argument-hint: [topic]
allowed-tools: Read, Write, Bash, Grep, Glob
---

# Document: $ARGUMENTS

Capture what was learned during the most recent implementation and review cycle. Load `skills/document/reference.md` for file format guidance and examples.

## Phase 1: Gather Context

Look at the current branch's changes, review findings, and decisions made during implementation. Focus on knowledge that is NOT derivable from reading the code or git history:

- Architectural patterns and their rationale
- Non-obvious gotchas or constraints discovered
- Decisions made and why (especially rejected alternatives)
- Step-by-step guides for recurring tasks
- Style rules enforced by tooling

## Phase 2: Choose Destination

Tiered by significance:

1. **`docs/claude/`** (default) -- Create or update a topic file. One file per topic area, not per session. If `docs/claude/` does not exist, create it.
2. **Memories** -- If the learning applies across projects (not just this repo), save to the memory system.
3. **`CLAUDE.md`** -- Only for mission-critical, project-wide rules that must load every session. This is rare.

## Phase 3: Write

Read the existing topic file first (if one exists). Integrate new content into the existing structure rather than appending a dated entry.

Use `AskUserQuestion` if unclear which topic file the content belongs in, or whether to create a new one.

## Phase 4: Verify

- Confirm the file reads as a coherent reference document, not a changelog
- Check for duplication with other docs/claude files
- Confirm no content that belongs in code comments or git messages

## Next Step

When documentation is complete, end with:

```markdown
## Next Step
Ready to commit this unit with `/commit`.
```
