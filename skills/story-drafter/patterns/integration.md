# Integration Story Template

Use for third-party API integrations, webhooks, external services.

## Template

```markdown
# [Verb] [External Service] [Integration]

## Story

As a [persona], I want [integration capability], so that [data sync/automation value].

## Acceptance Criteria

- [ ] [Outbound/Inbound] connection to [service] established
- [ ] [Data type] syncs [direction] with [frequency]
- [ ] [Auth mechanism] credentials stored securely
- [ ] [Failure scenario] triggers [fallback/retry/alert]
- [ ] [Rate limit] respected with [throttling strategy]

## Technical Notes

[Reserved for Technical Reviewer Agent]

## Points: [Reserved for Estimator Agent]
```

## Acceptance Criteria Patterns

### Connection

- `OAuth flow completes with [provider] successfully`
- `API key validated on first request`
- `Webhook signature verified before processing`

### Data Flow

- `Syncs [entity] from [source] to [destination] every [interval]`
- `Transforms [external format] to internal schema`
- `Deduplicates based on [unique identifier]`

### Error Handling

- `Retries with backoff when rate limited (429)`
- `Queues failed requests for later retry`
- `Alerts when [service] is unreachable for [duration]`
- `Falls back to [cached/stale data] during outage`

### Security

- `Stores credentials in [secrets manager], not database`
- `Rotates tokens before expiration`
- `Logs integration calls without sensitive data`

### Monitoring

- `Tracks sync latency and success rate`
- `Alerts when sync fails [N] consecutive times`
- `Provides manual re-sync capability for admins`
