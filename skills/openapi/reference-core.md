---
name: openapi-reference-core
description: Core OpenAPI 3.1.1 reference covering document structure, path items, operations, parameters, request/response bodies, schemas, and components.
---

# OpenAPI 3.1.1 Core Reference

## Document Root Structure

| Field               | Type                          | Required | Description                    |
| ------------------- | ----------------------------- | -------- | ------------------------------ |
| `openapi`           | string                        | Yes      | Must be `"3.1.1"`              |
| `info`              | Info Object                   | Yes      | API metadata                   |
| `jsonSchemaDialect` | string (URI)                  | No       | Default JSON Schema dialect    |
| `servers`           | [Server Object]               | No       | API server URLs (default: `/`) |
| `paths`             | Paths Object                  | No       | Available endpoints            |
| `webhooks`          | Map[string, Path Item Object] | No       | Incoming webhook definitions   |
| `components`        | Components Object             | No       | Reusable schemas               |
| `security`          | [Security Requirement Object] | No       | Global security                |
| `tags`              | [Tag Object]                  | No       | Endpoint grouping              |
| `externalDocs`      | External Documentation Object | No       | Additional documentation       |

## Info Object

| Field            | Type           | Required | Description                       |
| ---------------- | -------------- | -------- | --------------------------------- |
| `title`          | string         | Yes      | API title                         |
| `version`        | string         | Yes      | API version (not OpenAPI version) |
| `summary`        | string         | No       | Short one-line summary            |
| `description`    | string         | No       | Longer markdown description       |
| `termsOfService` | string (URL)   | No       | URL to terms of service           |
| `contact`        | Contact Object | No       | Contact information               |
| `license`        | License Object | No       | License information               |

```yaml
info:
  title: My API
  version: 1.0.0
  summary: Short one-liner
  description: |
    Longer markdown description.
    Supports **formatting**.
  contact:
    name: API Support
    email: support@example.com
  license:
    name: MIT
    identifier: MIT
```

## Server Object

| Field         | Type                                | Required | Description            |
| ------------- | ----------------------------------- | -------- | ---------------------- |
| `url`         | string                              | Yes      | Server URL             |
| `description` | string                              | No       | Server description     |
| `variables`   | Map[string, Server Variable Object] | No       | URL template variables |

```yaml
servers:
  - url: https://api.example.com/{version}
    description: Production
    variables:
      version:
        default: v1
        enum: [v1, v2]
  - url: http://localhost:8080
    description: Development
```

## Path Item Object

Describes operations available on a single path.

| Field         | Type                                   | Required | Description                     |
| ------------- | -------------------------------------- | -------- | ------------------------------- |
| `$ref`        | string                                 | No       | Reference to external path item |
| `summary`     | string                                 | No       | Path summary                    |
| `description` | string                                 | No       | Path description                |
| `get`         | Operation Object                       | No       | GET operation                   |
| `put`         | Operation Object                       | No       | PUT operation                   |
| `post`        | Operation Object                       | No       | POST operation                  |
| `delete`      | Operation Object                       | No       | DELETE operation                |
| `options`     | Operation Object                       | No       | OPTIONS operation               |
| `head`        | Operation Object                       | No       | HEAD operation                  |
| `patch`       | Operation Object                       | No       | PATCH operation                 |
| `trace`       | Operation Object                       | No       | TRACE operation                 |
| `servers`     | [Server Object]                        | No       | Path-specific servers           |
| `parameters`  | [Parameter Object \| Reference Object] | No       | Parameters for all operations   |

## Operation Object

| Field          | Type                                    | Required | Description                        |
| -------------- | --------------------------------------- | -------- | ---------------------------------- |
| `operationId`  | string                                  | No*      | Unique operation identifier        |
| `summary`      | string                                  | No       | Short description                  |
| `description`  | string                                  | No       | Longer markdown description        |
| `tags`         | [string]                                | No       | Groups for organization            |
| `parameters`   | [Parameter Object \| Reference Object]  | No       | Path, query, header, cookie params |
| `requestBody`  | Request Body Object \| Reference Object | No       | Request payload                    |
| `responses`    | Responses Object                        | Yes      | Possible responses                 |
| `callbacks`    | Map[string, Callback Object]            | No       | Callback definitions               |
| `deprecated`   | boolean                                 | No       | Mark as deprecated                 |
| `security`     | [Security Requirement Object]           | No       | Override global security           |
| `servers`      | [Server Object]                         | No       | Operation-specific servers         |

\*Required for code generation tools.

## Parameter Object

| Field             | Type                                            | Required | Description                           |
| ----------------- | ----------------------------------------------- | -------- | ------------------------------------- |
| `name`            | string                                          | Yes      | Parameter name                        |
| `in`              | string                                          | Yes      | Location: path, query, header, cookie |
| `description`     | string                                          | No       | Parameter description                 |
| `required`        | boolean                                         | No*      | Whether required (default: false)     |
| `deprecated`      | boolean                                         | No       | Mark as deprecated                    |
| `schema`          | Schema Object                                   | No**     | Parameter schema                      |
| `content`         | Map[string, Media Type Object]                  | No**     | Complex parameter serialization       |
| `style`           | string                                          | No       | Serialization style                   |
| `explode`         | boolean                                         | No       | Explode arrays/objects                |
| `example`         | any                                             | No       | Example value                         |
| `examples`        | Map[string, Example Object \| Reference Object] | No       | Multiple examples                     |

\*Path parameters MUST have `required: true`.
\*\*Must have either `schema` OR `content`, never both.

### Parameter Styles

| Style            | `in`          | Explode | Example                           |
| ---------------- | ------------- | ------- | --------------------------------- |
| `simple`         | path, header  | false   | `3,4,5` (default path/header)     |
| `form`           | query, cookie | true    | `?id=3&id=4&id=5` (default query) |
| `deepObject`     | query         | true    | `?filter[status]=active`          |
| `spaceDelimited` | query         | false   | `?id=3%204%205`                   |
| `pipeDelimited`  | query         | false   | `?id=3\|4\|5`                     |

## Request Body Object

| Field         | Type                           | Required | Description           |
| ------------- | ------------------------------ | -------- | --------------------- |
| `description` | string                         | No       | Body description      |
| `content`     | Map[string, Media Type Object] | Yes      | Content by media type |
| `required`    | boolean                        | No       | Whether required      |

## Responses and Response Objects

At least one response must be defined per operation. Use HTTP status codes as keys.

| Field         | Type                                           | Required | Description          |
| ------------- | ---------------------------------------------- | -------- | -------------------- |
| `description` | string                                         | Yes      | Response description |
| `headers`     | Map[string, Header Object \| Reference Object] | No       | Response headers     |
| `content`     | Map[string, Media Type Object]                 | No       | Response content     |
| `links`       | Map[string, Link Object \| Reference Object]   | No       | Related operations   |

## Schema Object (JSON Schema)

OpenAPI 3.1.1 uses full JSON Schema Draft 2020-12 with OAS extensions.

### Basic Types

```yaml
# String
type: string
format: email  # or: uri, uuid, date-time, date, hostname, ipv4, ipv6

# Number / Integer
type: number       # or: integer
format: int32      # or: int64

# Boolean
type: boolean

# Nullable string (3.1.1 style)
type: ["string", "null"]
```

### Compound Types

```yaml
# Array
type: array
items:
  type: string
minItems: 1
maxItems: 100
uniqueItems: true

# Object
type: object
required: [id, name]
properties:
  id:
    type: string
    format: uuid
  name:
    type: string
additionalProperties: false

# Enum
type: string
enum: [pending, active, archived]
```

## Components Object

| Field             | Type                                                    | Required | Description             |
| ----------------- | ------------------------------------------------------- | -------- | ----------------------- |
| `schemas`         | Map[string, Schema Object]                              | No       | Reusable schemas        |
| `responses`       | Map[string, Response Object \| Reference Object]        | No       | Reusable responses      |
| `parameters`      | Map[string, Parameter Object \| Reference Object]       | No       | Reusable parameters     |
| `examples`        | Map[string, Example Object \| Reference Object]         | No       | Reusable examples       |
| `requestBodies`   | Map[string, Request Body Object \| Reference Object]    | No       | Reusable request bodies |
| `headers`         | Map[string, Header Object \| Reference Object]          | No       | Reusable headers        |
| `securitySchemes` | Map[string, Security Scheme Object \| Reference Object] | No       | Security scheme defs    |
| `links`           | Map[string, Link Object \| Reference Object]            | No       | Reusable links          |
| `callbacks`       | Map[string, Callback Object \| Reference Object]        | No       | Reusable callbacks      |
| `pathItems`       | Map[string, Path Item Object]                           | No       | Reusable path items     |

Component names must match: `^[a-zA-Z0-9\.\-_]+$`

## Reference Object

| Field         | Type   | Required | Description                              |
| ------------- | ------ | -------- | ---------------------------------------- |
| `$ref`        | string | Yes      | URI reference                            |
| `summary`     | string | No       | Override referenced object's summary     |
| `description` | string | No       | Override referenced object's description |

In 3.1.1, `$ref` can have sibling `summary` and `description` properties.

## Validation Rules

1. Field names are case-sensitive
2. Component names must match pattern `^[a-zA-Z0-9\.\-_]+$`
3. `operationId` must be unique across all operations
4. Path parameters must be declared in path template AND parameters array
5. Path parameters must have `required: true`
6. Parameter uniqueness determined by combination of `name` + `in`
7. Parameters must have either `schema` OR `content`, never both
8. `required` array must only list properties that exist in `properties`
9. Security schemes must be defined in components before use
10. Responses must have at least one status code defined
