---
description: Explore a problem through discussion and research, then produce a ready-to-use prompt for /essentials:story
when_to_use: When the user has a vague idea, loose requirements, or wants to explore before committing to a story
argument-hint: <problem or idea to explore>
allowed-tools: Read, Grep, Glob, Bash, WebSearch, WebFetch, AskUserQuestion
---

# Discuss

Explore a problem through iterative discussion and research until it is clear enough to become a user story.

## Input: $ARGUMENTS

If `$ARGUMENTS` is provided, use it as the starting seed.
Otherwise, use `AskUserQuestion` to ask: "What problem or idea do you want to explore?"

Do NOT assume scope, users, or constraints. Just listen.

## Execution Flow

### Phase 1: Seed

1. Capture the user's initial problem or idea
2. Read CLAUDE.md for project context (tech stack, conventions, terminology)
3. Restate the problem back to the user in one sentence to confirm understanding

### Phase 2: Research

Based on the seed, gather relevant context. Do both in parallel where applicable:

**Codebase exploration** (Glob, Grep, Read):

- What exists today that relates to this problem?
- What patterns, conventions, or constraints apply?
- What files or modules would likely be affected?

**Web research** (WebSearch, WebFetch) -- only when the problem involves:

- External libraries, APIs, or services
- Patterns or approaches the user might not be aware of
- Industry standards or best practices relevant to the domain

Skip web research if the problem is purely internal to the codebase.

Present findings as a brief summary -- not a wall of text. Focus on what is relevant to the user's decision-making.

### Phase 3: Discuss

After presenting research findings, ask 2-3 focused questions using `AskUserQuestion`. Target the gaps:

- **Who**: Who is the user or actor? (if unclear)
- **What**: What specific outcome do they want? (if vague)
- **Boundaries**: What is in scope vs out of scope? (if broad)
- **Constraints**: Technical, timeline, or design constraints? (if unspoken)
- **Patterns**: Follow existing patterns or break from them? (if relevant)

Pick only the questions that matter most given what you already know. Do NOT ask all five every time.

**This phase loops.** After each round of answers:

1. Assess whether you have enough clarity to synthesize (all three: action, user, value)
2. If yes, move to Phase 4
3. If no, do more targeted research or ask follow-up questions
4. If the user says "that's enough" or "let's go", move to Phase 4 regardless

IMPORTANT: Keep each discussion round short. Present what you learned, ask what you need, move on. Do NOT lecture or over-explain.

### Phase 4: Synthesize

When clarity is sufficient, produce a structured feature brief. Before outputting, verify the brief contains all three elements: action, user, and value. If any element is missing, fill it from discussion context or mark it as "TBD."

Output it directly in chat as a fenced markdown block:

````markdown
```
## Feature Description
[One clear sentence: As a [user], I want [action], so that [value].]
[One paragraph expanding on what this means concretely.]

## Context & Constraints
- Tech stack: [relevant stack from CLAUDE.md]
- Affected areas: [files, modules, or systems identified in research]
- Patterns to follow: [existing conventions discovered]
- Out of scope: [anything explicitly excluded during discussion]

## Acceptance Criteria Hints
- [Key behavior 1 the story should capture]
- [Key behavior 2]
- [Key behavior 3]

## Research Notes
- [Relevant finding from codebase or web research]
- [Another finding]
```
````

After outputting the brief, use `AskUserQuestion` to ask:

```txt
"Copy the brief to your clipboard?"
Options: "Yes, copy it" / "No, I'll copy it myself"
```

If the user says yes, copy the brief content (without the fenced code block markers) to the clipboard:

- macOS: `echo '...' | pbcopy`
- Linux: `echo '...' | xclip -selection clipboard`
- Windows/WSL: `echo '...' | clip.exe`

Detect the platform from the OS environment. Use `printf '%s'` instead of `echo` to avoid trailing newline issues.

Then tell the user:

```markdown
## Next Step
Run `/clear`, then `/essentials:story` and paste the brief as the feature description.
```

## Anti-Patterns

| Don't | Instead |
| ----- | ------- |
| Ask more than 3 questions per round | Pick the 2-3 that matter most right now |
| Lecture the user about best practices | Share findings briefly, let them decide |
| Loop indefinitely | After 3 rounds, synthesize with what you have and note gaps |
| Assume missing details | Ask or mark as "TBD" in the brief |
| Output a file | Output text in chat -- the user controls when to use it |
| Research when the problem is already clear | Skip to Phase 4 if the seed has action, user, and value |

## When Things Go Wrong

- **Problem is already clear**: If `$ARGUMENTS` contains a well-formed feature description (action, user, value all present), skip discussion and tell the user: "This is already clear enough for `/essentials:story`. Run it directly."
- **User wants to pivot mid-discussion**: Reset your understanding. Restate the new direction and continue from Phase 2.
- **Research turns up nothing relevant**: Say so. Do NOT fabricate context. Move to discussion with what you have.
- **After 3 rounds, still unclear**: Synthesize the best brief you can and mark unclear sections as "TBD -- needs further discussion." Ship imperfect over endless.
