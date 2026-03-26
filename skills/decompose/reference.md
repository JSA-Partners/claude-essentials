---
name: decompose
description: Decompose user stories into dependency-ordered implementation units
---

# Decompose Skill

Break stories or specs into single-commit implementation units with strict dependency ordering.

## Core Principle

**Units are dependency-ordered work items.** Each unit is one commit, independently reviewable, independently testable, and safe to merge without later units existing.

## Quick Reference

| # | Rule | Key Test |
|---|------|----------|
| 1 | Dependency-first ordering | Units form a DAG -- no circular deps |
| 2 | One concern per unit | Can you describe the unit in one sentence? |
| 3 | Production/test separation | Production refactors don't include test migration |
| 4 | Reviewable size | <15 files, <3 packages, <8 steps |
| 5 | Temporary compatibility | Build and tests pass after every unit |

## Decomposition Rules

### Rule 1: Dependency-First Ordering

Units form a directed acyclic graph. Every unit explicitly lists what it depends on. If unit B needs artifacts from unit A, unit A comes first. Units at the same level can execute in parallel.

### Rule 2: One Concern Per Unit

Each unit should change code for one reason:

| Good | Bad |
| --- | --- |
| "Add test helpers" | "Add test helpers and migrate 3 handler tests" |
| "Refactor authors package" | "Refactor authors and publications packages" |
| "Create store-level tests" | "Create store tests and delete handler tests" |

### Rule 3: Production and Test Separation

When a story involves both production code changes and test migration:

1. Production refactors get their own units (they must not break existing tests)
2. New test infrastructure gets its own unit
3. Test migration gets per-package units
4. Test deletion happens only after replacement tests pass

### Rule 4: Reviewable Size

A unit should be reviewable in one sitting. Warning signs it's too large:

- Touches 15+ files
- Spans 3+ packages
- Has more than 8 steps
- Requires both production code changes and test changes

When a unit is too large, split by:

1. **By package** -- one sub-unit per package (most common)
2. **By layer** -- production code vs test code vs wiring
3. **By concern** -- interfaces vs implementation vs migration

### Rule 5: Temporary Compatibility

If a unit changes function signatures or APIs, it must either:

- Add deprecated wrappers that preserve the old signatures
- Update all callers in the same unit

Never leave the codebase in a broken state between units. Build and tests must pass after every unit.

## Anti-Patterns

| Don't | Instead |
| --- | --- |
| Create a unit that touches 4 packages | Split by package -- one sub-unit each |
| Mix "add new tests" with "delete old tests" | Separate: add first, delete after verification |
| List dependencies by number only | State WHY the dependency exists |
| Include "special considerations" catch-all | Flag edge cases inline within specific steps |
| Skip the "one sentence" test | If you can't summarize in one sentence, split |

## Research Protocol

When a technical decision needs "research idiomatic approach", search for actual implementations in established repos. Code over opinions.

### Reference Projects

**Go**: hashicorp/consul (HTTP handlers, middleware), hashicorp/vault (storage backends, plugins), cockroachdb/cockroach (SQL layer, store tests), kubernetes/kubernetes (API machinery, DI)

**SvelteKit**: sveltejs/kit (routing, hooks, load functions), sveltejs/realworld (full app patterns), huntabyte/shadcn-svelte (component composition, actions)

**TypeScript**: effect-ts/effect (error handling, composability), colinhacks/zod (schema validation, type inference), trpc/trpc (end-to-end type safety, API patterns)

**Python**: pallets/flask (routing, blueprints), encode/starlette (async middleware, lifespan), python-attrs/attrs (data modeling), psf/requests (API design, session management)

### Research Quality

Before accepting research results:

- At least 3 real projects cited with file paths
- Actual code snippets shown (not paraphrased)
- Pattern consistency noted (do most projects agree?)
- Skip research when the codebase already has an established pattern or the user gave a specific preference

## Output Format

The deliverable is unit files written to `~/.cache/claude-essentials/<YYYY-MM-DD>-<short-descriptor>/`, not chat prose. Each unit becomes a separate markdown file (`unit-01.md`, `unit-02.md`, etc.) plus a `plan.md` with the summary table. The calling skill defines the exact file template -- this skill defines the decomposition rules only.

## Evaluation Checklist

Before writing the unit files, verify:

- [ ] Every unit has explicit dependencies listed
- [ ] No circular dependencies exist
- [ ] Each unit passes the "one concern" test
- [ ] Each unit can be merged independently without breaking the build
- [ ] Large units (15+ files) have been flagged for splitting
- [ ] Research decisions are documented with citations
- [ ] Acceptance criteria are specific and checkable
