-- ✦ Lost Galaxy — options (on top of LazyVim defaults)
local o = vim.opt
o.relativenumber = true
o.scrolloff = 6
o.wrap = false
o.cursorline = true
o.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,a:blinkon400-blinkoff300"

-- windows: use powershell 7 for :!commands and :terminal
if vim.fn.has("win32") == 1 then
  o.shell = vim.fn.executable("pwsh") == 1 and "pwsh" or "powershell"
  o.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"
  o.shellredir = '2>&1 | %%{ "$_" } | Out-File %s; exit $LastExitCode'
  o.shellpipe = '2>&1 | %%{ "$_" } | Tee-Object %s; exit $LastExitCode'
  o.shellquote = ""
  o.shellxquote = ""
end
