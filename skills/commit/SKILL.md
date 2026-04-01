---
description: Generate a commit message matching the project's conventions, defaulting to conventional commits
when_to_use: When the user asks to commit, create a commit, or save changes to git
argument-hint: "[files to stage]"
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

IMPORTANT: This step determines correctness. Get the convention wrong and hooks will reject the commit.

Run in parallel:

- `git log --oneline -20` -- analyze recent commits for patterns
- `git diff --cached` -- understand the staged changes
- Check for commitlint config (`.commitlintrc.*`, `commitlint.config.*`, or `commitlint` key in `package.json`)
- Check CLAUDE.md for commit conventions

**Determine convention (in priority order):**

1. **Commitlint config** -- if present, this is the enforced standard. Extract allowed types, scopes, and rules.
2. **CLAUDE.md instructions** -- project-specific overrides
3. **Git history** -- if the majority of recent commits follow a recognizable convention, match it
4. **Default** -- if no clear convention exists, use conventional commits (see Quick Reference below)

**Extract from history:**

- Commit message convention in use (conventional commits, Angular, freeform, etc.)
- Scopes used (e.g., api, auth, db, ui)
- Description style (length, wording patterns)
- Whether bodies are commonly used
- Any custom types beyond standard ones

### Step 3: Generate Message

**Auto-detect scope** from staged file paths (when using conventional commits or scoped conventions):

- Map directory paths to logical scopes (e.g., `internal/auth/*` to `auth`, `src/api/*` to `api`)
- Multiple areas: most specific common ancestor, or omit

**Generate message matching the detected convention:**

- Use the convention identified in Step 2
- Match the style, casing, and structure observed in git history
- Skip body unless change is complex or non-obvious
- Include footer only for breaking changes or issue refs

IMPORTANT: **Validate the message** against the detected convention before presenting it. For conventional commits, validate:

- Type: `feat|fix|docs|style|refactor|perf|test|build|ci|chore`
- Description: imperative, lowercase, no period, <50 chars
- Breaking changes: exclamation mark suffix or `BREAKING CHANGE:` footer

### Step 4: Confirm & Commit

CRITICAL: **Never run `git commit` without explicit user approval.** Present the generated message, then **use AskUserQuestion tool**:

- **"Commit"** - Execute the commit
- **"Edit"** - User provides feedback via "Other" option, regenerate message

Do NOT proceed to `git commit` until the user selects "Commit". Skipping confirmation means the user loses the chance to catch mistakes.

**For multiline messages** (with body/footer), use HEREDOC:

```bash
git commit -m "$(cat <<'EOF'
feat(scope): description

Body text here.

BREAKING CHANGE: details
EOF
)"
```

### Step 5: Handle Failures

If the commit fails (e.g., hook rejection, commitlint error):

1. Read the error output carefully
2. Diagnose the specific rule violation (wrong type, bad scope, description too long, etc.)
3. Fix the message to satisfy the rule
4. Retry the commit once

Do NOT retry with the same message. Do NOT bypass hooks with `--no-verify`.

## Anti-Patterns

- Do NOT write multi-paragraph bodies for trivial changes. Body is for "why", not "what".
- Do NOT guess scope when unsure -- omit it instead. `feat: add login` beats `feat(auth): add login` when the scope is ambiguous.
- Do NOT add trailers (Co-Authored-By, Signed-off-by) unless the project convention requires them.

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
