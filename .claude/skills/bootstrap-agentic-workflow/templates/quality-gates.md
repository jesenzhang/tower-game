# Quality Gates Template

Templates for `scripts/agent-check.sh`, `scripts/agent-check.ps1`, `scripts/agent-guard.sh`, `scripts/agent-guard.ps1`, `scripts/create-task.sh`, `.husky/pre-commit`, and `.github/workflows/ci.yml`.

## Generation Rules

1. Generate both `.sh` and `.ps1` variants for all scripts (dual-platform).
2. Only include checks for commands that were actually detected. Never fabricate commands.
3. If no commands were detected, generate a minimal version that only checks git diff.
4. CI platform is determined by `CI_PLATFORM` variable.

---

## agent-check.sh

```bash
#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/.."

echo "=== Agent Quality Gate ==="

# 1. Conflict markers
echo "Checking for conflict markers..."
git diff --check 2>/dev/null || true

{{CHECKS_BLOCK}}

echo "=== Quality gate passed ==="
```

### CHECKS_BLOCK Generation

For each detected command, add a check:

```bash
# Lint
echo "Running lint..."
{{LINT_COMMAND}}
```

Available check types:

| Variable | Check Command | Include When |
|---|---|---|
| `LINT_COMMAND` | `echo "Running lint..." && {{LINT_COMMAND}}` | Detected |
| `FORMAT_COMMAND` | `echo "Checking formatting..." && {{FORMAT_COMMAND}} --check` (or as-is if check flag included) | Detected |
| `TYPECHECK_COMMAND` | `echo "Running typecheck..." && {{TYPECHECK_COMMAND}}` | Detected |
| `TEST_COMMAND` | `echo "Running tests..." && {{TEST_COMMAND}}` | Detected |
| `BUILD_COMMAND` | `echo "Running build..." && {{BUILD_COMMAND}}` | Detected |

### Godot-Specific Checks

If `PROJECT_TYPE` is "Godot":

```bash
# Godot-specific checks
echo "Checking for .import files in staging..."
staged_imports=$(git diff --cached --name-only --diff-filter=ACM '*.import' 2>/dev/null || true)
if [ -n "$staged_imports" ]; then
    echo "ERROR: .import files detected in staging. Remove them."
    echo "$staged_imports"
    exit 1
fi

echo "Checking for .godot/ directory in staging..."
staged_godot=$(git diff --cached --name-only --diff-filter=ACM '.godot/*' 2>/dev/null || true)
if [ -n "$staged_godot" ]; then
    echo "ERROR: .godot/ directory detected in staging. Remove it."
    echo "$staged_godot"
    exit 1
fi

{{JSON_VALIDATION_IF_PYTHON_AVAILABLE}}
```

JSON validation (if Python is available):

```bash
echo "Validating JSON data files..."
find game/data -name '*.json' -exec python -m json.tool {} > /dev/null \; 2>&1 || {
    echo "ERROR: Invalid JSON detected in game/data/"
    exit 1
}
```

### Minimal Version (No Commands Detected)

```bash
echo "=== Agent Quality Gate ==="

echo "Checking for conflict markers..."
git diff --check 2>/dev/null || true

echo "WARNING: No lint/test/format commands detected."
echo "Only basic git checks are running."
echo "Consider configuring lint and test tools for stronger quality gates."

echo "=== Quality gate passed (minimal) ==="
```

---

## agent-check.ps1

PowerShell equivalent of agent-check.sh:

```powershell
#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location (Join-Path $ScriptDir "..")

Write-Host "=== Agent Quality Gate ===" -ForegroundColor Cyan

# 1. Conflict markers
Write-Host "Checking for conflict markers..."
git diff --check 2>$null

{{CHECKS_BLOCK_PS}}

Write-Host "=== Quality gate passed ===" -ForegroundColor Green
```

PowerShell check format:

```powershell
# Lint
Write-Host "Running lint..."
{{LINT_COMMAND}}
if ($LASTEXITCODE -ne 0) { Write-Host "ERROR: Lint failed" -ForegroundColor Red; exit 1 }
```

---

## agent-guard.sh

```bash
#!/usr/bin/env bash
# Pre-commit guard: blocks problematic commits
set -euo pipefail

echo "Running pre-commit guard..."

# 1. Block conflict markers
if git diff --cached | grep -qE '^(<<<<<<<|=======|>>>>>>>)'; then
    echo "ERROR: Conflict markers detected. Resolve conflicts before committing."
    exit 1
fi

# 2. Block .env files
staged_env=$(git diff --cached --name-only --diff-filter=ACM '.env*' 2>/dev/null || true)
if [ -n "$staged_env" ]; then
    echo "ERROR: .env files detected in staging. Remove them."
    echo "$staged_env"
    exit 1
fi

# 3. Block secrets
staged_secrets=$(git diff --cached --name-only --diff-filter=ACM '*secret*' '*credential*' '*password*' 2>/dev/null || true)
if [ -n "$staged_secrets" ]; then
    echo "ERROR: Potential secret files detected in staging:"
    echo "$staged_secrets"
    exit 1
fi

{{PROJECT_TYPE_GUARD_CHECKS}}

echo "Pre-commit guard passed."
```

### Godot-Specific Guard Checks

```bash
# 4. Block .import files
staged_imports=$(git diff --cached --name-only --diff-filter=ACM '*.import' 2>/dev/null || true)
if [ -n "$staged_imports" ]; then
    echo "ERROR: .import files detected. Add '*.import' to .gitignore."
    exit 1
fi

# 5. Block .godot/ directory
staged_godot=$(git diff --cached --name-only --diff-filter=ACM '.godot/*' 2>/dev/null || true)
if [ -n "$staged_godot" ]; then
    echo "ERROR: .godot/ directory detected. Add '.godot/' to .gitignore."
    exit 1
fi
```

---

## agent-guard.ps1

```powershell
#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"

Write-Host "Running pre-commit guard..." -ForegroundColor Cyan

# 1. Block conflict markers
$diff = git diff --cached 2>$null
if ($diff -match '^(<<<<<<<|=======|>>>>>>>)') {
    Write-Host "ERROR: Conflict markers detected. Resolve conflicts before committing." -ForegroundColor Red
    exit 1
}

# 2. Block .env files
$stagedEnv = git diff --cached --name-only --diff-filter=ACM '.env*' 2>$null
if ($stagedEnv) {
    Write-Host "ERROR: .env files detected in staging:" -ForegroundColor Red
    $stagedEnv | ForEach-Object { Write-Host "  $_" }
    exit 1
}

# 3. Block secrets
$stagedSecrets = git diff --cached --name-only --diff-filter=ACM '*secret*' '*credential*' '*password*' 2>$null
if ($stagedSecrets) {
    Write-Host "ERROR: Potential secret files detected:" -ForegroundColor Red
    $stagedSecrets | ForEach-Object { Write-Host "  $_" }
    exit 1
}

{{PROJECT_TYPE_GUARD_CHECKS_PS}}

Write-Host "Pre-commit guard passed." -ForegroundColor Green
```

---

## create-task.sh

```bash
#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/.."

if [ $# -lt 2 ]; then
    echo "Usage: ./scripts/create-task.sh <type> <description>"
    echo "Types: feature, fix, refactor, docs"
    echo "Example: ./scripts/create-task.sh feature add-enemy-spawn"
    exit 1
fi

TYPE="$1"
DESCRIPTION="$2"
BRANCH_NAME="${TYPE}/${DESCRIPTION}"

# Create branch
echo "Creating branch: ${BRANCH_NAME}"
git checkout -b "$BRANCH_NAME" 2>/dev/null || {
    echo "ERROR: Could not create branch. Check git status."
    exit 1
}

# Create issue if gh is available
if command -v gh &>/dev/null; then
    echo "Creating GitHub issue..."
    ISSUE_TEMPLATE=$(cat "$SCRIPT_DIR/../docs/agents/issue-lifecycle.md" | sed -n '/^## Issue Template$/,/^## /p' | head -n -1 | tail -n +2)
    gh issue create --title "${TYPE}: ${DESCRIPTION}" --body "$ISSUE_TEMPLATE" --label "phase-4,vertical-slice"
    echo "Issue created. Check the URL above."
else
    echo "gh CLI not available. Branch created without issue."
fi

echo "Ready to work on: ${BRANCH_NAME}"
```

---

## .husky/pre-commit

```bash
#!/usr/bin/env bash
# Pre-commit hook: run quality gate
set -euo pipefail

echo "Running pre-commit checks..."

# Run guard first
./scripts/agent-guard.sh

# Run full quality gate
./scripts/agent-check.sh
```

**Setup note**: After generating this file, the user needs to run:
```bash
npx husky install
```

If husky is not installed:
```bash
npm install --save-dev husky
npx husky install
npx husky add .husky/pre-commit "./scripts/agent-guard.sh && ./scripts/agent-check.sh"
```

---

## .github/workflows/ci.yml

```yaml
name: CI

on:
  pull_request:
  push:
    branches: [main, develop]

jobs:
  quality:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

{{SETUP_STEPS}}

      - name: Quality Gate
        run: |
          chmod +x scripts/agent-check.sh
          ./scripts/agent-check.sh
```

### SETUP_STEPS Generation

#### Godot
```yaml
      - name: Validate JSON data files
        run: |
          find game/data -name '*.json' -exec python3 -m json.tool {} > /dev/null \;
```

#### Python+Node
```yaml
      - uses: actions/setup-python@v5
        with:
          python-version: '{{PYTHON_VERSION}}'
      - uses: actions/setup-node@v4
        with:
          node-version: '{{NODE_VERSION}}'
      - name: Install backend dependencies
        run: cd backend && pip install -r requirements.txt
      - name: Install frontend dependencies
        run: cd frontend && npm ci
```

#### Node only
```yaml
      - uses: actions/setup-node@v4
        with:
          node-version: '{{NODE_VERSION}}'
      - run: npm ci
```

#### Rust
```yaml
      - uses: actions-rust-lang/setup-rust-toolchain@v1
      - run: cargo clippy -- -D warnings
      - run: cargo test
```

#### Go
```yaml
      - uses: actions/setup-go@v5
        with:
          go-version: '{{GO_VERSION}}'
      - run: go vet ./...
      - run: go test ./...
```

---

## .gitignore Template

Generate only if `.gitignore` does not exist. Append to existing if it does.

### Universal
```
# Environment
.env
.env.*
!.env.example

# IDE
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db
```

### Godot
```
# Godot
.godot/
*.import
export_presets.cfg
```

### Python+Node
```
# Python
__pycache__/
*.pyc
.venv/
venv/

# Node
node_modules/
dist/
.next/
```

### Rust
```
# Rust
target/
Cargo.lock
```

### Go
```
# Go
bin/
```
