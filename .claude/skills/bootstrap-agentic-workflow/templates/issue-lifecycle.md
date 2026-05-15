# Issue Lifecycle Template

This template generates `docs/agents/issue-lifecycle.md`.

## Generation Rules

1. Translate to `DOMINANT_LANGUAGE` if needed.
2. Adapt label list based on whether GitHub Issues is the tracker.
3. Keep technical terms in English.

## Template

```markdown
# Issue Lifecycle

## Labels

Use these labels to track which phase an issue is in:

| Label | Meaning | Color |
|-------|---------|-------|
| `phase-0` | Safety/environment setup | gray |
| `phase-1` | Requirement alignment | blue |
| `phase-2` | PRD/task breakdown | purple |
| `phase-3` | Architecture/interface design | yellow |
| `phase-4` | Implementation (TDD) | green |
| `phase-5` | Human acceptance | orange |
| `bug` | Bug fix needed | red |
| `refactor` | Architecture improvement | cyan |
| `vertical-slice` | A complete small feature | bright green |
| `blocked` | Waiting on another task | dark red |

## Vertical Slice Requirement

Every implementation issue must be a vertical slice:

- It delivers **one small, runnable piece of value**.
- It can be implemented and tested **independently**.
- It is **NOT** split by layer (no "frontend-only" or "backend-only" issues for cross-cutting features).
- It cuts through all relevant layers to deliver working functionality.

### Examples

**Bad (horizontal):** "Implement all enemy types"
**Good (vertical):** "Implement Slime enemy: data definition, behavior logic, spawn trigger, and visual"

**Bad (horizontal):** "Build the entire UI framework"
**Good (vertical):** "Add tower placement button to HUD: icon, click handler, and placement mode"

## Issue Template

When creating issues, use this template:

```markdown
## Goal
<What this task delivers — one sentence>

## Acceptance Criteria
- [ ] <Testable criterion 1>
- [ ] <Testable criterion 2>
- [ ] <Testable criterion 3>

## Affected Systems
- <System/module list>

## Dependencies
- <Blocked by: #issue> or "None"

## Quality Gate
- [ ] Tests pass (or manual verification documented)
- [ ] `./scripts/agent-check.sh` passes
- [ ] No unrelated changes
```

## Issue States

```
New -> Phase 1 (grill-me if unclear)
     -> Phase 2 (to-prd, then to-issues)
         -> Phase 3 (design interface if new module)
             -> Phase 4 (TDD implementation)
                 -> Phase 5 (human review)
                     -> Done
                     -> Bug found -> new Phase 4 issue
```

## PRD Template Location

PRDs go in `docs/prd/` with naming convention: `prd-<feature-name>.md`.

### PRD Template

```markdown
# PRD: <Feature Name>

## Background
<Why this feature is needed>

## Goals
- <Goal 1>
- <Goal 2>

## Non-Goals
- <Explicitly out of scope>

## Acceptance Criteria
- [ ] <Criterion 1>
- [ ] <Criterion 2>

## Affected Systems
- <System list>

## Dependencies
- <External dependencies or blocking issues>

## Open Questions
- <Unresolved questions, or "None">
```
```
