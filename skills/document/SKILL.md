---
description: Capture learnings from implementation into project docs, memories, or CLAUDE.md
when_to_use: When the user wants to document what was learned, save decisions, or update project docs after implementation
argument-hint: <path-to-unit.md | topic>
allowed-tools: Read, Write, Edit, Bash, Grep, Glob
---

# Document: $ARGUMENTS

## Resolve Context

1. If `$ARGUMENTS` is a unit file path (e.g., `~/.cache/claude-essentials/2026-03-26-auth/unit-01.md`), read that file to understand what was implemented. Use its scope to focus the documentation scan.
2. If `$ARGUMENTS` is a partial or vague reference (e.g., `auth`, `unit-02`), glob `~/.cache/claude-essentials/` to find matching unit files. If exactly one match, use it. If multiple matches, show options via `AskUserQuestion`.
3. If `$ARGUMENTS` is a topic string (not a file path), use it as the documentation focus area.
4. If `$ARGUMENTS` is empty, scan uncommitted changes on the current branch to determine what was implemented.

Load `${CLAUDE_SKILL_DIR}/reference.md` for file format guidance and examples.

## Phase 1: Gather Context

Scan the current branch for what was implemented:

1. Run `git diff main --name-only` to identify changed files
2. Run `git log main..HEAD --oneline` to see commit history
3. Read the changed files to understand the implementation

Focus on knowledge that is NOT derivable from reading the code or git history:

- Architectural patterns and their rationale
- Non-obvious gotchas or constraints discovered
- Decisions made and why (especially rejected alternatives)
- Step-by-step guides for recurring tasks
- Style rules enforced by tooling

IMPORTANT: Do NOT document anything derivable from reading the code, git history, or existing CLAUDE.md. If you can learn it by running `git log` or reading the source, it does not belong in a reference doc.

## Phase 2: Choose Destination

Tiered by significance:

1. **`docs/claude/`** (default) -- Create or update a topic file. One file per topic area, not per session. If `docs/claude/` does not exist, search for an alternative documentation directory already in use (e.g., `docs/`, `.claude/docs/`, or any directory with existing reference markdown files). If a reasonable alternative is found, confirm with the user before writing there. If nothing exists, create `docs/claude/`.
2. **Memories** -- If the learning applies across projects (not just this repo), save to the memory system.
3. **`CLAUDE.md`** -- Only for mission-critical, project-wide rules that must load every session. This is rare.

## Phase 3: Write

IMPORTANT: One file per topic area, not per session. Read the existing topic file first (if one exists). Integrate new content into the existing structure. Do NOT append dated entries or create a new file when the topic already has one -- edit the existing file instead.

Use `AskUserQuestion` if unclear which topic file the content belongs in, or whether to create a new one.

### When Things Go Wrong

- **Docs directory does not exist**: Search for an alternative (`docs/`, `.claude/docs/`). If nothing exists, confirm with the user before creating `docs/claude/`.
- **Content overlaps two topic files**: Pick the primary file, add a cross-reference to the other.
- **Topic does not fit existing files**: Create a new topic file. Do not force content into an unrelated file.

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
