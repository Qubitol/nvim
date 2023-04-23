-- Automatically install and setup packer
local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({"git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path})
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

-- Autocommand that reloads neovim whenever you save the packer.lua file
vim.cmd([[
    augroup packer_user_config
        autocmd!
        autocmd BufWritePost packer.lua source <afile> | PackerSync
    augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

-- Have packer use a popup window
packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
})

-- List the plugins and pin them, so the configuration does not break when updates roll
return require("packer").startup(function(use)

    -- Packer can manage itself
    use({
        "wbthomason/packer.nvim",
        commit = "dac4088c70f4337c6c40d1a2751266a324765797",
    })

    -- Useful lua functions used by lots of plugins
    use({
        "nvim-lua/plenary.nvim",
        commit = "bb444796dc5746d969f0718913a31c8075741e36",
    })

    -- Improve neovim startup time
    use({
        "lewis6991/impatient.nvim",
        commit = "c90e273f7b8c50a02f956c24ce4804a47f18162e",
    })

    -- Dev icons
    use({
        "nvim-tree/nvim-web-devicons",
        commit = "05e1072f63f6c194ac6e867b567e6b437d3d4622",
    })

    -- Git
    use({
        "tpope/vim-fugitive",
        commit = "99cdb88bc64063dc4656ae53496f06fb2a394cd4",
    })

    -- Git signs
    use({
        "lewis6991/gitsigns.nvim",
        commit = "d4f8c01280413919349f5df7daccd0c172143d7c",
    })

    -- Git worktree
    use({
        -- "ThePrimeagen/git-worktree.nvim",
        -- commit = "d7f4e2584e81670154f07ca9fa5dd791d9c1b458",
        "brandoncc/git-worktree.nvim",
        branch = "catch-and-handle-telescope-related-error",
    })

    -- Mason
    use({
        "williamboman/mason.nvim",
        commit = "c609775d1fc5ae18aadc92b8b65be9c9b1980004",
    })

    -- LSP
    use({
        "williamboman/mason-lspconfig.nvim",
        commit = "43c7f402cb9822b61b5dc05bf0b385928df256a6",
    })

    use({
        "neovim/nvim-lspconfig",
        commit = "41dc4e017395d73af0333705447e858b7db1f75e",
    })

    -- Linters & Formatters
    use({
        "jose-elias-alvarez/null-ls.nvim",
        commit = "915558963709ea17c5aa246ca1c9786bfee6ddb4",
    })

    use({
        "jay-babu/mason-null-ls.nvim",
        commit = "93946aef86b1409958c97ee5feaf30bdd1053e24",
    })

    -- DAP
    use({
        "mfussenegger/nvim-dap",
        commit = "5a1479c5d633daa0db06988ed44663f07f10f5dd",
    })

    use({
        "jayp0521/mason-nvim-dap.nvim",
        commit = "a775db8ac7c468fb05fcf67069961dba0d7feb56",
    })

    -- Autocomplete
    --
    --
    -- Snippets
    use({
        "L3MON4D3/LuaSnip",
        tag = "v1.2.1",
        run = "make install_jsregexp"
    })

    -- Telescope
    use({
        "nvim-telescope/telescope.nvim",
        -- tag = "0.1.1",
        commit = "4b4db1ff7dbedc95975c3bd2a2ba8d2bdf5d6c46",
    })

    use({
        "nvim-telescope/telescope-fzf-native.nvim",
        run = "make",
    })

    -- -- Symbol sources
    -- use({
    --     "nvim-telescope/telescope-symbols.nvim",
    --     commit = "f7d7c84873c95c7bd5682783dd66f84170231704",
    -- })

    -- Harpoon
    use({
        "ThePrimeagen/harpoon",
        commit = "8c0bb0a328e57278f4783bb0e2ea32f296d36db1",
    })

    -- Undotree
    use({
        "mbbill/undotree",
        tag = "rel_6.1",
    })

    -- Aerial
    use({
        "stevearc/aerial.nvim",
        commit = "e76aec1fc2f83451a9acf5379fbb1d8278910873",
    })

    -- -- Trouble
    -- use({
    --     "folke/trouble.nvim",
    --     commit = "490f7fe6d227f4f7a64f00be8c7dcd7a508ed271",
    -- })

    -- LaTeX
    use({
        "lervag/vimtex",
        commit = "13fa591e82f7fe0fedbb097e9869d32f6af207fe",
    })

    -- Neorg
    use({
        "nvim-neorg/neorg",
        tag = "v3.2.0",
        run = ":Neorg sync-parsers",
    })

    -- Sorround
    use({
        "kylechui/nvim-surround",
        commit = "ad56e6234bf42fb7f7e4dccc7752e25abd5ec80e",
    })

    -- Rnvimr
    use({
        "kevinhwang91/rnvimr",
        commit = "cd0311d65cb3b8f8737b52f3294eb77d2fcec826",
    })

    -- Treesitter
    use({
        "nvim-treesitter/nvim-treesitter",
        commit = "b1569394614804aaad4e994731161f253ff61bcc",
        run = function()
            local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
            ts_update()
        end,
    })

    -- Indent
    use({
        "yioneko/nvim-yati",
        tag = "0.0.4",
    })

    -- Context line
    use({
        "nvim-treesitter/nvim-treesitter-context",
        commit = "4842abe5bd1a0dc8b67387cc187edbabc40925ba",
    })

    -- Context commenting
    use({
        "JoosepAlviste/nvim-ts-context-commentstring",
        commit = "4a42b30376c1bd625ab5016c2079631d531d797a",
    })

    -- Commenting
    use({
        "numToStr/Comment.nvim",
        commit = "ab00bcf5aa979c53f2f40dc2655c03e24f4ef50f",
    })

    -- Indentation guides
    use({
        "lukas-reineke/indent-blankline.nvim",
        commit = "c4c203c3e8a595bc333abaf168fcb10c13ed5fb7",
    })

    -- Colorizer: make color strings appear colored accordingly
    use({
        "norcalli/nvim-colorizer.lua",
        commit = "36c610a9717cc9ec426a07c8e6bf3b3abcb139d6",
    })

    -- Colorscheme
    use({
        "catppuccin/nvim",
        commit = "3020af75aae098a77737d91ee37c7147c8450d99",
        as = "catpuccin",
    })

    -- Tmux integration
    use({
        "aserowy/tmux.nvim",
        commit = "3f73843df726e55b92dbb2938edbb3eb6d0746f5",
    })

    -- Save sessions for tmux-resurrect
    use({
        "tpope/vim-obsession",
        commit = "fe9d3e1a9a50171e7d316a52e1e56d868e4c1fe5",
    })

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
        require('packer').sync()
    end
end)
