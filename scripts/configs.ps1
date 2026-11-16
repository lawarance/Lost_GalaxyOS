# Map of live config locations -> repo locations. Edit this list as you add apps.
$Repo = Split-Path $PSScriptRoot -Parent

$Configs = @(
    @{ Name = "glazewm";     Live = "$HOME\.glzr\glazewm\config.yaml";                Repo = "$Repo\glazewm\config.yaml" }
    @{ Name = "yasb-config"; Live = "$HOME\.config\yasb\config.yaml";                 Repo = "$Repo\yasb\config.yaml" }
    @{ Name = "yasb-styles"; Live = "$HOME\.config\yasb\styles.css";                  Repo = "$Repo\yasb\styles.css" }
    @{ Name = "terminal";    Live = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"; Repo = "$Repo\terminal\settings.json" }
    @{ Name = "pwsh";        Live = $PROFILE.CurrentUserCurrentHost;                  Repo = "$Repo\powershell\Microsoft.PowerShell_profile.ps1" }
    @{ Name = "bashrc";      Live = "$HOME\.bashrc";                                  Repo = "$Repo\gitbash\.bashrc" }
    @{ Name = "bash_profile";Live = "$HOME\.bash_profile";                            Repo = "$Repo\gitbash\.bash_profile" }
    @{ Name = "fastfetch";   Live = "$HOME\.config\fastfetch\config.jsonc";           Repo = "$Repo\fastfetch\config.jsonc" }
    @{ Name = "nvim";        Live = "$env:LOCALAPPDATA\nvim";                         Repo = "$Repo\nvim"; Dir = $true }
    @{ Name = "vscode";      Live = "$env:APPDATA\Code\User\settings.json";           Repo = "$Repo\vscode\settings.json" }
    @{ Name = "vscode-keys"; Live = "$env:APPDATA\Code\User\keybindings.json";        Repo = "$Repo\vscode\keybindings.json" }
    @{ Name = "gitconfig";   Live = "$HOME\.gitconfig";                               Repo = "$Repo\git\.gitconfig" }
)
