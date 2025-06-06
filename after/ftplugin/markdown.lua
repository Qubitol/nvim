local set = vim.opt_local
local map = vim.keymap.set
local opts = { buffer = true, noremap = true, silent = true }

set.colorcolumn = ""
set.wrap = true
set.concealcursor = "nc"
set.cursorlineopt = "number"

map("v", "<leader>tf", "<cmd>'<,'>! tr -s ' ' | column -t -s '|' -o '|'<CR>", opts)
