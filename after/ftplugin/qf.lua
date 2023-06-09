local set = vim.opt
local map = vim.keymap.set
local opts = { buffer = true, noremap = true, silent = true }

-- preview the diagnostic location
map("n", "p", "<CR>zz<C-w>w", opts)
map("n", "J", "j<CR>zz<C-w>w", opts)
map("n", "K", "k<CR>zz<C-w>w", opts)

-- remove element from quickfix
-- map("n", "dd", "<cmd>setlocal modifiable<CR>dd<cmd>setlocal nomodifiable<CR>", opts)
-- map("v", "d", "<esc><cmd>setlocal modifiable<CR>gvd<cmd>setlocal nomodifiable<CR>", opts)

-- close quickfix buffer
map("n", "gq", "<cmd>cclose<CR>", opts)

-- populate command line with Cfilter
map("n", "f", ":Cfilter", opts)

-- options
set.colorcolumn = ""
