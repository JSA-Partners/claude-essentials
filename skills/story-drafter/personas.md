# Personas

Standard personas for user stories. Select based on who performs the action.

## Persona Definitions

| Persona                   | Use When                                         | Example Actions                                    |
| ------------------------- | ------------------------------------------------ | -------------------------------------------------- |
| **System Administrator**  | System config, data management, admin operations | Delete users, configure settings, manage roles     |
| **Content Manager**       | Content CRUD, curation, publishing workflows     | Create articles, publish posts, moderate comments  |
| **Developer**             | API, SDK, integration, technical tooling         | Use API endpoints, integrate SDK, access docs      |
| **External API Consumer** | Third-party integration, webhooks                | Receive webhooks, query public API, sync data      |
| **System**                | Automated processes, background jobs             | Schedule tasks, process queues, send notifications |
| **User**                  | End-user facing features, UI interactions        | Log in, view dashboard, submit forms               |

## Selection Logic

```txt
WHO performs the action?
    |
    +-> Internal staff managing system? --> System Administrator
    |
    +-> Internal staff managing content? --> Content Manager
    |
    +-> Developer using our API? --> Developer / External API Consumer
    |
    +-> Automated process, no human? --> System
    |
    +-> End user of the product? --> User
```

## Custom Personas

If no standard persona fits, create a specific one:

- Use role-based naming: "Billing Manager", "Support Agent", "Team Lead"
- Avoid generic terms: "stakeholder", "customer" (too vague)
- Include context: "Enterprise User" vs "Free Tier User" when relevant

## Persona in Context

The persona determines:

1. **Acceptance criteria focus** - What matters to this persona
2. **Authorization scope** - What permissions they have
3. **Error messaging** - How to communicate failures
4. **Success metrics** - How to measure value delivered
