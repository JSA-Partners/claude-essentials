---
description: Decompose a plan or user story into single-commit implementation units
argument-hint: <path-to-plan.md>
---

# Decompose: $ARGUMENTS

If `$ARGUMENTS` is empty, use `AskUserQuestion` to ask: "Provide a plan, story, or spec to decompose (file path or paste inline)."

## Skill Reference

- `skills/decompose/SKILL.md` - Decomposition rules and evaluation checklist

## CRITICAL RULES

1. **All output files go in `/tmp/claude/decompose-<short-descriptor>/`.** Not in the project directory. Not in `docs/`. Always `/tmp/`.
2. **You MUST write unit files to disk using the Write tool.** The deliverable is files, not chat prose. If you finish this command without calling Write to create unit files in `/tmp/`, you have failed.
3. **Do not present unit details in chat.** Write them to files instead. The only chat output is the summary table and the next-step path.

---

## Phase 1: Understand

**DO NOT DECOMPOSE YET** - first understand the input and codebase.

1. **Read the input** - file path or inline content from `$ARGUMENTS`
2. **Explore the codebase** using an Explore agent:

   ```txt
   Task(subagent_type='Explore', thoroughness='very thorough'):
   Explore all code areas affected by [input topic].
   Map: current patterns, affected files, test structure.
   ```

3. **Extract every ambiguity** - anywhere the input says "what" but not "how"
4. **Ask clarifying questions** via `AskUserQuestion` (max 4 per round, iterate as needed)

**Checkpoint -- stop and ask user when:**

- A unit touches more than 15 files
- You're unsure whether something should be one unit or two
- The input references work that may not be complete
- Research reveals conflicting patterns

---

## Phase 2: Decompose and Write Files to /tmp/

Read `skills/decompose/SKILL.md` for decomposition rules.

### Step 1: Plan the units (internal only, do not output to chat)

- Identify units -- each unit is one commit: one concern, independently mergeable
- Order by dependency -- strict topological sort
- Verify against the evaluation checklist in `skills/decompose/SKILL.md`

### Step 2: Create the output directory

```
Bash: mkdir -p /tmp/claude/decompose-<short-descriptor>
```

### Step 3: Write plan.md to /tmp/

Use the Write tool to create `/tmp/claude/decompose-<short-descriptor>/plan.md` containing:

```markdown
# Decomposition: <story title>

| # | Unit | Description | Depends On | Files |
|---|------|-------------|------------|-------|
| 1 | <kebab-case-name> | <one sentence> | None | ~N |
| 2 | <kebab-case-name> | <one sentence> | 1 | ~N |
```

### Step 4: Write each unit file to /tmp/

Use the Write tool to create `/tmp/claude/decompose-<short-descriptor>/unit-01.md`, `unit-02.md`, etc. Each file MUST use this exact template:

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

Use `Glob` on `/tmp/claude/decompose-<short-descriptor>/unit-*.md` to confirm all files exist. If any are missing, write them now.

---

## Output

After ALL files are written and verified, show the user:

1. The unit table from `plan.md`
2. The `/tmp/` directory path

Then end with:

```markdown
## Next Step
Units saved to `/tmp/claude/decompose-<name>/`. Run `/implement /tmp/claude/decompose-<name>/unit-01.md` to start.
```
