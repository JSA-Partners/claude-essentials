---
description: Create user stories through agent collaboration
argument-hint: [feature description]
allowed-tools: Read, Write, Glob, Agent
---

# Story

Create user stories through agent collaboration.

## Skill Reference

Load on-demand for detailed patterns:

- `skills/story-drafter/SKILL.md` - Core formula, confidence threshold
- `skills/story-drafter/personas.md` - Approved personas
- `skills/story-drafter/patterns/` - Acceptance criteria patterns by story type

Load `patterns/` directory files only after template selection in Phase 2.

## Execution Flow

### Phase 1: Gather Input

If `$ARGUMENTS` provided, use as feature description.
Otherwise, ask: "What feature or change do you want to implement?"

### Phase 2: Draft Story

Run `story-drafter` agent with user input.

| Responsibility | Detail                                                     |
| -------------- | ---------------------------------------------------------- |
| Load skill     | Read `skills/story-drafter/SKILL.md`             |
| Assess clarity | All 3 elements clear? (action, user, value)                |
| Select pattern | Match to `skills/story-drafter/patterns/` folder |
| Ask if unclear | Unlimited focused questions, no assumptions                |
| Output         | Story + acceptance criteria                                |

### Phase 3: Estimate & Analyze

Run `story-estimator` agent with drafted story.

| Responsibility     | Detail                                 |
| ------------------ | -------------------------------------- |
| Analyze codebase   | Find patterns, affected files          |
| Assess complexity  | Apply Fibonacci scale                  |
| Generate notes     | Technical considerations from analysis |
| Flag decomposition | If ≥8 points, suggest breakdown        |
| Output             | Points + technical notes               |

### Phase 4: Generate File

1. **Locate story directory**: Check `docs/user-stories/` first. If it does not exist, search for alternative locations (e.g., `stories/`, `user-stories/`, or any directory containing files that match the story template structure). If no story directory is found, ask the user where stories should live and create the directory.
2. Find next story number: highest in the story directory + 1
3. Create file using template structure
4. Populate all sections from agent outputs
5. Confirm creation with file path

## Output Template

If a `template.md` exists in the story directory, follow it. Otherwise use this default:

```markdown
# [NUMBER]: [STORY_TITLE]

Milestone [NUMBER]: [NAME]

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

When story-estimator returns ≥8 points:

1. List components identified
2. Ask which to draft first
3. Create focused story for that component
4. Note remaining items for follow-up

## Next Step

When the story is created, end with:

```markdown
## Next Step
Ready to break this down. Run `/decompose` to create implementation units.
```
