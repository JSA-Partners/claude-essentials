---
name: openapi-reference-advanced
description: Advanced OpenAPI 3.1.1 patterns including schema composition (allOf/oneOf/anyOf), discriminators, callbacks, links, and webhooks.
---

# OpenAPI 3.1.1 Advanced Reference

## Schema Composition

### allOf (must match all schemas)

```yaml
allOf:
  - $ref: "#/components/schemas/BaseResource"
  - type: object
    properties:
      extraField:
        type: string
```

### oneOf (must match exactly one)

```yaml
oneOf:
  - $ref: "#/components/schemas/TypeA"
  - $ref: "#/components/schemas/TypeB"
```

### anyOf (must match at least one)

```yaml
anyOf:
  - type: string
  - type: integer
```

### not (must not match)

```yaml
not:
  type: "null"
```

### if/then/else (JSON Schema 2020-12)

```yaml
if:
  properties:
    type:
      const: "premium"
then:
  required: ["subscriptionId"]
else:
  properties:
    subscriptionId: false
```

## Discriminator Object

Used with `oneOf`/`anyOf` for polymorphism.

| Field          | Type                | Required | Description                 |
| -------------- | ------------------- | -------- | --------------------------- |
| `propertyName` | string              | Yes      | Property holding type name  |
| `mapping`      | Map[string, string] | No       | Type name to schema mapping |

```yaml
oneOf:
  - $ref: "#/components/schemas/Cat"
  - $ref: "#/components/schemas/Dog"
discriminator:
  propertyName: petType
  mapping:
    cat: "#/components/schemas/Cat"
    dog: "#/components/schemas/Dog"
```

## Callback Object

Map of runtime expressions to Path Item Objects. Used when your API triggers requests to caller-provided URLs.

```yaml
callbacks:
  onEvent:
    "{$request.body#/callbackUrl}":
      post:
        requestBody:
          required: true
          content:
            application/json:
              schema:
                $ref: "#/components/schemas/Event"
        responses:
          "200":
            description: Callback processed
```

## Link Object

Describes a possible design-time link for a response.

| Field          | Type             | Required | Description                        |
| -------------- | ---------------- | -------- | ---------------------------------- |
| `operationRef` | string           | No*      | Relative/absolute URI to operation |
| `operationId`  | string           | No*      | Name of existing operation         |
| `parameters`   | Map[string, any] | No       | Parameters to pass (runtime exprs) |
| `requestBody`  | any              | No       | Request body (runtime expression)  |
| `description`  | string           | No       | Link description                   |
| `server`       | Server Object    | No       | Target server                      |

\*Must have either `operationRef` OR `operationId`, not both.

```yaml
responses:
  "201":
    description: Created
    links:
      GetUserById:
        operationId: getUser
        parameters:
          userId: $response.body#/id
```

## Webhooks

Top-level field for incoming webhook definitions. Uses the same Path Item Object structure as `paths`.

```yaml
webhooks:
  newOrder:
    post:
      summary: New order notification
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: "#/components/schemas/Order"
      responses:
        "200":
          description: Webhook processed
```

## Example Object

| Field           | Type   | Required | Description            |
| --------------- | ------ | -------- | ---------------------- |
| `summary`       | string | No       | Short description      |
| `description`   | string | No       | Long description       |
| `value`         | any    | No*      | Embedded example value |
| `externalValue` | string | No*      | URL to example value   |

\*Must have either `value` OR `externalValue`, not both.

```yaml
examples:
  basic:
    summary: A basic example
    value:
      id: "123"
      name: "Example Resource"
  external:
    summary: External example
    externalValue: https://example.com/examples/resource.json
```

## Media Type Object

| Field      | Type                                            | Required | Description             |
| ---------- | ----------------------------------------------- | -------- | ----------------------- |
| `schema`   | Schema Object                                   | No       | Content schema          |
| `example`  | any                                             | No       | Example value           |
| `examples` | Map[string, Example Object \| Reference Object] | No       | Multiple examples       |
| `encoding` | Map[string, Encoding Object]                    | No       | Encoding for properties |

## Header Object

Same as Parameter Object, but without `name` and `in` fields (those are implicit).

| Field         | Type                                            | Required | Description            |
| ------------- | ----------------------------------------------- | -------- | ---------------------- |
| `description` | string                                          | No       | Header description     |
| `required`    | boolean                                         | No       | Whether required       |
| `deprecated`  | boolean                                         | No       | Mark as deprecated     |
| `schema`      | Schema Object                                   | No*      | Header schema          |
| `content`     | Map[string, Media Type Object]                  | No*      | Complex serialization  |
| `style`       | string                                          | No       | Default: `simple`      |
| `explode`     | boolean                                         | No       | Explode arrays/objects |
| `example`     | any                                             | No       | Example value          |
| `examples`    | Map[string, Example Object \| Reference Object] | No       | Multiple examples      |

\*Must have either `schema` OR `content`, never both.

## Tag Object

| Field          | Type                          | Required | Description              |
| -------------- | ----------------------------- | -------- | ------------------------ |
| `name`         | string                        | Yes      | Tag name                 |
| `description`  | string                        | No       | Tag description          |
| `externalDocs` | External Documentation Object | No       | Additional documentation |

```yaml
tags:
  - name: Resources
    description: Resource management operations
    externalDocs:
      description: Learn more
      url: https://docs.example.com/resources
```

## External Documentation Object

| Field         | Type         | Required | Description           |
| ------------- | ------------ | -------- | --------------------- |
| `url`         | string (URL) | Yes      | Documentation URL     |
| `description` | string       | No       | Documentation summary |

## Advanced Schema Features

### Tuple Validation

```yaml
type: array
prefixItems:
  - type: string
  - type: integer
```

### Property Name Constraints

```yaml
type: object
propertyNames:
  pattern: "^[a-z]+$"
minProperties: 1
maxProperties: 50
```

### Const (single allowed value)

```yaml
const: "fixed_value"
```
