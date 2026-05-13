# Generation Checklist

Use this checklist to verify generated scripts before delivery.

## Pre-generation

- [ ] Inspected `pyproject.toml` for Python version and entry points
- [ ] Inspected `package.json` for Node version and scripts
- [ ] Inspected backend settings module for ports and env vars
- [ ] Inspected `vite.config.*` for frontend port
- [ ] Inspected existing `scripts/` directory for scripts to preserve
- [ ] Inspected `CLAUDE.md` / `AGENTS.md` for documented commands
- [ ] Collected all variables from `variables.md`
- [ ] Asked user for any undetectable values

## Port consistency

- [ ] `start_backend` default port matches project config
- [ ] `start_frontend` default port matches vite config
- [ ] `service` uses same default ports as individual scripts
- [ ] `local_test` uses test ports (dev + 10000) that don't overlap
- [ ] `deploy_supervisor_service` uses dev ports
- [ ] `supervisor/<name>.conf` uses dev ports
- [ ] Frontend VITE env vars in all scripts target correct backend port

## Command consistency

- [ ] Backend start command in `start_backend` matches actual project entry point
- [ ] Backend start command in `service` calls `start_backend` correctly
- [ ] Backend start command in `deploy_supervisor_service` matches `start_backend`
- [ ] Backend start command in `supervisor/<name>.conf` matches `deploy_supervisor_service`
- [ ] Frontend start command in `start_frontend` matches package.json dev script
- [ ] Frontend start command in `service` calls `start_frontend` correctly
- [ ] Frontend start command in `deploy_supervisor_service` matches `start_frontend`

## Environment variable consistency

- [ ] All scripts use same env prefix
- [ ] `start_backend` exports correct env vars
- [ ] `local_test` sets `WE_STORAGE_TYPE=sqlite` (or equivalent)
- [ ] `local_test` sets correct Vite env vars
- [ ] `deploy_supervisor_service` injects all required env vars
- [ ] `supervisor/<name>.conf` environment= line has all required vars

## Feature completeness

- [ ] All scripts have `--help` / usage
- [ ] All scripts have color logging helpers
- [ ] All scripts resolve paths from own location
- [ ] All PowerShell scripts set UTF-8 encoding
- [ ] Background mode works in both bash and PowerShell
- [ ] PowerShell background uses `-WindowStyle Hidden` (not `-NoNewWindow`)
- [ ] `stop_port` has cross-platform fallbacks (lsof/ss/netstat/taskkill)
- [ ] `stop_port` kills entire process tree (handles uvicorn --reload subprocess)
- [ ] `stop_port` does NOT use `$pid` as a variable name (PowerShell reserved)
- [ ] `start_backend` accepts `--reload` flag; `local_test`/`service` pass it, production does not
- [ ] `start_backend` background mode does NOT use `RedirectStandardOutput/Error` when app has built-in file logging
- [ ] `start_frontend` background mode uses separate files for stdout and stderr redirects
- [ ] `db_manage` has all required subcommands
- [ ] `install_env` checks Python, installs uv, installs Node, runs sync+install
- [ ] `README.md` documents all scripts with correct examples

## Safety

- [ ] `db_manage restore` has confirmation prompt
- [ ] `db_manage restore` creates pre-restore safety copy
- [ ] `install_env` does not auto-install Python (validates only)
- [ ] `deploy_supervisor_service` requires root/sudo
- [ ] No scripts hardcode secrets or credentials
- [ ] `local_test` binds to `127.0.0.1` only
