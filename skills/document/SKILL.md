---
description: Capture learnings from implementation into project docs, memories, or CLAUDE.md
argument-hint: <path-to-unit.md | topic>
allowed-tools: Read, Write, Bash, Grep, Glob
---

# Document: $ARGUMENTS

## Resolve Context

1. If `$ARGUMENTS` is a unit file path (e.g., `~/.cache/claude-essentials/2026-03-26-auth/unit-01.md`), read that file to understand what was implemented. Use its scope to focus the documentation scan.
2. If `$ARGUMENTS` is a partial or vague reference (e.g., `auth`, `unit-02`), glob `~/.cache/claude-essentials/` to find matching unit files. If exactly one match, use it. If multiple matches, show options via `AskUserQuestion`.
3. If `$ARGUMENTS` is a topic string (not a file path), use it as the documentation focus area.
4. If `$ARGUMENTS` is empty, scan uncommitted changes on the current branch to determine what was implemented.

Load `${CLAUDE_SKILL_DIR}/reference.md` for file format guidance and examples.

## Phase 1: Gather Context

Look at the current branch's changes, review findings, and decisions made during implementation. Focus on knowledge that is NOT derivable from reading the code or git history:

- Architectural patterns and their rationale
- Non-obvious gotchas or constraints discovered
- Decisions made and why (especially rejected alternatives)
- Step-by-step guides for recurring tasks
- Style rules enforced by tooling

## Phase 2: Choose Destination

Tiered by significance:

1. **`docs/claude/`** (default) -- Create or update a topic file. One file per topic area, not per session. If `docs/claude/` does not exist, search for an alternative documentation directory already in use (e.g., `docs/`, `.claude/docs/`, or any directory with existing reference markdown files). If a reasonable alternative is found, confirm with the user before writing there. If nothing exists, create `docs/claude/`.
2. **Memories** -- If the learning applies across projects (not just this repo), save to the memory system.
3. **`CLAUDE.md`** -- Only for mission-critical, project-wide rules that must load every session. This is rare.

## Phase 3: Write

Read the existing topic file first (if one exists). Integrate new content into the existing structure rather than appending a dated entry.

Use `AskUserQuestion` if unclear which topic file the content belongs in, or whether to create a new one.

## Phase 4: Verify

- Confirm the file reads as a coherent reference document, not a changelog
- Check for duplication with other docs/claude files
- Confirm no content that belongs in code comments or git messages

## Output

When documentation is complete, end with **exactly** this structure:

```markdown
## Done
Learnings captured in [destination file(s)].

## Next Step
1. Review the documentation changes
2. Run `/clear`
3. Run `/essentials:commit`
```
