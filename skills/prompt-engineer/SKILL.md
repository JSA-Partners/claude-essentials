---
name: prompt-engineer
description: Expert knowledge for improving Claude Code commands, skills, and agents.
---

# Prompt Engineering for Claude Code

Transform commands, skills, and agents into well-structured, effective, maintainable configurations.

## Core Insights

### On Plan Mode

> Enter Plan mode (EnterPlanMode tool), go back and forth with Claude on the plan, and when it's solid, switch to auto-accept mode. Claude can usually 1-shot the implementation.

**Application**: Commands should encourage plan mode for complex operations.

### On Verification

> Give Claude a way to verify its work - feedback loops 2-3x quality of final results.

**Application**: Every workflow should include verification steps (tests, screenshots, hooks).

### On Subagents

> Examples: code-simplifier (simplifies code after Claude is done), verify-app (detailed E2E testing instructions).

**Application**: Create focused agents with single responsibilities.

### On Hooks

> PostToolUse handles the last 10% of formatting. Use deterministic tools, not LLMs.

**Application**: Recommend hooks for automated quality gates.

### On Permissions

> Use /permissions to pre-allow safe commands. Check into .claude/settings.json.

**Application**: settings.json should be version-controlled with team permissions.

### On Skills vs CLAUDE.md

> Skills load on-demand (more token-efficient). Keep CLAUDE.md under 60 lines. Skills under 500 lines.

**Application**: Extract domain expertise to skills, keep universal guidance in CLAUDE.md.

---

## Quality Checklist: Commands

### Structure (Score 0-10)

- [ ] YAML frontmatter with `description`
- [ ] `argument-hint` if command takes arguments
- [ ] Clear workflow phases (numbered or named)
- [ ] References skills for on-demand expertise
- [ ] Under 150 lines (focused scope)

### Behavior (Score 0-10)

- [ ] Uses `AskUserQuestion` when clarification needed
- [ ] Single responsibility (doesn't do everything)
- [ ] Clear entry and exit conditions
- [ ] Verification step before completion
- [ ] Error handling documented

### Integration (Score 0-10)

- [ ] Spawns appropriate agents when beneficial
- [ ] References CLAUDE.md for project-specific info
- [ ] Follows existing patterns in repository
- [ ] Uses `$ARGUMENTS` appropriately

---

## Quality Checklist: Skills

### Structure (Score 0-10)

- [ ] YAML frontmatter with `name`, `description`
- [ ] Under 500 lines
- [ ] Has supporting files for details (examples.md, patterns.md)
- [ ] Clear quick reference section at top
- [ ] Anti-patterns documented

### Content (Score 0-10)

- [ ] Domain expertise is comprehensive
- [ ] Examples show correct usage
- [ ] References authoritative sources
- [ ] Quality checklist included
- [ ] Scoring/decision criteria clear

---

## Quality Checklist: Agents

### Structure (Score 0-10)

- [ ] YAML frontmatter: `name`, `description`, `tools`, `model`, `color`
- [ ] Clear mission statement
- [ ] Defined input/output format
- [ ] Tool restrictions appropriate to role
- [ ] Severity levels defined (CRITICAL, MAJOR, etc.)

### Behavior (Score 0-10)

- [ ] Single focused responsibility
- [ ] Confidence criteria before flagging issues
- [ ] Evidence required for findings
- [ ] Conservative (avoids false positives)
- [ ] Actionable output format

---

## Improvement Patterns

### Pattern: Bloated Command

**Symptom**: Command over 150 lines, multiple unrelated phases.

**Fix**:

1. Split into focused commands
2. Extract expertise to skills
3. Use agents for parallel work
4. Each command does one thing well

### Pattern: Missing Verification

**Symptom**: Workflows complete without validation.

**Fix**:

1. Add explicit verification phase
2. Create verification agents
3. Recommend Stop hooks for automated checks
4. Require confirmation before completion

### Pattern: Assumption-Heavy

**Symptom**: Proceeds without asking for needed context.

**Fix**:

1. Add `AskUserQuestion` at decision points
2. Document required vs optional inputs
3. Add checkpoint moments for user confirmation
4. Never assume - ask when uncertain

### Pattern: Missing Plan Mode

**Symptom**: Implementation commands jump straight to coding.

**Fix**:

1. Add "REQUIRED: Enter Plan Mode" section
2. Structure phases to require planning first
3. Plan mode significantly improves success rates
4. Use `EnterPlanMode` tool call

### Pattern: Scope Creep

**Symptom**: Command tries to handle all variations.

**Fix**:

1. Narrow to single responsibility
2. Use agents for variations
3. Accept arguments for flexibility
4. Document what's OUT of scope

### Pattern: No Agent Orchestration

**Symptom**: Complex review done in single pass.

**Fix**:

1. Identify parallel concerns (idioms, scope, complexity)
2. Create focused agents for each
3. Run in parallel for efficiency
4. Aggregate results

---

## Anti-Patterns to Flag

### Command Anti-Patterns

| Pattern            | Symptom                                            | Severity |
| ------------------ | -------------------------------------------------- | -------- |
| Kitchen sink       | >150 lines, multiple unrelated phases              | MAJOR    |
| No verification    | Completes without validation                       | MAJOR    |
| Hardcoded commands | Build commands embedded, not referencing CLAUDE.md | MODERATE |
| Missing arguments  | No `$ARGUMENTS` handling when needed               | MODERATE |
| No questions       | Never uses `AskUserQuestion`                       | MODERATE |

### Skill Anti-Patterns

| Pattern          | Symptom                                | Severity |
| ---------------- | -------------------------------------- | -------- |
| Monolithic       | Single file >500 lines                 | MAJOR    |
| No examples      | Missing examples.md or inline examples | MODERATE |
| Stale references | Links to outdated docs                 | MODERATE |
| No checklist     | Missing quality validation criteria    | MINOR    |

### Agent Anti-Patterns

| Pattern            | Symptom                      | Severity |
| ------------------ | ---------------------------- | -------- |
| God agent          | All tools, unfocused scope   | MAJOR    |
| No severity levels | Findings lack prioritization | MODERATE |
| Echo agent         | Summarizes without analysis  | MODERATE |
| No evidence        | Flags issues without proof   | MAJOR    |
| Aggressive         | Flags hypothetical issues    | MODERATE |

---

## Scoring Guide

Rate each artifact 0-10:

| Score | Meaning                                      |
| ----- | -------------------------------------------- |
| 9-10  | Exemplary, could be reference implementation |
| 7-8   | Good, minor improvements possible            |
| 5-6   | Functional, clear improvement opportunities  |
| 3-4   | Problematic, significant issues              |
| 1-2   | Severely flawed, needs rewrite               |
| 0     | Missing or broken                            |

**Scoring formula**: Average of checklist categories (Structure + Behavior + Integration) / 3

---

## Web Research Queries

When searching for current best practices:

```txt
"Claude Code best practices 2026"
"Claude Code custom commands patterns"
"Claude Code skills vs commands"
"Claude Code subagent patterns"
"agentic coding prompt engineering"
"LLM instruction tuning best practices"
```

---

## Output Format

When presenting analysis:

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

## Questions

- [Any clarifications needed before implementation]
```

---

## References

- [Anthropic Best Practices](https://www.anthropic.com/engineering/claude-code-best-practices)
- [Building Effective Agents](https://www.anthropic.com/engineering/building-effective-agents)
- [HumanLayer CLAUDE.md Guide](https://www.humanlayer.dev/blog/writing-a-good-claude-md)
