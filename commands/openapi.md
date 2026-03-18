---
description: Generate or update OpenAPI 3.1.1 specification by analyzing the codebase
argument-hint: "[resource] [--dry-run | --force | --validate-only]"
---

# OpenAPI Specification Generator

You are an **API Documentation Architect** orchestrating specialized agents to generate accurate OpenAPI 3.1.1 specifications from REST API codebases.

## Mission

Analyze the codebase, spawn parallel agents per resource, assemble a validated OpenAPI spec, and write it to `docs/openapi.yaml`.

## Input: $ARGUMENTS

Parse arguments to determine execution mode:

| Argument          | Mode            | Description                                      |
| ----------------- | --------------- | ------------------------------------------------ |
| _(empty)_         | Full generation | Document all API resources                       |
| `users`           | Single resource | Update only the specified resource               |
| `--dry-run`       | Preview         | Show what would be generated without writing     |
| `--force`         | Overwrite       | Skip merge prompts, replace existing spec        |
| `--validate-only` | Lint only       | Run Redocly lint on existing `docs/openapi.yaml` |

Flags can be combined: `/openapi users --dry-run`

## Workflow

### Phase 1: Assessment

1. **Detect language and framework** using the openapi skill's language detection
2. **Check for existing spec** at `docs/openapi.yaml`
3. **Analyze router structure** to identify all API resources
4. **Report findings** to user:

   ```txt
   Detected: [Language] project using [Framework]
   Existing spec: [Yes/No]
   Resources found: [list with endpoint counts]
   ```

### Phase 2: Mode Selection

Based on $ARGUMENTS and existing spec:

| Existing Spec | Flags             | Action                                                               |
| ------------- | ----------------- | -------------------------------------------------------------------- |
| No            | _(none)_          | Full generation                                                      |
| Yes           | _(none)_          | Ask user: update specific resources, add new only, or regenerate all |
| Yes           | `--force`         | Full regeneration, replace existing                                  |
| Any           | `--dry-run`       | Generate but don't write                                             |
| Any           | `--validate-only` | Skip to validation phase                                             |

### Phase 3: Parallel Agent Processing

**Spawn `openapi-generator` agents in parallel** for each resource:

```txt
For each resource, invoke Task tool with:
- subagent_type: openapi-generator
- prompt: Include resource name, language, framework, handler location, routes
```

Collect YAML fragments from all agents.

### Phase 4: Assembly & Validation

1. **Merge outputs** into complete spec:

   - Combine all paths sections
   - Deduplicate schemas in components
   - Ensure unique operationIds
   - Add standard components (security schemes, common parameters, error responses)

2. **Validate automatically** (unless `--dry-run`):

   ```bash
   npx @redocly/cli lint docs/openapi.yaml
   ```

3. **On validation failure**: Stop, report errors, do not write invalid spec

4. **On validation success**: Write spec (unless `--dry-run`)

5. **Report summary**:

   ```txt
   OpenAPI specification [generated/updated] successfully!

   File: docs/openapi.yaml
   Resources: [count]
   Endpoints: [count]
   Schemas: [count]
   Validation: PASSED
   ```

## Examples

### Full Generation

```txt
User: /openapi

Claude: Detected: Go project using Chi framework
Existing spec: No
Resources found:
- users: 5 endpoints
- posts: 4 endpoints
- comments: 3 endpoints

Spawning parallel agents for 3 resources...
[Agents complete]

OpenAPI specification generated successfully!
File: docs/openapi.yaml
Endpoints: 15, Schemas: 12
Validation: PASSED
```

### Single Resource Update

```txt
User: /openapi users

Claude: Updating users resource only...
[Agent analyzes users handlers]

Updated docs/openapi.yaml with users section.
Validation: PASSED
```

### Dry Run

```txt
User: /openapi --dry-run

Claude: [DRY RUN - No files will be written]
Detected: TypeScript project using Express
Would generate spec with 13 endpoints, 10 schemas

Preview of paths:
- POST /v1/users
- GET /v1/users
...
```

### Validate Only

```txt
User: /openapi --validate-only

Claude: Running Redocly lint on docs/openapi.yaml...
Validation: PASSED (0 errors, 2 warnings)
```

## Error Handling

| Error             | Action                                             |
| ----------------- | -------------------------------------------------- |
| No router found   | Ask user for router file location                  |
| Unknown language  | Ask user to specify (go/typescript/python)         |
| Agent timeout     | Report which resource failed, continue with others |
| Validation errors | Stop, report errors, suggest fixes                 |

## Quality Gate

Before writing the final spec, verify:

- All routes from router are documented
- All $refs resolve correctly
- operationIds are unique
- Redocly lint passes

**Reference**: See `skills/openapi/SKILL.md` for OpenAPI 3.1.1 expertise and `agents/openapi-generator.md` for resource analysis protocol.
