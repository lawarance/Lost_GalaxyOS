# ✦ Lost Galaxy — apply Windhawk mod settings in one go
# usage:  .\apply.ps1           (asks for admin, writes settings, restarts explorer)
# needs:  the 3 mods installed once in Windhawk (Explore → Install):
#         Translucent Windows · Windows 11 File Explorer Styler · Windows 11 Notification Center Styler
# source: settings.json (generated from the *.yaml files in this folder)

$ErrorActionPreference = "Stop"

# ─── run as admin (Windhawk keeps settings in HKLM) ───
$admin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $admin) {
    Start-Process pwsh -Verb RunAs -ArgumentList "-NoProfile", "-ExecutionPolicy", "Bypass", "-File", "`"$PSCommandPath`""
    return
}

$base = "HKLM:\SOFTWARE\Windhawk\Engine\Mods"
if (-not (Test-Path $base)) {
    Write-Host "Windhawk registry storage not found ($base). Portable Windhawk? Tell Claude." -ForegroundColor Red
    Read-Host "Enter to close"; return
}

$all = Get-Content (Join-Path $PSScriptRoot "settings.json") -Raw | ConvertFrom-Json
$now = [int][DateTimeOffset]::UtcNow.ToUnixTimeSeconds()

foreach ($mod in $all.PSObject.Properties) {
    $modKey = Join-Path $base $mod.Name
    if (-not (Test-Path $modKey)) {
        Write-Host "  skip  $($mod.Name)  (not installed — install it in Windhawk first)" -ForegroundColor DarkYellow
        continue
    }
    $setKey = Join-Path $modKey "Settings"
    if (Test-Path $setKey) { Remove-Item $setKey -Recurse -Force }   # clear old values
    New-Item $setKey | Out-Null

    foreach ($s in $mod.Value.PSObject.Properties) {
        if ($s.Value -is [bool] -or $s.Value -is [int] -or $s.Value -is [long]) {
            New-ItemProperty -Path $setKey -Name $s.Name -PropertyType DWord -Value ([int]$s.Value) | Out-Null
        } else {
            New-ItemProperty -Path $setKey -Name $s.Name -PropertyType String -Value ([string]$s.Value) | Out-Null
        }
    }
    # tells the running mod to reload its settings
    Set-ItemProperty -Path $modKey -Name "SettingsChangeTime" -Value $now -Type DWord
    Write-Host "  apply $($mod.Name)" -ForegroundColor Magenta
}

Write-Host "`nrestarting explorer..." -ForegroundColor Cyan
Stop-Process -Name explorer -Force
Write-Host "✦ done" -ForegroundColor Magenta
Start-Sleep 2
