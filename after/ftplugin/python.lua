local set = vim.opt_local

set.expandtab = true
set.autoindent = true
set.smarttab = true
set.shiftwidth = 4
set.tabstop = 4
set.softtabstop = 4

vim.g.pyindent_closed_paren_align_last_line = true
vim.g.pyindent_searchpair_timeout = 10 -- https://github.com/vim/vim/issues/1098#issuecomment-484197849
vim.g.pyindent_continue = vim.fn.shiftwidth()
vim.g.pyindent_open_paren = vim.fn.shiftwidth()
