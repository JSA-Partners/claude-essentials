# Background Job Story Template

Use for async processes, scheduled tasks, queue workers.

## Template

```markdown
# [Verb] [Process] [Automatically/On Schedule]

## Story

As a System, I want [automated process], so that [operational/business value].

## Acceptance Criteria

- [ ] Job runs [frequency: hourly/daily/on-trigger]
- [ ] Processes [batch size] records per execution
- [ ] Completes within [timeout] duration
- [ ] Logs [start/progress/completion] for observability
- [ ] Handles [failure scenario] with [retry/alert]

## Technical Notes

[Reserved for Technical Reviewer Agent]

## Points: [Reserved for Estimator Agent]
```

## Acceptance Criteria Patterns

### Scheduling

- `Job runs every [interval] via cron`
- `Job triggers when [event] occurs`
- `Job executes during [off-peak window]`

### Processing

- `Processes up to [N] items per batch`
- `Uses cursor-based pagination for large datasets`
- `Skips already-processed records via checkpoint`

### Reliability

- `Retries [N] times with exponential backoff on failure`
- `Sends alert when failure rate exceeds [threshold]`
- `Creates dead letter entry for unrecoverable items`
- `Implements idempotency for safe re-runs`

### Performance

- `Completes batch in under [N] seconds`
- `Uses connection pooling to limit DB connections`
- `Implements graceful shutdown on SIGTERM`

### Observability

- `Emits metrics: items_processed, duration, errors`
- `Logs structured JSON with correlation ID`
- `Updates health check endpoint on heartbeat`
