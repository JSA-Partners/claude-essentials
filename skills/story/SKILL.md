---
description: Create user stories through agent collaboration
when_to_use: When the user describes a feature, enhancement, or change they want to build
argument-hint: [feature description]
allowed-tools: Read, Write, Glob, Agent
---

# Story

Create user stories through agent collaboration.

## Skill Reference

Load on-demand for detailed patterns:

- `${CLAUDE_SKILL_DIR}/../story-drafter/SKILL.md` - Core formula, confidence threshold
- `${CLAUDE_SKILL_DIR}/../story-drafter/personas.md` - Approved personas
- `${CLAUDE_SKILL_DIR}/../story-drafter/patterns/` - Acceptance criteria patterns by story type

Load `patterns/` directory files only after template selection in Phase 2.

## Execution Flow

### Phase 1: Gather Input

If `$ARGUMENTS` provided, use as feature description.
Otherwise, use `AskUserQuestion` to ask: "What feature or change do you want to implement?"

Read CLAUDE.md for project conventions, tech stack, and terminology. Stories should reflect the project's language, not generic phrasing.

### Phase 2: Draft Story

Run `story-drafter` agent with full context.

IMPORTANT: Brief the agent like a smart colleague who just walked in -- they have not seen this conversation.

```txt
Task(subagent_type='story-drafter'):
Feature request: [user's description, verbatim]
Project context: [tech stack and conventions from CLAUDE.md]
Load the story-drafter skill at [${CLAUDE_SKILL_DIR}/../story-drafter/SKILL.md]
for the core formula, personas, and acceptance criteria patterns.
Return: complete story draft with acceptance criteria.
```

| Responsibility | Detail                                                     |
| -------------- | ---------------------------------------------------------- |
| Load skill     | Read `${CLAUDE_SKILL_DIR}/../story-drafter/SKILL.md` |
| Assess clarity | All 3 elements clear? (action, user, value)                |
| Select pattern | Match to `${CLAUDE_SKILL_DIR}/../story-drafter/patterns/` folder |
| Ask if unclear | Unlimited focused questions, no assumptions                |
| Output         | Story + acceptance criteria                                |

### Phase 3: Estimate & Analyze

Run `story-estimator` agent with the drafted story.

```txt
Task(subagent_type='story-estimator'):
Estimate this user story:
[paste full story draft from Phase 2]
Project root: [working directory]
Return: Fibonacci points, confidence level, technical notes,
and affected files from codebase analysis.
```

| Responsibility     | Detail                                 |
| ------------------ | -------------------------------------- |
| Analyze codebase   | Find patterns, affected files          |
| Assess complexity  | Apply Fibonacci scale                  |
| Generate notes     | Technical considerations from analysis |
| Flag decomposition | If >=8 points, suggest breakdown       |
| Output             | Points + technical notes               |

### Phase 4: Generate & Verify

1. **Locate story directory**: Check `docs/user-stories/` first. If it does not exist, search for alternative locations (e.g., `stories/`, `user-stories/`, or any directory containing files that match the story template structure). If no story directory is found, use `AskUserQuestion` to ask where stories should live and create the directory.
2. Find next story number: highest in the story directory + 1
3. Create file using template structure
4. Populate all sections from agent outputs
5. Confirm creation with file path

**Before declaring complete, verify:**

- [ ] File was created at the expected path
- [ ] All template sections are populated (no empty or placeholder sections)
- [ ] Acceptance criteria are testable (specific actions and expected results)
- [ ] Technical notes include affected files from estimator analysis
- [ ] Points reflect estimator output

## Output Template

If a `template.md` exists in the story directory, follow it. Otherwise use this default:

```markdown
# [NUMBER]: [STORY_TITLE]

## Story

As a [persona], I want [action], so that [value].

## Acceptance Criteria

- [testable condition 1]
- [testable condition 2]
- [testable condition 3]

## Technical Notes

- [dependencies, gotchas, scope boundaries]
- [note from estimator analysis]
- [affected files/patterns]

## Points: [1, 2, 3, 5, 8, 13]
```

Bulleted sections: Use flat bullets and sub-bullets only. No headers or category labels.

## Decomposition

IMPORTANT: When story-estimator returns >=8 points, do NOT generate a single large story. Decompose instead:

1. List components identified by the estimator
2. Use `AskUserQuestion` to ask which component to draft first
3. Create a focused story for that component
4. Note remaining items for follow-up

## Anti-Patterns

| Don't | Instead |
| ----- | ------- |
| Draft without all 3 elements clear (action, user, value) | Ask clarifying questions until all elements are specific |
| Include implementation details in the story | Keep stories focused on WHAT, not HOW -- technical notes are separate |
| Generate a single 8+ point story | Decompose into smaller stories first |
| Assume project conventions | Read CLAUDE.md for terminology and tech stack |
| Delegate to agents with vague context | Use the briefing templates above with full context |

## When Things Go Wrong

- **Story-drafter cannot determine story type**: Check if the user's description maps to multiple types. Use `AskUserQuestion` to narrow scope. Do NOT guess.
- **Story-estimator returns no affected files**: The feature may be entirely new. Note this in Technical Notes as "greenfield -- no existing patterns to reference."
- **Story directory does not exist and no alternatives found**: Use `AskUserQuestion` to ask the user. Do NOT create a directory without confirmation.
- **Agent returns incomplete output**: Re-run the agent with more specific context. Do NOT fill in missing sections yourself -- the agent has codebase access you do not.

## Next Step

When the story is created, end with:

```markdown
## Next Step
Ready to break this down. Run `/essentials:decompose` to create implementation units.
```
