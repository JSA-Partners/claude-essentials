---
description: Create a GitHub PR with conventional commit title and brief description
argument-hint: [base-branch]
---

# Create Pull Request

Create a PR with conventional commit title and 1-3 sentence description.

## Workflow

### Step 0: Verify Prerequisites

Run in parallel:

- `gh auth status` - verify GitHub CLI authenticated
- `git rev-parse --abbrev-ref HEAD` - get current branch
- Detect base branch: `git remote show origin | grep 'HEAD branch' | cut -d: -f2 | xargs`

**Check:**

- Not on base branch (would have nothing to PR)
- Has commits ahead of base: `git log [base]..HEAD --oneline`
- Branch pushed to remote: `git ls-remote --heads origin [branch]`
- No existing PR: `gh pr list --head [branch] --json number`

If any fail, inform user and stop.

### Step 1: Learn PR Style

Run `gh pr list --state merged --limit 15 --json title,body` to analyze recent PRs.

**Extract:**

- Title format and style
- Description patterns
- Common sections

### Step 2: Analyze Changes

Run in parallel:

- `git log [base]..HEAD --oneline` - commits being merged
- `git diff [base]...HEAD --stat` - files changed

### Step 3: Generate PR

**Title (conventional commit style):**

- Type: feat/fix/docs/refactor/chore/etc.
- Scope if clear from changes
- Imperative, lowercase, no period

**Body (1-3 sentences):**

- What the change does
- Why it matters (if not obvious)

### Step 4: Confirm & Create

Present generated title and body, then **use AskUserQuestion**:

- **"Create PR"** - run `gh pr create`
- **"Create Draft"** - run `gh pr create --draft`
- **"Copy manually"** - print title and body for user to copy into GitHub
- **"Edit"** - user provides feedback, regenerate

Display the PR URL when complete.
