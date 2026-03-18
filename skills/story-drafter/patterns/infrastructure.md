# Infrastructure Story Template

Use for DevOps, deployment, containerization, and cloud infrastructure stories.

## Template

```markdown
# [Verb] [Infrastructure Component]

## Story

As a [persona], I want [infrastructure change], so that [reliability/scalability/operational value].

## Acceptance Criteria

- [ ] [Component] deploys to [environment] successfully
- [ ] [Health check] confirms service is running
- [ ] [Rollback] procedure documented and tested
- [ ] [Monitoring/alerting] configured for [metrics]
- [ ] [Security requirement] implemented

## Technical Notes

[Reserved for Technical Reviewer Agent]

## Points: [Reserved for Estimator Agent]
```

## Acceptance Criteria Patterns

### Container & Build

- `Dockerfile builds image under [N] MB`
- `Container starts in under [N] seconds`
- `Image tagged with git SHA and semantic version`
- `Multi-stage build separates build and runtime dependencies`
- `Non-root user runs application process`

### Deployment

- `Deploys to [staging|production] via [method: App Platform, Kubernetes, etc.]`
- `Zero-downtime deployment with rolling updates`
- `Health check endpoint returns 200 within [N] seconds of start`
- `Deployment fails fast if health check fails after [N] retries`
- `Supports canary/blue-green deployment strategy`

### Environment & Config

- `Environment variables injected via [secrets manager|env file]`
- `Config differs per environment (dev, staging, prod)`
- `Secrets never stored in repository or image`
- `Feature flags controllable without redeployment`

### Scaling & Resources

- `Auto-scales when CPU > [N]% for [duration]`
- `Resource limits set: [CPU], [memory]`
- `Horizontal scaling from [min] to [max] instances`
- `Database connection pooling limits concurrent connections`

### Rollback & Recovery

- `Previous version deployable within [N] minutes`
- `Database migrations are reversible`
- `Rollback does not lose data written since deployment`
- `Runbook documents manual recovery steps`

### Monitoring & Alerting

- `Logs shipped to [centralized logging system]`
- `Metrics exported: request latency, error rate, saturation`
- `Alert triggers when [condition] for [duration]`
- `Dashboard shows key service health indicators`

### Security

- `TLS terminates at load balancer / ingress`
- `Network policies restrict inter-service communication`
- `Vulnerability scan passes with no critical issues`
- `CORS and security headers configured`
