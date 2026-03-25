# dotclaude

## Tech Stack

- Content: Markdown with YAML frontmatter
- Tooling: pnpm, husky, markdownlint-cli2, commitlint
- Key dirs: agents/, commands/, skills/

## Purpose

- Reusable Claude Code agents, commands, skills, and settings for JSA+Partners
- Installed via symlink or copy into `~/.claude/`

## Development Workflow

```bash
pnpm install        # Install dependencies
pnpm run lint       # Lint all markdown files (auto-fixes)
```

Husky hooks run automatically on commit (markdownlint + commitlint).

## Code Style

- Severity levels: P1, P2, P3 (all agents use this taxonomy)
- Clean output: "No issues found." (all agents use this label)
- File naming: kebab-case for all files
- Skill references: use relative paths (`skills/foo/SKILL.md`), not `~/.claude/` absolute paths
- Agent tools: Read, Grep, Glob, Bash, WebSearch, WebFetch (only assign what the agent needs)
- Agent models: opus or haiku
- Size limits: agents < 200 lines, skills < 300 lines, commands < 150 lines
- No em dashes or en dashes in prose

## Documentation

- `README.md` - Install instructions, component catalog, plugin list
- `CLAUDE_TEMPLATE.md` - Template for CLAUDE.md in other projects
- `skills/sharpen/SKILL.md` - Quality checklists for agents, commands, skills

## Common Mistakes

- Do not use `~/.claude/` absolute paths in cross-references
- Do not add `Bash` to agent tools unless the agent genuinely needs shell execution
- Do not inline large examples in agents. Move them to skills.
