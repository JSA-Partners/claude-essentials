---
description: Decompose a user story into dependency-ordered, reviewable implementation plans
argument-hint: <story-number>
---

# Decompose Story: $ARGUMENTS

If `$ARGUMENTS` is empty, use `AskUserQuestion` to ask which story to decompose. List available stories from `docs/user-stories/`.

Decompose a user story into chronological, dependency-ordered implementation plans. Each plan is a reviewable, workable chunk. **No assumptions** — ask clarifying questions for every ambiguity and research what idiomatic projects actually do.

## Skill Reference

- `skills/story-planner/SKILL.md` - Core decomposition rules
- `skills/story-planner/plan-template.md` - Plan file template
- `skills/story-planner/research-protocol.md` - How to research idiomatic patterns

## Phase 1: Discover

**DO NOT WRITE PLANS YET** — first understand what exists.

1. **Read the story** at `docs/user-stories/$ARGUMENTS.md`
2. **Deep codebase exploration** — launch an Explore agent:

   ```txt
   Task(subagent_type='Explore', thoroughness='very thorough'):
   Explore all code areas affected by [story topic].
   Map: current patterns, affected files, boilerplate, test structure.
   ```

3. **Second exploration pass** if the story is large — launch another Explore agent focused on areas the first pass surfaced.

Goal: Build a complete mental model of the current state before asking questions.

## Phase 2: Clarify

1. **Extract every decision point** from the story — anywhere there's a "how" not just a "what"
2. **Check against codebase** — does the current code answer the question?
3. **Ask remaining questions** via `AskUserQuestion`:
   - Group related questions (max 4 per call)
   - Always include a "Research idiomatic approach" option for technical decisions
   - Never batch more than you can fit in one screen

**Iterate** — if answers raise new questions, ask again. No limit on clarification rounds.

## Phase 3: Research

For every question answered with "research idiomatic approach" (and for core architectural decisions regardless):

1. **Detect project language** from CLAUDE.md `Tech Stack` section
2. **Launch parallel research agents** — one per open question:

   ```txt
   Task(subagent_type='general-purpose', model='opus'):
   Research how established [LANGUAGE] projects handle [SPECIFIC PATTERN].
   Search real repos on GitHub. Return actual code examples with repo names
   and file paths. Do NOT rely on training knowledge.
   ```

3. **Follow the full research protocol** in `skills/story-planner/research-protocol.md` for reference projects, prompt templates, and quality checks.
4. **Synthesize decisions** — for each researched question, state:
   - **Finding**: What established projects do (with citations)
   - **Decision**: What we'll do and why
5. **Present findings to user** for validation before proceeding.

## Phase 4: Decompose

Read `skills/story-planner/SKILL.md` for decomposition rules.

1. **Identify logical units** — group by shared dependencies, cohesive scope (one package, one concern), and reviewable size.
2. **Order by dependency** — strict topological sort. Plans at the same level can be parallelized; plans with dependencies must list them explicitly.
3. **Build the plan table** — present to user:

   ```txt
   | Plan | Phase | Description | Depends On |
   |------|-------|-------------|------------|
   ```

4. **Evaluate plan sizes** — ask the user about plans that touch 15+ files, span 3+ packages, or require both production and test changes.
5. **Split oversized plans** into sub-plans (`plan-XX-01.md`, etc.) after user approval.

## Phase 5: Write Plans

1. **Create output directory**: `temp/` in project root
2. **Write plans in parallel** — use `skills/story-planner/plan-template.md`
3. **Parent plans** that were split become index files referencing their sub-plans
4. **Final inventory** — list all created files with their dependency order

Output: `temp/plan-01.md`, `plan-02.md`, `plan-02-01.md` (sub-plans), etc.

## Phase 6: Verify

Run the `skeptic-reviewer` agent on all generated plans:

```txt
Task(subagent_type='skeptic-reviewer'):
Challenge each plan against the evaluation checklist below.
Verify that dependency ordering is correct, plans are independently mergeable,
and no plan exceeds reviewable size. Reject plans that fail criteria.
```

**Evaluation checklist:**

- [ ] Every plan has explicit dependencies listed
- [ ] No circular dependencies exist
- [ ] Each plan passes the "one concern" test
- [ ] Each plan can be merged independently without breaking the build
- [ ] Large plans (15+ files) have been flagged for splitting
- [ ] Research decisions are documented with citations
- [ ] Acceptance criteria are specific and checkable

Fix any violations the skeptic-reviewer identifies before presenting the final inventory to the user.

## Anti-Patterns

| Don't | Instead |
| --- | --- |
| Assume how something should work | Ask the user or research idiomatic patterns |
| Rely on training knowledge for patterns | Search real repos and cite actual code |
| Write plans before understanding the code | Explore thoroughly first (Phase 1) |
| Create one massive plan | Decompose until each plan is independently reviewable |
| Skip dependency ordering | Every plan must list what it depends on |

## Checkpoint Moments

**Stop and ask user when:**

- A story phase has unclear boundaries
- Research reveals conflicting patterns across projects
- A plan touches more than 15 files
- You're unsure whether something should be one plan or two
- The story references other stories that may not be complete
