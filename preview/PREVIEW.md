# ✦ Lost Galaxy — preview the finished rice, then go back

## 1. save what you have now (on main)
```powershell
cd ~\dotfiles
.\scripts\sync.ps1                       # live configs -> repo (catches uncommitted changes)
git add -A
git commit -m "snapshot: before preview"  # "nothing to commit" is fine
git tag before-preview
git push ; git push --tags
```

## 2. preview branch + files
```powershell
git switch -c preview-final
# extract lost-galaxy-final-preview.zip INTO ~\dotfiles (overwrite everything)
git add -A
git commit -m "preview: end-of-project configs"
```
> don't use `dots` while previewing — it would commit/push on this branch.

## 3. install
```powershell
Unblock-File .\preview\*.ps1
.\preview\install-preview.ps1        # asks y/n for each part
```
| part | what |
|---|---|
| configs | everything in the repo → your system (alacritty, starship, shells, bat, fastfetch, yazi, flow, glazewm, yasb, vscode, nvim) |
| neovim | neovim + LazyVim tools via scoop → run `nvim` (or `v`) |
| VS Code | Catppuccin + icons, mauve accent, JetBrains Mono, smooth cursor |
| cursors | Lost Galaxy pixel cursors |
| Windhawk | translucent explorer + notification center |
| GlazeWM + YASB | tiling + bar, **windows taskbar hidden** while YASB runs |
| Spicetify | Spotify in catppuccin mocha |
| Vencord | Discord theme (only if Vencord is installed) |
| Nilesoft | themed right-click menu |

Manual extras: Stylus styles for Opera GX → `stylus\README.md`.

## 4. go back to your current version
```powershell
cd ~\dotfiles
.\preview\revert-preview.ps1         # undoes apps/system side (uses the saved state)
git switch main                      # repo back to your snapshot
.\scripts\restore.ps1                # your configs back on the system
```
keep the preview branch to come back later (`git switch preview-final`), or delete it: `git branch -D preview-final`.
