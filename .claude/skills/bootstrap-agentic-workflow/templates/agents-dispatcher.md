# AGENTS.md Dispatcher Template

This template defines the structure of the generated `AGENTS.md`. The generating agent fills placeholders (`{{VAR}}`) from the detected project profile and selects conditional sections based on project type.

## Merge Strategy

If `AGENTS.md` already exists:

1. **Preserve** all domain sections (Architecture Rules, Code Style, Game Systems, Physics Layers, etc.) in their current order.
2. **Insert** the following dispatcher sections after the first domain section:
   - Agent Operating Protocol
   - Skill Routing
   - Hard Rules
3. **Update** these sections if they already exist:
   - Command Cheat Sheet (add detected commands)
   - Testing Requirements (add detected test commands)
   - Safety Rules (merge with template rules)
4. **Never delete** any existing content without explicit user confirmation.

## Structural Skeleton

```markdown
# {{PROJECT_NAME}}

{{PROJECT_DESCRIPTION if available, otherwise "Project agent operating protocol."}}

## Project Overview

{{Existing project overview, or generate from detection.}}

## Repository Structure

{{Existing repository structure, or generate from detection.}}

---

## Agent Operating Protocol

When the user gives a feature request, bug report, refactor request, or vague idea, do not jump directly into coding.

Route the task through this workflow:

1. If the request is unclear, use grill-me behavior.
2. If the request is product-level, create or update a PRD.
3. If the work is larger than one small vertical slice, split it into issues.
4. If the work changes module boundaries, design the interface first.
5. If implementation is required, use TDD.
6. If debugging is required, diagnose or triage first.
7. Before completion, run the quality gate.

The user should not need to name a skill.
Choose the correct workflow automatically.

For routing details, see `docs/agents/skill-routing.md`.
For the full 6-phase workflow, see `docs/agents/workflow.md`.

### Hard Rules

- Never code before understanding the current task.
- Never implement a large feature in one pass.
- Never modify unrelated files.
- Never skip tests when a test runner is available.
- Never claim completion without running the quality gate script.
- Never run destructive git commands.
- Prefer vertical slices over horizontal layers.
- Prefer deep modules with small public interfaces.
- Prefer issue-driven work over chat-only work.

---

## Architecture Rules

{{Existing architecture rules, or generate from detection.}}

{{PROJECT_TYPE_SPECIFIC_SECTIONS}}

## Environment Requirements

{{Detected runtime versions and dependencies.}}

| Tool | Version | Install |
|---|---|---|
| {{runtime}} | {{version}} | {{install_command}} |

## Command Cheat Sheet

| Action | Command |
|---|---|
| Install dependencies | {{INSTALL_COMMAND}} |
| Start dev server | {{DEV_START_COMMAND}} |
| Run tests | {{TEST_COMMAND}} |
| Lint | {{LINT_COMMAND}} |
| Format | {{FORMAT_COMMAND}} |
| Typecheck | {{TYPECHECK_COMMAND}} |
| Build | {{BUILD_COMMAND}} |
| Quality gate | `./scripts/agent-check.sh` |

## Code Style

{{Existing code style rules, or generate from detection.}}

## Testing Requirements

{{Testing rules adapted to project.}}

## Safety Rules

- Never commit `.env`, credentials, or secret files.
- Never commit generated files: {{PROJECT_GENERATED_FILES}}.
- Never force-push to main or develop.
- Always run `./scripts/agent-check.sh` before claiming completion.

## Git Workflow Rules

- Create feature branches from develop (or main if no develop).
- Branch naming: `<type>/<short-description>` (e.g., `feature/enemy-spawn`, `fix/buff-stacking`).
- Commit messages: concise, imperative mood.
- One logical change per commit.

## Definition of Done

A task is done only when all items in `docs/agents/dor-dod.md` Definition of Done are satisfied.
```

## Conditional Sections

Include these sections based on project type. See [agents-md-sections.md](agents-md-sections.md) for full content.

### Godot (when `PROJECT_TYPE` is "Godot")

Place after Architecture Rules:

```markdown
### Godot-Specific Rules

- Never commit `.godot/` directory or `.import` files.
- Scenes (`.tscn`) are the primary organizational unit; prefer composing scenes over monolithic scripts.
- Use autoloads for global systems; document each autoload's responsibility.
- Physics layers must be configured in `project.godot` and documented here.
- Data-driven design: game data lives in JSON/resource files under `data/`, not hardcoded.
- Signal connections: prefer editor connections for scene-internal events, `connect()` for cross-scene.
```

### Python+Node (when `PROJECT_TYPE` is "Python+Node fullstack")

Place after Architecture Rules:

```markdown
### Backend Rules (Python)

- Use virtual environment; never install globally.
- Dependency changes must update lock file.
- API endpoints follow REST conventions.

### Frontend Rules (Node/TypeScript)

- Use the project's package manager; never switch.
- Component co-location: styles, tests, and component in same directory.
```

### Rust (when `PROJECT_TYPE` is "Rust")

Place after Architecture Rules:

```markdown
### Rust Rules

- `cargo fmt --check` must pass before commit.
- `cargo clippy` warnings are treated as errors.
- Public API changes require updating documentation.
- Unsafe code requires a safety comment explaining the invariant.
```

### Go (when `PROJECT_TYPE` is "Go")

Place after Architecture Rules:

```markdown
### Go Rules

- `go vet` must pass.
- Error handling: always check errors, never use `_` for `error` returns.
- Interface definition belongs in the consumer package, not the implementation package.
```
