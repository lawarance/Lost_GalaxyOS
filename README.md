# ✦ Lost Galaxy

```
   ✦   lost galaxy — windows rice
       catppuccin mocha · mauve × pink · pixel art
```

## stack
| | |
|---|---|
| terminal | Alacritty · PowerShell 7 · Git Bash |
| prompt | Starship (arrow bar) |
| cli | eza · bat · fzf · zoxide · ripgrep · fd · lazygit · btop · yazi |
| fetch | fastfetch (per-row gradient galaxy) |
| wm / bar | GlazeWM · YASB *(paused)* |
| launcher | Flow Launcher (`Alt+Q`) |
| windows | Windhawk: Translucent Windows · File Explorer Styler · Notification Center Styler |
| cursors | Lost Galaxy pixel pack (3 animated) |
| font | JetBrainsMono Nerd Font 11pt |

## folders
| folder | what |
|---|---|
| `palette/` | colors (single source of truth) |
| `alacritty/ starship/ powershell/ gitbash/` | terminal + shells |
| `bat/ fastfetch/ yazi/` | cli tools |
| `glazewm/ yasb/ flowlauncher/ windhawk/` | desktop |
| `cursors/ identity/ wallpaper/` | look & identity |
| `packages/` | `scoop import packages\scoop.json` |
| `scripts/` | sync · restore · save |
| `nvim/ vscode/` | editors (LazyVim · VS Code) |
| `stylus/ spicetify/ vencord/ nilesoft/` | apps |
| `preview/` | install / revert the full preview — see `preview/PREVIEW.md` |

## usage
```powershell
dots -m "msg"                     # live -> repo, commit, push
.\scripts\restore.ps1 <name>      # repo -> live (makes .bak)
.\cursors\install.ps1             # cursors
.\windhawk\apply.ps1              # windhawk mod settings (admin)
```
