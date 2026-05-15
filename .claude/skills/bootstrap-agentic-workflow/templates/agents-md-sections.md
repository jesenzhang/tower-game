# AGENTS.md Section Catalog

Per-project-type section content for the generated AGENTS.md. The generating agent includes sections whose "Include when" condition matches the detected project type.

---

## Godot

Include when: `PROJECT_TYPE` is "Godot"

### Godot-Specific Rules

```markdown
### Godot-Specific Rules

- Never commit `.godot/` directory or `.import` files.
- Scenes (`.tscn`) are the primary organizational unit; prefer composing scenes over monolithic scripts.
- Use autoloads for global systems; document each autoload's responsibility.
- Physics layers must be configured in `project.godot` and documented here.
- Data-driven design: game data lives in JSON/resource files under `data/`, not hardcoded.
- Signal connections: prefer editor connections for scene-internal events, `connect()` for cross-scene.
```

### Godot Project Structure Section

Include when: generating Repository Structure for a Godot project.

```markdown
## Repository Structure

- `game/` — Main Godot project directory
  - `project.godot` — Project configuration, autoloads, physics layers
  - `autoload/` — Global singleton systems
  - `systems/` — Core game systems (TagSystem, BuffSystem, etc.)
  - `scenes/` — Scene files organized by feature
  - `scripts/` — Shared GDScript utilities
  - `data/` — JSON game data files (enemies, towers, artifacts, etc.)
  - `resources/` — Godot resource files (.tres)
  - `assets/` — Art, audio, and other media
  - `ui/` — UI scenes and scripts
```

### Godot Testing Section

Include when: generating Testing Requirements for a Godot project.

```markdown
## Testing Requirements

Godot 4.x GDScript testing is limited. Options:

- **GUT (Godot Unit Testing)**: GDScript-based unit testing framework.
- **GdUnit4**: Another GDScript testing option.
- **Manual scene testing**: Run scenes in editor to verify behavior.

When no test runner is configured:
- Verify logic correctness through manual scene testing.
- Validate JSON data files with `python -m json.tool game/data/*.json` (if Python available).
- The TDD workflow adapts: write the expected behavior as a comment, implement, then verify manually.
```

---

## Python+Node

Include when: `PROJECT_TYPE` is "Python+Node fullstack"

### Backend Rules

```markdown
### Backend Rules (Python)

- Use virtual environment; never install globally.
- Dependency changes must update lock file (`uv.lock` or `requirements.txt`).
- API endpoints follow REST conventions.
- Database migrations must be reversible.
- Configuration via environment variables, never hardcoded.
```

### Frontend Rules

```markdown
### Frontend Rules (Node/TypeScript)

- Use the project's package manager ({{PACKAGE_MANAGER}}); never switch.
- Component co-location: styles, tests, and component in same directory.
- Run typecheck before claiming completion.
- No `any` types without a comment explaining why.
```

---

## Rust

Include when: `PROJECT_TYPE` is "Rust"

```markdown
### Rust Rules

- `cargo fmt --check` must pass before commit.
- `cargo clippy` warnings are treated as errors.
- Public API changes require updating doc comments.
- Unsafe code requires a `// SAFETY:` comment explaining the invariant.
- Feature flags must be documented in the crate root.
- No `unwrap()` in library code; use proper error handling.
```

---

## Go

Include when: `PROJECT_TYPE` is "Go"

```markdown
### Go Rules

- `go vet` must pass.
- Error handling: always check errors, never use `_` for `error` returns.
- Interface definition belongs in the consumer package.
- Table-driven tests for functions with multiple cases.
- No init() functions with side effects.
```

---

## Monorepo

Include when: `PROJECT_TYPE` is "Monorepo"

```markdown
### Monorepo Rules

- Changes to shared packages must be backward-compatible.
- Each package has its own test/lint/build commands (see Command Cheat Sheet per package).
- Cross-package changes require updating all affected packages in one commit.
- Use workspace commands for cross-cutting operations: `{{WORKSPACE_COMMAND}}`.
```

---

## Universal Sections

Always include regardless of project type.

### Safety Rules

```markdown
## Safety Rules

- Never commit `.env`, credentials, or secret files.
- Never commit generated files (varies by project type).
- Never force-push to main or develop.
- Always run `./scripts/agent-check.sh` before claiming completion.
- Never delete files without confirming with the user.
- Never run `rm -rf` or equivalent destructive commands.
```

### Git Workflow Rules

```markdown
## Git Workflow Rules

- Create feature branches from develop (or main if no develop exists).
- Branch naming: `<type>/<short-description>` (e.g., `feature/user-auth`, `fix/login-error`).
- Commit messages: concise, imperative mood (e.g., "Add enemy spawn system").
- One logical change per commit.
- Never commit directly to main.
```
