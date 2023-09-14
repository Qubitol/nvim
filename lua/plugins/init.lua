-- Plugin manager
require("plugins.packer")

-- Icons
require("plugins.nvim-web-devicons")

-- Treesitter
require("plugins.treesitter")
require("plugins.treesitter-context")

-- Mason
require("plugins.mason")
require("plugins.lsp")
require("plugins.null_ls")

-- CMP
require("plugins.luasnip")
require("plugins.cmp")

-- Other plugins in alphabetic order
require("plugins.aerial")
require("plugins.colorizer")
require("plugins.comment")
require("plugins.gitsigns")
require("plugins.git-worktree")
require("plugins.harpoon")
require("plugins.indent-blankline")
require("plugins.neorg")
require("plugins.no-neck-pain")
require("plugins.netrw")
require("plugins.surround")
require("plugins.telescope")
require("plugins.tmux")
require("plugins.undotree")
require("plugins.vim-fugitive")

-- Statusline
require("plugins.heirline")

-- Builtin cfilter plugin
vim.cmd("packadd cfilter")
