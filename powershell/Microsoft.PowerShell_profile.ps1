# ═══════════════════════════════════════════════════════════════════
#  ✦ Lost Galaxy — PowerShell 7 profile ($PROFILE)
#  repo: ~\dotfiles\powershell\Microsoft.PowerShell_profile.ps1
#  reload after editing:  . $PROFILE
# ═══════════════════════════════════════════════════════════════════


# ─── 1. encoding (UTF-8 everywhere, needed for icons) ─────────────

try {
    [Console]::InputEncoding  = [System.Text.Encoding]::UTF8
    [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
    $OutputEncoding = [System.Text.UTF8Encoding]::new($false)
    chcp 65001 > $null
} catch {}


# ─── 2. startup: fastfetch ────────────────────────────────────────

Clear-Host
if (Get-Command fastfetch -ErrorAction SilentlyContinue) {
    fastfetch -c "$HOME/.config/fastfetch/config.jsonc"
}
Set-Alias neofetch fastfetch


# ─── 3. profile helpers ──────────────────────────────────────────

function editprofile { code $PROFILE }
function profile     { $PROFILE }


# ─── 4. clear screen (same as bash) ──────────────────────────────

Set-Alias c     Clear-Host
Set-Alias cl    Clear-Host
Set-Alias clean Clear-Host


# ─── 5. navigation (same as bash) ────────────────────────────────

function dotfiles { Set-Location "$HOME\dotfiles" }
function home     { Set-Location "$HOME\Desktop\Lawarance" }
function prj      { Set-Location "$HOME\Desktop\Lawarance\Notes\Sem3\AiDS\AiSD_2026Z_GR2_gr4" }

function mkcd([string]$Path) {
    New-Item -ItemType Directory -Force -Path $Path | Out-Null
    Set-Location $Path
}
Set-Alias dircd mkcd


# ─── 6. build tools ──────────────────────────────────────────────

Set-Alias make mingw32-make


# ─── 7. dotfiles: sync + commit + push ───────────────────────────
# usage: dots -m "message"

function dots { Get-ChildItem "$HOME\dotfiles\scripts" -File | Unblock-File; & "$HOME\dotfiles\scripts\save.ps1" @args }

# ─── 8. PSReadLine: keybinds + colors ────────────────────────────

# Ctrl+Q = clear the whole line (Esc works too)
Set-PSReadLineKeyHandler -Chord Ctrl+q -Function RevertLine

# history-based suggestions (grey ghost text, accept with →)
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle InlineView

# syntax colors while typing (lost galaxy palette)
$rgb = { param($hex) $PSStyle.Foreground.FromRgb([Convert]::ToInt32($hex, 16)) }
Set-PSReadLineOption -Colors @{
    Command          = & $rgb 'cba6f7'   # mauve
    Parameter        = & $rgb 'f5c2e7'   # pink
    String           = & $rgb 'a6e3a1'   # green
    Number           = & $rgb 'fab387'   # peach
    Variable         = & $rgb 'f5e0dc'   # rosewater
    Operator         = & $rgb '89dceb'   # sky
    Comment          = & $rgb '6c7086'   # overlay0
    Keyword          = & $rgb 'b4befe'   # lavender
    InlinePrediction = & $rgb '585b70'   # surface2
}
Remove-Variable rgb


# ─── 9. cli tools: eza · bat · fzf · btop · lazygit ──────────────

# eza (ls with icons; colors come from the alacritty palette)
Remove-Item Alias:ls -Force -ErrorAction SilentlyContinue
function ls { eza --icons --group-directories-first @args }
function ll { eza -la --icons --git --group-directories-first @args }
function lt { eza --tree --level=2 --icons --git-ignore @args }

# bat (cat with syntax colors)
$env:BAT_CONFIG_PATH = "$HOME\dotfiles\bat\config"
Remove-Item Alias:cat -Force -ErrorAction SilentlyContinue
function cat { bat @args }

# fzf (fuzzy finder) — lost galaxy colors
$env:FZF_DEFAULT_COMMAND = 'fd --type f --hidden --exclude .git'
$env:FZF_DEFAULT_OPTS = @(
    '--height=45% --layout=reverse --border=rounded --margin=0,1'
    '--prompt="󰙴 " --pointer="▶" --marker="✦" --separator="─" --scrollbar="│"'
    '--color=bg:-1,bg+:#313244,fg:#cdd6f4,fg+:#cdd6f4'
    '--color=hl:#f5c2e7,hl+:#f5c2e7,info:#cba6f7,prompt:#cba6f7'
    '--color=pointer:#f5e0dc,marker:#b4befe,spinner:#f5e0dc,header:#89dceb'
    '--color=border:#45475a,label:#cba6f7,selected-bg:#45475a'
) -join ' '

# fp = find file with preview · fe = find + open in code
function fp { fzf --preview 'bat --color=always --style=numbers --line-range=:200 {}' @args }
function fe { $f = fp; if ($f) { code $f } }

# Ctrl+T = insert file path · Ctrl+R = fuzzy history  (needs PSFzf module)
if (Get-Module -ListAvailable PSFzf) {
    Import-Module PSFzf
    Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
}

# btop / lazygit
Set-Alias top btop
Set-Alias lg  lazygit

# yazi: file manager · `y` = open, quit = cd into that folder
$env:YAZI_FILE_ONE = "C:\Program Files\Git\usr\bin\file.exe"
function y {
    $tmp = (New-TemporaryFile).FullName
    yazi $args --cwd-file="$tmp"
    $cwd = Get-Content -Path $tmp -Encoding UTF8
    if ($cwd -and $cwd -ne $PWD.Path) { Set-Location -LiteralPath (Resolve-Path -LiteralPath $cwd).Path }
    Remove-Item -Path $tmp
}


# ─── 10. prompt: starship ────────────────────────────────────────
# config: ~\.config\starship.toml

if (Get-Command starship -ErrorAction SilentlyContinue) {
    Invoke-Expression (&starship init powershell)
}


# ─── 11. zoxide (smart cd: `z dotfiles`) ─────────────────────────

if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (& { (zoxide init powershell | Out-String) })
}
