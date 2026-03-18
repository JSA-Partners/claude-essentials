# dotclaude

[JSA+Partners'](https://jsapartners.co/) collection of [Claude Code](https://code.claude.com/) agents, commands, skills, and resources we use across our engineering projects.

## Getting Started

| Path                             | Description                                                                           |
| -------------------------------- | ------------------------------------------------------------------------------------- |
| [`agents/`](agents/)             | [Subagents](https://code.claude.com/docs/en/sub-agents) for specialized tasks         |
| [`commands/`](commands/)         | [Slash commands](https://code.claude.com/docs/en/slash-commands) for common workflows |
| [`skills/`](skills/)             | [Agent skills](https://code.claude.com/docs/en/skills) for domain-specific knowledge  |
| [`settings.json`](settings.json) | [Global settings](https://code.claude.com/docs/en/settings) and hooks configuration   |

### Install

Copy or symlink to [`~/.claude/` (user-scoped) or `.claude/` (project-scoped)](https://code.claude.com/docs/en/settings#available-scopes). Symlinking individual files instead of directories lets you combine multiple libraries alongside your own custom agents, commands, and skills. Updates pull in automatically with `git pull`.

```bash
# Copy everything
cp settings.json ~/.claude/
cp -r agents commands skills ~/.claude/

# Or symlink to stay in sync
mkdir -p ~/.claude/agents ~/.claude/commands ~/.claude/skills
ln -sf $(pwd)/settings.json ~/.claude/settings.json
ln -sf $(pwd)/agents/* ~/.claude/agents/
ln -sf $(pwd)/commands/* ~/.claude/commands/
ln -sf $(pwd)/skills/* ~/.claude/skills/
```

## What's Included

### Agents

| Agent | Purpose |
| ----- | ------- |
| `architecture-advisor` | Identifies superior design patterns. Conservative, only flags high-confidence issues. |
| `complexity-reviewer` | Reviews code for YAGNI, AHA, Rule of Three, SRP, DAMP, SOLID, DRY violations. |
| `go-idiom-reviewer` | Reviews Go code for idiomatic patterns, citing Effective Go. |
| `openapi-generator` | Generates OpenAPI 3.1.1 spec sections from handler code. Supports Go, TypeScript, Python. |
| `scope-reviewer` | Detects scope creep by tracing implementations to user stories. |
| `skeptic-reviewer` | Adversarial verification of other agents' findings. Eliminates false positives. |
| `story-drafter` | Converts feature ideas into implementable user stories with acceptance criteria. |
| `story-estimator` | Estimates story points using Fibonacci scale with codebase analysis. |
| `svelte-idiom-reviewer` | Reviews Svelte 5/SvelteKit code for idiomatic patterns. |
| `technical-reviewer` | Reviews code for security vulnerabilities, performance issues, data integrity risks. |

### Commands

| Command | Purpose |
| ------- | ------- |
| `/commit` | Generate conventional commit messages matching project patterns. |
| `/complexity-review` | Review code changes for complexity violations. |
| `/create-story` | Interactive user story creation using agent collaboration. |
| `/decompose-story` | Decompose a user story into dependency-ordered implementation plans. |
| `/go-implement` | Implement a Go user story with idiomatic patterns and quality gates. |
| `/go-review` | Review Go code with parallel specialized agents and adversarial verification. |
| `/meta-optimize` | Update the optimize-claude command with new resources. |
| `/openapi` | Generate or update OpenAPI 3.1.1 specification from codebase analysis. |
| `/optimize-claude` | Systematically improve commands, skills, and agents. |
| `/pr` | Create a GitHub PR with conventional commit title. |
| `/svelte-implement` | Implement a Svelte/SvelteKit user story with idiomatic patterns. |
| `/svelte-review` | Review Svelte/SvelteKit code with parallel agents. |
| `/write-bdd` | Write BDD comments in test files using Given-When-Then format. |

### Skills

| Skill | Purpose |
| ----- | ------- |
| `bdd-comments` | BDD comment patterns and examples for test files. |
| `implementation-workflow` | Shared phased implementation workflow for language-specific commands. |
| `openapi` | OpenAPI 3.1.1 reference, language-specific patterns, and examples. |
| `prompt-engineer` | Quality checklists and structural patterns for Claude Code artifacts. |
| `review-workflow` | Shared parallel review orchestration with adversarial verification. |
| `story-drafter` | Story templates, personas, and acceptance criteria patterns. |
| `story-planner` | Decomposition rules, plan templates, and research protocols. |
| `svelte-testing` | Svelte 5 testing patterns with vitest-browser-svelte and SSR testing. |

## Resources

Guides that shaped how we work with Claude Code:

- [Official Documentation](https://code.claude.com/docs) by Anthropic
- [Building Effective Agents](https://www.anthropic.com/engineering/building-effective-agents) by Anthropic
- [Claude Code Best Practices](https://www.anthropic.com/engineering/claude-code-best-practices) by Anthropic
- [How the Creator of Claude Code Uses It](https://x.com/bcherny/status/2007179832300581177) by Boris Cherny
- [Writing a Good CLAUDE.md](https://www.humanlayer.dev/blog/writing-a-good-claude-md) by Kyle Mistele
- [Claude Code 2.0 Guide](https://sankalp.bearblog.dev/my-experience-with-claude-code-20-and-how-to-get-better-at-using-coding-agents/) by Sankalp Shubham
- [Claude Code Tips](https://github.com/ykdojo/claude-code-tips) by YK Sugi

## Plugins

Plugins enabled in [`settings.json`](settings.json):

- [Astral](https://github.com/astral-sh/claude-code-plugins) by Astral
- [Claude HUD](https://github.com/jarrodwatts/claude-hud) by Jarrod Watts
- [Compound Engineering](https://github.com/EveryInc/compound-engineering-plugin) by Every
- [Gopls LSP](https://github.com/anthropics/claude-plugins-official) by Anthropic
- [Impeccable](https://github.com/pbakaus/impeccable) by Paul Bakaus
- [TypeScript LSP](https://github.com/anthropics/claude-plugins-official) by Anthropic

## License

Distributed under the MIT License. See [LICENSE](LICENSE) for more information.
