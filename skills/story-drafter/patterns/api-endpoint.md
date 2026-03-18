# API Endpoint Story Template

Use for REST API stories involving HTTP methods, request/response handling.

## Template

```markdown
# [Verb] [Resource] [via API]

## Story

As a [persona], I want [METHOD /path action], so that [integration/automation value].

## Acceptance Criteria

- [ ] [METHOD] /v[VERSION]/[resource] returns [CODE] on success
- [ ] Returns [ERROR_CODE] when [validation/auth condition]
- [ ] Request body validates [required fields]
- [ ] Response includes [required fields in DTO]
- [ ] [Auth requirement: role/permission needed]

## Technical Notes

[Reserved for Technical Reviewer Agent]

## Points: [Reserved for Estimator Agent]
```

## Acceptance Criteria Patterns

### Success Cases

- `GET /v1/resources returns 200 with paginated list`
- `POST /v1/resources returns 201 with created resource`
- `PUT /v1/resources/{id} returns 200 with updated resource`
- `DELETE /v1/resources/{id} returns 204 on success`

### Error Cases

- `Returns 400 when required field [name] is missing`
- `Returns 401 when authentication token is invalid`
- `Returns 403 when user lacks [permission] role`
- `Returns 404 when resource does not exist`
- `Returns 409 when [unique constraint] is violated`
- `Returns 422 when [business rule] is violated`

### Validation

- `Requires [field] to be non-empty string`
- `Requires [field] to be valid [format: email/UUID/slug]`
- `Limits [field] to [max] characters`
- `Requires [field] to be one of [enum values]`
