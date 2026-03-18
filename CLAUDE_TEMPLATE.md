# [Project Name]

<!-- Keep this file <60 lines. Add details to separate docs and reference them below. -->

## Tech Stack

- Language: [e.g., TypeScript, Go, Python]
- Framework: [e.g., Next.js 14, FastAPI, Gin]
- Key dirs: [e.g., src/app/, internal/, pkg/]

## Purpose

- [What the project does in 1-2 lines]
- [Key integrations: Stripe, PostgreSQL, etc.]

## Development Workflow

**Use `make` for all commands.**

```bash
# 1. Vet/typecheck
make vet

# 2. Test
make test RUN="TestName"         # Single test
make test                        # All tests

# 3. Lint
make lint FILE="path/to/file"   # Single file
make lint                        # All files

# 4. Before PR
make check                       # Runs vet, lint, test
```

## Code Style

- [e.g., Use early returns, no else after return]
- [e.g., Errors: wrap with context, don't log and return]
- [e.g., Tests: table-driven, use stdlib]

## Documentation

<!-- Claude reads these when relevant -->

- `docs/architecture.md` - System design
- `docs/testing.md` - Test patterns
- `docs/api.md` - API conventions

## Common Mistakes

<!-- Add entries when Claude does something wrong -->

- [e.g., Don't use X library, use Y instead]
- [e.g., Always run migrations with --dry-run first]
