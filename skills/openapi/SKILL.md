---
name: openapi
description: OpenAPI 3.1.1 specification expertise for generating, modifying, and validating REST API documentation. Use when working with openapi.yaml files, API documentation, or the /openapi command.
---

# OpenAPI 3.1.1 Specification Skill

You are an expert in the OpenAPI 3.1.1 Specification. Your expertise enables accurate generation and modification of OpenAPI documents that describe REST APIs.

## Quick Reference

### Document Structure

```yaml
openapi: 3.1.1
info:
  title: API Title
  version: 1.0.0
  description: API description
servers:
  - url: https://api.example.com/v1
    description: Production server
paths:
  /resource:
    get:
      # ... operation definition
components:
  schemas:
    # ... reusable schemas
  securitySchemes:
    # ... authentication definitions
  pathItems:
    # ... reusable path items
security:
  - bearerAuth: []
```

### Critical OpenAPI 3.1.1 Rules

1. **Version**: Must be exactly `openapi: 3.1.1` (string, not number)
2. **Full JSON Schema**: Uses JSON Schema Draft 2020-12
3. **Nullable**: Use `type: ["string", "null"]` instead of `nullable: true`
4. **Examples**: Use `examples` (plural) as array, not `example` (singular)
5. **operationId**: Must be unique across all operations (required for code gen)
6. **Path parameters**: Must have `required: true` (always required)
7. **Component names**: Must match pattern `^[a-zA-Z0-9\.\-_]+$`

## Anti-Patterns

| Don't                          | Instead                    | Why                          |
| ------------------------------ | -------------------------- | ---------------------------- |
| `nullable: true`               | `type: ["string", "null"]` | 3.0 syntax, invalid in 3.1.1 |
| `example:` (singular)          | `examples:` (plural)       | Deprecated in 3.1.1          |
| Missing `operationId`          | Unique operationId per op  | Required for code generation |
| Path param without `required`  | `required: true`           | Path params must be required |
| Duplicate operationIds         | Unique IDs across all ops  | Spec validation will fail    |
| `additionalProperties` omitted | Explicit `true` or `false` | Ambiguous without it         |

## Language-Specific Patterns

This skill auto-detects your project language from manifest files:

| File                                  | Language   |
| ------------------------------------- | ---------- |
| `go.mod`                              | Go         |
| `package.json` + `tsconfig.json`      | TypeScript |
| `package.json`                        | JavaScript |
| `pyproject.toml` / `requirements.txt` | Python     |

For language-specific type mappings and handler patterns, see:

- [go.md](go.md) - Go type mappings, stdlib/Chi/Gin/Echo patterns
- [typescript.md](typescript.md) - TypeScript types, Express/Fastify/NestJS patterns
- [python.md](python.md) - Python types, FastAPI/Flask/DRF patterns

## Common Authentication Patterns

For JWT/Bearer token auth:

```yaml
components:
  securitySchemes:
    bearerAuth:
      type: http
      scheme: bearer
      bearerFormat: JWT
security:
  - bearerAuth: []
```

## Additional Resources

For detailed reference documentation, see:

- [reference-core.md](reference-core.md) - Core OpenAPI 3.1.1 reference (paths, operations, parameters, schemas, components)
- [reference-advanced.md](reference-advanced.md) - Advanced patterns (composition, discriminators, callbacks, links, webhooks)
- [reference-appendix.md](reference-appendix.md) - Appendix (HTTP status codes, XML, OAuth flows, security schemes, encoding)
- [examples.md](examples.md) - Common API patterns with examples

## Quality Checklist

Before finalizing an OpenAPI spec:

- [ ] Version is exactly `openapi: 3.1.1` (string)
- [ ] All operations have unique `operationId`
- [ ] All path parameters have `required: true`
- [ ] All `$ref` targets exist in components
- [ ] Response descriptions are present (required)
- [ ] Security schemes defined before use
- [ ] No `nullable: true` (use type arrays)
- [ ] Validated with Redocly CLI (see below)

## Validation

After generating or modifying an OpenAPI spec, validate using Redocly:

```bash
npx @redocly/cli lint docs/openapi.yaml
```

## References

- [OpenAPI 3.1.1 Specification](https://spec.openapis.org/oas/v3.1.1.html)
- [JSON Schema Draft 2020-12](https://json-schema.org/draft/2020-12/json-schema-core.html)
