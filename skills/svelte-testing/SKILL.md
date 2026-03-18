---
name: svelte-testing
description: Svelte 5 testing patterns with vitest-browser-svelte, SSR testing, and client-server alignment
---

# Svelte 5 Testing Patterns

## Testing Decision Tree

- Test framework: Use vitest with vitest-browser-svelte, NOT @testing-library/svelte
- Test file naming: `component-name.svelte.test.ts` (kebab-case)
- SSR validation: Create `.ssr.test.ts` for server-rendered components
- Test colocation: Place tests alongside components, not in separate `__tests__` folder
- Mocking strategy: Mock only external services (APIs, databases), NOT FormData/Request
- Component testing: Test in real browser environment, not jsdom
- Server testing: Test with real Request objects, verify client-server alignment
- Test IDs: Use kebab-case: `data-testid="submit-button"`

## Client-Server Alignment

Tests should verify client-server alignment to prevent production mismatches:

- Shared validation logic: Use same validation on client and server
- FormData handling: Test with real FormData objects, not mocks
- Request objects: Test with real Request objects for API routes
- TypeScript contracts: Use shared types between client and server

## Detection Patterns

```txt
# Testing anti-patterns (SHOULD)
"@testing-library/svelte"           # Should use vitest-browser-svelte
"jest"                               # Should use vitest
"\.test\.ts$"                        # Missing .svelte in test file name for component tests
```

## Anti-Patterns by Severity

### SHOULD Fix

- **@testing-library/svelte**: Use `vitest-browser-svelte` for Svelte 5 testing
- **Heavy mocking in tests**: Mock only external services, use real FormData/Request
- **Missing SSR tests**: Server-rendered components need `.ssr.test.ts` files
- **Non-colocated tests**: Test files should be alongside components

### COULD Improve

- **Test naming**: Not using kebab-case for test files and test IDs
- **Missing test coverage**: Complex components without accessibility tests

## References

- [Sveltest](https://github.com/spences10/sveltest) - Reference project for Svelte 5 testing patterns
- [vitest-browser-svelte](https://www.npmjs.com/package/vitest-browser-svelte) - Svelte 5 testing library
