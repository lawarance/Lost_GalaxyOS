-- ✦ Lost Galaxy — extra keys (LazyVim: <space> is the leader, press it and wait to see everything)
local map = vim.keymap.set
map("i", "jk", "<Esc>", { desc = "Exit insert" })
map("n", "<C-s>", "<cmd>w<cr>", { desc = "Save" })
map("n", "<leader>fd", "<cmd>e ~/dotfiles<cr>", { desc = "Open dotfiles" })
