#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"

[Console]::InputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

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

# 4. Block .import files
$stagedImports = git diff --cached --name-only --diff-filter=ACM '*.import' 2>$null
if ($stagedImports) {
    Write-Host "ERROR: .import files detected. Add '*.import' to .gitignore." -ForegroundColor Red
    exit 1
}

# 5. Block .godot/ directory
$stagedGodot = git diff --cached --name-only --diff-filter=ACM '.godot/*' 2>$null
if ($stagedGodot) {
    Write-Host "ERROR: .godot/ directory detected. Add '.godot/' to .gitignore." -ForegroundColor Red
    exit 1
}

Write-Host "Pre-commit guard passed." -ForegroundColor Green
