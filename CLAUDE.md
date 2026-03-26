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
- Skill references: use relative paths (`skills/foo/SKILL.md`), not absolute paths
- Agent tools: Read, Grep, Glob, Bash, WebSearch, WebFetch (only assign what the agent needs)
- Agent models: opus or haiku
- Size limits: < 300 lines for agents and skills
- No em dashes or en dashes in prose

## Documentation

- `README.md` - Plugin install instructions, component catalog
- `skills/sharpen/reference.md` - Quality checklists for agents and skills
- `/meta` - Update the /sharpen skill with new resources or improvements

## Common Mistakes

- Do not add `Bash` to agent tools unless the agent genuinely needs shell execution
- Do not inline large examples in agents. Move them to skills.
