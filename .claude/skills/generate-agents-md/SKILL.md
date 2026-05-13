---
name: generate-agents-md
description: Generate or update a repository-specific AGENTS.md file for AI coding agents. Use this skill when the user asks to create, improve, standardize, audit, or migrate AGENTS.md / coding-agent instructions / repository execution rules.
---

# Generate AGENTS.md Skill

## Purpose

Generate or update a practical, repository-specific `AGENTS.md` file for AI coding agents.

The generated `AGENTS.md` should work as an executable project manual for agents. It must help coding agents understand:

- What the repository is.
- How the project is structured.
- Which runtimes, package managers, and tools are required.
- How to install, start, test, lint, typecheck, build, and preview the project.
- Which local URLs, ports, API docs, and service endpoints matter.
- Which environment variables, database workflows, and migration commands matter.
- Where code should be placed.
- Which architectural boundaries must be preserved.
- Which safety rules must not be violated.
- What "done" means for a task.

This skill must produce operational guidance, not generic motivational text.

---

## When To Use

Use this skill when the user asks to:

- Create `AGENTS.md`.
- Generate coding-agent instructions for a repository.
- Improve or audit an existing `AGENTS.md`.
- Standardize repository rules for Codex, Claude Code, Cursor, Kilo, opencode, Aider, Copilot, Gemini, or similar coding agents.
- Convert README, docs, project structure, or existing tool-specific rules into `AGENTS.md`.
- Make agents follow project-specific commands, architecture, documentation, Git, or safety rules.

---

## Core Principle

`AGENTS.md` is not a README, product spec, architecture document, API reference, or one-off task plan.

It is a concise operating manual for coding agents.

It should answer:

```txt
What is this repo?
How do I work in it?
What commands do I run?
Which local services and ports matter?
Where should code go?
What must I avoid?
How do I know the task is complete?
```

Prefer truth over completeness.

Do not invent commands, frameworks, directories, ports, tools, architectural rules, or permissions.

---

## Operating Modes

### Repository Inspection Mode

Use this mode when the agent can access the repository.

Steps:

1. Inspect the repository tree.
2. Read project documentation and configuration files.
3. Detect package managers, runtimes, service ports, databases, task runners, and CI commands.
4. Detect existing agent instruction files.
5. Extract real commands.
6. Identify conflicts, missing settings, or stale instructions.
7. Ask targeted questions only for settings that cannot be reliably detected.
8. Generate or update `AGENTS.md`.

Do not ask the user for information that can be discovered from files.

### User-Provided Context Mode

Use this mode when the repository is not accessible.

Steps:

1. Ask the user for the smallest useful set of project information.
2. Prefer project tree, README, package/build files, task runner files, runtime config, CI files, and existing agent instruction files.
3. Generate `AGENTS.md` from the provided information.
4. Mark undetected commands or uncertain assumptions clearly.

### Conservative Fallback Mode

Use this mode when the user wants a result but key information is missing and cannot be obtained.

Rules:

- Generate a conservative `AGENTS.md`.
- Mark missing items as `Not detected` or `To be confirmed`.
- Do not guess commands or ports.
- Add a short note explaining what could not be verified.

---

## Missing Information Handling

Before generating `AGENTS.md`, inspect the repository first.

If important information cannot be detected automatically, ask the user targeted questions instead of guessing.

Ask only for missing or conflicting settings that affect the generated `AGENTS.md`.

Examples of settings to ask about:

- Preferred package manager when multiple lockfiles exist.
- Development startup command when no script or README command exists.
- Test command when no test script, config, or CI command exists.
- Required runtime versions when no version files exist.
- Python runtime and package manager when a Python project is detected but no version/tooling files exist.
- Node.js runtime and package manager when a Node frontend is detected but no version/tooling files exist.
- Backend port when startup commands and config disagree.
- Frontend dev server port when Vite, Next, or similar config is missing or ambiguous.
- API base URL when frontend proxy and backend command disagree.
- Database type when multiple configs exist.
- Migration workflow when migrations are present but no command is documented.
- Whether agents are allowed to create Git commits.
- Whether agents should update docs automatically after code changes.
- Whether destructive local reset commands are allowed.

For Python + Node projects with missing environment-version files, propose the default environment baseline defined in this skill and ask the user to confirm it instead of silently inventing project-specific requirements.

Question policy:

- Ask only after repository inspection.
- Ask at most 3 to 7 focused questions at once.
- Explain why each answer matters.
- Provide detected defaults when available.
- Do not ask broad questions like "What is your project structure?"
- Do not ask the user to repeat information already found in files.
- If the user does not answer, generate a conservative `AGENTS.md` and mark unknown items clearly.

Example question set:

```txt
I could not reliably detect a few settings needed for AGENTS.md.

Please confirm:

1. Backend port: I found `30001` in the backend startup command, but another config references `8000`. Which one should AGENTS.md use?
2. Frontend tests: I found frontend build and lint scripts, but no test script. Should frontend testing be listed as "not configured"?
3. Git behavior: Should agents create commits automatically after completing a task, or only when explicitly requested?
```

---

## Default Environment Baseline For Python + Node Projects

Use this baseline only when the repository appears to be a conventional Python backend + Node frontend project and exact environment requirements are not detectable from files.

Do not silently assert it as fact. Ask the user to confirm it first.

Default backend environment:

```md
### Backend Environment

- Python 3.12+
- uv (Python package manager; automatically manages the `backend/.venv` virtual environment)
```

Default frontend environment:

```md
### Frontend Environment

- Node.js 18+
- npm 9+
- Node.js version manager:
  - Linux/macOS: prefer `nvm` when no project-specific tool is detected.
  - Windows: ask the user which tool to use when not specified. Common options include `fnm`, `nvm-windows`, and `Volta`.
```

Default environment management table:

```md
### Environment Management Tools

The project uses version/environment management tools to isolate runtime environments from older system-installed versions.

| Tool | Manages | Install/Runtime Location | Purpose |
|------|---------|--------------------------|---------|
| **uv** | Python virtual environment | `backend/.venv/` | Backend dependency isolation; `uv sync` creates/manages it automatically |
| **nvm** | Node.js version | `~/.nvm/` | Frontend Node.js version management on Linux/macOS without modifying system Node |
| **Windows Node manager** | Node.js version | User-local tool directory | Use the project/team-confirmed tool, such as `fnm`, `nvm-windows`, or `Volta` |
```

Important constraints:

- If the backend is not under `backend/`, adjust `backend/.venv/` to the actual project path or ask the user.
- Do not assume a Windows Node.js version manager.
- If the project targets Windows and no tool is detected, ask the user whether to use `fnm`, `nvm-windows`, `Volta`, or another team-standard tool.
- Do not mention startup helper scripts, such as `scripts/env_loader.sh`, unless they are actually detected in the repository and the project intends agents to rely on them.
- If the user rejects or overrides this baseline, use the user's confirmed values.

Example targeted question:

```txt
I could not detect explicit runtime versions or Node.js version-manager preferences.

Please confirm whether AGENTS.md should use this baseline:

1. Backend: Python 3.12+ with uv managing backend/.venv.
2. Frontend: Node.js 18+ with npm 9+.
3. Node.js version manager:
   - Linux/macOS: nvm
   - Windows: which tool should be documented? Common options are fnm, nvm-windows, and Volta.
```

---

## Files To Inspect

Inspect the following files and directories when present.

### Project Identity

- `README.md`
- `docs/`
- `package.json`
- `pyproject.toml`
- `Cargo.toml`
- `go.mod`
- `pom.xml`
- `build.gradle`
- `composer.json`
- `Gemfile`
- `.tool-versions`
- `.node-version`
- `.python-version`
- `.ruby-version`
- `.java-version`

### Build And Runtime

- `Makefile`
- `justfile`
- `Taskfile.yml`
- `turbo.json`
- `nx.json`
- `docker-compose.yml`
- `compose.yml`
- `Dockerfile`
- `.devcontainer/devcontainer.json`
- `devcontainer.json`
- `.env.example`
- `.env.template`
- `.env.sample`
- `scripts/`

### Quality Checks

- `.github/workflows/`
- `.gitlab-ci.yml`
- `biome.json`
- `eslint.config.*`
- `.eslintrc*`
- `prettier.config.*`
- `.prettierrc*`
- `ruff.toml`
- `.ruff.toml`
- `mypy.ini`
- `pyrightconfig.json`
- `pytest.ini`
- `vitest.config.*`
- `jest.config.*`
- `playwright.config.*`
- `tsconfig.json`

### Architecture And Conventions

- `docs/architecture*`
- `docs/specs/`
- `docs/adr/`
- `src/`
- `app/`
- `backend/`
- `frontend/`
- `server/`
- `client/`
- `packages/`
- `apps/`
- `libs/`
- `modules/`
- `services/`
- `tests/`
- `migrations/`
- `alembic.ini`

### Existing Agent Instructions

- `AGENTS.md`
- `.cursorrules`
- `.cursor/rules/`
- `CLAUDE.md`
- `.claude/`
- `GEMINI.md`
- `.windsurfrules`
- `.github/copilot-instructions.md`
- `.aider.conf.yml`

When multiple instruction files exist, consolidate compatible guidance into `AGENTS.md` without deleting the originals unless the user explicitly asks.

---

## Files To Request When Repository Is Not Accessible

If the repository cannot be inspected directly, ask the user for the smallest useful set of information.

Preferred request:

```txt
Please provide one of the following:

Option A: Upload the repository or give me access to inspect it.

Option B: Paste the key project files:

1. Project tree, such as `tree -L 3` or `find . -maxdepth 3 -type f`
2. `README.md`
3. Existing `AGENTS.md`, if any
4. Backend package/build file, such as `pyproject.toml`, `requirements.txt`, `go.mod`, or `pom.xml`
5. Frontend package file, such as `package.json`
6. Runtime files, such as `docker-compose.yml`, `.env.example`, or `vite.config.ts`
7. CI or task files, such as `Makefile`, `justfile`, or `.github/workflows/*`
```

Do not request sensitive files such as real `.env` files, private keys, production credentials, or secret-bearing deployment files.

---

## Output Location

Default output path:

```txt
AGENTS.md
```

For monorepos, generate a root-level `AGENTS.md` first.

Only generate nested `AGENTS.md` files when:

- The user explicitly asks for them.
- Different subprojects have substantially different commands, stacks, or rules.
- Local overrides are necessary to prevent agents from applying root-level rules incorrectly.

Examples:

```txt
AGENTS.md
frontend/AGENTS.md
backend/AGENTS.md
packages/core/AGENTS.md
```

Root-level instructions should contain global repository rules.

Nested instructions should contain local overrides only.

---

## Language Rules

Use the dominant language of the repository documentation.

If unclear:

- Use English for `AGENTS.md` by default.
- Use Chinese when the repository documentation and user communication are primarily Chinese.
- Keep command names, file paths, package names, environment variables, API names, and code identifiers unchanged.

---

## Recommended AGENTS.md Structure

Prefer this structure when the project contains enough reliable information:

```md
# AGENTS.md

## Project Overview

## Repository Structure

## Environment Requirements

## Backend Development

## Frontend Development

## Quick Start

## Local URLs

## Environment Variables

## Database And Migrations

## Code Style

## Architecture Rules

## Testing Requirements

## Documentation Rules

## Git Workflow Rules

## Safety Rules

## Definition of Done

## Command Cheat Sheet
```

Adapt the structure to the repository.

Delete sections that do not apply.

For example:

- Do not include `Frontend Development` if there is no frontend.
- Do not include `Backend Development` if there is no backend.
- Do not include `Database And Migrations` if no database or migration workflow is detected.
- Do not include `Local URLs` if no local service URLs are detected.

Use extra sections only when useful, such as:

```md
## API Conventions
## Frontend Conventions
## Backend Conventions
## Monorepo Rules
## Deployment Notes
## Agent Workflow
## Troubleshooting Notes
## Known Configuration Notes
```

Do not add decorative or verbose sections.

---

## Output Style Rules

The generated `AGENTS.md` should be clear enough for both humans and coding agents.

Use:

- Section headings for major workflows.
- Numbered steps for setup procedures.
- Fenced code blocks for executable commands.
- Tables only for quick command lookup.
- Short notes for warnings or inconsistencies.
- Concrete rules instead of abstract advice.

Avoid:

- Dense inline command lists.
- Long paragraphs.
- Generic advice.
- Unverified commands.
- Mixing multiple unrelated commands in one sentence.
- Copying large portions of README or docs.

### Command Formatting Rules

Prefer fenced code blocks for executable commands.

Good:

````md
### Install Backend Dependencies

```bash
cd backend
uv sync
```
````

Bad:

```md
Install backend dependencies with `cd backend && uv sync`.
```

Use inline commands only in:

- Short command cheat sheets.
- Tables.
- Notes that refer to a command without instructing the agent to execute it.

When commands must be run from a specific directory, include the `cd` command in the code block.

Example:

````md
### Start Backend Development Server

```bash
cd backend
uv run uvicorn main:app --reload --port 30001 --host 0.0.0.0
```
````

### Detailed Commands And Cheat Sheets

Use detailed command sections for execution.

Use cheat sheets only as quick lookup.

Detailed section:

````md
## Backend Development

### Run Tests

```bash
cd backend
uv run pytest
```
````

Cheat sheet:

```md
| Task | Command |
|------|---------|
| Run backend tests | `cd backend && uv run pytest` |
```

---

## Section Guidance

### Project Overview

Summarize the project in 3 to 8 lines.

Include:

- Product or system purpose.
- Main tech stack.
- Main runtime or deployment model.
- Important constraints.

Avoid marketing language.

Bad:

```md
This is an innovative next-generation platform.
```

Good:

```md
This is a FastAPI + Vue contract management system for small-team local deployment.
The backend exposes REST APIs, the frontend is a TypeScript SPA, and uploaded files are stored through a configured storage layer.
```

### Repository Structure

List only directories that actually exist or are clearly intended.

Use concise descriptions.

Example:

```md
## Repository Structure

```txt
contract_management/
├── backend/                 # FastAPI backend application
│   ├── api/                  # API routes
│   ├── core/                 # Configuration and infrastructure helpers
│   ├── models/               # Database models
│   ├── schemas/              # Pydantic schemas
│   └── main.py               # Application entry point
├── frontend/                # Vue + TypeScript frontend
│   └── src/                  # Frontend source code
└── docs/                    # Design and project documentation
```
```

A tree block is often clearer than a flat bullet list for small and medium repositories.

For large monorepos, use grouped bullet lists instead of a huge tree.

If the project structure is unclear, write:

```md
- Repository structure is still evolving. Follow existing directory patterns before introducing new top-level directories.
```

### Environment Requirements

Include required runtime and tool versions when detectable.

Use sources such as:

- `.python-version`
- `.node-version`
- `.tool-versions`
- `pyproject.toml`
- `package.json`
- `Dockerfile`
- CI files
- README

If the environment requirements cannot be reliably detected, ask the user targeted questions instead of guessing.

For conventional Python backend + Node frontend projects, use the following baseline as the proposed default when versions/tools are missing, and ask the user to confirm it:

```md
## Environment Requirements

### Backend Environment

- Python 3.12+
- uv (Python package manager; automatically manages the `backend/.venv` virtual environment when the backend lives in `backend/`)

### Frontend Environment

- Node.js 18+
- npm 9+
- Node.js version manager:
  - Linux/macOS: `nvm`, unless the repository specifies another tool.
  - Windows: confirm with the user when not specified. Possible options include `fnm`, `nvm-windows`, and `Volta`.
  
### Environment Management Tools

The project uses version/environment management tools to isolate runtime environments from older system-installed versions.

| Tool | Manages | Install/Runtime Location | Purpose |
|------|---------|--------------------------|---------|
| **uv** | Python virtual environment | `backend/.venv/` | Backend dependency isolation; `uv sync` creates/manages it automatically |
| **nvm** | Node.js version | `~/.nvm/` | Frontend Node.js version management on Linux/macOS without modifying system Node |
| **fnm** | Node.js version | User-local fnm directory | Frontend Node.js version management on Windows without modifying system Node |
```

Rules:

- Do not claim these defaults were detected unless repository files confirm them.
- If the user confirms these defaults, include them in the generated `AGENTS.md`.
- If only a Python project is present, include only the backend/Python part.
- If only a Node project is present, include only the frontend/Node part.
- If the Python project is not under `backend/`, adjust the virtualenv path to the actual project layout or ask the user.
- Do not add project-specific startup-loader claims such as `scripts/env_loader.sh` unless such scripts are actually present and intended by the repository.

If no version is detected and no default applies, write `Version not detected` or omit the version.

### Development Commands

Extract real commands from project files.

Prefer commands from:

1. `Makefile`, `justfile`, or `Taskfile.yml`
2. `package.json` scripts
3. `pyproject.toml`
4. CI workflows
5. README
6. Existing scripts

Group commands by area, such as backend, frontend, shared packages, Docker, or database.

Use fenced code blocks for executable commands.

Example:

````md
## Backend Development

### Install Dependencies

```bash
cd backend
uv sync
```

### Start Development Server

```bash
cd backend
uv run uvicorn main:app --reload --port 30001 --host 0.0.0.0
```

### Run Tests

```bash
cd backend
uv run pytest
```

### Run Lint

```bash
cd backend
uv run ruff check .
```
````

When a command is not detected, do not fabricate one.

Use:

```md
- Test command: Not detected. Check project documentation or CI before assuming.
```

### Quick Start

For multi-service repositories, include a short section showing how to start the minimum useful local development environment.

Example:

````md
## Quick Start

Start the backend in one terminal:

```bash
cd backend
uv run uvicorn main:app --reload --port 30001 --host 0.0.0.0
```

Start the frontend in another terminal:

```bash
cd frontend
npm run dev
```
````

Only include verified commands.

### Local URLs

When local service URLs are detectable, include them:

- Frontend development URL
- Backend API base URL
- API documentation URL
- Admin console URL
- Database console URL
- Object storage console URL

Example:

```md
## Local URLs

- Frontend: `http://localhost:5180`
- Backend API: `http://localhost:30001`
- API docs: `http://localhost:30001/api/docs`
```

Only include URLs verified from config, README, scripts, or source code.

If conflicting ports are detected, explicitly mark the conflict instead of guessing.

Example:

```md
## Known Configuration Notes

- Backend startup commands use port `30001`.
- Some existing documentation references port `8000`.
- Verify `vite.config.ts` and backend runtime config before changing API proxy behavior.
```

### Environment Variables

Include environment variable names and safe example values when useful.

Rules:

- Prefer `.env.example`, `.env.template`, `.env.sample`, README, or documented config files.
- Do not copy secrets from real `.env` files.
- Do not expose credentials, tokens, private URLs, production secrets, or private endpoints.
- Explain the purpose of important variables.
- Mark production-only or development-only variables when clear.

Example:

```md
## Environment Variables

Create `backend/.env` from the documented example.

Required variables:

- `APP_NAME`: Application display name.
- `DEBUG`: Enables development debug mode.
- `DATABASE_URL`: Database connection string.
- `PORT`: Backend service port.
- `SECRET_KEY`: JWT signing secret. Use a strong private value in production.
```

### Database And Migrations

Include this section when database configuration, migrations, seed scripts, or local database files are detected.

Cover:

- Local database type
- Database URL source
- Migration command
- Seed command
- Reset command, if safe
- Whether tables are auto-created
- Local database file path, if applicable

Safety rules:

- Do not run destructive reset commands unless explicitly requested.
- Do not modify already-applied migrations unless the repository convention clearly allows it.
- Prefer new corrective migrations over editing old migrations.
- Mark destructive reset commands clearly.

Example:

````md
## Database And Migrations

The default development database is SQLite.

Local database file:

```txt
backend/contract_management.db
```

Tables are created automatically during backend startup.

Destructive local reset, only when explicitly requested:

```bash
cd backend
rm contract_management.db
uv run uvicorn main:app --reload
```
````

### Code Style

Write specific, enforceable rules.

Good:

```md
- Keep API route handlers thin; put business logic in service modules.
- Prefer explicit types for exported TypeScript functions.
- Do not use `any` unless the reason is documented near the usage.
- Preserve existing formatting and naming conventions.
```

Bad:

```md
- Write clean code.
- Be careful.
- Use best practices.
```

### Architecture Rules

Capture project-specific boundaries derived from the current repository structure.

Examples for layered backend projects:

```md
## Architecture Rules

- API routes should handle request validation, authentication, and response mapping only.
- Business logic belongs in service-layer modules.
- Database access must go through repository or data-access modules.
- File/object storage must go through the storage abstraction.
- Frontend code must not depend on backend internal models directly.
- Shared DTOs or API contracts must be documented when changed.
```

Examples for monorepos:

```md
- Applications in `apps/` may depend on packages in `packages/`.
- Packages must not depend on applications.
- Shared packages should avoid importing app-specific configuration.
```

Examples for event-driven or agent systems:

```md
- Events must be append-only unless an explicit compaction or migration process exists.
- Replayable workflows must avoid hidden side effects.
- Long-running tasks must persist enough state to resume safely.
```

Do not impose architecture patterns that the repository does not appear to use.

### Testing Requirements

Specify what to test and what to run.

Example:

```md
## Testing Requirements

- Add or update tests for changed business logic.
- Add integration tests for API behavior changes.
- Add frontend interaction tests for user-visible behavior changes when practical.
- Run the smallest relevant test set during iteration.
- Run the full relevant suite before finalizing a task when practical.
- Do not remove or weaken tests to make the suite pass.
- If tests cannot be run, explain why and list the exact command that should be run manually.
```

### Documentation Rules

Specify when docs should be updated.

Example:

```md
## Documentation Rules

- Update documentation when changing architecture, commands, configuration, public APIs, or workflows.
- Put feature specs in `docs/specs/` when that directory exists or is requested.
- Put architecture decisions in `docs/adr/` when that directory exists or is requested.
- Keep README focused on human onboarding.
- Keep AGENTS.md focused on coding-agent execution rules.
```

Only mention directories that exist or are intentionally introduced by the task.

### Git Workflow Rules

Include Git safety rules when the repository instructions mention Git workflow or when the user wants agents to manage changes safely.

Default rule:

```md
- Do not commit changes unless the user explicitly asks for a commit.
```

Recommended section:

```md
## Git Workflow Rules

- Check `git status --short` before risky edits and before final summary.
- Use file-level `git diff -- <path>` to inspect relevant changes.
- Do not run `git reset --hard`.
- Do not run broad destructive restore commands.
- Do not commit changes unless the user explicitly asks for a commit.
- When committing is requested:
  - Review `git status --short`.
  - Review relevant diffs.
  - Stage only intended files.
  - Use a concise commit message that matches the actual changes.
```

If the user explicitly wants automatic commits after each completed task, include that behavior, but make it explicit and bounded.

Example:

```md
- After completing a requested coding task, create a commit only if the user or project workflow explicitly requires it.
```

### Safety Rules

This section is mandatory.

Include strong rules against destructive or risky behavior.

Example:

```md
## Safety Rules

- Never commit secrets, credentials, tokens, private URLs, or API keys.
- Do not copy values from real `.env` files into documentation.
- Do not modify production deployment files unless the task explicitly requires it.
- Do not rewrite git history or run destructive git commands unless explicitly requested.
- Do not delete user work or overwrite files without checking their contents.
- Do not delete or weaken tests to hide failures.
- Do not change applied database migrations unless a new corrective migration is created.
- Do not silently change public API behavior.
- Ask before adding new production dependencies.
```

### Definition Of Done

Make completion measurable.

Example:

```md
## Definition of Done

A task is complete only when:

- The requested behavior is implemented.
- Relevant tests are added or updated.
- Relevant checks have been run, or a clear reason is given for why they could not be run.
- Documentation is updated when behavior, commands, configuration, or architecture changes.
- The final response summarizes:
  - What changed.
  - Which files changed.
  - Which commands were run.
  - Any known risks or follow-up work.
```

### Command Cheat Sheet

For repositories with multiple subprojects, include a concise command table after detailed command sections.

Use only verified commands.

Example:

```md
## Command Cheat Sheet

| Task | Command |
|------|---------|
| Install backend dependencies | `cd backend && uv sync` |
| Start backend | `cd backend && uv run uvicorn main:app --reload --port 30001 --host 0.0.0.0` |
| Run backend tests | `cd backend && uv run pytest` |
| Install frontend dependencies | `cd frontend && npm install` |
| Start frontend | `cd frontend && npm run dev` |
| Build frontend | `cd frontend && npm run build` |
```

Tables are for scanning. Detailed instructions should still use fenced command blocks.

---

## Command Discovery Rules

### Node / Frontend

Check:

```txt
package.json
pnpm-lock.yaml
yarn.lock
package-lock.json
bun.lockb
vite.config.*
next.config.*
vitest.config.*
jest.config.*
playwright.config.*
```

Prefer the package manager indicated by the lockfile:

```txt
pnpm-lock.yaml -> pnpm
yarn.lock -> yarn
package-lock.json -> npm
bun.lockb -> bun
```

Extract scripts from `package.json`, such as:

```json
{
  "scripts": {
    "dev": "...",
    "build": "...",
    "test": "...",
    "lint": "...",
    "typecheck": "..."
  }
}
```

Do not assume missing scripts.

### Python / Backend

Check:

```txt
pyproject.toml
requirements.txt
requirements-dev.txt
Pipfile
poetry.lock
uv.lock
pytest.ini
ruff.toml
mypy.ini
```

Prefer:

```txt
uv.lock -> uv
poetry.lock -> poetry
requirements.txt only -> python -m pip
```

Do not assume FastAPI, Django, Flask, Celery, pytest, Ruff, or mypy unless detected.

### Go

Check:

```txt
go.mod
Makefile
```

Common commands may be used only if consistent with project conventions:

```txt
go test ./...
go vet ./...
go build ./...
```

### Rust

Check:

```txt
Cargo.toml
Cargo.lock
```

Common commands:

```txt
cargo test
cargo clippy
cargo fmt
cargo build
```

### Java / JVM

Check:

```txt
pom.xml
build.gradle
gradlew
mvnw
```

Prefer wrapper scripts when present:

```txt
./mvnw test
./gradlew test
```

### Docker

Check:

```txt
Dockerfile
docker-compose.yml
compose.yml
```

Only include Docker commands that are clearly supported.

### Task Runners

When `Makefile`, `justfile`, or `Taskfile.yml` exists, prefer documented tasks over manually assembled commands.

Examples:

```txt
make test
just dev
task build
```

Only include task commands that actually exist.

---

## Consistency Check

Before finalizing `AGENTS.md`, check for internal contradictions.

Look for:

- Different ports for the same service.
- Different package managers for the same subproject.
- Commands that reference missing directories.
- URLs that do not match startup commands.
- API proxy targets that do not match backend ports.
- Test commands that are not defined in package scripts, config, task runner files, or CI.
- Environment variables referenced in docs but not in examples or config.
- README commands that conflict with package scripts or CI.
- Existing agent instructions that contradict repository configuration.

If contradictions are found:

- Do not hide them.
- Do not silently normalize them.
- Add a short note in the final response.
- Add a `Known Configuration Notes` section in `AGENTS.md` when the contradiction affects future agent work.

Example:

```md
## Known Configuration Notes

- Backend startup commands use port `30001`.
- Some older documentation references port `8000`.
- Confirm the intended API proxy target before changing frontend request configuration.
```

---

## Existing AGENTS.md Update Policy

When updating an existing `AGENTS.md`:

1. Preserve correct project-specific information.
2. Remove stale or contradicted commands.
3. Replace vague rules with concrete rules.
4. Keep useful safety constraints.
5. Keep useful project-specific workflow details.
6. Do not rewrite the entire file unnecessarily.
7. Do not remove domain-specific instructions unless they are clearly obsolete.
8. Prefer a minimal diff unless the existing file is structurally poor.

Before changing existing content, identify:

```txt
Keep:
- Accurate commands
- Accurate architecture rules
- Accurate local URLs and ports
- Accurate environment notes
- Project-specific conventions
- Useful Git safety rules

Fix:
- Stale commands
- Conflicting ports
- Conflicting package managers
- Generic filler
- Missing testing instructions
- Missing safety rules
- Overly dense inline command formatting
- Overly long or duplicated sections

Remove:
- False claims
- One-off task instructions
- Personal preferences unrelated to the repo
- Deprecated workflows
- Secrets or sensitive values
```

---

## AGENTS.md Quality Bar

A good `AGENTS.md` should be:

- Specific to the repository.
- Clear enough for humans and agents.
- Short enough to stay useful.
- Accurate enough to execute.
- Stable across many tasks.
- Explicit about commands.
- Explicit about runtime requirements.
- Explicit about ports and local URLs when relevant.
- Explicit about architecture boundaries.
- Explicit about safety rules.
- Explicit about done criteria.

Target size:

```txt
100 to 300 lines for most repositories.
50 to 150 lines for small repositories.
```

Avoid files that are too long. Long instructions dilute important rules and may be truncated by tools.

---

## Anti-Patterns

Do not generate this kind of content:

```md
- Always write perfect code.
- Make sure everything is good.
- Follow best practices.
- Be smart and careful.
- This project is amazing and innovative.
```

Do not include:

```txt
- Long product requirements
- Full API documentation
- Full database schema
- Complete coding tutorials
- Temporary task plans
- Personal motivational text
- Duplicate README content
- Unverified commands
- Huge pasted documentation
- Real secrets from `.env` files
- Automatic Git commit rules unless explicitly requested
```

---

## Generated AGENTS.md Template

Use this template as a starting point.

Adapt it to the repository. Delete sections that do not apply.

````md
# AGENTS.md

## Project Overview

<Describe what this repository does, the main stack, and important constraints.>

## Repository Structure

```txt
<repo>/
├── <path>/                  # <purpose>
├── <path>/                  # <purpose>
└── <path>/                  # <purpose>
```

## Environment Requirements

### Backend Environment

- <Python version, for example Python 3.12+ when confirmed or detected>
- <Python package manager, for example uv>

### Frontend Environment

- <Node.js version, for example Node.js 18+ when confirmed or detected>
- <Node package manager, for example npm 9+>

### Environment Management Tools

| Tool | Manages | Install/Runtime Location | Purpose |
|------|---------|--------------------------|---------|
| <tool> | <runtime/deps> | <location> | <purpose> |

## Backend Development

### Install Dependencies

```bash
cd <backend-dir>
<install-command>
```

### Start Development Server

```bash
cd <backend-dir>
<start-command>
```

### Run Tests

```bash
cd <backend-dir>
<test-command>
```

### Run Lint

```bash
cd <backend-dir>
<lint-command>
```

## Frontend Development

### Install Dependencies

```bash
cd <frontend-dir>
<install-command>
```

### Start Development Server

```bash
cd <frontend-dir>
<start-command>
```

### Build Production Bundle

```bash
cd <frontend-dir>
<build-command>
```

### Run Lint Or Format

```bash
cd <frontend-dir>
<lint-or-format-command>
```

## Quick Start

Start the backend in one terminal:

```bash
cd <backend-dir>
<start-command>
```

Start the frontend in another terminal:

```bash
cd <frontend-dir>
<start-command>
```

## Local URLs

- Frontend: `<frontend-url>`
- Backend API: `<backend-url>`
- API docs: `<api-docs-url>`

## Environment Variables

Create the local environment file from the documented example.

Important variables:

- `<NAME>`: <purpose>
- `<NAME>`: <purpose>

Do not commit real secrets or private environment files.

## Database And Migrations

<Describe local database, migration commands, seed commands, and reset safety notes.>

## Code Style

- Follow existing project conventions.
- Keep changes minimal and localized.
- Prefer explicit types for public APIs.
- Avoid introducing unnecessary abstractions.
- Do not add new dependencies unless clearly justified.

## Architecture Rules

- Respect existing module boundaries.
- Keep dependency direction consistent with the current architecture.
- Put new code next to the closest existing equivalent.
- Do not introduce global mutable state unless explicitly justified.

## Testing Requirements

- Add or update tests for changed behavior.
- Run the smallest relevant test set during iteration.
- Run the full relevant suite before finalizing when practical.
- Do not remove or weaken tests to make checks pass.
- If tests cannot be run, explain why and provide the exact command that should be run manually.

## Documentation Rules

- Update documentation when changing architecture, public APIs, commands, configuration, or workflows.
- Keep README focused on human onboarding.
- Keep AGENTS.md focused on coding-agent execution rules.
- Put long-form design notes in the appropriate docs directory instead of AGENTS.md.

## Git Workflow Rules

- Check `git status --short` before risky edits and before final summary.
- Use file-level `git diff -- <path>` to inspect relevant changes.
- Do not run `git reset --hard`.
- Do not run broad destructive restore commands.
- Do not commit changes unless the user explicitly asks for a commit.
- When committing is requested:
  - Review relevant diffs first.
  - Stage only intended files.
  - Use a concise commit message that matches the actual changes.

## Safety Rules

- Never commit secrets, credentials, tokens, private URLs, or API keys.
- Do not copy values from real `.env` files into documentation.
- Do not modify production deployment files unless the task explicitly requires it.
- Do not rewrite git history or run destructive git commands unless explicitly requested.
- Do not delete user work or overwrite files without checking their contents.
- Do not delete or weaken tests to hide failures.
- Do not silently change public API behavior.
- Ask before adding new production dependencies.

## Definition of Done

A task is complete only when:

- The requested behavior is implemented.
- Relevant tests are added or updated.
- Relevant checks have been run, or a clear reason is given for why they could not be run.
- Documentation is updated when behavior, commands, configuration, or architecture changes.
- The final response summarizes:
  - What changed.
  - Which files changed.
  - Which commands were run.
  - Any known risks or follow-up work.

## Command Cheat Sheet

| Task | Command |
|------|---------|
| Install dependencies | `<command>` |
| Start development server | `<command>` |
| Run tests | `<command>` |
| Run lint | `<command>` |
| Build | `<command>` |
````

---

## Final Response Requirements

After generating or updating `AGENTS.md`, respond with:

```txt
Created/updated AGENTS.md.

Summary:
- <main change 1>
- <main change 2>
- <main change 3>

Detected commands:
- <command 1>
- <command 2>

Detected uncertainties:
- <uncertainty or missing information>

Tests/checks run:
- <command actually run, or "Not run: <reason>">
```

If no reliable commands were detected, say so directly.

Do not claim tests were run unless they were actually run.

Do not claim the repository uses a framework unless it was detected.

Do not claim a conflict was resolved unless the user confirmed the intended value or the repository made it unambiguous.

---

## Failure Handling

If the repository cannot be inspected, produce a conservative generic `AGENTS.md` and clearly mark unknowns.

Use wording like:

```md
The repository structure could not be fully detected. Follow existing patterns and verify commands before running them.
```

If commands are missing:

```md
- Test command: Not detected.
- Build command: Not detected.
- Lint command: Not detected.
```

If settings conflict:

```md
- Backend port: Conflicting references detected. Confirm whether the intended port is `30001` or `8000` before editing proxy or API client configuration.
```

Never fill missing information with guesses.

---

## Review Checklist

Before finalizing, check that the generated `AGENTS.md`:

- Contains real repository paths.
- Contains real commands or clearly marked unknowns.
- Uses fenced code blocks for executable commands.
- Uses command tables only as quick lookup.
- Does not duplicate the README.
- Does not contain long product requirements.
- Does not contain temporary task instructions.
- Does not expose secrets or private environment values.
- Contains environment requirements when detectable.
- Contains local URLs when detectable.
- Contains database notes when relevant.
- Contains Git safety rules.
- Contains safety rules.
- Contains testing rules.
- Contains a definition of done.
- Identifies command, port, package manager, or config conflicts when detected.
- Is concise enough for coding agents to use.
