---
description: >
  Inject behavioral plays and execution protocols.
  Run without args to see all plays, with a play name to activate it.
argument-hint: "[taste | diagnose | scope | reorient | preflight | defer]"
allowed-tools: Read, Grep, Glob, Bash
---

# Playbook

Plays are attention anchors. Single words that decompress into behavioral specs or execution protocols.

## Quick Reference

| Play | Type | Expands to |
|------|------|-----------|
| **taste** | steering | Idiomatic, researched, no naive answers |
| **diagnose** | steering | Stop retrying, root cause first, 3 hypotheses |
| **scope** | steering | Turn vague quality words into 3 testable bullets |
| **reorient** | execution | Re-entry after a gap: git log, PRs, plans, status |
| **preflight** | execution | Local CI checks before pushing, project-aware |
| **defer** | execution | Track skipped review items visibly |

## Modes

### No args (`/playbook`)

Display the Quick Reference table and list each play with its description. Let the user pick by running `/playbook [play]`.

### With arg (`/playbook [play]`)

Activate that play. Steering plays inject behavior going forward. Execution plays run immediately.

---

## Steering Plays

### taste

Expert-depth mode. Do not give the naive first-pass answer.

- Research before answering. Check docs, conventions, community patterns.
- Be idiomatic: Effective Go, Pythonic, SvelteKit conventions, CLIG.dev for CLIs.
- Naming must match existing codebase. Grep before inventing.
- Reference guides explicitly. Cite the source.
- No hacks. No workarounds. If the right way exists, use it.
- When multiple valid approaches exist, pick one and justify. No menus.

Confirm: "taste active. Expert-depth, no naive answers."

### diagnose

Stop retrying. Switch to root cause analysis.

- State what was tried and what failed.
- Read error output, check logs, trace execution path.
- Propose 3 hypotheses ranked by likelihood before any fix.
- Present to user, get alignment on which to pursue.
- If 3rd attempt fails: recommend filing issue, pinning working version, or deferring. Do not attempt a 4th.

Confirm: "diagnose active. Next failure triggers root cause analysis."

### scope

Turn vague quality words into testable acceptance criteria.

- When user says "robust," "world-class," "production-ready," or similar: pause.
- Produce 3 testable bullets that define "done" using domain context.
- Present for confirmation before starting implementation.
- Reference these bullets when delivering.

Confirm: "scope active. Vague quality terms will be decomposed."

---

## Execution Plays

### reorient

Re-entry after a gap. Run in parallel and present a status summary:

1. `git log --oneline -15` for recent commits
2. `git status` for uncommitted work
3. `git stash list` for stashed work
4. `gh pr list --author @me 2>/dev/null` for open PRs
5. Find plans: `ls docs/plans/*.md 2>/dev/null`
6. Count TODOs: `grep -rl "TODO\|FIXME" --include="*.go" --include="*.py" --include="*.svelte" --include="*.ts" . 2>/dev/null`

Present as a status summary with last activity date, uncommitted work, open PRs, active plans, and pending TODOs. Then ask: "What do you want to pick up?"

### preflight

Local CI checks before pushing. Auto-detect project type and run matching checks:

- `go.mod` exists: `go vet ./... && go test ./... -count=1`
- `pyproject.toml` exists: `uv run ruff check . && uv run mypy . && uv run pytest`
- `svelte.config.js` exists: `pnpm run check && pnpm run lint`

If multiple apply, run all. Report pass/fail per check. If anything fails, state what failed and stop.

### defer

When the user selectively acts on review findings (e.g., "do 2 and 8 only"):

1. Identify the skipped items by number and description.
2. For each skipped item, add a `// TODO(deferred): [description] - [date]` comment at the relevant code location.
3. If the item is cross-cutting (not tied to one location), create a GitHub issue instead.
4. Confirm what was deferred and where it was tracked.
