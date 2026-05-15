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
    gh issue create --title "${TYPE}: ${DESCRIPTION}" --body "## Goal
${DESCRIPTION}

## Acceptance Criteria
- [ ] To be defined

## Affected Systems
- TBD

## Dependencies
- None

## Quality Gate
- [ ] Tests pass (or manual verification documented)
- [ ] ./scripts/agent-check.sh passes
- [ ] No unrelated changes" --label "phase-4,vertical-slice"
    echo "Issue created. Check the URL above."
else
    echo "gh CLI not available. Branch created without issue."
fi

echo "Ready to work on: ${BRANCH_NAME}"
