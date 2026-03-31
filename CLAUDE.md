# claude-essentials

## Tech Stack

- Content: Markdown with YAML frontmatter
- Tooling: pnpm, husky, markdownlint-cli2, commitlint
- Key dirs: agents/, skills/

## Purpose

- Claude Code plugin with reusable agents and skills for JSA+Partners
- Distributed via the Claude Code plugin marketplace

## Development Workflow

```bash
pnpm install        # Install dependencies
pnpm run lint       # Lint all markdown files (auto-fixes)
```

Test locally with `claude --plugin-dir .` and `/reload-plugins` after changes.

Husky hooks run automatically on commit (markdownlint + commitlint).

## Code Style

- Severity levels: P1, P2, P3 (all agents use this taxonomy)
- Clean output: "No issues found." (all agents use this label)
- File naming: kebab-case for all files
- Skill file references: use `${CLAUDE_SKILL_DIR}/file.md` for portable paths (resolves correctly in both plugin and project contexts)
- Agent tools: Read, Grep, Glob, Bash, WebSearch, WebFetch (only assign what the agent needs)
- Agent models: opus or haiku
- Size limits: target < 1500 words, max 2500 words (~5K tokens, the compaction re-injection cap)
- No em dashes or en dashes in prose

## Documentation

- `README.md` - Plugin install instructions, component catalog
- `skills/sharpen/reference.md` - Quality checklists for agents and skills
- `/essentials:meta` - Update the /essentials:sharpen skill with new resources or improvements

## Common Mistakes

- Do not add `Bash` to agent tools unless the agent genuinely needs shell execution
- Do not inline large examples in agents. Move them to skills.
