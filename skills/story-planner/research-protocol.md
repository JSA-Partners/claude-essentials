---
name: research-protocol
description: How to research idiomatic patterns in established projects
---

# Research Protocol

When a technical decision requires "research idiomatic approach", follow this protocol. The goal: find what real projects actually do, not what blog posts recommend.

## Core Principle

**Code over opinions.** Search for actual implementations in established repositories. Training knowledge is a starting point for search queries, not a source of truth.

## Language Detection

Read the project's `CLAUDE.md` or equivalent for the tech stack. Adapt research targets accordingly.

## Reference Projects by Language

### Go

| Project | Org | Strengths |
| --- | --- | --- |
| Kubernetes | kubernetes/kubernetes | API patterns, test infrastructure, DI |
| Consul | hashicorp/consul | HTTP handlers, test helpers, middleware |
| Vault | hashicorp/vault | Storage backends, test suites, plugin arch |
| Boundary | hashicorp/boundary | Factory pattern, functional options, repos |
| CockroachDB | cockroachdb/cockroach | SQL layer, store tests, test utilities |
| Grafana | grafana/grafana | Service layer, DI (Wire), store tests |
| Gitea | go-gitea/gitea | ORM patterns, test fixtures, model layer |
| Teleport | gravitational/teleport | gRPC, auth, test patterns |

**Authoritative sources**: Effective Go, Go Wiki (CodeReviewComments, TestComments), Go Proverbs.

### TypeScript

| Project | Org | Strengths |
| --- | --- | --- |
| Next.js | vercel/next.js | App patterns, middleware, testing |
| tRPC | trpc/trpc | API patterns, type safety, testing |
| Prisma | prisma/prisma | ORM patterns, test utilities |
| Remix | remix-run/remix | Loader/action patterns, testing |
| Effect | Effect-TS/effect | Functional patterns, DI, testing |

### Python

| Project | Org | Strengths |
| --- | --- | --- |
| FastAPI | tiangolo/fastapi | DI, test client, async patterns |
| Django | django/django | ORM, test framework, factory pattern |
| SQLAlchemy | sqlalchemy/sqlalchemy | Session management, test patterns |
| httpx | encode/httpx | HTTP client, test patterns |

## Research Agent Prompt Template

Launch one agent per open question. Use this prompt structure:

```txt
Research how established [LANGUAGE] projects handle [SPECIFIC PATTERN].

The question is: [EXACT QUESTION being decided]
The options are: [LIST OPTIONS if applicable]

Search for patterns in these projects:
1. [PROJECT_1] - look at [SPECIFIC AREA]
2. [PROJECT_2] - look at [SPECIFIC AREA]
3. [PROJECT_3] - look at [SPECIFIC AREA]

Specifically look for:
- [CONCRETE THING TO FIND 1]
- [CONCRETE THING TO FIND 2]
- [CONCRETE THING TO FIND 3]

I need concrete code examples from real repos.
Do NOT rely on training knowledge - actually search and fetch from GitHub/web.
Return actual patterns with repo names and file paths.
```

## Research Quality Checklist

Before accepting research results:

- [ ] At least 3 real projects cited with file paths
- [ ] Actual code snippets shown (not paraphrased)
- [ ] Pattern consistency noted (do most projects agree?)
- [ ] Outliers explained (why does project X differ?)
- [ ] Sources listed with URLs

## Synthesis Format

After research completes, synthesize into decisions:

```markdown
### [Topic]

**Finding**: [What N/M projects do, with citations]
**Decision**: [What we'll do and why]
```

## When to Skip Research

Not every decision needs external research. Skip when:

- The codebase already has an established pattern for this exact thing
- The language's official docs/wiki give a clear, unambiguous answer
- The decision is trivial (naming, file placement) with no meaningful alternatives
- The user gave a specific preference (not "research it")

## Anti-Patterns

| Don't | Instead |
| --- | --- |
| Search for blog posts | Search for actual repo implementations |
| Cite one project as definitive | Show consensus across 3+ projects |
| Paraphrase what projects do | Show actual code snippets |
| Research everything | Only research genuine decision points |
| Accept first result | Verify pattern across multiple projects |
| Rely on training knowledge | Actually fetch and read the code |
