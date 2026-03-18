---
name: bdd-comments
description: Write BDD (Behavior-Driven Development) comments in test files using Given-When-Then format. Use when writing or editing test cases.
---

# BDD Comments Skill

Write Behavior-Driven Development comments in test files.

## Audience Perspectives

Apply the selected audience perspective consistently throughout all comments.

### Developer (API Consumer)

Focus on: requests, responses, side effects, database changes.

### End-User

Focus on: UI actions, visual feedback, navigation, state changes visible to users.

### QA/Tester

Focus on: preconditions, exact inputs/outputs, edge cases, boundary conditions, data integrity.

## Comment Syntax

| Language   | Single-line | Block         |
| ---------- | ----------- | ------------- |
| Go         | `//`        | `/* */`       |
| TypeScript | `//`        | `/* */`       |
| Python     | `#`         | `""" """`     |
| Ruby       | `#`         | `=begin =end` |
| Rust       | `//`        | `/* */`       |

## BDD Structure

All comments follow this pattern:

```txt
Given: [preconditions and setup]
When: [action being performed]
Then: [primary expected outcome]
And: [additional validations]
```

### Rules

1. **Always start with Given** - Never skip preconditions
2. **One When per test** - Single action under test
3. **Then for primary outcome** - Response status, return value, or primary assertion
4. **And for additional checks** - Multiple allowed, one assertion per line

## Anti-Patterns

### Avoid

- Assumptions about untested behavior
- Vague language: "An error occurs", "The request fails"
- Intent over behavior: "A user wants to...", "The system should..."

### Prefer

- Specific assertions: "The response status is 422"
- Exact error messages: "The response contains 'email already exists'"
- Observable outcomes: "No database changes occur"

## Quality Checklist

- [ ] All comments start with `Given:`
- [ ] Actions are explicit (HTTP method + endpoint, or UI action)
- [ ] Outcomes are specific (status codes, exact messages)
- [ ] No assumptions about untested behavior
- [ ] Multiple validations use separate `And:` lines
- [ ] Comment syntax matches target language

## Additional Resources

- For detailed templates by audience and scenario, see [patterns.md](patterns.md)
- For language-specific code examples, see [examples.md](examples.md)
