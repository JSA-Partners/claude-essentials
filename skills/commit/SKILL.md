---
description: Generate a commit message matching the project's conventions, defaulting to conventional commits
disable-model-invocation: true
allowed-tools: Bash, Read
---

# Commit Message Generator

Generate commit messages that match the project's established patterns.

## Workflow

### Step 1: Check Staging

Run `git status --porcelain` to check working directory state.

**If nothing staged but changes exist:**

- Analyze changed files and group by directory/module
- If cohesive (same feature/area): suggest `git add .`
- If multiple logical groups: suggest splitting into separate commits with specific `git add` commands
- **Use AskUserQuestion tool** to confirm staging with options:
  - "Stage all" - run `git add .`
  - "Stage selected" - show suggested groupings and let user pick

**If nothing staged and no changes:** Inform user there's nothing to commit.

### Step 2: Learn Project Style

Run in parallel:

- `git log --oneline -20` - analyze recent commits for patterns
- `git diff --cached` - understand the staged changes

**Extract from history:**

- Commit message convention in use (conventional commits, Angular, freeform, etc.)
- Scopes used (e.g., api, auth, db, ui)
- Description style (length, wording patterns)
- Whether bodies are commonly used
- Any custom types beyond standard ones

**Determine convention:**

- If the majority of recent commits follow a recognizable convention, match it
- If no clear convention exists or the history is sparse, default to conventional commits (see Quick Reference below)

### Step 3: Generate Message

**Auto-detect scope** from staged file paths (when using conventional commits or scoped conventions):

- Map directory paths to logical scopes (e.g., `internal/auth/*` to `auth`, `src/api/*` to `api`)
- Multiple areas: most specific common ancestor, or omit

**Generate message matching the detected convention:**

- Use the convention identified in Step 2
- Match the style, casing, and structure observed in git history
- Skip body unless change is complex or non-obvious
- Include footer only for breaking changes or issue refs

**Validate the message** against the detected convention. For conventional commits, validate:

- Type: `feat|fix|docs|style|refactor|perf|test|build|ci|chore`
- Description: imperative, lowercase, no period, <50 chars
- Breaking changes: exclamation mark suffix or `BREAKING CHANGE:` footer

### Step 4: Confirm & Commit

Present the generated message, then **use AskUserQuestion tool**:

- **"Commit"** - Execute the commit
- **"Edit"** - User provides feedback via "Other" option, regenerate message

**For multiline messages** (with body/footer), use HEREDOC:

```bash
git commit -m "$(cat <<'EOF'
feat(scope): description

Body text here.

BREAKING CHANGE: details
EOF
)"
```

## Quick Reference (Conventional Commits Default)

```txt
<type>[scope][!]: <description>

[optional body]

[optional footer]
```

**Types:** feat, fix, docs, style, refactor, perf, test, build, ci, chore

**Rules:**

- Description: imperative, lowercase, no period
- Body: only when "why" isn't obvious from diff
- Footer: `BREAKING CHANGE:` or issue refs (`Fixes #123`)

This format is the default. If the project's git history shows a different convention, follow that instead.
