# ✦ Lost Galaxy — Spotify via Spicetify (catppuccin mocha, mauve)
# needs Spotify from spotify.com (NOT the Microsoft Store version)
# undo: spicetify restore
$ErrorActionPreference = "Stop"
if (-not (Get-Command spicetify -ErrorAction SilentlyContinue)) {
    Invoke-WebRequest -UseBasicParsing https://raw.githubusercontent.com/spicetify/cli/main/install.ps1 | Invoke-Expression
    $env:PATH += ";$env:LOCALAPPDATA\spicetify"
}
$theme = "$env:APPDATA\spicetify\Themes\catppuccin"
New-Item -ItemType Directory -Force $theme | Out-Null
foreach ($f in "color.ini", "user.css", "theme.js") {
    Invoke-WebRequest -UseBasicParsing "https://raw.githubusercontent.com/catppuccin/spicetify/main/catppuccin/$f" -OutFile "$theme\$f"
}
spicetify config current_theme catppuccin color_scheme mocha inject_css 1 inject_theme_js 1 replace_colormap 1 overwrite_assets 1
spicetify backup apply
if ($LASTEXITCODE -ne 0) { spicetify apply }
Write-Host "✦ spotify themed — accent can be changed in Spotify → profile menu → Catppuccin settings" -ForegroundColor Magenta
