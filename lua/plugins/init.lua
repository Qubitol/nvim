-- Plugin manager
require("plugins.packer")

-- Colorscheme
require("plugins.catppuccin")
require("plugins.nvim-web-devicons")

-- Treesitter
require("plugins.treesitter")
require("plugins.treesitter-context")

-- Mason
require("plugins.mason")
require("plugins.lsp")
require("plugins.null_ls")

-- CMP
require("plugins.cmp")
require("plugins.luasnip")

-- Other plugins in alphabetic order
require("plugins.aerial")
require("plugins.colorizer")
require("plugins.comment")
require("plugins.fidget")
require("plugins.gitsigns")
require("plugins.git-worktree")
require("plugins.harpoon")
require("plugins.indent-blankline")
require("plugins.lastplace")
require("plugins.neorg")
require("plugins.no-neck-pain")
require("plugins.pqf")
require("plugins.rnvimr")
require("plugins.surround")
require("plugins.telescope")
require("plugins.tmux")
require("plugins.undotree")
require("plugins.vim-fugitive")

-- Statusline
require("plugins.heirline")

-- Builtin cfilter plugin
vim.cmd("packadd cfilter")
