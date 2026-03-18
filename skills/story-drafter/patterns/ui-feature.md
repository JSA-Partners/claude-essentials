# UI Feature Story Template

Use for frontend/UI stories involving user interactions, visual elements.

## Template

```markdown
# [Verb] [UI Element] [in Context]

## Story

As a [persona], I want [UI interaction], so that [user experience value].

## Acceptance Criteria

- [ ] [Element] is visible [when/where condition]
- [ ] Clicking [element] [action that happens]
- [ ] [Loading state] displays during [async operation]
- [ ] [Success state] shows [confirmation/feedback]
- [ ] [Error state] displays [user-friendly message]

## Technical Notes

[Reserved for Technical Reviewer Agent]

## Points: [Reserved for Estimator Agent]
```

## Acceptance Criteria Patterns

### Visibility

- `Button appears on [page/component] for [role] users`
- `Modal opens when [trigger action] is performed`
- `Section is hidden until [condition] is met`

### Interactions

- `Clicking submit validates form before sending`
- `Hovering shows tooltip with [information]`
- `Pressing Enter triggers [action] in form`
- `Swiping left reveals [action buttons]`

### States

- `Loading spinner displays while fetching data`
- `Success toast appears after [action] completes`
- `Error banner shows when [operation] fails`
- `Empty state displays when [no data] exists`

### Responsiveness

- `Layout adjusts for mobile viewport (<768px)`
- `Touch targets are at least 44x44 pixels`
- `Form is keyboard-navigable`
