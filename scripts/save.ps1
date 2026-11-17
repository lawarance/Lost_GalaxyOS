# sync live configs -> repo, commit, push
# usage:  .\scripts\save.ps1 -m "glazewm: borders"
param(
    [Parameter(Mandatory = $true)]
    [Alias('m')]
    [string]$Message
)

$Repo = Split-Path $PSScriptRoot -Parent
Push-Location $Repo
try {
    & "$PSScriptRoot\sync.ps1"

    git add -A
    if (-not (git status --porcelain)) {
        Write-Host "nothing changed, nothing to commit" -ForegroundColor DarkGray
        return
    }

    Write-Host "`nchanges:" -ForegroundColor Cyan
    git status --short

    git commit -m $Message
    if ($LASTEXITCODE -ne 0) { Write-Host "commit failed" -ForegroundColor Red; return }

    git push
    if ($LASTEXITCODE -ne 0) { Write-Host "push failed (commit is saved locally)" -ForegroundColor Red; return }

    Write-Host "`n✦ saved + pushed: $Message" -ForegroundColor Magenta
}
finally {
    Pop-Location
}
