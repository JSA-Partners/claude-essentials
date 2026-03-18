---
name: openapi-reference-appendix
description: OpenAPI 3.1.1 appendix covering HTTP status codes, XML objects, OAuth flow details, security schemes, and encoding.
---

# OpenAPI 3.1.1 Appendix Reference

## HTTP Status Code Reference

### Informational (1xx)

| Code | Name                | Usage                                       |
| ---- | ------------------- | ------------------------------------------- |
| 100  | Continue            | Client should continue with request body    |
| 101  | Switching Protocols | Server switching to protocol in Upgrade hdr |

### Successful (2xx)

| Code | Name                          | Usage                                     |
| ---- | ----------------------------- | ----------------------------------------- |
| 200  | OK                            | Successful GET, PUT, PATCH with body      |
| 201  | Created                       | Successful POST creating resource         |
| 202  | Accepted                      | Request accepted for async processing     |
| 203  | Non-Authoritative Information | Transformed response from proxy           |
| 204  | No Content                    | Successful DELETE, PUT/PATCH without body |
| 205  | Reset Content                 | Client should reset document view         |

### Redirection (3xx)

| Code | Name               | Usage                                 |
| ---- | ------------------ | ------------------------------------- |
| 300  | Multiple Choices   | Multiple representations available    |
| 301  | Moved Permanently  | Resource permanently moved to new URI |
| 302  | Found              | Resource temporarily at different URI |
| 303  | See Other          | Redirect to GET another resource      |
| 307  | Temporary Redirect | Temporary redirect, preserve method   |
| 308  | Permanent Redirect | Permanent redirect, preserve method   |

### Client Error (4xx)

| Code | Name                   | Usage                                    |
| ---- | ---------------------- | ---------------------------------------- |
| 400  | Bad Request            | Malformed syntax, invalid request        |
| 401  | Unauthorized           | Missing or invalid authentication        |
| 402  | Payment Required       | Reserved for future use (payment APIs)   |
| 403  | Forbidden              | Valid auth but insufficient permissions  |
| 404  | Not Found              | Resource doesn't exist                   |
| 405  | Method Not Allowed     | HTTP method not supported for resource   |
| 406  | Not Acceptable         | Cannot produce acceptable response fmt   |
| 408  | Request Timeout        | Client did not produce request in time   |
| 409  | Conflict               | Duplicate resource, state conflict       |
| 410  | Gone                   | Resource permanently removed             |
| 411  | Length Required        | Content-Length header required           |
| 413  | Payload Too Large      | Request entity exceeds server limits     |
| 414  | URI Too Long           | Request URI exceeds server limits        |
| 415  | Unsupported Media Type | Content-Type not supported               |
| 417  | Expectation Failed     | Expect header requirements not met       |
| 422  | Unprocessable Entity   | Semantic validation error                |
| 426  | Upgrade Required       | Client must switch to different protocol |
| 429  | Too Many Requests      | Rate limit exceeded                      |

### Server Error (5xx)

| Code | Name                       | Usage                                     |
| ---- | -------------------------- | ----------------------------------------- |
| 500  | Internal Server Error      | Unexpected server error                   |
| 501  | Not Implemented            | Server doesn't support the functionality  |
| 502  | Bad Gateway                | Invalid response from upstream server     |
| 503  | Service Unavailable        | Server temporarily overloaded/maintenance |
| 504  | Gateway Timeout            | Upstream server didn't respond in time    |
| 505  | HTTP Version Not Supported | HTTP version in request not supported     |

## XML Object

For XML serialization of schema properties.

| Field       | Type    | Required | Description                       |
| ----------- | ------- | -------- | --------------------------------- |
| `name`      | string  | No       | XML element name                  |
| `namespace` | string  | No       | XML namespace URI                 |
| `prefix`    | string  | No       | XML namespace prefix              |
| `attribute` | boolean | No       | Serialize as attribute vs element |
| `wrapped`   | boolean | No       | Wrap array in container element   |

```yaml
Pet:
  type: object
  properties:
    id:
      type: integer
      xml:
        attribute: true
    name:
      type: string
    tags:
      type: array
      items:
        type: string
      xml:
        wrapped: true
        name: tag
  xml:
    name: pet
```

## Security Scheme Object

| Field              | Type               | Required      | Description                                    |
| ------------------ | ------------------ | ------------- | ---------------------------------------------- |
| `type`             | string             | Yes           | apiKey, http, mutualTLS, oauth2, openIdConnect |
| `description`      | string             | No            | Scheme description                             |
| `name`             | string             | apiKey only   | Header, query, or cookie name                  |
| `in`               | string             | apiKey only   | header, query, or cookie                       |
| `scheme`           | string             | http only     | HTTP auth scheme (bearer, basic, etc.)         |
| `bearerFormat`     | string             | No            | Bearer token format hint (e.g., JWT)           |
| `flows`            | OAuth Flows Object | oauth2 only   | OAuth2 flow configurations                     |
| `openIdConnectUrl` | string             | openIdConnect | OpenID Connect discovery URL                   |

### OAuth Flows Object

| Field               | Type              | Required | Description                  |
| ------------------- | ----------------- | -------- | ---------------------------- |
| `implicit`          | OAuth Flow Object | No       | Implicit flow                |
| `password`          | OAuth Flow Object | No       | Resource owner password flow |
| `clientCredentials` | OAuth Flow Object | No       | Client credentials flow      |
| `authorizationCode` | OAuth Flow Object | No       | Authorization code flow      |

### OAuth Flow Object

| Field              | Type                | Required                                       | Description       |
| ------------------ | ------------------- | ---------------------------------------------- | ----------------- |
| `authorizationUrl` | string              | implicit, authorizationCode                    | Authorization URL |
| `tokenUrl`         | string              | password, clientCredentials, authorizationCode | Token URL         |
| `refreshUrl`       | string              | No                                             | Refresh token URL |
| `scopes`           | Map[string, string] | Yes                                            | Available scopes  |

```yaml
securitySchemes:
  bearerAuth:
    type: http
    scheme: bearer
    bearerFormat: JWT

  apiKey:
    type: apiKey
    in: header
    name: X-API-Key

  oauth2:
    type: oauth2
    flows:
      authorizationCode:
        authorizationUrl: https://auth.example.com/authorize
        tokenUrl: https://auth.example.com/token
        refreshUrl: https://auth.example.com/refresh
        scopes:
          read: Read access
          write: Write access
      clientCredentials:
        tokenUrl: https://auth.example.com/token
        scopes:
          admin: Admin access

  openIdConnect:
    type: openIdConnect
    openIdConnectUrl: https://auth.example.com/.well-known/openid-configuration
```

## Security Requirement Object

Map of security scheme names to required scopes. Empty array means no scopes required.

```yaml
# Global security (applies to all operations)
security:
  - bearerAuth: []

# Per-operation override
paths:
  /public:
    get:
      security: [] # No auth required
  /private:
    get:
      security:
        - bearerAuth: []
        - apiKey: []
  /admin:
    get:
      security:
        - oauth2: [admin]
```

## Encoding Object

For multipart and application/x-www-form-urlencoded content.

| Field           | Type                                           | Required | Description               |
| --------------- | ---------------------------------------------- | -------- | ------------------------- |
| `contentType`   | string                                         | No       | Content-Type for property |
| `headers`       | Map[string, Header Object \| Reference Object] | No       | Additional headers        |
| `style`         | string                                         | No       | Serialization style       |
| `explode`       | boolean                                        | No       | Explode arrays/objects    |
| `allowReserved` | boolean                                        | No       | Allow reserved characters |

```yaml
requestBody:
  content:
    multipart/form-data:
      schema:
        type: object
        properties:
          file:
            type: string
            format: binary
          metadata:
            type: object
      encoding:
        file:
          contentType: application/octet-stream
        metadata:
          contentType: application/json
```

## Contact Object

| Field   | Type         | Required | Description   |
| ------- | ------------ | -------- | ------------- |
| `name`  | string       | No       | Contact name  |
| `url`   | string (URL) | No       | Contact URL   |
| `email` | string       | No       | Contact email |

## License Object

| Field        | Type         | Required | Description                                   |
| ------------ | ------------ | -------- | --------------------------------------------- |
| `name`       | string       | Yes      | License name                                  |
| `identifier` | string       | No       | SPDX identifier (mutually exclusive with url) |
| `url`        | string (URL) | No       | License URL (mutually exclusive w/identifier) |
