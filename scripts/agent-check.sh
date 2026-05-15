#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/.."

echo "=== Agent Quality Gate ==="

# 1. Conflict markers
echo "Checking for conflict markers..."
git diff --check 2>/dev/null || true

# 2. Godot-specific checks
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

# 3. JSON validation (if Python available)
if command -v python &>/dev/null || command -v python3 &>/dev/null; then
    PYTHON_CMD=$(command -v python3 &>/dev/null && echo "python3" || echo "python")
    echo "Validating JSON data files..."
    for f in $(find game/data -name '*.json' 2>/dev/null); do
        $PYTHON_CMD -m json.tool "$f" > /dev/null 2>&1 || {
            echo "ERROR: Invalid JSON detected: $f"
            exit 1
        }
    done
    echo "JSON validation passed."
else
    echo "WARNING: Python not available. Skipping JSON validation."
fi

echo "=== Quality gate passed ==="
