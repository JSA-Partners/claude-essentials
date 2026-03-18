# Python-Specific OpenAPI Patterns

Type mappings, handler patterns, and project conventions for generating OpenAPI specs from Python REST APIs.

## Project Structure Detection

### Common Locations

| Component      | Typical Paths                                              |
| -------------- | ---------------------------------------------------------- |
| Main App       | `app/main.py`, `src/main.py`, `api/app.py`                 |
| Routes         | `app/routers/`, `app/routes/`, `app/api/`, `api/views/`    |
| Schemas        | `app/schemas/`, `app/models/`, `api/serializers/`          |
| Models         | `app/models/`, `app/db/models/`, `models/`                 |
| Test Factories | `tests/factories/`, `tests/conftest.py`, `tests/fixtures/` |

### Framework Detection

Check `pyproject.toml` or `requirements.txt`:

| Framework             | Package Name          |
| --------------------- | --------------------- |
| FastAPI               | `fastapi`             |
| Flask                 | `flask`               |
| Django REST Framework | `djangorestframework` |
| Starlette             | `starlette`           |
| Litestar              | `litestar`            |
| Falcon                | `falcon`              |

---

## Handler Patterns by Framework

### FastAPI

```python
from fastapi import APIRouter, HTTPException, status
from pydantic import BaseModel

router = APIRouter(prefix="/resources", tags=["Resources"])

@router.get("/", response_model=list[Resource])
async def list_resources() -> list[Resource]:
    return await service.find_all()

@router.post("/", response_model=Resource, status_code=status.HTTP_201_CREATED)
async def create_resource(body: CreateResourceRequest) -> Resource:
    return await service.create(body)

@router.get("/{resource_id}", response_model=Resource)
async def get_resource(resource_id: str) -> Resource:
    resource = await service.find_by_id(resource_id)
    if not resource:
        raise HTTPException(status_code=404, detail="Resource not found")
    return resource
```

### Flask

```python
from flask import Blueprint, jsonify, request

bp = Blueprint('resources', __name__, url_prefix='/resources')

@bp.route('/', methods=['GET'])
def list_resources():
    resources = service.find_all()
    return jsonify([r.to_dict() for r in resources])

@bp.route('/', methods=['POST'])
def create_resource():
    data = request.get_json()
    resource = service.create(data)
    return jsonify(resource.to_dict()), 201
```

### Flask-RESTful

```python
from flask_restful import Resource, Api

class ResourceList(Resource):
    def get(self):
        return [r.to_dict() for r in service.find_all()]

    def post(self):
        data = request.get_json()
        resource = service.create(data)
        return resource.to_dict(), 201

api.add_resource(ResourceList, '/resources')
```

### Django REST Framework

```python
from rest_framework import viewsets, status
from rest_framework.response import Response

class ResourceViewSet(viewsets.ModelViewSet):
    queryset = Resource.objects.all()
    serializer_class = ResourceSerializer

    def create(self, request):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        self.perform_create(serializer)
        return Response(serializer.data, status=status.HTTP_201_CREATED)
```

---

## Type Mapping

| Python Type     | OpenAPI Schema               |
| --------------- | ---------------------------- |
| `str`           | `type: string`               |
| `str \| None`   | `type: ["string", "null"]`   |
| `Optional[str]` | `type: ["string", "null"]`   |
| `int`           | `type: integer`              |
| `float`         | `type: number`               |
| `bool`          | `type: boolean`              |
| `bytes`         | `type: string, format: byte` |

### Date/Time Types

| Python Type | OpenAPI Schema                    |
| ----------- | --------------------------------- |
| `datetime`  | `type: string, format: date-time` |
| `date`      | `type: string, format: date`      |
| `time`      | `type: string, format: time`      |
| `timedelta` | `type: string, format: duration`  |

### Special Types

| Python Type           | OpenAPI Schema                         |
| --------------------- | -------------------------------------- |
| `UUID`                | `type: string, format: uuid`           |
| `Decimal`             | `type: string` or `type: number`       |
| `EmailStr` (Pydantic) | `type: string, format: email`          |
| `HttpUrl` (Pydantic)  | `type: string, format: uri`            |
| `IPvAnyAddress`       | `type: string, format: ipv4` or `ipv6` |

### Complex Types

| Python Type         | OpenAPI Schema                                   |
| ------------------- | ------------------------------------------------ |
| `list[T]`           | `type: array, items: {T schema}`                 |
| `List[T]`           | `type: array, items: {T schema}`                 |
| `dict[str, T]`      | `type: object, additionalProperties: {T schema}` |
| `Dict[str, T]`      | `type: object, additionalProperties: {T schema}` |
| `Any`               | `type: object, additionalProperties: true`       |
| `Literal["a", "b"]` | `type: string, enum: ["a", "b"]`                 |

---

## Pydantic Model Extraction

### Basic Model

```python
from pydantic import BaseModel, Field
from datetime import datetime
from typing import Optional

class CreateResourceRequest(BaseModel):
    name: str = Field(..., min_length=1, max_length=255)
    email: Optional[str] = Field(None, pattern=r'^[\w\.-]+@[\w\.-]+\.\w+$')
    active: bool = True

class Resource(BaseModel):
    id: str
    name: str
    email: Optional[str] = None
    active: bool
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True  # For ORM mode
```

Maps to:

```yaml
CreateResourceRequest:
  type: object
  required:
    - name
  properties:
    name:
      type: string
      minLength: 1
      maxLength: 255
    email:
      type: ["string", "null"]
      pattern: '^[\w\.-]+@[\w\.-]+\.\w+$'
    active:
      type: boolean
      default: true

Resource:
  type: object
  required:
    - id
    - name
    - active
    - created_at
    - updated_at
  properties:
    id:
      type: string
    name:
      type: string
    email:
      type: ["string", "null"]
    active:
      type: boolean
    created_at:
      type: string
      format: date-time
    updated_at:
      type: string
      format: date-time
```

### Field Constraints Mapping

| Pydantic Field                  | OpenAPI Schema        |
| ------------------------------- | --------------------- |
| `Field(..., min_length=N)`      | `minLength: N`        |
| `Field(..., max_length=N)`      | `maxLength: N`        |
| `Field(..., ge=N)`              | `minimum: N`          |
| `Field(..., le=N)`              | `maximum: N`          |
| `Field(..., gt=N)`              | `exclusiveMinimum: N` |
| `Field(..., lt=N)`              | `exclusiveMaximum: N` |
| `Field(..., pattern=r'...')`    | `pattern: '...'`      |
| `Field(..., description='...')` | `description: '...'`  |
| `Field(default=X)`              | `default: X`          |

### Pydantic Examples

```python
class Resource(BaseModel):
    name: str
    email: str

    model_config = {
        "json_schema_extra": {
            "examples": [
                {"name": "Acme Corp", "email": "contact@acme.com"}
            ]
        }
    }
```

---

## Django REST Framework Serializers

### Basic Serializer

```python
from rest_framework import serializers

class ResourceSerializer(serializers.ModelSerializer):
    class Meta:
        model = Resource
        fields = ['id', 'name', 'email', 'active', 'created_at', 'updated_at']
        read_only_fields = ['id', 'created_at', 'updated_at']

class CreateResourceSerializer(serializers.Serializer):
    name = serializers.CharField(min_length=1, max_length=255)
    email = serializers.EmailField(required=False, allow_null=True)
    active = serializers.BooleanField(default=True)
```

### Serializer Field Mapping

| DRF Field         | OpenAPI Schema                    |
| ----------------- | --------------------------------- |
| `CharField()`     | `type: string`                    |
| `IntegerField()`  | `type: integer`                   |
| `FloatField()`    | `type: number`                    |
| `BooleanField()`  | `type: boolean`                   |
| `DateTimeField()` | `type: string, format: date-time` |
| `EmailField()`    | `type: string, format: email`     |
| `URLField()`      | `type: string, format: uri`       |
| `UUIDField()`     | `type: string, format: uuid`      |

---

## Marshmallow Schemas (Flask)

```python
from marshmallow import Schema, fields, validate

class ResourceSchema(Schema):
    id = fields.Int(dump_only=True)
    name = fields.Str(required=True, validate=validate.Length(min=1, max=255))
    email = fields.Email(allow_none=True)
    active = fields.Bool(load_default=True)
    created_at = fields.DateTime(dump_only=True)

class CreateResourceSchema(Schema):
    name = fields.Str(required=True, validate=validate.Length(min=1, max=255))
    email = fields.Email(allow_none=True)
    active = fields.Bool(load_default=True)
```

---

## Response Status Detection

### FastAPI

```python
@router.post("/", status_code=status.HTTP_201_CREATED)
@router.delete("/{id}", status_code=status.HTTP_204_NO_CONTENT)

# Or via Response
from fastapi.responses import Response
return Response(status_code=204)
```

### Flask

```python
return jsonify(data), 201
return '', 204
return jsonify({'error': 'Not found'}), 404
```

### Django REST Framework

```python
from rest_framework import status
return Response(data, status=status.HTTP_201_CREATED)
return Response(status=status.HTTP_204_NO_CONTENT)
```

---

## Path Parameter Extraction

### FastAPI

```python
@router.get("/{resource_id}")
async def get_resource(resource_id: str):
    pass

@router.get("/{user_id}/posts/{post_id}")
async def get_user_post(user_id: int, post_id: int):
    pass
```

### Flask

```python
@bp.route('/<resource_id>')
def get_resource(resource_id):
    pass

@bp.route('/<int:user_id>/posts/<int:post_id>')
def get_user_post(user_id, post_id):
    pass
```

Maps to:

```yaml
parameters:
  - name: resource_id
    in: path
    required: true
    schema:
      type: string
```

---

## Query Parameter Patterns

### FastAPI

```python
from fastapi import Query

@router.get("/")
async def list_resources(
    limit: int = Query(20, ge=1, le=100),
    cursor: Optional[str] = None,
    sort: Literal["asc", "desc"] = "asc",
):
    pass
```

### Flask

```python
@bp.route('/')
def list_resources():
    limit = request.args.get('limit', 20, type=int)
    cursor = request.args.get('cursor')
    sort = request.args.get('sort', 'asc')
```

Maps to:

```yaml
parameters:
  - name: limit
    in: query
    schema:
      type: integer
      minimum: 1
      maximum: 100
      default: 20
  - name: cursor
    in: query
    schema:
      type: string
  - name: sort
    in: query
    schema:
      type: string
      enum: ["asc", "desc"]
      default: "asc"
```

---

## Test Factory Patterns

### Factory Boy

```python
import factory
from faker import Faker

fake = Faker()

class ResourceFactory(factory.Factory):
    class Meta:
        model = Resource

    id = factory.LazyFunction(lambda: str(uuid.uuid4()))
    name = factory.LazyFunction(fake.company)
    email = factory.LazyFunction(fake.email)
    active = True
    created_at = factory.LazyFunction(datetime.utcnow)
    updated_at = factory.LazyFunction(datetime.utcnow)

# Usage
resource = ResourceFactory()
resources = ResourceFactory.create_batch(5)
```

### Pytest Fixtures

```python
import pytest
from faker import Faker

fake = Faker()

@pytest.fixture
def resource_data():
    return {
        "name": fake.company(),
        "email": fake.email(),
        "active": True,
    }

@pytest.fixture
def resource(db_session, resource_data):
    resource = Resource(**resource_data)
    db_session.add(resource)
    db_session.commit()
    return resource
```

Extract values for OpenAPI examples:

```yaml
examples:
  ResourceExample:
    summary: Example resource
    value:
      id: "550e8400-e29b-41d4-a716-446655440000"
      name: "Acme Corporation"
      email: "contact@acme.com"
      active: true
      created_at: "2024-01-15T10:30:00Z"
      updated_at: "2024-01-15T10:30:00Z"
```
