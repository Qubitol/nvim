local set = vim.opt_local
local map = vim.keymap.set
local opts = { buffer = true, noremap = true, silent = true }

-- load cfilter-plugin
vim.cmd [[packadd cfilter]]

-- preview the diagnostic location
map("n", "p", "<CR>zz<C-w>p", opts)
map("n", "J", "j<CR>zz<C-w>p", opts)
map("n", "K", "k<CR>zz<C-w>p", opts)

-- e - error message
-- w - warning message
-- i - info message
-- n - note message  => hint

-- options
set.colorcolumn = ""
set.wrap = false

-- highlighting groups
set.winhighlight = "Normal:Quickfix"
