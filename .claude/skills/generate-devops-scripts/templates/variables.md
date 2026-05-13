# Script Variable Reference

This file defines all project-specific values that must be resolved before generating scripts.

## Project Identity

| Variable | Example | Source |
|----------|---------|--------|
| `PROJECT_NAME` | `workflow-engine` | `pyproject.toml` name, or directory name (kebab-case) |
| `PROJECT_DISPLAY_NAME` | `Workflow Engine` | Human-readable name for console output |
| `PROJECT_PACKAGE` | `workflow_engine` | Python package name (importable) |

## Backend

| Variable | Example | Source |
|----------|---------|--------|
| `BACKEND_DIR` | `backend` | Relative from project root |
| `BACKEND_ENTRY` | `python -m workflow_engine.serve_ui_api` | Entry point module path |
| `BACKEND_PORT` | `18901` | Default dev port |
| `BACKEND_HOST` | `0.0.0.0` | Default bind host (dev), `127.0.0.1` (test) |
| `PYTHON_VERSION` | `3.12` | `pyproject.toml` requires-python |
| `PYTHON_PKG_MGR` | `uv` | `uv.lock` → `uv`, `poetry.lock` → `poetry` |
| `BACKEND_RUN_CMD` | `uv run python -m workflow_engine.serve_ui_api` | Full command to start backend |
| `BACKEND_LOG_DIR` | `backend/logs` | Where the app writes its own log files |
| `BACKEND_LOG_PREFIX` | `local_test_` | Log file prefix from settings (e.g., `LOG_PREFIX` env var) |
| `BACKEND_HAS_FILE_LOGGING` | `true` | Whether the app uses RotatingFileHandler or similar |

## Frontend

| Variable | Example | Source |
|----------|---------|--------|
| `FRONTEND_DIR` | `frontend` | Relative from project root |
| `FRONTEND_PORT` | `18577` | `vite.config.ts` server.port |
| `FRONTEND_HOST` | `0.0.0.0` | Default bind host (dev), `127.0.0.1` (test) |
| `NODE_VERSION` | `20` | `package.json` engines, `.node-version` |
| `FRONTEND_START_CMD` | `npx vite --host HOST --port PORT` | From `package.json` `"dev"` script |
| `FRONTEND_BUILD_CMD` | `npm run build` | From `package.json` `"build"` script |

## Environment Variables

| Variable | Example | Source |
|----------|---------|--------|
| `ENV_PREFIX` | `WE_` | Backend settings module |
| `ENV_HOST_VAR` | `WE_HOST` | Host env var name |
| `ENV_PORT_VAR` | `WE_PORT` | Port env var name |
| `ENV_STORAGE_VAR` | `WE_STORAGE_TYPE` | Storage type env var name |
| `VITE_API_VAR` | `VITE_WORKFLOW_ENGINE_API_BASE` | Frontend API base URL env var |
| `VITE_WS_VAR` | `VITE_WORKFLOW_ENGINE_WS_BASE` | Frontend WS base URL env var |

## Storage

| Variable | Example | Source |
|----------|---------|--------|
| `DEFAULT_STORAGE` | `memory` | Backend settings default |
| `SQLITE_PATH` | `.tmp/workflow_engine/engine.db` | Backend settings default |
| `SQLITE_DIR` | `.tmp/workflow_engine` | Parent of SQLITE_PATH |
| `DB_FILE_NAME` | `engine.db` | Basename of SQLITE_PATH |

## Test Environment

| Variable | Example | Calculation |
|----------|---------|-------------|
| `TEST_BACKEND_PORT` | `28901` | `BACKEND_PORT + 10000` |
| `TEST_FRONTEND_PORT` | `28577` | `FRONTEND_PORT + 10000` |
| `TEST_SQLITE_PATH` | `.tmp/workflow_engine/engine.local_test.db` | SQLITE_PATH with `.local_test` suffix |
| `TEST_STORAGE` | `sqlite` | Always SQLite for test isolation |

## Supervisor

| Variable | Example | Source |
|----------|---------|--------|
| `SUPERVISOR_APP_NAME` | `workflow-engine` | Same as PROJECT_NAME |
| `SUPERVISOR_USER` | detected | `SUDO_USER` or `whoami` |
| `SUPERVISOR_APP_DIR` | detected | Project root absolute path |
| `SUPERVISOR_LOG_DIR` | `<app-dir>/logs` | Default |
