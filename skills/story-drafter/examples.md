# Story Examples

Real examples demonstrating proper story format by type.

## API Endpoint Example

**Input**: "Add ability to delete resources"

**Output**:

```markdown
# Delete Resource via API

## Story

As a System Administrator, I want to delete a resource by ID, so that I can remove outdated or incorrect entries from the system.

## Acceptance Criteria

- [ ] DELETE /v1/resources/{id} returns 204 on success
- [ ] Returns 404 when resource does not exist
- [ ] Returns 403 when user lacks admin role
- [ ] Soft deletes by setting deleted_at timestamp
- [ ] Returns 409 when resource has active references

## Technical Notes

[Reserved for Technical Reviewer Agent]

## Points: [Reserved for Estimator Agent]
```

## UI Feature Example

**Input**: "Add a button to export data to CSV"

**Output**:

```markdown
# Add CSV Export Button to Dashboard

## Story

As a Content Manager, I want to export dashboard data to CSV, so that I can analyze metrics in spreadsheet tools.

## Acceptance Criteria

- [ ] Export button appears in dashboard header for managers
- [ ] Clicking button downloads CSV with current filters applied
- [ ] Loading spinner displays during export generation
- [ ] Success toast confirms download started
- [ ] Error message displays if export fails with retry option

## Technical Notes

[Reserved for Technical Reviewer Agent]

## Points: [Reserved for Estimator Agent]
```

## Background Job Example

**Input**: "Send daily digest emails"

**Output**:

```markdown
# Send Daily Digest Email Notifications

## Story

As a System, I want to send daily digest emails, so that users receive consolidated updates without notification fatigue.

## Acceptance Criteria

- [ ] Job runs daily at 9:00 AM UTC
- [ ] Processes users in batches of 100
- [ ] Skips users with no new activity
- [ ] Completes within 30 minutes for 10K users
- [ ] Retries failed sends 3 times with backoff

## Technical Notes

[Reserved for Technical Reviewer Agent]

## Points: [Reserved for Estimator Agent]
```

## Integration Example

**Input**: "Sync customer data from Salesforce"

**Output**:

```markdown
# Sync Customer Data from Salesforce

## Story

As a System Administrator, I want customer data to sync from Salesforce, so that our system has up-to-date customer information.

## Acceptance Criteria

- [ ] OAuth connection to Salesforce established via admin UI
- [ ] Customer records sync every 15 minutes
- [ ] Transforms Salesforce Contact to internal Customer schema
- [ ] Alerts when sync fails 3 consecutive times
- [ ] Provides manual re-sync button for admins

## Technical Notes

[Reserved for Technical Reviewer Agent]

## Points: [Reserved for Estimator Agent]
```

## CLI Command Example

**Input**: "Add ability to export data from the CLI"

**Output**:

```markdown
# Export Data via CLI

## Story

As a Developer, I want to export data to a file via CLI, so that I can automate data extraction in scripts and pipelines.

## Acceptance Criteria

- [ ] `mycli export [resource]` outputs data to stdout
- [ ] `--output / -o [file]` writes result to specified file
- [ ] `--format / -f [json|csv]` controls output format (default: json)
- [ ] Returns exit code 0 on success, 1 on invalid args, 2 on API error
- [ ] `--help` displays usage with examples
- [ ] Progress indicator shown for exports > 1 second

## Technical Notes

[Reserved for Technical Reviewer Agent]

## Points: [Reserved for Estimator Agent]
```

## Infrastructure Example

**Input**: "Set up auto-scaling for the API"

**Output**:

```markdown
# Configure Auto-Scaling for API Service

## Story

As a System Administrator, I want the API to auto-scale based on load, so that the system handles traffic spikes without manual intervention.

## Acceptance Criteria

- [ ] Auto-scales when CPU > 70% for 2 minutes
- [ ] Scales from 2 to 10 instances based on demand
- [ ] New instances pass health check within 30 seconds
- [ ] Scale-down waits 5 minutes after load decreases
- [ ] Alert triggers when max instances reached
- [ ] Scaling events logged for audit

## Technical Notes

[Reserved for Technical Reviewer Agent]

## Points: [Reserved for Estimator Agent]
```

## Decomposition Example

**Input**: "Build complete auth system"

**Response** (not a story):

```txt
This requires multiple stories. I identified:

1. User registration endpoint
2. Login/logout functionality
3. Password reset flow
4. Token refresh mechanism
5. Role-based permissions

Which component should I draft first?
```

## Clarification Example

**Input**: "Fix the thing"

**Response** (not a story):

```txt
I need more information to draft a story:

1. What specific issue or feature?
2. What is the expected outcome?
3. Who is affected?
```
