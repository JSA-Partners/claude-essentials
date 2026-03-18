---
name: story-drafter
description: Convert feature ideas to implementable user stories with appropriate templates
---

# Story Drafter Skill

Transform feature ideas into clear, implementable user stories.

## Core Formula

```txt
As a [PERSONA],
I want [SPECIFIC_ACTION],
so that [MEASURABLE_VALUE].
```

## Confidence Threshold

Only draft when ALL three are clear:

| Element    | Required Clarity                        |
| ---------- | --------------------------------------- |
| **Action** | Specific verb + object (not vague)      |
| **User**   | Identifiable persona from `personas.md` |
| **Value**  | Outcome-focused, measurable benefit     |

If any element is unclear: **Stop and ask.**

## Pattern Selection

Match story type to patterns in `skills/story-drafter/patterns/`:

| Story Type     | Template            | Signals                              |
| -------------- | ------------------- | ------------------------------------ |
| API Endpoint   | `api-endpoint.md`   | REST, HTTP methods, request/response |
| UI Feature     | `ui-feature.md`     | Frontend, button, form, display      |
| Background Job | `background-job.md` | Scheduled, async, worker, queue      |
| Integration    | `integration.md`    | Third-party, webhook, external API   |
| CLI Command    | `cli-command.md`    | CLI, flags, arguments, terminal      |
| Infrastructure | `infrastructure.md` | Docker, deploy, scale, environment   |

If multiple match or none match: **Ask user to specify.**

## Decomposition Protocol

When input contains multiple features ("and", "also", compound requests):

1. List the components identified
2. Ask: "Which component should I draft first?"
3. Draft ONE story at a time
4. Note remaining items for follow-up

## Quick Reference

- **Personas**: See `personas.md` for approved list
- **Examples**: See `examples.md` for format samples
- **Patterns**: See `patterns/` folder for acceptance criteria guides

## Anti-Patterns

| Don't                                     | Instead                         |
| ----------------------------------------- | ------------------------------- |
| Assume missing details                    | Ask unlimited focused questions |
| Draft multiple stories at once            | Draft one, note others          |
| Use vague terms ("appropriate", "proper") | Use specific, testable language |
| Include implementation details            | Focus on WHAT, not HOW          |
