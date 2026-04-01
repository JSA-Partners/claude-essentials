---
name: sharpen
description: Expert knowledge for improving Claude Code skills and agents.
---

# Prompt Engineering for Claude Code

Transform skills and agents into well-structured, effective, maintainable configurations.

## How Skills Are Processed

Understanding how the system handles skills prevents common mistakes:

- **Description cap**: Skill descriptions are hard-capped at **250 characters** in the tool listing. Front-load trigger keywords.
- **Content injection**: Skill content arrives as **user messages**, not system prompt. Write as directives, not persona definitions.
- **`allowed-tools`**: Auto-approves tools for the user, does not restrict the model. It is convenience, not a security boundary.
- **`$ARGUMENTS`**: Simple string substitution -- replaces every instance in the skill content.
- **`paths` field**: Gitignore-style patterns for conditional activation. Skill only appears when matching files are accessed.
- **`${CLAUDE_SKILL_DIR}`**: Substituted with the skill's absolute directory path at invocation. Use for portable file references instead of hardcoded relative paths.
- **`when_to_use` field**: Appended to description in the listing as `"{description} - {when_to_use}"`. Helps Claude decide when to auto-invoke.
- **Supporting files are not auto-loaded**: Only SKILL.md is injected. Reference files require an explicit Read call. Inline critical guidance in SKILL.md; use supporting files for deep dives.
- **Compaction budget**: Post-compaction re-injection is capped at **5K tokens per skill** (~2500 words), 25K total.
- **Microcompaction**: Older tool results are stripped between turns. Front-load the most important information.
- **Tool result truncation**: Large tool results are stored to disk with only an ~8KB preview sent to the model. Skills and agents that read large files should target specific sections (line ranges, grep patterns) rather than reading entire files.
- **`context: fork`**: Runs skill in an isolated sub-agent. Good for self-contained tasks (reviews, analysis). The parent receives a summary, not the full conversation.

## How Agents Are Processed

Understanding how agents are loaded and presented to the model:

- **Listing format**: Agent `name` + `description` becomes literally `"- name: description (Tools: ...)"` in the Agent tool listing. One line. Keep description concise and action-oriented.
- **No system size limit on agents**: The loader accepts agent markdown as-is with no truncation. The only ceiling is the model's context window. Keep agents focused for quality, not because the system enforces a line count.
- **Body becomes system prompt**: The markdown body (after frontmatter) is the agent's system prompt. Structure as: identity first, constraints second, dynamic context last.
- **Tool resolution**: `tools: ['*']` expands to all available tools. Specific tool lists restrict to only those tools. `disallowedTools` excludes from wildcard.
- **`skills` field**: Preloads skill content as initial user messages. Best way to give agents domain-specific knowledge without inlining it in the agent body.
- **Fork children**: Receive strict boilerplate rules -- 500 word report limit, structured output format (`Scope:`, `Result:`, `Key files:`). Cannot spawn sub-agents.
- **Model selection**: Use `haiku` for speed-focused agents (exploration, simple classification). Use `opus` for judgment-heavy agents (reviews, generation). Use `inherit` for fork agents to maintain prompt cache.

---

## Prompt Engineering Patterns

These patterns are proven in production. Apply when writing or reviewing skills and agents.

### Emphasis Hierarchy

Use a calibrated set of emphasis markers. Overuse dilutes impact.

| Marker | Frequency | Use for |
| ------ | --------- | ------- |
| CRITICAL | 1x max per section | The single most important behavioral rule |
| IMPORTANT | 2-3x per artifact | Rules that prevent common mistakes |
| MUST/NEVER | Targeted | Absolute boundaries and prohibitions |
| Do NOT | Moderate | Strong defaults that have exceptions |
| Unmarked | Default | Normal guidance and preferences |

### Reason-Before-Rule

Pair every constraint with its justification. "Do X because Y" is stronger than bare "Do X." When the model understands purpose, it generalizes to novel situations the rule did not cover.

### Paired Prohibitions

Never say "don't do X" without saying what to do instead. Bare prohibitions create ambiguity. Example: "Do NOT use Bash for file search. Use Grep instead."

### Concrete Examples Over Abstract Rules

Replace vague categories with categorized example lists. "Be careful with risky operations" is weak. Listing "rm -rf, git reset --hard, dropping database tables" anchors understanding.

### Contract Language

Frame critical obligations as contracts, not suggestions. "The contract: verification must happen before reporting completion" is stronger than "try to verify your work."

### Scope Anchoring

Include an explicit scope statement. Define what "done" looks like. "Match the scope of your actions to what was actually requested" prevents gold-plating.

### Failure Recovery Protocol

Every agent should include a "when things go wrong" section: diagnose the error, try a focused fix, investigate root cause, then escalate. Without this, agents retry blindly or give up immediately.

### Honest Reporting

Instruct agents to produce "an accurate report, not a defensive one." Address both false positives (claiming success on failure) and false negatives (hedging confirmed results).

### Strengths Declaration

Agents should list 3-4 bullet points of "Your strengths:" to prime behavior. This pattern is used by all built-in agents.

### Smart Colleague Briefing

When delegating to sub-agents: "Brief like a smart colleague who just walked in -- full context, not shorthand." Include file paths, line numbers, what specifically to change.

### Static-First Ordering

Place stable instructions first, variable context last. This mirrors prompt cache optimization and helps the model distinguish "how to behave" from "what to work with."

### Cache-Aware Agent Design

Fork agents receive a byte-identical copy of the parent context, sharing the API prompt cache. Design for this:

- Use `model: inherit` on fork agents so they hit the same cache as the parent.
- Prefer read-only tools (Read, Grep, Glob) which run concurrently. Mutating tools (Edit, Write, Bash) run serially and block each other.
- When a skill spawns multiple agents in parallel, they all share the cache. Five parallel agents cost roughly the same as one sequential agent.

### Anti-Pattern Enumeration

For each agent, identify the 3-5 most likely failure modes and prohibit them with concrete examples. Models default to training data patterns. Name what you want to override.

---

## Quality Checklist: Skills

### Structure (Score 0-10)

- [ ] YAML frontmatter with `description` (under 250 characters)
- [ ] `when_to_use` if auto-invocation benefits the skill
- [ ] `argument-hint` if skill takes arguments
- [ ] `allowed-tools` lists only tools the skill actually needs
- [ ] Under 2500 words / ~5K tokens (compaction re-injection cap)
- [ ] Supporting file refs use `${CLAUDE_SKILL_DIR}`, not hardcoded paths
- [ ] Clear workflow phases (numbered or named)
- [ ] Uses `$ARGUMENTS` appropriately
- [ ] `paths` field for context-sensitive activation (when applicable)
- [ ] Important content front-loaded (survives microcompaction)

### Behavior (Score 0-10)

- [ ] Uses `AskUserQuestion` when clarification needed
- [ ] Single responsibility (does not do everything)
- [ ] Clear entry and exit conditions
- [ ] Verification step before completion
- [ ] References CLAUDE.md for project-specific info
- [ ] Written as directives (user message style), not persona

### Content (Score 0-10)

- [ ] Emphasis hierarchy is calibrated (not overused)
- [ ] Constraints include justification (reason-before-rule)
- [ ] Prohibitions are paired with alternatives
- [ ] Examples are concrete, not abstract
- [ ] Quality checklist included

---

## Quality Checklist: Agents

### Structure (Score 0-10)

- [ ] YAML frontmatter: `name`, `description`, `tools`, `model`, `color`
- [ ] `description` is concise and action-oriented (becomes one line in listing)
- [ ] Clear mission statement as opening line (identity first)
- [ ] Defined input/output format
- [ ] Tool restrictions appropriate to role (not wildcard unless general-purpose)
- [ ] Fork agents use `model: inherit` (shares prompt cache with parent)
- [ ] Severity levels defined (P1, P2, P3)

### Behavior (Score 0-10)

- [ ] Single focused responsibility
- [ ] Strengths declared (3-4 bullet points)
- [ ] Failure recovery section included
- [ ] Confidence criteria before flagging issues
- [ ] Evidence required for findings
- [ ] Conservative (avoids false positives)
- [ ] Emphasis hierarchy is calibrated
- [ ] Scope is anchored (what is out of scope)
- [ ] Actionable output format

---

## Anti-Patterns

### Skill Anti-Patterns

| Pattern | Symptom | Severity |
| ------- | ------- | -------- |
| Kitchen sink | >2500 words, multiple unrelated phases | P1 |
| No verification | Completes without validation | P1 |
| Oversize description | >250 chars, gets truncated in listing | P1 |
| Token bloat | >2500 words, lost after compaction | P1 |
| Hardcoded build cmds | Build commands not referencing CLAUDE.md | P2 |
| Missing arguments | No `$ARGUMENTS` handling when needed | P2 |
| No questions | Never uses `AskUserQuestion` | P2 |
| Emphasis flooding | CRITICAL/IMPORTANT on every other line | P2 |
| Bare prohibitions | "Don't do X" without "do Y instead" | P2 |
| Abstract constraints | Vague rules without concrete examples | P2 |
| Hardcoded file paths | `skills/x/ref.md` instead of `${CLAUDE_SKILL_DIR}/ref.md` | P2 |
| Missing allowed-tools | No tool restrictions declared | P2 |

### Agent Anti-Patterns

| Pattern | Symptom | Severity |
| ------- | ------- | -------- |
| God agent | All tools, unfocused scope | P1 |
| No evidence | Flags issues without proof | P1 |
| No failure recovery | No "when things go wrong" section | P1 |
| No severity levels | Findings lack prioritization | P2 |
| Echo agent | Summarizes without analysis | P2 |
| Aggressive | Flags hypothetical issues | P2 |
| No strengths | Missing strengths declaration | P2 |
| Emphasis flooding | Overuses CRITICAL/IMPORTANT markers | P2 |
| Fork model override | Fork agent with explicit model instead of `inherit` | P2 |
| Missing scope anchor | No "out of scope" definition | P3 |

---

## Scoring Guide

Rate each artifact 0-10:

| Score | Meaning |
| ----- | ------- |
| 9-10 | Exemplary, could be reference implementation |
| 7-8 | Good, minor improvements possible |
| 5-6 | Functional, clear improvement opportunities |
| 3-4 | Problematic, significant issues |
| 1-2 | Severely flawed, needs rewrite |
| 0 | Missing or broken |

**Scoring formula**: Average of checklist categories (Structure + Behavior + Content) / 3

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
- **Pattern**: [which prompt engineering pattern applies]
- **Fix**: [specific recommendation]

## Recommended Changes

1. [Priority 1 change]
2. [Priority 2 change]

## Questions

- [Any clarifications needed before implementation]
```
