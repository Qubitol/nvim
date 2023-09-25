local set = vim.opt_local

set.colorcolumn = ""
set.signcolumn = "no"
set.cursorline = false

-- highlighting groups
set.winhighlight = "Normal:FileBrowser"

-- keys
vim.keymap.set("n", "gq", "<cmd>q<CR>", { buffer = true, noremap = true, silent = true })
