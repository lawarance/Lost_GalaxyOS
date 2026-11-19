# ✦ Lost Galaxy — Windhawk mod settings

Paste each file into the mod's **Settings** tab (YAML editor) → **Save settings**.

| mod | file |
|---|---|
| Translucent Windows | `translucent-windows.yaml` |
| Windows 11 File Explorer Styler | `file-explorer-styler.yaml` |
| Windows 11 Notification Center Styler | `notification-center-styler.yaml` |

Colors: tint `#11111b` (crust) at ~65% (`A6`), mauve overlay `#cba6f7`.
Windows accent color must be set to `CBA6F7` (Settings → Personalization → Colors).

## one-click apply
```powershell
cd ~\dotfiles\windhawk
.\apply.ps1
```
Edit a `.yaml`, then regenerate `settings.json` (ask Claude) and run `apply.ps1` again.
