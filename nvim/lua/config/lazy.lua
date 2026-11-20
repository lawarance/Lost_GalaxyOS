local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable",
    "https://github.com/folke/lazy.nvim.git", lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({ { "Failed to clone lazy.nvim:\n", "ErrorMsg" }, { out, "WarningMsg" } }, true, {})
    vim.fn.getchar(); os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    { "LazyVim/LazyVim", import = "lazyvim.plugins", opts = { colorscheme = "catppuccin" } },

    -- ─── languages (LSP + treesitter + formatters + linters) ───
    { import = "lazyvim.plugins.extras.lang.python" },     -- pyright/basedpyright, ruff, venv picker
    { import = "lazyvim.plugins.extras.lang.java" },       -- jdtls
    { import = "lazyvim.plugins.extras.lang.clangd" },     -- C / C++
    { import = "lazyvim.plugins.extras.lang.sql" },        -- sql + dadbod
    { import = "lazyvim.plugins.extras.lang.json" },
    { import = "lazyvim.plugins.extras.lang.yaml" },
    { import = "lazyvim.plugins.extras.lang.toml" },
    { import = "lazyvim.plugins.extras.lang.markdown" },
    { import = "lazyvim.plugins.extras.lang.tailwind" },   -- css / html helpers
    { import = "lazyvim.plugins.extras.lang.docker" },     -- ML: containers
    -- ─── editing / completion ───
    { import = "lazyvim.plugins.extras.coding.mini-surround" },
    { import = "lazyvim.plugins.extras.editor.mini-files" },

    { import = "plugins" },
  },
  defaults = { lazy = false, version = false },
  install = { colorscheme = { "catppuccin" } },
  checker = { enabled = true, notify = false },
  ui = { border = "rounded" },
  performance = { rtp = { disabled_plugins = { "gzip", "tarPlugin", "tohtml", "tutor", "zipPlugin" } } },
})
