---
description: Write BDD comments in test files using Given-When-Then format
argument-hint: <test-file>
---

# BDD Comments

If `$ARGUMENTS` is empty, use `AskUserQuestion` to ask which test file to annotate.

Write or update BDD comments for: $ARGUMENTS

## Task

1. **Ask the user** which audience perspective to use (via AskUserQuestion tool)
2. **Read the test file** and analyze each test case
3. **Detect language** from file extension and use appropriate comment syntax
4. **Write precise BDD comments** following the Given/When/Then/And structure

## Audience Selection (Required)

Before writing any comments, use the AskUserQuestion tool:

```json
{
  "question": "Which audience perspective should the BDD comments use?",
  "header": "Audience",
  "options": [
    {
      "label": "Developer",
      "description": "API consumer - requests, responses, side effects"
    },
    {
      "label": "End-user",
      "description": "Product user - actions, feedback, state changes"
    },
    {
      "label": "QA",
      "description": "Tester - preconditions, inputs, outputs, edge cases"
    }
  ],
  "multiSelect": false
}
```

## BDD Format

```txt
// Given: [preconditions and setup]
// When: [action being performed]
// Then: [primary expected outcome]
// And: [additional validations]
```

## Guidelines

- **Precision over intent**: Describe what the test validates, not what it intends
- **Explicit HTTP details**: Always specify METHOD and endpoint for API tests
- **Specific status codes**: "201 Created" not "success"
- **Quote error messages**: Match actual assertion strings
- **One And per assertion**: Break multiple checks into separate lines

## Quality Checklist

- [ ] All comments start with `Given:`
- [ ] HTTP methods and endpoints are explicit
- [ ] Status codes are specific (not "success" or "error")
- [ ] No assumptions about untested behavior
- [ ] Multiple validations use separate `And:` lines
- [ ] Comment syntax matches target language
