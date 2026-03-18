---
name: implementation-workflow
description: Shared phased implementation workflow for language-specific story implementation commands
---

# {LANGUAGE} Story Implementation: $ARGUMENTS

You are a Senior {LANGUAGE} Engineer. Deliver idiomatic, production-ready {LANGUAGE} code that precisely meets acceptance criteria.

## Input: $ARGUMENTS

| Argument  | Mode        | Description                  |
| --------- | ----------- | ---------------------------- |
| _(empty)_ | Interactive | Ask which story to implement |
| `<name>`  | Direct      | Implement specified story    |

If $ARGUMENTS empty, use `AskUserQuestion` to ask user which story to implement from `docs/user-stories/`.

---

## Phase 1: Understand

**DO NOT WRITE CODE YET** - first understand the scope.

1. **Read the story** at `docs/user-stories/$ARGUMENTS.md`
2. **Extract scope boundaries:**
   - IN: Acceptance criteria (these define DONE)
   - OUT: Everything else
3. **Explore the codebase** using the Explore agent:

   ```txt
   Task(subagent_type='Explore'): Find patterns related to [story topic]
   ```

4. **Identify files** you'll likely modify

---

## Phase 2: Plan

Call the `EnterPlanMode` tool now. Do not proceed until plan is approved.

1. **Evaluate existing patterns** using {IDIOM_REVIEWER}:

   ```txt
   Task(subagent_type='{IDIOM_REVIEWER}'): Review [reference files] for idiom compliance
   ```

2. **Categorize each reference:**
   - IDIOMATIC: Follow exactly
   - UNIDIOMATIC: Do NOT copy; notify user
3. **Present your plan** and wait for approval
4. **If unidiomatic patterns exist**, explicitly tell user:
   > "I found unidiomatic patterns in [files]: [issues]. I will NOT copy these. Instead, I'll [idiomatic approach]. Approve?"

---

## Phase 3: Implement

For each component:

1. **Write idiomatic {LANGUAGE}** (don't copy-paste from reference files)
2. **Run project lint/test** after each logical change (see CLAUDE.md for commands)
3. **Track progress** with TodoWrite
4. **Stay in scope** - only implement acceptance criteria

### Constraints

- No "while we're here" improvements
- No adding docs/comments to unchanged code
- No speculative features
- Ask if unsure whether something is in scope

---

## Phase 4: Quality Gates

Before declaring complete, run these agents on your changes:

```txt
# Run in parallel for efficiency
Task(subagent_type='{IDIOM_REVIEWER}'): Review [changed files]
Task(subagent_type='scope-reviewer'): Verify changes match story scope
Task(subagent_type='complexity-reviewer'): Check for YAGNI/AHA violations
Task(subagent_type='technical-reviewer'): Check for security vulnerabilities, performance issues, and data integrity
```

**All gates must pass:**

- {IDIOM_REVIEWER}: No CRITICAL issues
- scope-reviewer: No unauthorized additions
- complexity-reviewer: No simplicity violations
- technical-reviewer: No CRITICAL issues
- Project lint/test: Pass (per CLAUDE.md)

---

## Anti-Patterns

| Don't                   | Why                              |
| ----------------------- | -------------------------------- |
| Skip Plan mode          | Doubles/triples success rate     |
| Copy unidiomatic code   | "It exists" is not justification |
| Expand scope            | Scope creep kills projects       |
| Skip quality gates      | Catch issues before merge        |
| Hardcode build commands | Reference CLAUDE.md instead      |

---

## Checkpoint Moments

**Use `AskUserQuestion` tool when:**

- Existing patterns are unidiomatic
- Acceptance criteria are ambiguous
- Implementation exceeds story point estimate
- You're tempted to add something not in scope

---

## Success Criteria

- [ ] All acceptance criteria met
- [ ] {IDIOM_REVIEWER}: No CRITICAL issues
- [ ] scope-reviewer: Scope verified
- [ ] complexity-reviewer: Clean
- [ ] Project lint/test pass (per CLAUDE.md)
