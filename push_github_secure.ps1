param(
    [Parameter(Mandatory=$false)]
    [string]$RepoUrl = "https://github.com/YOUR_USERNAME/apex-sdi-roblox-private.git",
    [Parameter(Mandatory=$false)]
    [string]$Branch = "main",
    [Parameter(Mandatory=$false)]
    [string]$CommitMsg = "feat: update APEX SDI Roblox 12-tab script"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

if (-not (Test-Path ".gitignore")) {
    @"
APEX_KEYS.txt
apex_sdi_registry.json
.env
*.pem
*.key
"@ | Set-Content -Path ".gitignore" -Encoding UTF8
}

if (-not (Test-Path ".git")) {
    git init -b $Branch
}

git add .gitignore APEX_SDI_ROBLOX_12TABS.lua
$staged = git diff --cached --name-only
if ($staged -match "APEX_KEYS\.txt|\.env|\.pem|\.key") {
    Write-Error "CHAN PUSH: Phat hien file nhay cam trong danh sach staged!"
    exit 1
}

if (-not (git diff --cached --quiet)) {
    git commit -m $CommitMsg
}

$remotes = git remote
if ($remotes -contains "origin") {
    git remote set-url origin $RepoUrl
} else {
    git remote add origin $RepoUrl
}

git branch -M $Branch
git push -u origin $Branch
Write-Host "Hoan tat dua code len GitHub an toan!" -ForegroundColor Green
