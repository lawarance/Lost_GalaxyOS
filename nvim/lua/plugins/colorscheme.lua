-- ✦ Lost Galaxy — catppuccin mocha with mauve accents + transparent bg (alacritty opacity shows through)
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "mocha",
      transparent_background = true,
      term_colors = true,
      styles = { comments = { "italic" }, keywords = { "bold" } },
      custom_highlights = function(c)
        return {
          CursorLineNr = { fg = c.mauve, style = { "bold" } },
          LineNr = { fg = c.surface2 },
          FloatBorder = { fg = c.mauve },
          WinSeparator = { fg = c.surface1 },
          Visual = { bg = c.surface1 },
          Search = { bg = c.mauve, fg = c.crust },
          IncSearch = { bg = c.pink, fg = c.crust },
          PmenuSel = { bg = c.mauve, fg = c.crust, style = { "bold" } },
          TelescopeBorder = { fg = c.mauve },
          SnacksPickerBorder = { fg = c.mauve },
        }
      end,
      integrations = { blink_cmp = true, gitsigns = true, mason = true, mini = true, noice = true,
                       snacks = true, treesitter = true, which_key = true, flash = true },
    },
  },
}
