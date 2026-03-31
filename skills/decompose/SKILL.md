---
description: Decompose a plan or user story into single-commit implementation units
when_to_use: When the user has a plan or story and wants to break it into implementable units
argument-hint: <file-path or prompt>
allowed-tools: Read, Write, Bash, Glob, Agent
---

# Decompose: $ARGUMENTS

If `$ARGUMENTS` is empty, use `AskUserQuestion` to ask: "Provide a plan, story, or spec to decompose (file path or paste inline)."

## Skill Reference

- `${CLAUDE_SKILL_DIR}/reference.md` - Decomposition rules and evaluation checklist

## CRITICAL RULES

1. **All output files go in `~/.cache/claude-essentials/`.** Not in the project directory, not in `docs/`, never `/tmp/`. Cache output keeps the project tree clean and avoids accidental commits of planning artifacts.
2. **You MUST write unit files to disk using the Write tool.** The deliverable is files, not chat prose. Files survive `/clear` and feed directly into `/essentials:implement`. If you finish without calling Write, you have failed.
3. **Do not present unit details in chat.** Write them to files instead. The only chat output is the summary table and the next-step block. Chat prose wastes context window and is lost after `/clear`.

---

## Phase 1: Understand

**DO NOT DECOMPOSE YET** - first understand the input and codebase.

1. **Read the input** - file path or inline content from `$ARGUMENTS`
2. **Read CLAUDE.md** for project conventions, tech stack, and build commands
3. **Explore the codebase** using an Explore agent. Brief it like a smart colleague who just walked in -- full context, not shorthand:

   ```txt
   Task(subagent_type='Explore', thoroughness='very thorough'):
   I'm decomposing [input topic] into implementation units.
   Find: (1) all files and packages affected, (2) existing patterns
   for similar work, (3) test structure and conventions, (4) any
   active work-in-progress that overlaps.
   Return file paths and a summary of each area.
   ```

4. **Extract every ambiguity** - anywhere the input says "what" but not "how"
5. **Ask clarifying questions** via `AskUserQuestion` (max 4 per round, iterate as needed)

**Checkpoint -- stop and ask user when:**

- A unit touches more than 15 files
- You're unsure whether something should be one unit or two
- The input references work that may not be complete
- Research reveals conflicting patterns

---

## Phase 2: Decompose and Write Files

Read `${CLAUDE_SKILL_DIR}/reference.md` for decomposition rules.

### Step 1: Plan the units (internal only, do not output to chat)

- Identify units -- each unit is one commit: one concern, independently mergeable
- Order by dependency -- strict topological sort
- Verify against the evaluation checklist in `${CLAUDE_SKILL_DIR}/reference.md`

### Step 2: Create the output directory

Derive `<short-descriptor>` from the input: use the filename stem (without extension) if a file was provided, or 2-3 key words from an inline prompt. Use today's date as a prefix for uniqueness.

```bash
Bash: mkdir -p "${XDG_CACHE_HOME:-$HOME/.cache}/claude-essentials/<YYYY-MM-DD>-<short-descriptor>"
```

### Step 3: Write plan.md

Use the Write tool to create `~/.cache/claude-essentials/<YYYY-MM-DD>-<short-descriptor>/plan.md` containing:

```markdown
# Decomposition: <story title>

**Source**: `<original $ARGUMENTS verbatim -- file path or inline prompt, truncated to ~200 chars>`

| # | Unit | Description | Depends On | Files |
|---|------|-------------|------------|-------|
| 1 | <kebab-case-name> | <one sentence> | None | ~N |
| 2 | <kebab-case-name> | <one sentence> | 1 | ~N |
```

### Step 4: Write each unit file

Use the Write tool to create `unit-01.md`, `unit-02.md`, etc. in the same directory. Each file MUST use this exact template:

```markdown
# Unit <N>: <Title>

## Description
<What this unit delivers -- one concern, one commit>

## Depends On
<List of prerequisite unit numbers and why, or "None">

## Scope
### IN
- <What this unit changes -- list every affected file>

### OUT
- <What this unit does NOT touch>

## Steps
1. <Numbered implementation steps, max 8>

## Acceptance Criteria
- <Specific, checkable criteria from the story>
```

### Step 5: Verify

Use `Glob` on the output directory for `unit-*.md` to confirm all files exist. If any are missing, write them now.

---

## When Things Go Wrong

- **Circular dependencies**: Re-examine shared state. Extract the shared piece into its own unit that both depend on.
- **Unit too large (15+ files)**: Split by package first, then by layer (production vs test vs wiring).
- **Conflicting patterns in codebase**: Flag the conflict in the unit's Steps section and note which pattern to follow and why.
- **Scope unclear after questions**: Write what you can decompose and mark unclear areas as "TBD -- needs [specific decision]" in the unit file.

Do NOT guess when stuck. Ask the user via `AskUserQuestion` with specific options.

---

## Output

After ALL files are written and verified, show the user:

1. The unit table from `plan.md`
2. The output directory path

Then end with **exactly** this structure:

```markdown
## Done
N units saved to `~/.cache/claude-essentials/<name>/`.

## Next Step
1. Review the plan and unit files in `~/.cache/claude-essentials/<name>/`
2. Run `/clear`
3. Run `/essentials:implement ~/.cache/claude-essentials/<name>/unit-01.md`
```
