# ✦ Lost Galaxy — install the full "end of project" preview
# run from the repo root, on the preview-final branch:   .\preview\install-preview.ps1
# every part asks first (y/n). everything it changes is recorded so revert-preview.ps1 can undo it.

$ErrorActionPreference = "Continue"
$Repo  = Split-Path $PSScriptRoot -Parent
$State = "$env:LOCALAPPDATA\LostGalaxy\preview-state.json"
New-Item -ItemType Directory -Force (Split-Path $State) | Out-Null
$s = [ordered]@{ scoop = @(); vscodeExt = @(); nvimExisted = $false; spicetify = $false; vencordTheme = $false;
                 nilesoftInstalled = $false; nilesoftThemeBackup = $null; windhawkBackup = $null; cursors = $null; desktop = $false }
function Save { $s | ConvertTo-Json -Depth 5 | Set-Content $State -Encoding utf8 }
function Ask($q) { (Read-Host "`n✦ $q [y/n]") -match '^(y|t|tak|yes)$' }
function Head($t) { Write-Host "`n─── $t ───" -ForegroundColor Magenta }

Set-Location $Repo
$branch = git rev-parse --abbrev-ref HEAD
if ($branch -eq "main") { Write-Host "You are on main — switch to the preview branch first (see PREVIEW.md)." -ForegroundColor Red; return }
Get-ChildItem $Repo -Recurse -File -ErrorAction SilentlyContinue | Where-Object { $_.FullName -notmatch "\\.git\\" } | Unblock-File -ErrorAction SilentlyContinue

# 1 ─ configs (alacritty, starship, shells, bat, fastfetch, yazi, flow, glazewm, yasb, vscode, nvim…)
Head "1/9 configs"
$s.nvimExisted = Test-Path "$env:LOCALAPPDATA\nvim"
Save
& "$Repo\scripts\restore.ps1"

# 2 ─ LazyVim dependencies
Head "2/9 neovim + LazyVim tools"
if (Ask "install neovim, mingw (C compiler), nodejs-lts, python, tree-sitter with scoop?") {
    $have = (scoop export | ConvertFrom-Json).apps.Name
    foreach ($p in "neovim", "mingw", "nodejs-lts", "python", "tree-sitter") {
        if ($have -notcontains $p) { scoop install $p; if ($LASTEXITCODE -eq 0) { $s.scoop += $p } }
    }
    Save
    Write-Host "first `nvim` start downloads plugins + language servers (1–3 min)" -ForegroundColor DarkGray
}

# 3 ─ VS Code
Head "3/9 VS Code extensions"
if ((Get-Command code -ErrorAction SilentlyContinue) -and (Ask "install VS Code theme extensions?")) {
    $have = code --list-extensions
    Get-Content "$Repo\vscode\extensions.txt" | Where-Object { $_ -and $_ -notmatch '^#' } | ForEach-Object {
        if ($have -notcontains $_) { code --install-extension $_ --force | Out-Null; $s.vscodeExt += $_ }
    }
    Save
}

# 4 ─ cursors
Head "4/9 cursors"
if (Ask "install Lost Galaxy cursors?") {
    $k = Get-ItemProperty "HKCU:\Control Panel\Cursors"
    $s.cursors = @{}; foreach ($n in "(default)", "Arrow", "Help", "AppStarting", "Wait", "Crosshair", "IBeam", "NWPen", "No", "SizeNS", "SizeWE", "SizeNWSE", "SizeNESW", "SizeAll", "UpArrow", "Hand", "Pin", "Person") { $s.cursors[$n] = $k.$n }
    Save
    & "$Repo\cursors\install.ps1"
}

# 5 ─ Windhawk
Head "5/9 Windhawk mod settings"
if (Ask "apply Windhawk settings? (UAC prompt)") {
    $s.windhawkBackup = "$env:LOCALAPPDATA\LostGalaxy\windhawk-before.reg"
    reg export "HKLM\SOFTWARE\Windhawk\Engine\Mods" $s.windhawkBackup /y | Out-Null
    Save
    & "$Repo\windhawk\apply.ps1"
    Start-Sleep 4
}

# 6 ─ GlazeWM + YASB (taskbar hides while YASB runs)
Head "6/9 GlazeWM + YASB"
if (Ask "start GlazeWM + YASB?") { $s.desktop = $true; Save; glazewm start }

# 7 ─ Spotify
Head "7/9 Spicetify (Spotify)"
if (Ask "theme Spotify with Spicetify?") { & "$Repo\spicetify\setup.ps1"; $s.spicetify = $true; Save }

# 8 ─ Discord
Head "8/9 Vencord theme (Discord)"
if (Test-Path "$env:APPDATA\Vencord") {
    if (Ask "copy Lost Galaxy theme into Vencord?") {
        New-Item -ItemType Directory -Force "$env:APPDATA\Vencord\themes" | Out-Null
        Copy-Item "$Repo\vencord\lost-galaxy.theme.css" "$env:APPDATA\Vencord\themes\" -Force
        $s.vencordTheme = $true; Save
        Write-Host "enable it: Discord → Settings → Vencord → Themes" -ForegroundColor DarkGray
    }
} else { Write-Host "Vencord not installed — skipping (see vencord\README.md)" -ForegroundColor DarkGray }

# 9 ─ right-click menu
Head "9/9 Nilesoft Shell (right-click menu)"
if (Ask "install/theme Nilesoft Shell? (UAC prompt, restarts explorer)") {
    $dir = "$env:ProgramFiles\Nilesoft Shell"
    if (-not (Test-Path $dir)) { winget install Nilesoft.Shell --accept-package-agreements --accept-source-agreements; $s.nilesoftInstalled = $true }
    if (Test-Path "$dir\imports\theme.nss") {
        $s.nilesoftThemeBackup = "$env:LOCALAPPDATA\LostGalaxy\theme.nss.before"
        Copy-Item "$dir\imports\theme.nss" $s.nilesoftThemeBackup -Force
    }
    Save
    Start-Process pwsh -Verb RunAs -Wait -ArgumentList "-NoProfile", "-Command", "Copy-Item '$Repo\nilesoft\theme.nss' '$dir\imports\theme.nss' -Force; Stop-Process -Name explorer -Force"
}

Save
Write-Host "`n✦ preview installed. state saved to $State" -ForegroundColor Magenta
Write-Host "  undo everything: .\preview\revert-preview.ps1  (see PREVIEW.md)" -ForegroundColor DarkGray
