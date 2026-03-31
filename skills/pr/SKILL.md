---
description: Create a GitHub PR with conventional commit title and brief description
when_to_use: When the user asks to create a PR, open a pull request, or submit changes for review
argument-hint: [base-branch]
disable-model-invocation: true
allowed-tools: Bash, Read
---

# Create Pull Request

Create a PR with conventional commit title and 1-3 sentence description.

## Input: $ARGUMENTS

| Argument   | Mode       | Description                                        |
| ---------- | ---------- | -------------------------------------------------- |
| _(empty)_  | Auto       | Detect base branch from remote HEAD                |
| `<branch>` | Explicit   | Use provided branch as PR base                     |

## Workflow

### Step 0: Verify Prerequisites

**Determine base branch:**

- If `$ARGUMENTS` is provided and non-empty, use it as the base branch
- Otherwise, detect it: try `git symbolic-ref refs/remotes/origin/HEAD` first (local, fast), fall back to `git remote show origin | grep 'HEAD branch'` (network) if the ref is missing

Run in parallel:

- `gh auth status` -- verify GitHub CLI authenticated
- `git rev-parse --abbrev-ref HEAD` -- get current branch

**Check (all must pass or stop with explanation):**

- Not on base branch -- nothing to PR from the base itself
- Has commits ahead of base: `git log [base]..HEAD --oneline`
- Branch pushed and up to date: `git push --dry-run 2>&1` should report "Everything up-to-date"
- No existing PR: `gh pr list --head [branch] --json number`

### Step 1: Learn PR Style

IMPORTANT: Getting the style wrong produces PRs that look out of place in the project.

Run in parallel:

- `gh pr list --state merged --limit 15 --json title,body` -- analyze recent PRs
- Check CLAUDE.md for PR conventions or templates

**Extract:**

- Title format and style (conventional commits, freeform, etc.)
- Description patterns (sections, length, what's included)
- Any required sections or templates

### Step 2: Analyze Changes

Run in parallel:

- `git log [base]..HEAD --oneline` -- commits being merged
- `git diff [base]...HEAD --stat` -- files changed

### Step 3: Generate PR

**Title (conventional commit style unless project uses a different convention):**

- Type: feat/fix/docs/refactor/chore/etc.
- Scope if clear from changes
- Imperative, lowercase, no period

**Body (1-3 sentences):**

- What the change does
- Why it matters (if not obvious)

### Step 4: Confirm & Create

Present generated title and body, then **use AskUserQuestion**:

- **"Create PR"** -- run `gh pr create`
- **"Create Draft"** -- run `gh pr create --draft`
- **"Copy manually"** -- print title and body for user to copy into GitHub
- **"Edit"** -- user provides feedback, regenerate

Display the PR URL when complete.

### Step 5: Handle Failures

If `gh pr create` fails:

1. Read the error output carefully
2. Diagnose the cause (authentication expired, branch not pushed, merge conflicts, missing required fields)
3. Fix the issue or inform the user what needs to change
4. Retry once after fixing

Do NOT retry with the same arguments. Do NOT skip required PR template fields.

## Anti-Patterns

- Do NOT write multi-paragraph descriptions for simple changes. Body is for context, not a changelog.
- Do NOT include implementation details (file names, function names) in the body -- reviewers see that in the diff.
- Do NOT guess scope when unsure -- omit it. `feat: add login` beats `feat(auth): add login` when scope is ambiguous.
- Do NOT create PRs with "WIP" titles -- use `--draft` instead.
