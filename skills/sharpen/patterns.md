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

If $ARGUMENTS empty, use AskUserQuestion:

[question structure]

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
3. Iterate if needed

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

Run these agents in parallel:

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

Brief overview of the domain.

## Quick Reference

[most common lookups - tables, lists]

## Core Concepts

[domain knowledge organized by topic]

## Patterns

| Pattern | When | Example |
| ------- | ---- | ------- |
| ...     | ...  | ...     |

## Anti-Patterns

| Don't | Instead |
| ----- | ------- |
| ...   | ...     |

## Quality Checklist

- [ ] Requirement 1
- [ ] Requirement 2

## References

- [Link 1](url)
- [Link 2](url)
```

### Process Skill

```markdown
---
name: skill-name
description: [process expertise]
---

# Skill Name

## Workflow Overview

[high-level process description]

## Step 1: [Phase Name]

[detailed instructions]

### Inputs

- [required input 1]
- [required input 2]

### Actions

1. [action 1]
2. [action 2]

### Outputs

- [expected output]

## Step 2: [Phase Name]

[repeat structure]

## Quality Checklist

- [ ] Requirement 1
- [ ] Requirement 2

## Templates

[reusable templates for outputs]
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

## Detection Patterns

```txt
[grep patterns or heuristics]
```

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

## Edge Cases

| Scenario      | Handling        |
| ------------- | --------------- |
| [edge case 1] | [how to handle] |
| [edge case 2] | [how to handle] |
````

### Estimator Agent

````md
---
name: agent-name
description: Estimates [metric] for [scope]
tools: [Read, Grep, Glob, Bash]
model: opus
color: green
---

# Agent Name

You estimate [metric] for [scope].

## Mission

[single sentence purpose]

## Estimation Factors

| Factor     | Weight | How to Assess       |
| ---------- | ------ | ------------------- |
| [factor 1] | High   | [assessment method] |
| [factor 2] | Medium | [assessment method] |

## Scale

| Value | Meaning      |
| ----- | ------------ |
| 1     | [definition] |
| 2     | [definition] |
| 3     | [definition] |

## Output Format

```markdown
## Estimate: [value]

### Factors

- [factor 1]: [assessment] ([impact])
- [factor 2]: [assessment] ([impact])

### Confidence: [High/Medium/Low]

### Notes

[additional context]
```
````

---

## YAML Frontmatter Reference

### Skills

```yaml
---
description: Required - shown in / menu and used for auto-invocation
argument-hint: Optional - placeholder text
allowed-tools: Optional - comma-separated tool list
disable-model-invocation: Optional - true for skills with side effects
user-invocable: Optional - false for agent-only reference skills
context: Optional - fork to run in subagent
---
```

### Agents

```yaml
---
name: Required - agent identifier
description: Required - what this agent does
tools: Required - [Read, Grep, Glob, Bash, WebSearch, WebFetch]
model: Required - opus | haiku
color: Required - blue | red | yellow | orange | magenta | cyan | green
effort: Optional - low | medium | high | max
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

| Type             | Target     | Maximum   |
| ---------------- | ---------- | --------- |
| SKILL.md         | <200 lines | 300 lines |
| Agent            | <150 lines | 200 lines |
| Supporting files | <200 lines | 300 lines |
