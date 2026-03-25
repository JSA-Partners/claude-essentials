---
description: Update the /sharpen command with new resources or improvements
argument-hint: <url-or-change-description>
---

# Meta

Update the `/sharpen` command based on new resources or requested changes.

## Input: $ARGUMENTS

If `$ARGUMENTS` is empty, use `AskUserQuestion` to ask: "What would you like to improve? Provide a URL to a resource or describe a change."

**Required**: Either a URL to a resource or a description of a change to make.

Examples:

- `/meta https://addyosmani.com/blog/ai-coding-workflow/`
- `/meta Add a phase for checking hook compatibility`

---

## Skill Reference

Load for comprehensive quality criteria:

- `skills/sharpen/SKILL.md` - Quality checklists, anti-patterns, scoring
- `skills/sharpen/patterns.md` - Structural templates

---

## Execution

### If URL provided

1. **Fetch the resource** using WebFetch
2. **Extract relevant insights** for Claude Code optimization:
   - Prompt engineering patterns
   - Agentic workflow best practices
   - Command/skill design principles
   - Quality gates or verification steps
3. **Identify where insights apply** in:
   - `commands/sharpen.md` (main command)
   - `skills/sharpen/SKILL.md` (quality checklists)
   - `skills/sharpen/patterns.md` (templates)
   - Other commands/skills/agents if the pattern applies broadly
4. **Present proposed changes** with rationale
5. **Apply changes** after user approval

### If change description provided

1. **Read current files** to understand context
2. **Draft the change** aligned with existing style
3. **Present proposed change** with rationale
4. **Apply change** after user approval

---

## Error Handling

- **WebFetch fails**: Report error, ask if user wants to provide content manually or try different URL
- **Invalid URL format**: Ask for corrected URL or switch to change description mode
- **No relevant insights found**: Report honestly, ask if user wants to search for related resources

---

## Output Format

```markdown
## Source Analysis

**Input**: [URL or change description]
**Relevant insights**: [2-3 bullet points]

## Proposed Changes

### File: [path]

**Section**: [where]
**Change**: [what]
**Rationale**: [why this improves sharpen]

## Apply?
```

Use AskUserQuestion to confirm before making changes.

---

## Meta-Improvement Relationship

This command creates a **self-improving loop**:

```markdown
New insights → Update sharpen skill → Better checklists →
Better /sharpen evaluations → Higher quality artifacts
```

**Scope of influence**:

- Changes to `SKILL.md` checklists affect how ALL future artifacts are scored
- Changes to `patterns.md` templates affect how ALL future artifacts are structured
- Changes to `sharpen.md` affect the optimization workflow itself

**Implication**: Be thoughtful about skill changes—they have system-wide effects.

---

## Verification Phase

After applying changes:

1. **Re-read modified files** to confirm changes applied correctly
2. **Score against checklists** from sharpen skill
3. **Check for anti-patterns** introduced by the changes
4. **If sharpen skill was modified**: Verify new patterns/checklists are consistent with existing ones
5. **Present verification summary**:

```markdown
## Verification

**Files modified**: [list]
**Post-change scores**: [scores]
**Anti-patterns check**: [PASS/issues found]
**Skill impact**: [if skill modified, note system-wide effects]
```

If issues found, propose fixes before completing.
