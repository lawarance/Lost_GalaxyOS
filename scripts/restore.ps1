# repo -> live system   (backs up live files as *.bak first)
# usage:  .\scripts\restore.ps1            -> everything
#         .\scripts\restore.ps1 glazewm    -> one entry by Name
param([string]$Only)
. "$PSScriptRoot\configs.ps1"

foreach ($c in $Configs) {
    if ($Only -and $c.Name -ne $Only) { continue }
    if (-not (Test-Path $c.Repo)) { Write-Host "  skip  $($c.Name) (not in repo)" -ForegroundColor DarkGray; continue }

    if (Test-Path $c.Live) {
        $bak = "$($c.Live).bak"
        if (Test-Path $bak) { Remove-Item $bak -Recurse -Force }
        Copy-Item $c.Live $bak -Recurse -Force
    }
    New-Item -ItemType Directory -Force -Path (Split-Path $c.Live -Parent) | Out-Null
    if ($c.Dir) {
        robocopy $c.Repo $c.Live /MIR /NFL /NDL /NJH /NJS /NP /XF .gitkeep | Out-Null
    } else {
        Copy-Item $c.Repo $c.Live -Force
    }
    # strip the "downloaded from internet" mark so scripts can run
    Get-ChildItem $c.Live -Recurse -File -ErrorAction SilentlyContinue | Unblock-File
    Write-Host "  restore  $($c.Name)" -ForegroundColor Green
}
