# BDD Comment Patterns

Detailed templates organized by audience perspective. Use appropriate comment syntax for your language.

## Developer (API Consumer) Patterns

### CRUD Operations

**Create (POST):**

```txt
Given: An authorized request with name and email fields
When: A POST request is made to /v1/users
Then: The response status is 201 Created
And: The response contains the user ID and email
And: The user exists in the database
```

**Read (GET):**

```txt
Given: A user exists in the database
When: A GET request is made to /v1/users/{id}
Then: The response status is 200 OK
And: The response contains the user's name and email
```

**Update (PUT/PATCH):**

```txt
Given: A user exists with email "old@example.com"
When: A PUT request is made to /v1/users/{id} with new email
Then: The response status is 200 OK
And: The response contains the updated email
And: The database record reflects the change
```

**Delete:**

```txt
Given: A user exists in the database
When: A DELETE request is made to /v1/users/{id}
Then: The response status is 200 OK
And: The user is soft-deleted in the database
```

### Error Responses

**Validation (400):**

```txt
Given: A request with missing email field
When: A POST request is made to /v1/users
Then: The response status is 400 Bad Request
And: The response contains "email is required"
```

**Authentication (401):**

```txt
Given: A request without valid authorization
When: A GET request is made to /v1/users
Then: The response status is 401 Unauthorized
And: The response contains "Invalid authorization header"
```

**Not Found (404):**

```txt
Given: No user exists with ID "nonexistent"
When: A GET request is made to /v1/users/nonexistent
Then: The response status is 404 Not Found
And: The response contains "User Not Found"
```

**Conflict (409):**

```txt
Given: A user exists with email "taken@example.com"
When: A POST request is made with the same email
Then: The response status is 409 Conflict
And: The response contains "Duplicate Entry"
```

### Service/Repository Layer

```txt
Given: [System state and dependencies]
When: [Method] is called with [parameters]
Then: The result [specific assertion]
And: [Side effect verified]
```

## End-User Patterns

### Form Interactions

**Successful submission:**

```txt
Given: The user is on the registration page
And: The form fields are empty
When: The user fills in valid name and email and clicks Submit
Then: A success message is displayed
And: The user is redirected to the dashboard
```

**Validation feedback:**

```txt
Given: The user is on the registration page
When: The user submits the form with an invalid email format
Then: An error message "Please enter a valid email" is displayed
And: The email field is highlighted in red
And: The form is not submitted
```

### Navigation

```txt
Given: The user is logged in
And: The user is on the home page
When: The user clicks the "Settings" link
Then: The settings page is displayed
And: The user's current preferences are shown
```

### State Changes

```txt
Given: The user has items in their shopping cart
When: The user clicks "Remove" on an item
Then: The item is removed from the cart display
And: The cart total is updated
And: A confirmation toast appears
```

### Authentication Flows

**Login:**

```txt
Given: The user is on the login page
When: The user enters valid credentials and clicks Login
Then: The user is redirected to the dashboard
And: The navigation shows the user's name
```

**Logout:**

```txt
Given: The user is logged in
When: The user clicks the Logout button
Then: The user is redirected to the login page
And: Protected routes are no longer accessible
```

## QA/Tester Patterns

### Boundary Testing

```txt
Given: The input field accepts 1-100 characters
When: Exactly 100 characters are entered
Then: The input is accepted
And: No validation error is shown
```

```txt
Given: The input field accepts 1-100 characters
When: 101 characters are entered
Then: The input is rejected
And: The error "Maximum 100 characters allowed" is displayed
```

### Edge Cases

**Empty state:**

```txt
Given: The user has no items in their order history
When: The user navigates to Order History
Then: An empty state message is displayed
And: A "Start Shopping" call-to-action is shown
```

**Null/undefined handling:**

```txt
Given: A user record exists with optional phone field as null
When: The user profile is requested
Then: The response status is 200 OK
And: The phone field is omitted from the response (not null)
```

### Concurrency

```txt
Given: Two users are editing the same document
When: User A saves changes after User B
Then: User A receives a conflict warning
And: User A is shown the option to merge or overwrite
```

### Data Integrity

```txt
Given: A parent record with 3 child records exists
When: The parent record is deleted
Then: All 3 child records are cascade deleted
And: No orphan records remain in the database
```

### Performance Assertions

```txt
Given: The database contains 10,000 user records
When: A paginated list request is made for page 1
Then: The response is returned within 200ms
And: Only 20 records are included in the response
```

### Security Testing

```txt
Given: User A is authenticated
When: User A attempts to access User B's private data
Then: The response status is 403 Forbidden
And: No data from User B is leaked in the response
```

## Audit/Change Tracking

```txt
Given: A user exists with email "old@example.com"
When: An admin updates the email to "new@example.com"
Then: An audit record is created
And: The audit record contains the admin's user ID
And: The audit record captures old value, new value, and timestamp
```

## Batch Operations

```txt
Given: An authorized request with an array of 5 items
When: A POST request is made to /v1/users/batch
Then: The response status is 201 Created
And: The response contains 5 created resource IDs
And: All 5 resources exist in the database
```
