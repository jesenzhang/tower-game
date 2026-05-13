---
name: generate-devops-scripts
description: >-
  Generate a complete set of project operation scripts for any repository,
  including environment setup, service start/stop, service orchestration,
  local test isolation, log viewing, database management, and Linux
  Supervisor deployment. Use this skill when the user asks to create,
  update, or audit project scripts, devops scripts, operation scripts,
  or deployment scripts for a Python + Node.js fullstack project.
---

# Generate DevOps Scripts Skill

## Purpose

Generate a complete, consistent set of operation scripts for a Python backend + Node.js frontend project, covering the full lifecycle from environment setup to production deployment.

The generated scripts should provide:

- One-click environment installation (Python, uv, Node.js, nvm/fnm)
- Backend and frontend start/stop with foreground and background modes
- Unified service orchestration (start/stop/restart/status)
- Isolated local test environment (separate ports, SQLite storage)
- Port-based process management
- Log viewing with tail support
- Database management (backup/restore/status for SQLite)
- Linux Supervisor deployment with auto-generated configs and manage script
- README documentation for all scripts

## When To Use

Use this skill when the user asks to:

- Create project scripts, devops scripts, or operation scripts
- Generate deployment scripts for a fullstack project
- Scaffold a `scripts/` directory with start/stop/service management
- Set up Supervisor-managed deployment for a Python + Node project
- Create environment installation scripts
- Add database management scripts
- Audit or update existing operation scripts

## Core Principles

### 1. Dual-platform by default

Every script must have both a `.sh` (bash) and `.ps1` (PowerShell) version with matching behavior. The only exceptions are:

- `env_loader.sh` — bash-only shared environment loader (PowerShell scripts set PATH directly)
- `deploy_supervisor_service.sh` — Linux-only (Supervisor is not available on Windows)
- `show_logs.ps1` — PowerShell-only (bash users use `tail` directly)

### 2. Consistent patterns across all scripts

All scripts must follow these conventions:

- **Color logging**: `log_info` / `log_ok` / `log_warn` / `log_err` helpers in every bash script; `Write-Info` / `Write-OK` / `Write-Warn` / `Write-Err` in every PowerShell script.
- **Path resolution**: All scripts resolve paths relative to their own location (`SCRIPT_DIR` / `$ScriptDir`), never assume CWD.
- **UTF-8 encoding**: All PowerShell scripts set `[Console]::InputEncoding` / `OutputEncoding` to UTF-8.
- **Background mode**: Scripts support `--background` flag (bash: `nohup`; ps1: `Start-Process -WindowStyle Hidden`). **Never use `-NoNewWindow`** — it keeps the child process attached to the console and blocks the terminal.
- **Log directory**: Prefer the application's built-in file logging (e.g., Python `RotatingFileHandler` writing to `backend/logs/`) over `RedirectStandardOutput/RedirectStandardError`. When the app has its own logging to files, do NOT duplicate with `RedirectStandardOutput/Error` — they capture only the parent process stdout/stderr, missing child process output (e.g., uvicorn `--reload` spawns a reloader subprocess whose logs bypass the redirect).

### 3. Derive all values from the project

Do not guess commands, ports, or entry points. Inspect the project and derive:

- Backend start command from `pyproject.toml`, `main.py`, or existing scripts
- Frontend start command from `package.json` scripts
- Default ports from Vite config, backend settings, or existing documentation
- Storage type from backend settings or `.env` files
- Environment variable prefix from backend settings

## Information Gathering

Before generating any scripts, inspect the target project and collect:

### Required information

| Item | How to detect | Fallback |
|------|---------------|----------|
| Backend entry point | `pyproject.toml` scripts, `main.py`, existing startup scripts | Ask user |
| Backend host/port | Settings module, CLI defaults, existing scripts | `0.0.0.0:18901` |
| Frontend start command | `package.json` scripts (`"dev"`), Vite config | `npm run dev` |
| Frontend port | `vite.config.ts` `server.port`, existing scripts | `18577` |
| Python version | `pyproject.toml` `requires-python`, `.python-version` | `3.12+` |
| Node version | `package.json` `engines`, `.node-version` | `20+` |
| Package manager | `uv.lock` → uv, `poetry.lock` → poetry | uv |
| Storage type | Settings module, `.env` | `memory` |
| Env var prefix | Settings module | Detect from code |
| Project name | `pyproject.toml` name, directory name | Directory name |

### Files to inspect

- `pyproject.toml` — Python version, dependencies, entry points
- `backend/pyproject.toml` — Backend-specific config
- `frontend/package.json` — Frontend scripts, Node version
- `frontend/vite.config.*` — Dev server port, proxy config
- `backend/**/settings.py` or `config.py` — Environment variables, ports
- `backend/**/serve_*.py` or `main.py` — Backend entry points
- `Dockerfile` — Exposed ports, start commands
- `CLAUDE.md` / `AGENTS.md` — Documented commands and ports
- `scripts/` — Existing scripts to preserve or update

### Questions to ask (only when not detectable)

Ask at most 5 focused questions:

1. Backend start command (if not detectable from code)
2. Backend default port (if conflicting or missing)
3. Frontend default port (if conflicting or missing)
4. Environment variable prefix (if not detectable)
5. Storage type for production deployment (memory vs sqlite vs other)

## Script Inventory

Generate the following scripts, adapted to the target project:

### Shared utilities

| Script | Purpose |
|--------|---------|
| `env_loader.sh` | Load nvm and uv into PATH (sourced by all bash scripts) |

### Environment setup

| Script | Purpose |
|--------|---------|
| `install_env.sh` / `install_env.ps1` | One-click: Python + uv + Node.js (nvm/fnm) + backend deps + frontend deps |

### Service management

| Script | Purpose |
|--------|---------|
| `start_backend.sh` / `start_backend.ps1` | Start backend (foreground/background), configurable host/port/storage |
| `start_frontend.sh` / `start_frontend.ps1` | Start frontend (foreground/background), configurable host/port |
| `stop_port.sh` / `stop_port.ps1` | Kill process by port number (cross-platform) |
| `service.sh` / `service.ps1` | Unified start/stop/restart/status for both services |
| `local_test.sh` / `local_test.ps1` | Isolated test environment (separate ports, SQLite storage) |

### Operations

| Script | Purpose |
|--------|---------|
| `show_logs.ps1` | View/tail service logs |
| `db_manage.sh` / `db_manage.ps1` | SQLite database management (backup/restore/status/verify/init) |

### Deployment

| Script | Purpose |
|--------|---------|
| `deploy_supervisor_service.sh` | Deploy as Supervisor-managed Linux service |
| `supervisor/<project-name>.conf` | Supervisor config template |

### Documentation

| File | Purpose |
|------|---------|
| `scripts/README.md` | Complete usage documentation |

## Script Generation Rules

### start_backend

- Bash: `exec uv run <backend-start-command>` in foreground, `nohup ... &` in background
- PowerShell: direct `& uv run ...` in foreground, `Start-Process -WindowStyle Hidden` in background
- Must accept `--host`, `--port`, `--background`, `--reload` flags
- `--reload` is for development/testing only — the `service`/`local_test` scripts pass `--reload`, production scripts do not
- When the backend app has built-in file logging (e.g., `RotatingFileHandler`), background mode should NOT use `RedirectStandardOutput/RedirectStandardError` — let the app write to its own log files. Display those log file paths in the startup message instead.
- When the backend app lacks built-in file logging, use `RedirectStandardOutput`/`RedirectStandardError` as a fallback.
- Must accept storage-specific flags (e.g., `--storage sqlite`)
- Must export relevant environment variables before starting
- Must validate that `uv` and backend directory exist before starting

### start_frontend

- Bash: `exec npx vite --host --port` in foreground, `nohup ... &` in background
- PowerShell: `& npm run dev -- --host --port` in foreground, `Start-Process -WindowStyle Hidden` in background
- Must disable ANSI colors in background mode (`NO_COLOR=1`, `FORCE_COLOR=0`)
- Must accept `--host`, `--port`, `--background` flags
- Must validate that `npm` and frontend directory exist before starting
- Background mode: use `RedirectStandardOutput` and `RedirectStandardError` pointing to **separate** files (PowerShell does not allow both to the same path). Vite outputs to both streams.

### stop_port

- Bash: try `lsof`, then `ss`, then `netstat` (Git Bash fallback with `taskkill`). Send SIGTERM, wait 1s, then SIGKILL.
- PowerShell: `Get-NetTCPConnection` → `Stop-Process -Force`
- **Must kill entire process tree**, not just the listening process. When `--reload` is used, uvicorn spawns a reloader subprocess — killing only the parent leaves orphan children. Use `Get-CimInstance Win32_Process` to find child processes recursively.
- **PowerShell caveat**: `$pid` is a built-in read-only variable (current process ID). Never use `$pid` as a loop variable — use `$procId` or `$targetPid` instead.

### service

- Wraps `start_backend`, `start_frontend`, and `stop_port` scripts
- Actions: `start`, `stop`, `restart`, `status`
- Must support `--backend-only` and `--frontend-only` flags
- Status must show RUNNING/STOPPED with PID

### local_test

- Same as `service` but with different defaults:
  - Isolated ports (e.g., dev ports + 10000)
  - `WE_STORAGE_TYPE=sqlite` (or project equivalent)
  - Separate SQLite DB path (e.g., `engine.local_test.db`)
  - Bind to `127.0.0.1` only
  - Set Vite API proxy env vars
  - **Must pass `--reload` to backend** for auto-reloading during development

### db_manage

- Simple SQLite operations using native `sqlite3` CLI and/or Python
- Commands: `backup`, `restore`, `list-backups`, `status`, `verify`, `init`
- Backup: `cp` + integrity check via `PRAGMA integrity_check`
- Restore: confirmation prompt, pre-restore safety copy, then `cp`
- If the project uses alembic, also add: `migrate`, `migrate-create`, `migrate-history`, `stamp`

### deploy_supervisor_service

- Auto-detect app directory, user, uv/npm/npx paths
- Auto-install Supervisor via apt/yum/dnf
- Generate Supervisor config files for backend + frontend + group
- Generate management script at `/usr/local/bin/manage-<name>.sh`
- Support storage type configuration via environment variables in config
- Inject frontend Vite env vars (API base, WS base) in Supervisor config

### install_env

- Check Python 3.12+ (do not auto-install, just validate)
- Auto-install uv via official installer
- Auto-install Node.js via nvm (bash) or fnm (PowerShell) when missing or too old
- Run `uv sync` in backend directory
- Run `npm install` in frontend directory

### README

- Table of all scripts with purpose
- Quick start sections for each major workflow
- Port table (dev, test, env vars)
- Storage type table
- Supervisor deployment section

## Template Placeholders

When generating scripts from templates, replace these placeholders with project-specific values:

| Placeholder | Source |
|-------------|--------|
| `<PROJECT_NAME>` | Project directory name or `pyproject.toml` name |
| `<PROJECT_DISPLAY_NAME>` | Human-readable name for log messages |
| `<BACKEND_ENTRY>` | e.g., `python -m workflow_engine.serve_ui_api` or `uvicorn main:app` |
| `<BACKEND_PORT>` | Default backend port |
| `<FRONTEND_PORT>` | Default frontend port |
| `<TEST_BACKEND_PORT>` | Isolated test backend port (dev + 10000) |
| `<TEST_FRONTEND_PORT>` | Isolated test frontend port (dev + 10000) |
| `<ENV_PREFIX>` | Environment variable prefix (e.g., `WE_`) |
| `<STORAGE_TYPE>` | Default storage type |
| `<SQLITE_PATH>` | Default SQLite DB path |
| `<PYTHON_VERSION>` | Minimum Python version |
| `<NODE_VERSION>` | Minimum/installed Node.js version |
| `<VITE_API_ENV>` | Frontend API base env var name |
| `<VITE_WS_ENV>` | Frontend WS base env var name |

## Output Location

All scripts go into the project's `scripts/` directory:

```
scripts/
├── README.md
├── env_loader.sh
├── install_env.sh
├── install_env.ps1
├── start_backend.sh
├── start_backend.ps1
├── start_frontend.sh
├── start_frontend.ps1
├── stop_port.sh
├── stop_port.ps1
├── service.sh
├── service.ps1
├── local_test.sh
├── local_test.ps1
├── show_logs.ps1
├── db_manage.sh
├── db_manage.ps1
├── deploy_supervisor_service.sh
└── supervisor/
    └── <project-name>.conf
```

## Operating Procedure

1. **Inspect** the target project structure, config files, and existing scripts.
2. **Collect** all required information (entry points, ports, env vars, storage).
3. **Ask** focused questions only for values that cannot be reliably detected.
4. **Generate** all scripts adapted to the specific project.
5. **Verify** internal consistency (ports match, commands match, env vars match).
6. **Generate** `scripts/README.md` with complete documentation.
7. **Report** summary of generated scripts, detected values, and any uncertainties.

## Consistency Checks

Before finalizing, verify:

- Backend port in `start_backend` matches `service` and `local_test` offsets
- Frontend port in `start_frontend` matches `service` and `local_test` offsets
- Backend entry command matches actual project code
- Environment variable names match backend settings module
- Vite API proxy env vars in `start_frontend` / Supervisor config target the correct backend port
- `local_test` uses isolated ports (not overlapping with dev ports)
- `local_test` and `service` pass `--reload` to backend; production scripts (`deploy_supervisor_service`) do not
- `db_manage` SQLite path matches backend default path
- `deploy_supervisor_service` app name matches Supervisor config filename
- README documents all generated scripts with correct ports and commands
- `stop_port` uses process tree cleanup (not just the listening process)
- PowerShell scripts never use `$pid` as a variable name

## Quality Bar

Generated scripts must be:

- **Executable**: Every script should work without modification after environment setup
- **Idempotent**: Running `install_env` or `start_backend` multiple times should not break
- **Safe**: Destructive operations (`restore`, `stop_port`) must prompt for confirmation
- **Consistent**: Same flags, same port defaults, same env var names across all scripts
- **Self-documenting**: Every script has `--help` and usage messages
- **UTF-8 clean**: No encoding issues on Windows (PowerShell) or Linux (bash)

## Final Response

After generating scripts, respond with:

```
Generated <N> scripts for <PROJECT_NAME>.

Detected project configuration:
- Backend entry: <command>
- Backend port: <port>
- Frontend port: <port>
- Storage: <type>
- Env prefix: <prefix>

Scripts created:
- <list of scripts with one-line description>

Uncertainties:
- <any values that could not be detected or that conflict>
```
