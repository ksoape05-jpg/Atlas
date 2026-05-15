param(
    [string]$Remote = "origin",
    [string]$Branch = "main"
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
Set-Location $repoRoot

Write-Host "Atlas publish check" -ForegroundColor Cyan
git remote -v
git status --short

Write-Host ""
Write-Host "Staging Atlas source files, sample data, config, and tests." -ForegroundColor Cyan
git add `
    .gitignore `
    .streamlit/config.toml `
    .vscode/extensions.json `
    .vscode/settings.json `
    README.md `
    app.py `
    requirements.txt `
    data/.gitkeep `
    sample_data `
    scripts `
    tests `
    utils

$staged = git diff --cached --name-only
if (-not $staged) {
    Write-Host "No staged changes. Nothing to commit." -ForegroundColor Yellow
} else {
    Write-Host ""
    Write-Host "Staged files:" -ForegroundColor Cyan
    $staged
    git commit -m "Set Atlas as canonical app project"
}

Write-Host ""
Write-Host "Pushing $Branch to $Remote." -ForegroundColor Cyan
git push -u $Remote $Branch

Write-Host ""
Write-Host "Atlas is connected. Open this folder in VS Code and use Source Control normally." -ForegroundColor Green
