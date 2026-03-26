---
name: implement
description: Phased implementation workflow with idiom enforcement and scope discipline
---

# Implement Skill

Phased workflow for implementing a single decomposed unit. The calling skill detects the project language and selects the appropriate idiom reviewer.

## Golden Rule

**Idiomatic code always wins.** If existing code conflicts with language idioms, write idiomatic code and notify the user. Never propagate bad patterns.

## Phase 1: Understand

**DO NOT WRITE CODE YET** - first understand the scope.

1. **Read the unit** description (from a unit file path, decomposition output, or user input)
2. **Extract scope boundaries:**
   - IN: What this unit delivers (one concern, one commit)
   - OUT: Everything else
3. **Explore the codebase** using the Explore agent for affected areas
4. **Identify files** you'll likely modify

## Phase 2: Plan

Call `EnterPlanMode`. Do not proceed until plan is approved.

1. **Run the idiom reviewer** on reference files to evaluate existing patterns
2. **Categorize each reference:**
   - IDIOMATIC: Follow exactly
   - UNIDIOMATIC: Do NOT copy; notify user
3. **Present your plan** and wait for approval
4. **If unidiomatic patterns exist**, tell user explicitly what you found and what you'll do instead

## Phase 3: Implement

For each component:

1. **Write idiomatic code** (don't copy-paste from reference files)
2. **Run project lint/test** after each logical change (see CLAUDE.md for commands)
3. **Stay in scope** - only implement what the unit describes

### Constraints

- No "while we're here" improvements
- No adding docs/comments to unchanged code
- No speculative features
- Ask if unsure whether something is in scope

## Anti-Patterns

| Don't | Why |
| --- | --- |
| Skip Plan mode | Doubles/triples success rate |
| Copy unidiomatic code | "It exists" is not justification |
| Expand scope | Scope creep kills projects |
| Skip lint/test before review | Catch build failures early |
| Hardcode build commands | Reference CLAUDE.md instead |

## Checkpoint Moments

**Use `AskUserQuestion` when:**

- Existing patterns are unidiomatic
- Unit description is ambiguous
- Implementation exceeds expected size
- You're tempted to add something not in scope
