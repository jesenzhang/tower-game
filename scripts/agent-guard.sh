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

echo "Pre-commit guard passed."
