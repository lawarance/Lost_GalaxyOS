# ✦ Lost Galaxy cursors — install for the current user (no admin needed)
# usage:  .\install.ps1            animated arrow (twinkling star)
#         .\install.ps1 -Static    plain arrow
# undo:   Settings → Bluetooth & devices → Mouse → Additional mouse settings → Pointers → Scheme: Windows Default
param([switch]$Static)

$src  = Join-Path $PSScriptRoot "Lost Galaxy"
$dest = "$env:LOCALAPPDATA\Cursors\Lost Galaxy"
New-Item -ItemType Directory -Force $dest | Out-Null
Copy-Item "$src\*" $dest -Force
Get-ChildItem $dest | Unblock-File

$map = [ordered]@{
    Arrow       = $(if ($Static) { "arrow.cur" } else { "arrow.ani" })
    Help        = "help.cur"
    AppStarting = "working.ani"
    Wait        = "busy.ani"
    Crosshair   = "cross.cur"
    IBeam       = "text.cur"
    NWPen       = "handwriting.cur"
    No          = "unavailable.cur"
    SizeNS      = "vert.cur"
    SizeWE      = "horz.cur"
    SizeNWSE    = "dgn1.cur"
    SizeNESW    = "dgn2.cur"
    SizeAll     = "move.cur"
    UpArrow     = "alternate.cur"
    Hand        = "link.cur"
    Pin         = "pin.cur"
    Person      = "person.cur"
}

$key = "HKCU:\Control Panel\Cursors"
foreach ($k in $map.Keys) { Set-ItemProperty -Path $key -Name $k -Value (Join-Path $dest $map[$k]) }
Set-ItemProperty -Path $key -Name "(default)" -Value "Lost Galaxy"

# register as a scheme so it shows up in Mouse settings
if (-not (Test-Path "$key\Schemes")) { New-Item -Path "$key\Schemes" | Out-Null }
$scheme = ($map.Values | ForEach-Object { Join-Path $dest $_ }) -join ","
Set-ItemProperty -Path "$key\Schemes" -Name "Lost Galaxy" -Value $scheme

# apply now (no logout needed)
Add-Type -Namespace LG -Name Cur -MemberDefinition '[DllImport("user32.dll")] public static extern bool SystemParametersInfo(uint a, uint b, System.IntPtr c, uint d);'
[LG.Cur]::SystemParametersInfo(0x57, 0, [IntPtr]::Zero, 0x03) | Out-Null

Write-Host "✦ Lost Galaxy cursors installed" -ForegroundColor Magenta
