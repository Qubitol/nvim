local set = vim.opt_local
local map = vim.keymap.set
local opts = { buffer = true, noremap = true, silent = true }

-- preview the diagnostic location
map("n", "p", "<CR>zz<C-w>p", opts)

-- options
set.colorcolumn = ""
