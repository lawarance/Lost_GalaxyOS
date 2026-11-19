# repo -> live system   (backs up live files as *.bak first)
# usage:  .\scripts\restore.ps1              -> everything
#         .\scripts\restore.ps1 glazewm      -> one entry by Name
#         .\scripts\restore.ps1 bashrc -Debug-> show every step (find where it hangs)
param([string]$Only, [switch]$Debug)
. "$PSScriptRoot\configs.ps1"

function Step($msg) { if ($Debug) { Write-Host "      · $msg" -ForegroundColor DarkGray } }

foreach ($c in $Configs) {
    if ($Only -and $c.Name -ne $Only) { continue }
    if (-not (Test-Path -LiteralPath $c.Repo)) { Write-Host "  skip     $($c.Name) (not in repo)" -ForegroundColor DarkGray; continue }
    try {
        if ($c.Dir) {
            Step "backup dir"
            if (Test-Path -LiteralPath $c.Live) {
                $bak = "$($c.Live).bak"
                if (Test-Path -LiteralPath $bak) { Remove-Item -LiteralPath $bak -Recurse -Force }
                Copy-Item -LiteralPath $c.Live $bak -Recurse -Force
            }
            Step "mirror dir"
            robocopy $c.Repo $c.Live /MIR /NFL /NDL /NJH /NJS /NP /R:1 /W:1 /XF .gitkeep | Out-Null
            Step "unblock"
            Get-ChildItem -LiteralPath $c.Live -Recurse -File -ErrorAction SilentlyContinue | Unblock-File
        } else {
            $dir = Split-Path $c.Live -Parent
            Step "ensure folder $dir"
            if (-not (Test-Path -LiteralPath $dir)) { New-Item -ItemType Directory -Path $dir | Out-Null }
            if (Test-Path -LiteralPath $c.Live) {
                Step "backup file"
                [IO.File]::Copy($c.Live, "$($c.Live).bak", $true)
            }
            Step "copy file"
            [IO.File]::Copy((Resolve-Path -LiteralPath $c.Repo).Path, $c.Live, $true)
            Step "unblock"
            Unblock-File -LiteralPath $c.Live -ErrorAction SilentlyContinue
        }
        Write-Host "  restore  $($c.Name)" -ForegroundColor Green
    } catch {
        Write-Host "  FAILED   $($c.Name): $($_.Exception.Message)" -ForegroundColor Red
    }
}
