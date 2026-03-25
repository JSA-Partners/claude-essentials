---
description: Decompose a plan or user story into single-commit implementation units
argument-hint: <path-to-plan.md>
---

# Decompose: $ARGUMENTS

If `$ARGUMENTS` is empty, use `AskUserQuestion` to ask: "Provide a plan, story, or spec to decompose (file path or paste inline)."

## Skill Reference

- `skills/decompose/SKILL.md` - Decomposition rules and evaluation checklist

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

---

## Phase 2: Decompose

Read `skills/decompose/SKILL.md` for decomposition rules.

1. **Identify units** - each unit is one commit: one concern, independently mergeable
2. **Order by dependency** - strict topological sort; list dependencies explicitly
3. **Present the plan table**:

   ```txt
   | # | Unit | Description | Depends On |
   |---|------|-------------|------------|
   ```

4. **Flag oversized units** - anything touching 15+ files or spanning 3+ packages
5. **Wait for user approval** before proceeding

---

## Phase 3: Verify

Run `skeptic-reviewer` on the decomposition:

```txt
Task(subagent_type='skeptic-reviewer'):
Challenge each unit: correct dependency order, independently mergeable,
no circular deps, each unit passes the "one concern" test.
```

Fix any violations before presenting the final plan.

---

## Checkpoint Moments

**Stop and ask user when:**

- A unit touches more than 15 files
- You're unsure whether something should be one unit or two
- The input references work that may not be complete
- Research reveals conflicting patterns

---

## Phase 4: Save

After user approves the decomposition, persist to a temp directory:

1. **Create directory**: `/tmp/decompose-<short-descriptor>/` (e.g., `/tmp/decompose-auth-middleware/`)
2. **Write `plan.md`**: the full plan table with unit descriptions and dependency info
3. **Write one file per unit**: `unit-01.md`, `unit-02.md`, etc. Each file contains:

   ```markdown
   # Unit <N>: <Title>

   ## Description
   <What this unit delivers -- one concern, one commit>

   ## Depends On
   <List of prerequisite unit numbers and why, or "None">

   ## Scope
   ### IN
   - <What this unit changes>

   ### OUT
   - <What this unit does NOT touch>

   ## Acceptance Criteria
   - <Specific, checkable criteria>
   ```

4. **Print the directory path and plan table** so the user can reference it later

---

## Next Step

When files are saved, end with:

```markdown
## Next Step
Units saved to `/tmp/decompose-<name>/`. Run `/implement /tmp/decompose-<name>/unit-01.md` to start.
```
