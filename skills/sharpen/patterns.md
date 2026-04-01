# Reusable Patterns for Skills and Agents

Templates and patterns for creating well-structured Claude Code artifacts.

---

## Skill Patterns

### Interactive Skill

Use when user input shapes the workflow:

```markdown
---
description: [verb] [object] with [method]
argument-hint: [example input]
allowed-tools: Read, Write, Glob
---

# Skill Name

Brief description.

## Input: $ARGUMENTS

| Argument  | Mode        | Description    |
| --------- | ----------- | -------------- |
| _(empty)_ | Interactive | Ask what to do |
| `<value>` | Direct      | Apply to value |

## Phase 1: Gather Input

If $ARGUMENTS empty, use AskUserQuestion.

## Phase 2: Process

[workflow steps]

## Phase 3: Verify & Output

[verification and output format]
```

### Plan-Required Skill

Use for implementation tasks:

```markdown
---
description: [verb] [object] with quality gates
argument-hint: <identifier>
allowed-tools: Read, Write, Edit, Bash, Grep, Glob
---

# Skill Name: $ARGUMENTS

## CRITICAL: Plan Mode Required

**Before ANY work, call the EnterPlanMode tool.**

## Phase 1: Understand

DO NOT WRITE CODE YET.

1. Read [sources]
2. Explore codebase
3. Identify scope boundaries

## Phase 2: Plan

1. Present approach
2. Wait for approval

## Phase 3: Implement

[implementation with verification]

## Phase 4: Quality Gates

Before declaring complete:

- [ ] Gate 1
- [ ] Gate 2
```

### Agent-Orchestrating Skill

Use when parallel specialized work improves quality:

```markdown
---
description: [verb] [object] using specialized agents
argument-hint: [scope]
context: fork
allowed-tools: Read, Grep, Glob, Agent
---

# Skill Name

## Phase 1: Identify Scope

[how to determine what to work on]

## Phase 2: Parallel Analysis

Run these agents in parallel. All read-only agents share the parent's prompt cache, so parallel spawning is cheap. Prefer agents with read-only tools (Read, Grep, Glob) for concurrency.

| Agent     | Focus            |
| --------- | ---------------- |
| `agent-1` | [responsibility] |
| `agent-2` | [responsibility] |

## Phase 3: Synthesize

Combine agent outputs into unified report.

## Phase 4: Act on Findings

[how to address issues found]
```

### Domain Expertise Skill (Reference Only)

Use for agent reference material with `user-invocable: false`:

```markdown
---
name: skill-name
description: [when to use this skill]
---

# Skill Name

## Quick Reference

[most common lookups -- tables, lists]

## Core Concepts

[domain knowledge organized by topic]

## Anti-Patterns

| Don't | Instead |
| ----- | ------- |
| ...   | ...     |
```

---

## Agent Patterns

### Reviewer Agent

````md
---
name: agent-name
description: Reviews [scope] for [focus]
tools: [Read, Grep, Glob]
model: opus
color: yellow
---

# Agent Name

You review [scope] for [focus].

## Mission

[single sentence purpose]

## Your Strengths

- [strength 1 -- what you are best at]
- [strength 2 -- what you catch that others miss]
- [strength 3 -- your analytical approach]

## Analysis Protocol

For each item:

1. [detection step]
2. [analysis step]
3. [classification step]

## Severity Levels

| Level | Definition   | Action                |
| ----- | ------------ | --------------------- |
| P1    | [definition] | Must fix before merge |
| P2    | [definition] | Should fix            |
| P3    | [definition] | Consider fixing       |

## Output Format

### If issues found

```markdown
## [SEVERITY]: [Issue Name]

**Location**: [file:line]
**Evidence**: [quote or reference]
**Problem**: [explanation]
**Fix**: [recommendation]
```

### If clean

```markdown
No [focus] issues found.
```

## When Things Go Wrong

If analysis is uncertain:

1. Check your assumptions against the actual code
2. Look for project-specific conventions in CLAUDE.md
3. When genuinely ambiguous, note the uncertainty rather than guessing

Do NOT flag issues you are not confident about. Err toward fewer, higher-confidence findings.

## False Positive Avoidance

Do NOT flag:

- [exception 1]
- [exception 2]
````

### Generator Agent

````md
---
name: agent-name
description: Generates [output type] from [input type]
tools: [Read, Grep, Glob]
model: opus
color: cyan
---

# Agent Name

You generate [output type] from [input type].

## Mission

[single sentence purpose]

## Your Strengths

- [strength 1]
- [strength 2]

## Input Format

[expected input structure]

## Analysis Protocol

1. [phase 1: gather context]
2. [phase 2: analyze]
3. [phase 3: generate]

## Output Format

```markdown
[structured output template]
```

## Quality Requirements

- [requirement 1]
- [requirement 2]
````

---

## File Reference Patterns

### Same-directory references

Use `${CLAUDE_SKILL_DIR}` for portable paths. The loader substitutes this with the skill's absolute directory path at invocation time, regardless of whether the skill is loaded from a project or plugin.

```markdown
Load `${CLAUDE_SKILL_DIR}/reference.md` for quality checklists.
```

Do NOT use hardcoded relative paths like `skills/sharpen/reference.md`. These resolve from cwd, not the skill directory, and break when loaded as a plugin.

### Cross-skill references

Navigate from the skill directory:

```markdown
Load `${CLAUDE_SKILL_DIR}/../sharpen/reference.md` for quality criteria.
```

### Supporting files are not auto-loaded

Only `SKILL.md` is injected when a skill is invoked. Supporting files (reference.md, patterns.md) require the model to Read them explicitly. Design accordingly:

- Inline the most critical guidance directly in SKILL.md
- Use supporting files for deep-dive reference material
- Keep SKILL.md under 5K tokens so it survives compaction re-injection

---

## Prompt Crafting Patterns

### Emphasis Hierarchy

Calibrate emphasis markers to avoid dilution:

```markdown
## CRITICAL: [The One Rule]            <!-- 1x max per artifact -->

[explanation with justification]

IMPORTANT: [Rule that prevents common mistakes]   <!-- 2-3x per artifact -->

NEVER [absolute prohibition]. [Alternative] instead.  <!-- targeted use -->

Do NOT [strong default]. [Reason].                    <!-- moderate use -->

[Normal guidance in plain prose.]                      <!-- everything else -->
```

### Failure Recovery Section

Include in every agent that performs multi-step work:

```markdown
## When Things Go Wrong

1. Read the error output carefully before retrying
2. Check assumptions against actual code or state
3. Try a focused fix targeting the root cause
4. If genuinely stuck after investigation, report what you tried and what failed

Do NOT retry the identical action blindly. Do NOT abandon a viable approach
after a single failure. Do NOT escalate without investigation.
```

### Smart Colleague Briefing

Use when skills delegate to sub-agents:

```markdown
## Delegation Protocol

Brief sub-agents with full context. They have not seen this conversation.

NEVER delegate with vague references like "fix the bug we discussed."
ALWAYS include: file paths, line numbers, what specifically to change, and why.

Think of each agent prompt as briefing a smart colleague who just walked
into the room -- capable but without your context.
```

---

## YAML Frontmatter Reference

### Skills

```yaml
---
description: Required -- shown in / menu (250 char cap in listing)
when_to_use: Optional -- appended to description in listing ("{desc} - {when_to_use}")
argument-hint: Optional -- placeholder text
allowed-tools: Optional -- comma-separated tool list (auto-approves, not restricts)
disable-model-invocation: Optional -- true for skills with side effects
user-invocable: Optional -- false for agent-only reference skills
context: Optional -- fork to run in sub-agent
paths: Optional -- gitignore patterns for conditional activation
model: Optional -- override model
effort: Optional -- low | medium | high | max
---
```

### Agents

```yaml
---
name: Required -- agent identifier (becomes type in listing)
description: Required -- when to use (becomes one line in Agent tool)
tools: Required -- [Read, Grep, Glob] or ['*'] for all
disallowedTools: Optional -- exclude from wildcard
model: Required -- opus | haiku | inherit
color: Required -- blue | red | yellow | orange | magenta | cyan | green
effort: Optional -- low | medium | high | max
skills: Optional -- skills to preload as initial context
maxTurns: Optional -- conversation turn limit
memory: Optional -- user | project | local
---
```

---

## Naming Conventions

| Type   | Convention                                | Examples                                |
| ------ | ----------------------------------------- | --------------------------------------- |
| Skills | `verb/SKILL.md` or `domain-name/SKILL.md` | `commit/SKILL.md`, `review/SKILL.md`   |
| Agents | `role-reviewer.md` or `role-generator.md` | `scope-reviewer.md`, `story-drafter.md` |

---

## File Size Guidelines

| Type             | Target       | Maximum       |
| ---------------- | ------------ | ------------- |
| SKILL.md         | <1500 words  | 2500 words (~5K tokens, compaction cap) |
| Agent            | <1500 words  | 2500 words (no system limit, but stay focused) |
| Supporting files | <1500 words  | 2500 words |
