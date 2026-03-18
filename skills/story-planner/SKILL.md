---
name: story-planner
description: Decompose user stories into dependency-ordered implementation plans
---

# Story Planner Skill

Break large user stories into reviewable, implementable plans with strict dependency ordering.

## Core Principle

**Plans are dependency-ordered work units.** Each plan should be independently reviewable, independently testable, and safe to merge without later plans existing.

## Quick Reference

| # | Rule | Key Test |
|---|------|----------|
| 1 | Dependency-first ordering | Plans form a DAG — no circular deps |
| 2 | One concern per plan | Can you describe the plan in one sentence? |
| 3 | Production/test separation | Production refactors don't include test migration |
| 4 | Reviewable size | <15 files, <3 packages, <8 steps |
| 5 | Sub-plan naming | `plan-XX.md` top-level, `plan-XX-NN.md` sub-plans |
| 6 | Temporary compatibility | `make build && make test` passes after every plan |

## Decomposition Rules

### Rule 1: Dependency-First Ordering

Plans form a directed acyclic graph. Every plan explicitly lists what it depends on. If plan B needs artifacts from plan A, plan A comes first. Plans at the same level can execute in parallel.

### Rule 2: One Concern Per Plan

Each plan should change code for one reason:

| Good | Bad |
| --- | --- |
| "Add test helpers" | "Add test helpers and migrate 3 handler tests" |
| "Refactor authors package" | "Refactor authors and publications packages" |
| "Create store-level tests" | "Create store tests and delete handler tests" |

### Rule 3: Production and Test Separation

When a story involves both production code changes and test migration:

1. Production refactors get their own plans (they must not break existing tests)
2. New test infrastructure gets its own plan
3. Test migration gets per-package plans
4. Test deletion happens only after replacement tests pass

### Rule 4: Reviewable Size

A plan should be reviewable in one sitting. Warning signs it's too large:

- Touches 15+ files
- Spans 3+ packages
- Has more than 8 steps
- Requires both production code changes and test changes

When a plan is too large, split by:

1. **By package** — one sub-plan per package (most common)
2. **By layer** — production code vs test code vs wiring
3. **By concern** — interfaces vs implementation vs migration

### Rule 5: Sub-Plan Naming

```txt
plan-01.md          # Top-level plan
plan-02.md          # Top-level plan (becomes index if split)
plan-02-01.md       # Sub-plan of plan-02
plan-02-02.md       # Sub-plan of plan-02
plan-03.md          # Top-level plan
```

When a plan is split, the parent file becomes an index referencing sub-plans with their execution order and any shared context (decisions, conventions).

### Rule 6: Temporary Compatibility

If a plan changes function signatures or APIs, it must either:

- Add deprecated wrappers that preserve the old signatures
- Update all callers in the same plan

Never leave the codebase in a broken state between plans. `make build && make test` must pass after every plan.

## Anti-Patterns

| Don't | Instead |
| --- | --- |
| Create a plan that touches 4 packages | Split by package — one sub-plan each |
| Mix "add new tests" with "delete old tests" | Separate: add first, delete after verification |
| List dependencies by number only | State WHY the dependency exists |
| Include "special considerations" catch-all | Flag edge cases inline within specific steps |
| Skip the "one sentence" test | If you can't summarize in one sentence, split |

## Decision Documentation

Every plan that was informed by research must include:

```markdown
## Research-Driven Decisions

- **[Topic]**: [What established projects do] → [What we'll do]
```

## Acceptance Criteria Pattern

Every plan must end with acceptance criteria that are:

- **Checkable** — can be verified with a command or code inspection
- **Specific** — not "tests pass" but "make test-run PKG=./path/... passes"
- **Complete** — cover the "no regressions" case (build, lint, test)

```markdown
## Acceptance Criteria

- [ ] [Specific verifiable condition]
- [ ] `make build` passes
- [ ] `make test` passes (or specific package test)
- [ ] `make lint` passes
```

## Plan Evaluation Checklist

Before presenting plans to the user, verify:

- [ ] Every plan has explicit dependencies listed
- [ ] No circular dependencies exist
- [ ] Each plan passes the "one concern" test
- [ ] Each plan can be merged independently without breaking the build
- [ ] Large plans (15+ files) have been flagged for splitting
- [ ] Research decisions are documented with citations
- [ ] Acceptance criteria are specific and checkable
