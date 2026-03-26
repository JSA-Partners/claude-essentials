---
description: Generate a CLAUDE.md for the current project
allowed-tools: Read, Write, Glob
---

# Init

Generate a project-level CLAUDE.md file based on the codebase.

## Workflow

### Step 1: Check for Existing CLAUDE.md

Look for an existing `CLAUDE.md` in the project root.

**If it exists:** Use AskUserQuestion to confirm overwrite or cancel.

### Step 2: Analyze the Project

Read the project to detect:

- **Language and framework** from package.json, go.mod, pyproject.toml, Cargo.toml, or file extensions
- **Key directories** from the top-level folder structure
- **Build/test commands** from Makefile, package.json scripts, or equivalent
- **Existing docs** in docs/ or similar directories

### Step 3: Generate CLAUDE.md

Generate a CLAUDE.md with these sections, filled in from what you detected. Use concrete values where detected, bracketed placeholders where not. Keep under 60 lines.

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

### Step 4: Write and Confirm

Write the generated CLAUDE.md to the project root. Present a summary of what was detected vs what needs manual filling.

Suggest the user review and customize the placeholders.
