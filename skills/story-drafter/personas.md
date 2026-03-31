# Personas

Standard personas for user stories. Select based on who performs the action.

## Persona Definitions

| Persona              | Use When                                                  | Example Actions                                       |
| -------------------- | --------------------------------------------------------- | ----------------------------------------------------- |
| **Administrator**    | System config, user management, permissions, ops tasks    | Configure settings, manage roles, view audit logs     |
| **End User**         | Core product interactions, day-to-day usage               | Log in, view dashboard, submit forms, update profile  |
| **Developer**        | API, SDK, CLI, integration, developer tooling             | Use API endpoints, integrate SDK, read docs           |
| **API Consumer**     | Third-party or service-to-service integration             | Receive webhooks, query public API, sync data         |
| **System**           | Automated processes, scheduled jobs, no human trigger     | Process queues, send notifications, run migrations    |
| **Operator**         | Monitoring, incident response, infrastructure management  | View metrics, respond to alerts, scale services       |
| **Content Author**   | Content creation, editing, publishing workflows           | Create articles, publish posts, moderate comments     |
| **Reviewer/Approver**| Review workflows, approval gates, quality checks          | Approve submissions, review changes, sign off         |

## Selection Logic

```txt
WHO performs the action?
    |
    +-> Internal staff managing system/infra? --> Administrator or Operator
    |
    +-> Internal staff creating/managing content? --> Content Author
    |
    +-> Someone approving or reviewing work? --> Reviewer/Approver
    |
    +-> Developer using our API/SDK/CLI? --> Developer or API Consumer
    |
    +-> Automated process, no human trigger? --> System
    |
    +-> Person using the product? --> End User
```

## Custom Personas

If no standard persona fits, create a specific one:

- Use role-based naming: "Billing Manager", "Support Agent", "Team Lead"
- Avoid generic terms: "stakeholder", "customer" (too vague)
- Include context when relevant: "Enterprise User" vs "Free Tier User", "Mobile User" vs "Desktop User"

Not every project uses every persona. Pick the ones that map to real roles in the system being built.

## Persona in Context

The persona determines:

1. **Acceptance criteria focus** - What matters to this persona
2. **Authorization scope** - What permissions they have
3. **Error messaging** - How to communicate failures
4. **Success metrics** - How to measure value delivered
