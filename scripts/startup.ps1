# ✦ Lost Galaxy — autostart: GlazeWM (starts YASB), thide, Flow Launcher
# usage: .\scripts\startup.ps1           -> creates shortcuts in the Startup folder + starts everything now
#        .\scripts\startup.ps1 -Remove   -> removes the shortcuts
param([switch]$Remove)

$startup = [Environment]::GetFolderPath("Startup")
$ws = New-Object -ComObject WScript.Shell

function Find-Exe([string[]]$candidates) {
    foreach ($c in $candidates) {
        if (-not $c) { continue }
        $cmd = Get-Command $c -ErrorAction SilentlyContinue
        if ($cmd) { return $cmd.Source }
        if (Test-Path $c) { return (Resolve-Path $c).Path }
    }
    return $null
}

$apps = @(
    @{ Name = "LG GlazeWM"; Args = "start"; Exe = Find-Exe @(
        "glazewm", "$env:ProgramFiles\glzr.io\GlazeWM\glazewm.exe", "$env:LOCALAPPDATA\Programs\GlazeWM\glazewm.exe") }
    @{ Name = "LG thide"; Args = "start"; Exe = Find-Exe @(
        "thide", "$env:LOCALAPPDATA\Programs\thide\thide.exe") }
    @{ Name = "LG Flow Launcher"; Args = ""; Exe = Find-Exe @(
        "$env:LOCALAPPDATA\FlowLauncher\Flow.Launcher.exe", "$HOME\scoop\apps\flow-launcher\current\Flow.Launcher.exe", "Flow.Launcher") }
)

foreach ($a in $apps) {
    $lnk = Join-Path $startup "$($a.Name).lnk"
    if ($Remove) { Remove-Item $lnk -ErrorAction SilentlyContinue; Write-Host "  removed $($a.Name)"; continue }
    if (-not $a.Exe) { Write-Host "  NOT FOUND  $($a.Name) — tell Claude where it's installed" -ForegroundColor Red; continue }
    $s = $ws.CreateShortcut($lnk); $s.TargetPath = $a.Exe; $s.Arguments = $a.Args
    $s.WorkingDirectory = Split-Path $a.Exe; $s.WindowStyle = 7; $s.Save()
    Write-Host "  autostart  $($a.Name)  ->  $($a.Exe) $($a.Args)" -ForegroundColor Magenta
    # start it now if it's not running
    $proc = [IO.Path]::GetFileNameWithoutExtension($a.Exe)
    if (-not (Get-Process $proc -ErrorAction SilentlyContinue)) {
        if ($a.Args) { Start-Process $a.Exe -ArgumentList $a.Args -WindowStyle Hidden -ErrorAction SilentlyContinue }
        else         { Start-Process $a.Exe -ErrorAction SilentlyContinue }
    }
}
if (-not $Remove) { Write-Host "`n✦ done — these start at every login (folder: shell:startup)" -ForegroundColor Magenta }
