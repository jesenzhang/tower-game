#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location (Join-Path $ScriptDir "..")

[Console]::InputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "=== Agent Quality Gate ===" -ForegroundColor Cyan

# 1. Conflict markers
Write-Host "Checking for conflict markers..."
git diff --check 2>$null

# 2. Godot-specific checks
Write-Host "Checking for .import files in staging..."
$stagedImports = git diff --cached --name-only --diff-filter=ACM '*.import' 2>$null
if ($stagedImports) {
    Write-Host "ERROR: .import files detected in staging. Remove them." -ForegroundColor Red
    $stagedImports | ForEach-Object { Write-Host "  $_" }
    exit 1
}

Write-Host "Checking for .godot/ directory in staging..."
$stagedGodot = git diff --cached --name-only --diff-filter=ACM '.godot/*' 2>$null
if ($stagedGodot) {
    Write-Host "ERROR: .godot/ directory detected in staging. Remove it." -ForegroundColor Red
    $stagedGodot | ForEach-Object { Write-Host "  $_" }
    exit 1
}

# 3. JSON validation (if Python available)
$pythonCmd = $null
if (Get-Command python -ErrorAction SilentlyContinue) {
    $pythonCmd = "python"
} elseif (Get-Command python3 -ErrorAction SilentlyContinue) {
    $pythonCmd = "python3"
}

if ($pythonCmd) {
    Write-Host "Validating JSON data files..."
    $jsonFiles = Get-ChildItem -Path "game\data" -Filter "*.json" -Recurse -ErrorAction SilentlyContinue
    foreach ($f in $jsonFiles) {
        & $pythonCmd -m json.tool $f.FullName > $null 2>&1
        if ($LASTEXITCODE -ne 0) {
            Write-Host "ERROR: Invalid JSON detected: $($f.FullName)" -ForegroundColor Red
            exit 1
        }
    }
    Write-Host "JSON validation passed." -ForegroundColor Green
} else {
    Write-Host "WARNING: Python not available. Skipping JSON validation." -ForegroundColor Yellow
}

Write-Host "=== Quality gate passed ===" -ForegroundColor Green
