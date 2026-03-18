---
name: plan-template
description: Template for individual implementation plan files
---

# Plan Template

Use this structure for every plan file. Adapt sections as needed but preserve the ordering.

## Template

````markdown
# Plan XX: [Descriptive Title] (Phase N)

## Dependencies

- **plan-XX**: [Why this dependency exists]
- None. (if no dependencies)

## Scope

[1-3 sentences: what this plan does and does NOT do.]

## Research-Driven Decisions

[Only include if research informed this plan's approach.]

- **[Topic]**: [Finding from established projects] → [Decision for this codebase]

## Current State

[Show the code/pattern as it exists today. Use actual code snippets from the codebase.]

```lang
// Before — actual code from the codebase
```

## Target State

[Show what the code/pattern should look like after this plan.]

```lang
// After — what we're building toward
```

## Steps

### Step 1: [Action verb] [specific thing]

[Details: what to do, what to watch for, what the expected outcome is.]

### Step 2: [Action verb] [specific thing]

[Continue for each logical step.]

## Files Changed

| File | Action |
|------|--------|
| `path/to/file.go` | **New**: [what it contains] |
| `path/to/existing.go` | [what changes] |

## Acceptance Criteria

- [ ] [Specific verifiable condition with command or inspection method]
- [ ] `make build` passes
- [ ] `make test` passes (or `make test-run PKG=./specific/...`)
- [ ] `make lint` passes

## Risks

[Only include if there are non-obvious risks or edge cases.]

- **[Risk]**: [Description]
- **Mitigation**: [How to handle it]
````

## Key Rules

- **Dependencies**: state WHY each dependency exists, not just the plan number
- **Scope**: first sentence = what it DOES, second = what it does NOT (prevents scope creep)
- **Current/Target State**: use REAL code from the codebase; omit for greenfield plans
- **Steps**: action verbs ("Create", "Refactor", "Add"), include verification substeps
- **Files Changed**: list EVERY file — use **New**, **Refactor**, **Add**, **Remove** labels
- **Acceptance Criteria**: plan-specific first, then build/test/lint verification
- **Risks**: only non-obvious risks; every risk needs a mitigation; omit if none

## Index Plan Template

When a plan is split into sub-plans, the parent becomes an index:

````markdown
# Plan XX: [Title] (Phase N)

**This plan has been split into sub-plans. See:**

- `plan-XX-01.md` — [Description]
- `plan-XX-02.md` — [Description]
- `plan-XX-03.md` — [Description]

## Execution Order

[State which sub-plans can run in parallel and which must be sequential.]

## Shared Decisions

[Any research decisions or conventions that apply across all sub-plans.]
````
