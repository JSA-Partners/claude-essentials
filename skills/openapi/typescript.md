# TypeScript-Specific OpenAPI Patterns

Type mappings, handler patterns, and project conventions for generating OpenAPI specs from TypeScript/Node.js REST APIs.

## Project Structure Detection

### Common Locations

| Component      | Typical Paths                                                    |
| -------------- | ---------------------------------------------------------------- |
| Router/App     | `src/app.ts`, `src/index.ts`, `src/server.ts`                    |
| Routes         | `src/routes/`, `src/api/`, `src/controllers/`                    |
| Types/DTOs     | `src/types/`, `src/dto/`, `src/interfaces/`, `src/schemas/`      |
| Models         | `src/models/`, `src/entities/`                                   |
| Test Factories | `src/__tests__/factories/`, `test/factories/`, `tests/fixtures/` |

### Framework Detection

Check `package.json` dependencies:

| Framework | Package Name   |
| --------- | -------------- |
| Express   | `express`      |
| Fastify   | `fastify`      |
| NestJS    | `@nestjs/core` |
| Hono      | `hono`         |
| Koa       | `koa`          |
| Restify   | `restify`      |

---

## Handler Patterns by Framework

### Express

```typescript
// Function-based
router.get("/resources", async (req: Request, res: Response) => {
  const resources = await service.findAll();
  res.json(resources);
});

router.post("/resources", async (req: Request, res: Response) => {
  const body: CreateResourceDto = req.body;
  const resource = await service.create(body);
  res.status(201).json(resource);
});

// Class-based controller
class ResourceController {
  async list(req: Request, res: Response): Promise<void> {
    res.json(await this.service.findAll());
  }
}
```

### Fastify

```typescript
fastify.get<{ Reply: Resource[] }>("/resources", async (request, reply) => {
  return service.findAll();
});

fastify.post<{ Body: CreateResourceDto; Reply: Resource }>(
  "/resources",
  async (request, reply) => {
    reply.code(201);
    return service.create(request.body);
  }
);
```

### NestJS

```typescript
@Controller("resources")
export class ResourceController {
  @Get()
  async findAll(): Promise<Resource[]> {
    return this.service.findAll();
  }

  @Post()
  @HttpCode(201)
  async create(@Body() dto: CreateResourceDto): Promise<Resource> {
    return this.service.create(dto);
  }

  @Get(":id")
  async findOne(@Param("id") id: string): Promise<Resource> {
    return this.service.findOne(id);
  }
}
```

### Hono

```typescript
app.get("/resources", async (c) => {
  return c.json(await service.findAll());
});

app.post("/resources", async (c) => {
  const body = await c.req.json<CreateResourceDto>();
  return c.json(await service.create(body), 201);
});
```

---

## Type Mapping

| TypeScript Type            | OpenAPI Schema                    |
| -------------------------- | --------------------------------- |
| `string`                   | `type: string`                    |
| `string \| null`           | `type: ["string", "null"]`        |
| `number`                   | `type: number`                    |
| `number` (integer context) | `type: integer`                   |
| `boolean`                  | `type: boolean`                   |
| `Date`                     | `type: string, format: date-time` |
| `bigint`                   | `type: integer, format: int64`    |

### Optional and Nullable

| TypeScript Type                   | OpenAPI Schema                   |
| --------------------------------- | -------------------------------- |
| `string?` / `string \| undefined` | Optional field (not in required) |
| `string \| null`                  | `type: ["string", "null"]`       |
| `string \| null \| undefined`     | Optional + nullable              |

### Complex Types

| TypeScript Type     | OpenAPI Schema                                   |
| ------------------- | ------------------------------------------------ |
| `T[]`               | `type: array, items: {T schema}`                 |
| `Array<T>`          | `type: array, items: {T schema}`                 |
| `Record<string, T>` | `type: object, additionalProperties: {T schema}` |
| `Map<string, T>`    | `type: object, additionalProperties: {T schema}` |
| `object`            | `type: object`                                   |
| `any`               | `type: object, additionalProperties: true`       |
| `unknown`           | `type: object`                                   |

### Common Library Types

| Type                        | OpenAPI Schema                   |
| --------------------------- | -------------------------------- |
| `UUID` (from uuid)          | `type: string, format: uuid`     |
| `Decimal` (from decimal.js) | `type: string` or `type: number` |
| `Buffer`                    | `type: string, format: byte`     |

---

## DTO/Schema Extraction

### Interface-based DTOs

```typescript
interface CreateResourceDto {
  name: string;
  email?: string;
  active: boolean;
}

interface Resource {
  id: string;
  name: string;
  email: string | null;
  active: boolean;
  createdAt: Date;
  updatedAt: Date;
}
```

Maps to:

```yaml
CreateResourceRequest:
  type: object
  required:
    - name
    - active
  properties:
    name:
      type: string
    email:
      type: string
    active:
      type: boolean

Resource:
  type: object
  required:
    - id
    - name
    - active
    - createdAt
    - updatedAt
  properties:
    id:
      type: string
    name:
      type: string
    email:
      type: ["string", "null"]
    active:
      type: boolean
    createdAt:
      type: string
      format: date-time
    updatedAt:
      type: string
      format: date-time
```

---

## Validation Library Extraction

### Zod

```typescript
import { z } from "zod";

const CreateResourceSchema = z.object({
  name: z.string().min(1).max(255),
  email: z.string().email().optional(),
  age: z.number().int().min(0).max(150),
  tags: z.array(z.string()).default([]),
});

type CreateResourceDto = z.infer<typeof CreateResourceSchema>;
```

Maps to:

```yaml
CreateResourceRequest:
  type: object
  required:
    - name
    - age
  properties:
    name:
      type: string
      minLength: 1
      maxLength: 255
    email:
      type: string
      format: email
    age:
      type: integer
      minimum: 0
      maximum: 150
    tags:
      type: array
      items:
        type: string
      default: []
```

### class-validator (NestJS)

```typescript
import {
  IsString,
  IsEmail,
  IsOptional,
  MinLength,
  MaxLength,
} from "class-validator";

class CreateResourceDto {
  @IsString()
  @MinLength(1)
  @MaxLength(255)
  name: string;

  @IsEmail()
  @IsOptional()
  email?: string;

  @IsInt()
  @Min(0)
  @Max(150)
  age: number;
}
```

### Yup

```typescript
const schema = yup.object({
  name: yup.string().required().min(1).max(255),
  email: yup.string().email(),
  active: yup.boolean().default(true),
});
```

---

## Response Status Detection

### Express

```typescript
res.status(201).json(resource);
res.sendStatus(204);
res.status(400).json({ error: "Bad request" });
```

### NestJS Decorators

```typescript
@HttpCode(201)
@HttpCode(HttpStatus.NO_CONTENT)
@HttpCode(HttpStatus.CREATED)
```

### Fastify

```typescript
reply.code(201).send(resource);
reply.status(204).send();
```

---

## Path Parameter Extraction

### Express

```typescript
router.get("/resources/:id", (req, res) => {
  const { id } = req.params;
});

router.get("/users/:userId/posts/:postId", (req, res) => {
  const { userId, postId } = req.params;
});
```

### NestJS

```typescript
@Get(':id')
findOne(@Param('id') id: string) {}

@Get(':userId/posts/:postId')
findPost(@Param('userId') userId: string, @Param('postId') postId: string) {}
```

Maps to:

```yaml
parameters:
  - name: id
    in: path
    required: true
    schema:
      type: string
```

---

## Test Factory Patterns

### @faker-js/faker

```typescript
import { faker } from "@faker-js/faker";

export function createResource(overrides?: Partial<Resource>): Resource {
  return {
    id: faker.string.uuid(),
    name: faker.company.name(),
    email: faker.internet.email(),
    active: true,
    createdAt: faker.date.past(),
    updatedAt: faker.date.recent(),
    ...overrides,
  };
}
```

### Fishery

```typescript
import { Factory } from "fishery";

const resourceFactory = Factory.define<Resource>(() => ({
  id: faker.string.uuid(),
  name: faker.company.name(),
  email: faker.internet.email(),
  active: true,
  createdAt: new Date(),
  updatedAt: new Date(),
}));

// Usage
const resource = resourceFactory.build();
const resources = resourceFactory.buildList(5);
```

Extract default values for OpenAPI examples:

```yaml
examples:
  ResourceExample:
    summary: Example resource
    value:
      id: "550e8400-e29b-41d4-a716-446655440000"
      name: "Acme Corporation"
      email: "contact@acme.com"
      active: true
      createdAt: "2024-01-15T10:30:00Z"
      updatedAt: "2024-01-15T10:30:00Z"
```

---

## Query Parameter Patterns

### Express with query types

```typescript
interface ListQueryParams {
  limit?: number;
  cursor?: string;
  sort?: "asc" | "desc";
}

router.get("/resources", (req: Request<{}, {}, {}, ListQueryParams>, res) => {
  const { limit = 20, cursor, sort = "asc" } = req.query;
});
```

### NestJS Query decorator

```typescript
@Get()
findAll(
  @Query('limit', new DefaultValuePipe(20), ParseIntPipe) limit: number,
  @Query('cursor') cursor?: string,
) {}
```

Maps to:

```yaml
parameters:
  - name: limit
    in: query
    schema:
      type: integer
      default: 20
  - name: cursor
    in: query
    schema:
      type: string
```
