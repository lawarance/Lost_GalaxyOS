-- ✦ Lost Galaxy — dashboard logo + statusline tweaks
return {
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          header = [[
        ✦                        ⋆
   ╻  ┏━┓┏━┓╺┳╸   ┏━╸┏━┓╻  ┏━┓╻ ╻╻ ╻
   ┃  ┃ ┃┗━┓ ┃    ┃╺┓┣━┫┃  ┣━┫┏╋┛┗┳┛
   ┗━╸┗━┛┗━┛ ╹    ┗━┛╹ ╹┗━╸╹ ╹╹ ╹ ╹
             ⋆            ✧        ]],
        },
      },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.options = opts.options or {}
      opts.options.theme = "catppuccin"
      opts.options.component_separators = { left = "│", right = "│" }
      opts.options.section_separators = { left = "", right = "" }   -- arrows, like the starship bar
    end,
  },
}
