# 6-Phase Workflow Template

This template generates `docs/agents/workflow.md`. Adapt the language to match `DOMINANT_LANGUAGE` detected from the project. The template below is in English; translate content (not structure) if `DOMINANT_LANGUAGE` is Chinese/Japanese/Korean.

## Generation Rules

1. Translate all prose to `DOMINANT_LANGUAGE`. Keep technical terms (TDD, PRD, vertical slice, etc.) in English.
2. Each phase has a "Status" indicator. Set based on whether the corresponding infrastructure exists after template generation.
3. Adapt per-phase notes based on `PROJECT_TYPE` using the adaptation rules below.
4. Keep cross-references to other `docs/agents/*` files accurate.

## Template

```markdown
# AI-Assisted Development: 6-Phase Workflow

This document describes the standard workflow for AI-assisted development in this project. The agent follows this workflow automatically based on the routing rules in `skill-routing.md`.

For the Definition of Ready and Definition of Done, see `dor-dod.md`.
For issue creation and lifecycle, see `issue-lifecycle.md`.

---

## Phase 0: Safety Net & Environment

Establish guardrails before AI touches code.

**Checklist:**
- [ ] Pre-commit hooks configured (`.husky/pre-commit` -> `scripts/agent-check.sh`)
- [ ] Git guardrails active (`scripts/agent-guard.sh`)
- [ ] Quality gate script exists (`scripts/agent-check.sh`)
- [ ] `.gitignore` configured for project-generated files

**Status:** {{GENERATED|EXISTING|MANUAL_SETUP_NEEDED}}

**Notes:**
{{PROJECT_TYPE_NOTES_PHASE_0}}

---

## Phase 1: Domain Knowledge Sync & Requirement Alignment

Eliminate communication barriers and reach design consensus.

**Process:**
1. If the request is vague or unclear, use **grill-me** behavior: ask probing questions until the requirement is fully understood.
2. For new domains or concepts, use **ubiquitous-language** behavior: extract a DDD-style vocabulary from the conversation.
3. Confirm shared understanding before proceeding.

**Output:** Clear, testable requirement statement.

---

## Phase 2: Generate Target Docs & Task Breakdown

Transform consensus into executable tasks. Never implement everything at once.

**Process:**
1. Use **to-prd** behavior: generate a Product Requirements Document from the conversation context. Store in `docs/prd/prd-<feature-name>.md`.
2. Use **to-issues** behavior: split the PRD into vertical slices. Each slice is one small, runnable feature that cuts across all layers.
3. Create issues following the template in `issue-lifecycle.md`.

**Key principle:** Vertical slices, not horizontal layers.
- Bad: "Implement all enemy types" (horizontal)
- Good: "Implement Slime enemy: data, behavior, spawn, and visual" (vertical)

**Output:** PRD document + issue list with dependencies.

---

## Phase 3: Architecture & Interface Design

Plan module interfaces before implementation. AI performs better with well-defined boundaries.

**Process:**
1. For new modules: use **design-an-interface** behavior. Generate multiple interface proposals, pick one.
2. For existing code: use **improve-codebase-architecture** behavior. Find deepening opportunities.
3. If a large refactor is needed: generate a multi-step refactor plan with tiny commits.

**Output:** Interface specification or architecture improvement plan.

---

## Phase 4: Automated Dev & Test Loop

Execute implementation using strict TDD. The human can be AFK during this phase.

**Process:**
1. Pick one issue from the backlog.
2. **TDD cycle (Red-Green-Refactor):**
   - **Red:** Write a failing test that describes the expected behavior.
   - **Green:** Write the minimum implementation to make the test pass.
   - **Refactor:** Clean up while keeping tests green.
3. Run quality gate: `./scripts/agent-check.sh`
4. Commit with descriptive message.
5. Move to next issue.

**Notes:**
{{PROJECT_TYPE_NOTES_PHASE_4}}

---

## Phase 5: Human Acceptance & Bug Diagnosis

Human reviews AI output with fresh context.

**Process:**
1. **Human QA:** UI/UX testing, gameplay feel, visual polish — things AI cannot judge.
2. **Bug triage:** If bugs are found, use **triage** behavior. The agent investigates, finds root cause, and creates a new issue with TDD fix plan.
3. Route fix issues back to Phase 4.

**Output:** Verified features or triaged bug issues.

---

## Phase 6: Paradigm Self-Evolution

Improve the workflow itself over time.

**Process:**
1. When a repeated team pattern is identified, use **write-a-skill** behavior to capture it as a reusable skill.
2. Update this workflow document if the process evolves.
3. Update routing table if new skills are added.
```

## Project-Type Adaptation Rules

### Godot

**Phase 0 notes:**
```
Godot generates `.godot/` and `.import` files that must be gitignored.
Pre-commit hook should check for accidentally staged `.import` files.
```

**Phase 4 notes:**
```
GDScript testing is limited in Godot 4.x. TDD cycle adapts:
- If GUT or GdUnit4 is installed: use normal red-green-refactor.
- If no test runner: write expected behavior as a comment, implement, verify manually by running the scene.
- Always validate JSON data files after changes.
```

### Python+Node

**Phase 0 notes:**
```
Ensure both backend and frontend dependencies are installed.
Backend uses virtual environment; frontend uses the project's package manager.
```

**Phase 4 notes:**
```
Backend tests: pytest (or detected runner).
Frontend tests: vitest/jest (or detected runner).
Run both test suites in the quality gate.
```

### Rust

**Phase 4 notes:**
```
Tests: `cargo test`
Lint: `cargo clippy`
Format: `cargo fmt --check`
All three must pass in the TDD cycle.
```

### Go

**Phase 4 notes:**
```
Tests: `go test ./...`
Vet: `go vet`
Format is handled by `gofmt`.
```

### No Test Runner

**Phase 4 notes:**
```
No automated test runner detected. TDD cycle uses manual verification:
1. Write the expected behavior as a structured comment.
2. Implement the behavior.
3. Verify manually by running the application.
4. Document verification steps in the commit message.
Consider setting up a test framework to enable automated TDD.
```
