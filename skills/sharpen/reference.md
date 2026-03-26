---
name: sharpen
description: Expert knowledge for improving Claude Code skills and agents.
---

# Prompt Engineering for Claude Code

Transform skills and agents into well-structured, effective, maintainable configurations.

## Core Insights

### On Plan Mode

> Enter Plan mode (EnterPlanMode tool), go back and forth with Claude on the plan, and when it's solid, switch to auto-accept mode. Claude can usually 1-shot the implementation.

**Application**: Skills should encourage plan mode for complex operations.

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

## Quality Checklist: Skills

### Structure (Score 0-10)

- [ ] YAML frontmatter with `description`
- [ ] `argument-hint` if skill takes arguments
- [ ] `allowed-tools` restricts to minimum needed
- [ ] `disable-model-invocation: true` for skills with side effects
- [ ] Under 300 lines (focused scope)
- [ ] Has supporting files for details (reference.md, patterns.md)
- [ ] Clear workflow phases (numbered or named)
- [ ] Uses `$ARGUMENTS` appropriately

### Behavior (Score 0-10)

- [ ] Uses `AskUserQuestion` when clarification needed
- [ ] Single responsibility (doesn't do everything)
- [ ] Clear entry and exit conditions
- [ ] Verification step before completion
- [ ] References CLAUDE.md for project-specific info

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
- [ ] Severity levels defined (P1, P2, P3)

### Behavior (Score 0-10)

- [ ] Single focused responsibility
- [ ] Confidence criteria before flagging issues
- [ ] Evidence required for findings
- [ ] Conservative (avoids false positives)
- [ ] Actionable output format

---

## Improvement Patterns

### Pattern: Bloated Skill

**Symptom**: Skill over 300 lines, multiple unrelated phases.

**Fix**:

1. Split into focused skills
2. Extract expertise to reference files
3. Use agents for parallel work
4. Each skill does one thing well

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

**Symptom**: Implementation skills jump straight to coding.

**Fix**:

1. Add "REQUIRED: Enter Plan Mode" section
2. Structure phases to require planning first
3. Plan mode significantly improves success rates
4. Use `EnterPlanMode` tool call

### Pattern: Scope Creep

**Symptom**: Skill tries to handle all variations.

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

### Skill Anti-Patterns

| Pattern            | Symptom                                            | Severity |
| ------------------ | -------------------------------------------------- | -------- |
| Kitchen sink       | >300 lines, multiple unrelated phases              | P1       |
| No verification    | Completes without validation                       | P1       |
| Hardcoded build cmds | Build commands embedded, not referencing CLAUDE.md | P2       |
| Missing arguments  | No `$ARGUMENTS` handling when needed               | P2       |
| No questions       | Never uses `AskUserQuestion`                       | P2       |
| No examples        | Missing supporting reference files                 | P2       |
| Stale references   | Links to outdated docs                             | P2       |
| Missing allowed-tools | No tool restrictions declared                   | P2       |

### Agent Anti-Patterns

| Pattern            | Symptom                      | Severity |
| ------------------ | ---------------------------- | -------- |
| God agent          | All tools, unfocused scope   | P1       |
| No severity levels | Findings lack prioritization | P2       |
| Echo agent         | Summarizes without analysis  | P2       |
| No evidence        | Flags issues without proof   | P1       |
| Aggressive         | Flags hypothetical issues    | P2       |

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
"Claude Code custom skills patterns"
"Claude Code plugin skills agents"
"Claude Code subagent patterns"
"agentic coding prompt engineering"
"LLM instruction tuning best practices"
```

---

## Output Format

When presenting analysis:

```markdown
# Analysis: [artifact name]

**Type**: Skill | Agent
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
