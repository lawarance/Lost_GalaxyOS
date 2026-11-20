# ✦ Lost Galaxy — undo the preview (apps / system side). configs come back with git + restore (see PREVIEW.md)
# run from the repo root:   .\preview\revert-preview.ps1

$ErrorActionPreference = "Continue"
$State = "$env:LOCALAPPDATA\LostGalaxy\preview-state.json"
if (-not (Test-Path $State)) { Write-Host "no preview state found ($State) — nothing to undo" -ForegroundColor Yellow; return }
$s = Get-Content $State -Raw | ConvertFrom-Json
function Head($t) { Write-Host "`n─── $t ───" -ForegroundColor Magenta }

Head "GlazeWM + YASB"
if ($s.desktop) { glazewm command wm-exit 2>$null; yasbc stop 2>$null; Write-Host "stopped (taskbar is back)" }

Head "Spicetify"
if ($s.spicetify) { spicetify restore }

Head "Vencord theme"
if ($s.vencordTheme) { Remove-Item "$env:APPDATA\Vencord\themes\lost-galaxy.theme.css" -ErrorAction SilentlyContinue; Write-Host "removed" }

Head "VS Code extensions"
foreach ($e in $s.vscodeExt) { code --uninstall-extension $e | Out-Null; Write-Host "removed $e" }

Head "neovim"
if (-not $s.nvimExisted) {
    Remove-Item "$env:LOCALAPPDATA\nvim", "$env:LOCALAPPDATA\nvim-data" -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "removed LazyVim config + plugins"
}
foreach ($p in $s.scoop) { scoop uninstall $p }

Head "cursors"
if ($s.cursors) {
    foreach ($p in $s.cursors.PSObject.Properties) { Set-ItemProperty "HKCU:\Control Panel\Cursors" -Name $p.Name -Value ([string]$p.Value) }
    Add-Type -Namespace LG -Name Cur2 -MemberDefinition '[DllImport("user32.dll")] public static extern bool SystemParametersInfo(uint a, uint b, System.IntPtr c, uint d);'
    [LG.Cur2]::SystemParametersInfo(0x57, 0, [IntPtr]::Zero, 0x03) | Out-Null
    Write-Host "previous cursors back"
}

Head "Windhawk + Nilesoft (UAC prompt)"
$cmds = @()
if ($s.windhawkBackup -and (Test-Path $s.windhawkBackup)) {
    $cmds += "reg delete 'HKLM\SOFTWARE\Windhawk\Engine\Mods' /f | Out-Null; reg import '$($s.windhawkBackup)'"
}
if ($s.nilesoftInstalled) { $cmds += "winget uninstall Nilesoft.Shell --silent" }
elseif ($s.nilesoftThemeBackup -and (Test-Path $s.nilesoftThemeBackup)) {
    $cmds += "Copy-Item '$($s.nilesoftThemeBackup)' '$env:ProgramFiles\Nilesoft Shell\imports\theme.nss' -Force"
}
if ($cmds) {
    $cmds += "Stop-Process -Name explorer -Force"
    Start-Process pwsh -Verb RunAs -Wait -ArgumentList "-NoProfile", "-Command", ($cmds -join "; ")
    Write-Host "done"
}

Remove-Item $State -Force
Write-Host "`n✦ apps reverted. now: git switch main  →  .\scripts\restore.ps1   (PREVIEW.md step 4)" -ForegroundColor Magenta
