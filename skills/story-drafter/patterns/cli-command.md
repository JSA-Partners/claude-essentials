# CLI Command Story Template

Use for command-line interface stories involving arguments, flags, terminal input/output.

## Template

```markdown
# [Verb] [Action] via CLI

## Story

As a [persona], I want [CLI command action], so that [automation/scripting value].

## Acceptance Criteria

- [ ] `command [subcommand]` executes [primary action]
- [ ] `--flag` / `-f` enables [behavior]
- [ ] Outputs [format: table/JSON/plain] to stdout
- [ ] Returns exit code 0 on success, non-zero on failure
- [ ] `--help` displays usage information

## Technical Notes

[Reserved for Technical Reviewer Agent]

## Points: [Reserved for Estimator Agent]
```

## Acceptance Criteria Patterns

### Arguments & Flags

- `Accepts required positional argument [name]`
- `--output / -o [file] writes result to file`
- `--format / -f [json|table|csv] controls output format`
- `--quiet / -q suppresses non-essential output`
- `--verbose / -v increases logging detail`
- `--dry-run shows what would happen without executing`

### Input Handling

- `Reads from stdin when no file argument provided`
- `Accepts multiple values via repeated flag: --id 1 --id 2`
- `Supports glob patterns for file arguments`
- `Validates input format before processing`

### Output & Exit Codes

- `Outputs structured JSON when --format json specified`
- `Displays progress for operations > 1 second`
- `Returns exit code 0 on success`
- `Returns exit code 1 on user error (invalid args)`
- `Returns exit code 2 on system error (network, permissions)`
- `Writes errors to stderr, results to stdout`

### Help & Documentation

- `--help displays usage, arguments, and examples`
- `--version displays current version`
- `Provides contextual error messages with suggested fixes`
- `Shows example commands in help output`

### Environment & Config

- `Reads default values from [ENV_VAR] environment variable`
- `Loads config from ~/.config/[app]/config.yaml if present`
- `Command-line flags override config file values`
