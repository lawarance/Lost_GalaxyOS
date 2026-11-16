# live system -> repo   (run before committing)
. "$PSScriptRoot\configs.ps1"

foreach ($c in $Configs) {
    if (-not (Test-Path $c.Live)) { Write-Host "  skip  $($c.Name) (not found)" -ForegroundColor DarkGray; continue }
    New-Item -ItemType Directory -Force -Path (Split-Path $c.Repo -Parent) | Out-Null
    if ($c.Dir) {
        robocopy $c.Live $c.Repo /MIR /NFL /NDL /NJH /NJS /NP /XF .gitkeep | Out-Null
    } else {
        Copy-Item $c.Live $c.Repo -Force
    }
    Write-Host "  sync  $($c.Name)" -ForegroundColor Magenta
}
Write-Host "`ndone -> now: git status" -ForegroundColor Cyan
