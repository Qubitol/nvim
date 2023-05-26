local set = vim.opt
local map = vim.keymap.set
local opts = { buffer = true, noremap = true, silent = true }

-- preview the diagnostic location
map("n", "p", "<CR>zz<C-w>w", opts)

-- options
set.colorcolumn = ""
