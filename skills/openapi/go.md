# Go-Specific OpenAPI Patterns

Type mappings, handler patterns, and project conventions for generating OpenAPI specs from Go REST APIs.

## Project Structure Detection

### Common Locations

| Component      | Typical Paths                                                         |
| -------------- | --------------------------------------------------------------------- |
| Router         | `internal/server/router.go`, `cmd/api/routes.go`, `pkg/api/router.go` |
| Handlers       | `internal/server/handlers/`, `internal/api/`, `pkg/handlers/`         |
| DTOs           | `internal/dtos/`, `pkg/api/`, `internal/types/`                       |
| Models         | `internal/database/models/`, `internal/models/`, `pkg/models/`        |
| Test Factories | `internal/testutil/`, `test/factories/`, `pkg/testutil/`              |

### Framework Detection

Check `go.mod` for framework imports:

| Framework   | go.mod Import                         |
| ----------- | ------------------------------------- |
| Chi         | `github.com/go-chi/chi`               |
| Gin         | `github.com/gin-gonic/gin`            |
| Echo        | `github.com/labstack/echo`            |
| Fiber       | `github.com/gofiber/fiber`            |
| Gorilla Mux | `github.com/gorilla/mux`              |
| stdlib      | No framework import (uses `net/http`) |

---

## Handler Patterns by Framework

### Chi / stdlib (net/http)

```go
func (h *Handler) Create(w http.ResponseWriter, r *http.Request) {
    // Request body
    var body CreateRequestBody
    json.NewDecoder(r.Body).Decode(&body)

    // Response
    w.WriteHeader(http.StatusCreated)
    json.NewEncoder(w).Encode(dto)
}
```

### Gin

```go
func (h *Handler) Create(c *gin.Context) {
    var body CreateRequestBody
    c.ShouldBindJSON(&body)

    c.JSON(http.StatusCreated, dto)
}
```

### Echo

```go
func (h *Handler) Create(c echo.Context) error {
    var body CreateRequestBody
    c.Bind(&body)

    return c.JSON(http.StatusCreated, dto)
}
```

---

## Type Mapping

| Go Type          | OpenAPI Schema                    |
| ---------------- | --------------------------------- |
| `string`         | `type: string`                    |
| `*string`        | `type: ["string", "null"]`        |
| `int`, `int32`   | `type: integer, format: int32`    |
| `int64`          | `type: integer, format: int64`    |
| `uint`, `uint64` | `type: integer, format: int64`    |
| `float32`        | `type: number, format: float`     |
| `float64`        | `type: number, format: double`    |
| `bool`           | `type: boolean`                   |
| `time.Time`      | `type: string, format: date-time` |
| `[]byte`         | `type: string, format: byte`      |
| `uuid.UUID`      | `type: string, format: uuid`      |

### Nullable Types

| Go Type                | OpenAPI Schema                                |
| ---------------------- | --------------------------------------------- |
| `sql.NullString`       | `type: ["string", "null"]`                    |
| `sql.NullInt64`        | `type: ["integer", "null"], format: int64`    |
| `sql.NullBool`         | `type: ["boolean", "null"]`                   |
| `sql.NullTime`         | `type: ["string", "null"], format: date-time` |
| `nullable.Nullable[T]` | `type: ["T", "null"]`                         |

### Complex Types

| Go Type           | OpenAPI Schema                                   |
| ----------------- | ------------------------------------------------ |
| `[]T`             | `type: array, items: {T schema}`                 |
| `map[string]T`    | `type: object, additionalProperties: {T schema}` |
| `datatypes.JSON`  | `type: object, additionalProperties: true`       |
| `json.RawMessage` | `type: object, additionalProperties: true`       |

---

## Request Body Extraction

Look for struct definitions in handler files:

```go
type CreateRequestBody struct {
    Name   string  `json:"name"`           // required
    Email  *string `json:"email,omitempty"` // optional, nullable
    Active bool    `json:"active"`         // required
}
```

### Determining Required Fields

- **Required**: Non-pointer types without `omitempty`
- **Optional**: Pointer types OR has `omitempty` tag
- **Nullable**: Pointer types, `sql.Null*`, `nullable.Nullable[T]`

### JSON Tag Parsing

```go
`json:"fieldName"`           // Field name: fieldName
`json:"fieldName,omitempty"` // Optional field
`json:"-"`                   // Skip this field
```

---

## Response Extraction

### Status Code Detection

```go
w.WriteHeader(http.StatusOK)          // 200
w.WriteHeader(http.StatusCreated)     // 201
w.WriteHeader(http.StatusNoContent)   // 204
w.WriteHeader(http.StatusBadRequest)  // 400
w.WriteHeader(http.StatusNotFound)    // 404
w.WriteHeader(http.StatusConflict)    // 409
```

### Response Body Detection

```go
// Look for JSON encoding patterns
json.NewEncoder(w).Encode(dto)
json.MarshalWrite(w, dto)
render.JSON(w, r, dto)  // chi render
c.JSON(status, dto)      // gin
c.JSON(status, dto)      // echo
```

### Error Response Detection

```go
httputil.WriteError(w, r, http.StatusBadRequest, err)
render.Status(r, http.StatusNotFound)
c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"error": msg})
```

---

## DTO Analysis

### Response DTO Pattern

```go
// internal/dtos/resource.go
type GetResourceDTO struct {
    ID        uint      `json:"id"`
    Slug      string    `json:"slug"`
    Name      string    `json:"name"`
    CreatedAt time.Time `json:"createdAt"`
    UpdatedAt time.Time `json:"updatedAt"`
}
```

Maps to:

```yaml
Resource:
  type: object
  properties:
    id:
      type: integer
      format: int64
      readOnly: true
    slug:
      type: string
      readOnly: true
    name:
      type: string
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
    - slug
    - name
    - createdAt
    - updatedAt
```

### Update Request Pattern (JSON Merge Patch)

```go
type UpdateRequestBody struct {
    Name  nullable.Nullable[string] `json:"name"`
    Email nullable.Nullable[string] `json:"email"`
}
```

Maps to:

```yaml
UpdateResourceRequest:
  type: object
  description: JSON Merge Patch (RFC 7396) - only include fields to update
  properties:
    name:
      type: ["string", "null"]
      description: Set to null to clear, omit to leave unchanged
    email:
      type: ["string", "null"]
      description: Set to null to clear, omit to leave unchanged
```

---

## Test Factory Analysis

### Factory Function Pattern

```go
// internal/testutil/resource.go
func CreateResource(t *testing.T, db *gorm.DB, opts ...ResourceOption) *models.Resource {
    resource := &models.Resource{
        Name:   gofakeit.Company(),
        Domain: gofakeit.DomainName(),
        Active: true,
    }
    // Apply options...
    db.Create(resource)
    return resource
}
```

Extract default values for OpenAPI examples:

```yaml
examples:
  ResourceExample:
    summary: Example resource
    value:
      name: "Acme Corporation"
      domain: "acme.example.com"
      active: true
```

### Option Pattern

```go
type ResourceOption func(*models.Resource)

func WithName(name string) ResourceOption {
    return func(r *models.Resource) { r.Name = name }
}
```

---

## Path Parameter Extraction

### Chi Router Pattern

```go
chi.URLParam(r, "resourceSlug")
chi.URLParam(r, "id")
```

### Route Registration Pattern

```go
r.Route("/resources/{resourceSlug}", func(r chi.Router) {
    r.Get("/", handler.Get)
    r.Patch("/", handler.Update)
    r.Delete("/", handler.Delete)
})
```

Maps to:

```yaml
parameters:
  - name: resourceSlug
    in: path
    required: true
    schema:
      type: string
```

---

## Validation Extraction

### go-playground/validator Tags

```go
type CreateRequest struct {
    Name  string `json:"name" validate:"required,min=1,max=255"`
    Email string `json:"email" validate:"required,email"`
    Age   int    `json:"age" validate:"gte=0,lte=150"`
}
```

Maps to:

```yaml
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
```
