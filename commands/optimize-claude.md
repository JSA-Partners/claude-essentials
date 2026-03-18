---
description: Improve Claude Code commands, skills, and agents using proven patterns
argument-hint: [component | commands | skills | agents | --all]
---

# Optimize Claude Code Configuration

Systematically improve this project's commands, skills, and agents using proven patterns.

## CRITICAL: Plan Mode Required

**Before ANY analysis or changes, you MUST call the EnterPlanMode tool.**

This ensures we collaborate on improvements rather than making premature changes.

---

## Skill Reference

Load on-demand for comprehensive expertise:

- `skills/prompt-engineer/SKILL.md` - Quality checklists, scoring, patterns
- `skills/prompt-engineer/patterns.md` - Reusable templates for commands/skills/agents

---

## Input: $ARGUMENTS

| Argument   | Scope        | Description                                   |
| ---------- | ------------ | --------------------------------------------- |
| _(empty)_  | Interactive  | Ask what to improve                           |
| `commands` | All commands | Review all files in `commands/`     |
| `skills`   | All skills   | Review all directories in `skills/` |
| `agents`   | All agents   | Review all files in `agents/`       |
| `--all`    | Full audit   | Review commands, skills, and agents           |
| `<name>`   | Specific     | Review specific component by name             |

---

## Execution Flow

### Phase 1: Enter Plan Mode

**MANDATORY FIRST STEP:**

```txt
Call EnterPlanMode tool immediately.
Do not proceed without plan mode active.
```

### Phase 2: Research Current Best Practices

Search for current industry best practices:

```txt
Use WebSearch tool with queries like:
- "Claude Code best practices 2026"
- "Claude Code custom commands patterns"
- "agentic coding prompt engineering"
```

### Phase 3: Gather Context

Before suggesting ANY improvements, use AskUserQuestion to understand:

1. **Pain points**: What problems are you experiencing with current configs?
2. **Goals**: What do you want Claude Code to do better?
3. **Constraints**: Any workflows or patterns that must be preserved?

**Never assume.** If something is unclear, ask.

### Phase 4: Analyze Current State

Based on scope from $ARGUMENTS:

1. Read all relevant configuration files
2. Load `skills/prompt-engineer/SKILL.md` for quality checklists
3. Score each artifact against the checklists (0-10)
4. Identify gaps, anti-patterns, and opportunities
5. **Do NOT suggest fixes yet** - present findings first

### Phase 5: Present Findings

Use the output format from the skill:

```markdown
# Analysis: [artifact name]

**Type**: Command | Skill | Agent
**Current Score**: X/10
**Files Reviewed**: [list]

## Strengths

- [What's working well]

## Issues Found

### [SEVERITY]: [Issue Name]

- **Current**: [what exists]
- **Problem**: [why it's suboptimal]
- **Best practice**: [relevant principle]
- **Fix**: [specific recommendation]

## Recommended Changes

1. [Priority 1 change]
2. [Priority 2 change]
```

### Phase 6: Confirm Improvements

Use AskUserQuestion to confirm which improvements to implement:

```txt
Question: "Which improvements should I implement?"
Options:
- All recommendations
- Priority 1 only (highest impact)
- Select specific ones
- None yet (I have questions)
```

### Phase 7: Implement

For each approved improvement:

1. Make the specific change
2. Explain what was changed and why
3. Verify the change follows patterns from `skills/prompt-engineer/patterns.md`

**File Creation Authority**: You may create new files (skills, agents, commands) if beneficial. Always explain why and get approval first.

---

## Core Principles

Apply these in all recommendations:

| Principle            | Application                            |
| -------------------- | -------------------------------------- |
| Plan mode            | Require planning before implementation |
| Verification         | Include feedback loops in workflows    |
| Focused agents       | Single responsibility per agent        |
| Hooks for formatting | Deterministic tools, not LLMs          |
| Skills over bloat    | On-demand loading, <500 lines          |

---

## Anti-Patterns to Always Flag

| Pattern               | Problem                       | Fix                       |
| --------------------- | ----------------------------- | ------------------------- |
| >150 line command     | Scope creep, hard to maintain | Split or extract to skill |
| No verification step  | No way to catch errors        | Add quality gate phase    |
| No `AskUserQuestion`  | Assumes instead of asks       | Add clarification points  |
| Hardcoded commands    | Goes stale, not portable      | Reference CLAUDE.md       |
| God agent (all tools) | Unfocused, unreliable         | Restrict tools to needs   |

---

## Success Criteria

Before completing:

- [ ] All requested artifacts analyzed
- [ ] Scores provided with rationale
- [ ] User approved specific improvements
- [ ] Changes follow patterns from skill
- [ ] New files explained and approved (if any)
