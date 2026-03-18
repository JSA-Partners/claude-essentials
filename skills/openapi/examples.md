# OpenAPI Common Patterns and Examples

> **Note**: This file contains language-agnostic OpenAPI patterns. For language-specific
> type mappings and handler patterns, see:
>
> - [go.md](go.md) - Go/Chi/Gin patterns
> - [typescript.md](typescript.md) - TypeScript/Express/NestJS patterns
> - [python.md](python.md) - Python/FastAPI/Flask patterns

## CRUD Resource Pattern

Complete example for a typical REST resource:

```yaml
paths:
  /resources:
    get:
      operationId: listResources
      summary: List all resources
      tags:
        - Resources
      parameters:
        - $ref: "#/components/parameters/Cursor"
        - $ref: "#/components/parameters/Limit"
      responses:
        "200":
          description: Paginated list of resources
          content:
            application/json:
              schema:
                $ref: "#/components/schemas/ResourceList"
        "401":
          $ref: "#/components/responses/Unauthorized"
      security:
        - bearerAuth: []

    post:
      operationId: createResource
      summary: Create a new resource
      tags:
        - Resources
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: "#/components/schemas/CreateResourceRequest"
            examples:
              basic:
                summary: Basic resource
                value:
                  name: "Example Resource"
              full:
                summary: Full resource with all fields
                value:
                  name: "Complete Example"
                  description: "A fully specified resource"
                  active: true
      responses:
        "201":
          description: Resource created
          headers:
            Location:
              schema:
                type: string
              description: URL of the created resource
          content:
            application/json:
              schema:
                $ref: "#/components/schemas/Resource"
        "400":
          $ref: "#/components/responses/BadRequest"
        "401":
          $ref: "#/components/responses/Unauthorized"
        "409":
          $ref: "#/components/responses/Conflict"
      security:
        - bearerAuth: []

  /resources/{slug}:
    parameters:
      - name: slug
        in: path
        required: true
        description: URL-safe identifier for the resource
        schema:
          type: string
          pattern: "^[a-z0-9-]+$"

    get:
      operationId: getResource
      summary: Get a resource by slug
      tags:
        - Resources
      responses:
        "200":
          description: Resource details
          content:
            application/json:
              schema:
                $ref: "#/components/schemas/Resource"
        "401":
          $ref: "#/components/responses/Unauthorized"
        "404":
          $ref: "#/components/responses/NotFound"
      security:
        - bearerAuth: []

    patch:
      operationId: updateResource
      summary: Update a resource
      description: |
        Partially update a resource using JSON Merge Patch (RFC 7396).
        Only specified fields are updated. Set a field to `null` to clear it.
      tags:
        - Resources
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: "#/components/schemas/UpdateResourceRequest"
      responses:
        "200":
          description: Resource updated
          content:
            application/json:
              schema:
                $ref: "#/components/schemas/Resource"
        "400":
          $ref: "#/components/responses/BadRequest"
        "401":
          $ref: "#/components/responses/Unauthorized"
        "404":
          $ref: "#/components/responses/NotFound"
      security:
        - bearerAuth: []

    delete:
      operationId: deleteResource
      summary: Delete a resource
      tags:
        - Resources
      responses:
        "204":
          description: Resource deleted
        "401":
          $ref: "#/components/responses/Unauthorized"
        "404":
          $ref: "#/components/responses/NotFound"
      security:
        - bearerAuth: []
```

## Cursor-Based Pagination

```yaml
components:
  parameters:
    Cursor:
      name: cursor
      in: query
      description: Pagination cursor from previous response
      schema:
        type: string
    Limit:
      name: limit
      in: query
      description: Maximum number of items to return
      schema:
        type: integer
        minimum: 1
        maximum: 100
        default: 20

  schemas:
    PaginationMeta:
      type: object
      properties:
        nextCursor:
          type: ["string", "null"]
          description: Cursor for next page, null if no more results
        hasMore:
          type: boolean
          description: Whether more results exist
      required:
        - hasMore

    ResourceList:
      type: object
      properties:
        data:
          type: array
          items:
            $ref: "#/components/schemas/Resource"
        meta:
          $ref: "#/components/schemas/PaginationMeta"
      required:
        - data
        - meta
```

## Error Response Pattern (RFC 7807)

```yaml
components:
  schemas:
    ProblemDetails:
      type: object
      description: RFC 7807 Problem Details
      properties:
        type:
          type: string
          format: uri
          description: URI reference identifying the problem type
        title:
          type: string
          description: Short human-readable summary
        status:
          type: integer
          description: HTTP status code
        detail:
          type: string
          description: Human-readable explanation
        instance:
          type: string
          format: uri
          description: URI reference identifying this occurrence
      required:
        - type
        - title
        - status

  responses:
    BadRequest:
      description: Invalid request
      content:
        application/problem+json:
          schema:
            $ref: "#/components/schemas/ProblemDetails"
          examples:
            validation:
              summary: Validation error
              value:
                type: "https://api.example.com/problems/validation-error"
                title: "Validation Error"
                status: 400
                detail: "The 'name' field is required"

    Unauthorized:
      description: Authentication required
      content:
        application/problem+json:
          schema:
            $ref: "#/components/schemas/ProblemDetails"
          examples:
            missing:
              summary: Missing token
              value:
                type: "https://api.example.com/problems/unauthorized"
                title: "Unauthorized"
                status: 401
                detail: "Authentication token is required"

    NotFound:
      description: Resource not found
      content:
        application/problem+json:
          schema:
            $ref: "#/components/schemas/ProblemDetails"
          examples:
            notFound:
              summary: Resource not found
              value:
                type: "https://api.example.com/problems/not-found"
                title: "Not Found"
                status: 404
                detail: "The requested resource could not be found"

    Conflict:
      description: Resource conflict
      content:
        application/problem+json:
          schema:
            $ref: "#/components/schemas/ProblemDetails"
          examples:
            duplicate:
              summary: Duplicate resource
              value:
                type: "https://api.example.com/problems/conflict"
                title: "Conflict"
                status: 409
                detail: "A resource with this identifier already exists"

    InternalError:
      description: Internal server error
      content:
        application/problem+json:
          schema:
            $ref: "#/components/schemas/ProblemDetails"
```

## JWT Bearer Authentication

```yaml
components:
  securitySchemes:
    bearerAuth:
      type: http
      scheme: bearer
      bearerFormat: JWT
      description: |
        JWT token obtained from authentication provider.
        Include in Authorization header: `Bearer <token>`

security:
  - bearerAuth: []
```

## Nested Resource Pattern

For resources within resources (e.g., `/projects/{slug}/members`):

```yaml
paths:
  /projects/{projectSlug}/members:
    parameters:
      - name: projectSlug
        in: path
        required: true
        schema:
          type: string

    get:
      operationId: listProjectMembers
      summary: List members for a project
      tags:
        - Project Members
      responses:
        "200":
          description: List of members
        "404":
          description: Project not found

    post:
      operationId: createProjectMember
      summary: Add a member to a project
      tags:
        - Project Members
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: "#/components/schemas/CreateMemberRequest"
      responses:
        "201":
          description: Member added

  /projects/{projectSlug}/members/{memberId}:
    parameters:
      - name: projectSlug
        in: path
        required: true
        schema:
          type: string
      - name: memberId
        in: path
        required: true
        schema:
          type: string

    delete:
      operationId: deleteProjectMember
      summary: Remove a member
      tags:
        - Project Members
      responses:
        "204":
          description: Member removed
```

## Complete Single-Resource Example

Full CRUD example for a "users" resource in a TypeScript/Express project, showing paths, schemas, and realistic test factory values:

```yaml
# Resource: users
# Language: typescript
# Handlers analyzed: src/controllers/users.controller.ts

paths:
  /v1/users:
    get:
      operationId: listUsers
      summary: List all users
      tags:
        - Users
      parameters:
        - $ref: "#/components/parameters/Cursor"
        - $ref: "#/components/parameters/Limit"
      responses:
        "200":
          description: Paginated list of users
          content:
            application/json:
              schema:
                $ref: "#/components/schemas/UserList"
        "401":
          $ref: "#/components/responses/Unauthorized"
      security:
        - bearerAuth: []

    post:
      operationId: createUser
      summary: Create a new user
      tags:
        - Users
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: "#/components/schemas/CreateUserRequest"
      responses:
        "201":
          description: User created
          content:
            application/json:
              schema:
                $ref: "#/components/schemas/User"
        "400":
          $ref: "#/components/responses/BadRequest"
        "401":
          $ref: "#/components/responses/Unauthorized"
        "409":
          $ref: "#/components/responses/Conflict"
      security:
        - bearerAuth: []

  /v1/users/{id}:
    parameters:
      - name: id
        in: path
        required: true
        schema:
          type: string
          format: uuid

    get:
      operationId: getUser
      summary: Get a user by ID
      tags:
        - Users
      responses:
        "200":
          description: User details
          content:
            application/json:
              schema:
                $ref: "#/components/schemas/User"
        "401":
          $ref: "#/components/responses/Unauthorized"
        "404":
          $ref: "#/components/responses/NotFound"
      security:
        - bearerAuth: []

    patch:
      operationId: updateUser
      summary: Update a user
      tags:
        - Users
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: "#/components/schemas/UpdateUserRequest"
      responses:
        "200":
          description: User updated
          content:
            application/json:
              schema:
                $ref: "#/components/schemas/User"
        "400":
          $ref: "#/components/responses/BadRequest"
        "401":
          $ref: "#/components/responses/Unauthorized"
        "404":
          $ref: "#/components/responses/NotFound"
      security:
        - bearerAuth: []

    delete:
      operationId: deleteUser
      summary: Delete a user
      tags:
        - Users
      responses:
        "204":
          description: User deleted
        "401":
          $ref: "#/components/responses/Unauthorized"
        "404":
          $ref: "#/components/responses/NotFound"
      security:
        - bearerAuth: []

schemas:
  User:
    type: object
    properties:
      id:
        type: string
        format: uuid
        readOnly: true
      email:
        type: string
        format: email
      name:
        type: string
      role:
        type: string
        enum: [admin, user, guest]
      createdAt:
        type: string
        format: date-time
        readOnly: true
      updatedAt:
        type: string
        format: date-time
        readOnly: true
    required:
      - id
      - email
      - name
      - role
      - createdAt
      - updatedAt

  CreateUserRequest:
    type: object
    properties:
      email:
        type: string
        format: email
      name:
        type: string
        minLength: 1
        maxLength: 255
      role:
        type: string
        enum: [admin, user, guest]
        default: user
    required:
      - email
      - name

  UpdateUserRequest:
    type: object
    description: JSON Merge Patch (RFC 7396) - only include fields to update
    properties:
      name:
        type: ["string", "null"]
      role:
        type: ["string", "null"]
        enum: [admin, user, guest, null]

  UserList:
    type: object
    properties:
      data:
        type: array
        items:
          $ref: "#/components/schemas/User"
      meta:
        $ref: "#/components/schemas/PaginationMeta"
    required:
      - data
      - meta

examples:
  UserExample:
    summary: Example user
    value:
      id: "550e8400-e29b-41d4-a716-446655440000"
      email: "john.doe@example.com"
      name: "John Doe"
      role: "user"
      createdAt: "2024-01-15T10:30:00Z"
      updatedAt: "2024-01-15T10:30:00Z"
```

## Reference Data Endpoints

For read-only lookup tables:

```yaml
paths:
  /categories:
    get:
      operationId: listCategories
      summary: List all categories
      description: Returns reference data for category values
      tags:
        - Reference Data
      responses:
        "200":
          description: List of categories
          content:
            application/json:
              schema:
                type: object
                properties:
                  data:
                    type: array
                    items:
                      $ref: "#/components/schemas/Category"
      security:
        - bearerAuth: []

components:
  schemas:
    Category:
      type: object
      properties:
        id:
          type: integer
        name:
          type: string
        description:
          type: string
      required:
        - id
        - name
```
