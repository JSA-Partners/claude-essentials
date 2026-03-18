# BDD Comment Examples

Language-specific examples showing BDD comments in real test code.

## Go

### Table-Driven API Handler Tests

```go
func TestReadAuthor(t *testing.T) {
    tests := map[string]struct {
        // test fields...
    }{
        // Given: An author with no optional fields exists in the database
        // When: An authorized GET request is made to /v1/authors/{slug}
        // Then: The response status is 200 OK
        // And: The response JSON contains the author's slug and name
        // And: The email field is null
        "200OK_ValidAuthor": {
            // ...
        },

        // Given: No author exists with the requested slug
        // When: An authorized GET request is made to /v1/authors/{slug}
        // Then: The response status is 404 Not Found
        // And: The response contains "Author Not Found"
        "404NotFound_InvalidSlug": {
            // ...
        },
    }
    // ...
}
```

### Create Handler with Database Validation

```go
func TestCreateAuthor(t *testing.T) {
    tests := map[string]struct {
        // ...
    }{
        // Given: An authorized request is prepared with only the required name field
        // When: A POST request is made to /v1/authors
        // Then: The response status is 201 Created
        // And: The response includes a Location header with the resource URL
        // And: The response JSON contains the generated slug and name
        // And: The response JSON email field is null
        // And: The author is created in the database with correct name and null email
        "201Created_RequiredFields": {
            // ...
        },

        // Given: An authorized request is prepared with name and optional email
        // When: A POST request is made to /v1/authors
        // Then: The response status is 201 Created
        // And: The author is created in the database with correct name and email
        "201Created_AllFields": {
            // ...
        },
    }
    // ...
}
```

### Delete Handler with Soft Delete

```go
func TestDeleteAuthor(t *testing.T) {
    tests := map[string]struct {
        // ...
    }{
        // Given: An author exists in the database
        // When: An authorized DELETE request is made to /v1/authors/{slug}
        // Then: The response status is 204 No Content
        // And: The author is soft-deleted in the database (DeletedAt field is populated)
        "204NoContent_ValidAuthorSlug": {
            // ...
        },
    }
    // ...
}
```

### Database Constraint Tests

```go
func TestForeignKeyConstraints(t *testing.T) {
    tests := map[string]struct {
        // ...
    }{
        // Given: A parent record with associated child records exists
        // When: The parent record is hard-deleted
        // Then: ErrForeignKeyViolated is returned
        "ForeignKeyViolation_ParentWithChildren": {
            // ...
        },
    }
    // ...
}
```

### Data Loader Idempotency Tests

```go
func TestSeedLoader(t *testing.T) {
    tests := map[string]struct {
        // ...
    }{
        // Given: An empty database with no coverage statuses
        // When: Seed is called with valid JSON and conflict columns
        // Then: All expected coverage status records are created in the database
        // And: Exactly one status has is_default set to true
        "InitialLoadCreatesRecords": {
            // ...
        },

        // Given: Coverage statuses have been loaded into the database
        // And: A coverage status record has been manually modified with a custom description
        // When: Seed is called again with the original JSON
        // Then: The custom description is preserved
        // And: The modified record is not overwritten by the loader
        "PreservesExistingRecordModifications": {
            // ...
        },
    }
    // ...
}
```

## TypeScript

### Jest/Vitest Unit Tests

```typescript
describe("UserService", () => {
  describe("createUser", () => {
    it("creates user with valid data", async () => {
      // Given: A valid user payload with name and email
      // When: createUser is called
      // Then: A user record is created in the database
      // And: The returned user has an assigned ID

      const result = await userService.createUser({
        name: "Test User",
        email: "test@example.com",
      });
      expect(result.id).toBeDefined();
    });

    it("rejects duplicate email", async () => {
      // Given: A user exists with email "taken@example.com"
      // When: createUser is called with the same email
      // Then: A ConflictError is thrown
      // And: No new user is created

      await createTestUser("taken@example.com");
      await expect(
        userService.createUser({ email: "taken@example.com" })
      ).rejects.toThrow(ConflictError);
    });
  });
});
```

### React Component Tests

```typescript
describe("LoginForm", () => {
  it("submits valid credentials", async () => {
    // Given: The login form is rendered
    // When: The user enters valid email and password and clicks Submit
    // Then: The onSubmit handler is called with the credentials
    // And: The submit button shows a loading state

    render(<LoginForm onSubmit={mockSubmit} />);
    await userEvent.type(screen.getByLabelText("Email"), "test@example.com");
    await userEvent.type(screen.getByLabelText("Password"), "password123");
    await userEvent.click(screen.getByRole("button", { name: "Submit" }));

    expect(mockSubmit).toHaveBeenCalledWith({
      email: "test@example.com",
      password: "password123",
    });
  });

  it("displays validation error for invalid email", async () => {
    // Given: The login form is rendered
    // When: The user enters an invalid email format and blurs the field
    // Then: An error message "Please enter a valid email" is displayed
    // And: The email field has an error state

    render(<LoginForm onSubmit={mockSubmit} />);
    await userEvent.type(screen.getByLabelText("Email"), "invalid-email");
    await userEvent.tab();

    expect(screen.getByText("Please enter a valid email")).toBeInTheDocument();
  });
});
```

### E2E Tests (Playwright/Cypress)

```typescript
describe("User Registration", () => {
  it("completes registration flow", async () => {
    // Given: The user is on the registration page
    // When: The user fills in all required fields and submits
    // Then: The user is redirected to the welcome page
    // And: A confirmation email is sent

    await page.goto("/register");
    await page.fill('[name="email"]', "newuser@example.com");
    await page.fill('[name="password"]', "SecurePass123!");
    await page.click('button[type="submit"]');

    await expect(page).toHaveURL("/welcome");
    await expect(emailService.sent).toContainEqual(
      expect.objectContaining({ to: "newuser@example.com" })
    );
  });

  it("shows error for existing email", async () => {
    // Given: A user with email "existing@example.com" already exists
    // When: The user tries to register with the same email
    // Then: An error message "Email already registered" is displayed
    // And: The user remains on the registration page

    await page.goto("/register");
    await page.fill('[name="email"]', "existing@example.com");
    await page.fill('[name="password"]', "SecurePass123!");
    await page.click('button[type="submit"]');

    await expect(page.locator(".error")).toContainText(
      "Email already registered"
    );
    await expect(page).toHaveURL("/register");
  });
});
```

## Python

### pytest Examples

```python
class TestUserService:
    def test_create_user_success(self, db_session):
        # Given: A valid user payload with name and email
        # When: create_user is called
        # Then: A user record is created in the database
        # And: The returned user has an assigned ID

        result = user_service.create_user(
            name="Test User",
            email="test@example.com"
        )
        assert result.id is not None
        assert result.email == "test@example.com"

    def test_create_user_duplicate_email(self, db_session):
        # Given: A user exists with email "taken@example.com"
        # When: create_user is called with the same email
        # Then: A ConflictError is raised
        # And: No new user is created

        create_test_user(email="taken@example.com")
        with pytest.raises(ConflictError):
            user_service.create_user(email="taken@example.com")
```
