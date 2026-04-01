---
description: Generate a CLAUDE.md for the current project
when_to_use: When the user wants to set up Claude Code for a project or initialize CLAUDE.md
argument-hint: "[path]"
allowed-tools: Read, Write, Glob
---

# Init

Generate a project-level CLAUDE.md file based on the codebase.

## Input: $ARGUMENTS

| Argument  | Mode    | Description                              |
| --------- | ------- | ---------------------------------------- |
| _(empty)_ | Default | Generate CLAUDE.md in the project root   |
| `<path>`  | Targeted | Generate CLAUDE.md at the specified path |

If `$ARGUMENTS` is a directory path, generate CLAUDE.md inside that directory. This is useful for monorepo packages or subdirectories that need their own context.

## Workflow

### Step 1: Check for Existing CLAUDE.md

Look for an existing `CLAUDE.md` at the target location.

**If it exists:** Use AskUserQuestion to confirm:

- **"Overwrite"** -- replace entirely with a fresh generation
- **"Cancel"** -- stop without changes

### Step 2: Detect Project

IMPORTANT: Thorough detection produces a useful CLAUDE.md. Shallow detection produces a generic one.

Scan the project for these signals, organized by category:

**Language and framework:**

- `package.json` (Node/JS/TS -- check `dependencies` for framework)
- `go.mod` (Go -- check module path for framework hints)
- `pyproject.toml`, `setup.py`, `requirements.txt` (Python)
- `Cargo.toml` (Rust), `Gemfile` (Ruby), `build.gradle` (Java/Kotlin)
- File extensions as fallback (`.ts`, `.go`, `.py`, `.rs`)

**Build, test, and lint commands:**

- `Makefile`, `justfile`, `Taskfile.yml`
- `package.json` scripts section
- CI config: `.github/workflows/`, `.gitlab-ci.yml`, `.circleci/`
- Linter configs: `.eslintrc.*`, `prettier.config.*`, `ruff.toml`, `.golangci.yml`

**Project structure:**

- Top-level directories and their apparent purpose
- Monorepo markers: `pnpm-workspace.yaml`, `nx.json`, `turbo.json`, `lerna.json`
- Docker: `Dockerfile`, `docker-compose.yml`
- Test directories: `test/`, `tests/`, `__tests__/`, `*_test.go`

**Existing documentation:**

- `README.md`, `docs/`, `CONTRIBUTING.md`
- Existing `CLAUDE.md` files in subdirectories

### Step 3: Generate Draft

Generate a CLAUDE.md with these sections. Use concrete values where detected, bracketed placeholders where not. Keep under 60 lines.

~~~markdown
# [Project Name]

## Tech Stack

- Language: [e.g., TypeScript, Go, Python]
- Framework: [e.g., Next.js 14, FastAPI, Gin]
- Key dirs: [e.g., src/app/, internal/, pkg/]

## Purpose

- [What the project does in 1-2 lines]
- [Key integrations: Stripe, PostgreSQL, etc.]

## Development Workflow

```bash
# [Detected build/test/lint commands]
```

## Code Style

- [Placeholders for user to fill in]

## Documentation

- [List any existing doc files found]

## Common Mistakes

- [Placeholders for user to fill in]

~~~

### Step 4: Confirm Before Writing

Present the full draft to the user. Clearly mark which values were detected vs which are placeholders.

Use AskUserQuestion:

- **"Write"** -- write the file as-is
- **"Edit"** -- user provides feedback, regenerate the draft
- **"Cancel"** -- stop without writing

Do NOT write the file without user confirmation.

### Step 5: Write

Write the confirmed CLAUDE.md to the target location.

### Step 6: Verify

After writing:

1. Read the file back to confirm it was written correctly
2. Present a summary: what was detected, what needs manual filling
3. Suggest the user review and customize the placeholder sections
4. Explain where this file fits in the CLAUDE.md hierarchy:
   - `~/.claude/CLAUDE.md` -- global preferences (coding style, personal rules)
   - `./CLAUDE.md` -- project-level (architecture, conventions, build commands)
   - `.claude/rules/*.md` -- modular rules (one concern per file)
   - `CLAUDE.local.md` -- private notes (gitignored, not shared with team)
5. Note that CLAUDE.md is re-read every turn, not just at session start. Keep it focused on high-value, non-obvious information. Every line competes for the 40K character budget.

## Anti-Patterns

- Include only non-obvious conventions, gotchas, and workflow commands. Skip information obvious from the code itself (e.g., "this is a TypeScript project" when `tsconfig.json` is present).
- Target a concise 40-60 line document. A focused CLAUDE.md that loads every session is better than a 200-line one that wastes context.
- Do NOT fabricate build commands. If you cannot detect them, use a placeholder. Wrong commands are worse than missing ones.
- Do NOT skip the Code Style and Common Mistakes sections. These are the highest-value sections and should always be present, even as placeholders.

## When Detection Fails

If config files are missing or the project structure is unusual:

1. Fall back to file extension scanning to identify the primary language
2. Check README.md for setup instructions or build commands
3. Use bracketed placeholders for anything you cannot confidently detect
4. Note in the summary which sections need manual attention

Do NOT guess. A CLAUDE.md with honest placeholders is more useful than one with wrong values.
