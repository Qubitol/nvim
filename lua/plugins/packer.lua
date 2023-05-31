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

    -- Snippets
    use({
        "L3MON4D3/LuaSnip",
        tag = "v1.2.1",
        run = "make install_jsregexp"
    })

    -- Autocomplete
    use({
        "hrsh7th/nvim-cmp",
        commit = "a0225043ab823fcad8d0d802e276d9838fb48c30",
    })

    use({
        "hrsh7th/cmp-nvim-lsp",
        commit = "0e6b2ed705ddcff9738ec4ea838141654f12eeef",
    })

    use({
        "hrsh7th/cmp-buffer",
        commit = "3022dbc9166796b644a841a02de8dd1cc1d311fa",
    })

    use({
        "hrsh7th/cmp-path",
        commit = "91ff86cd9c29299a64f968ebb45846c485725f23",
    })

    use({
        "hrsh7th/cmp-cmdline",
        commit = "5af1bb7d722ef8a96658f01d6eb219c4cf746b32",
    })

    use({
        "saadparwaiz1/cmp_luasnip",
        commit = "18095520391186d634a0045dacaa346291096566",
    })

    -- use({
    --     "tzachar/cmp-tabnine",
    --     commit = "b93f82ef5150e578677fc2e2b4b328b19eed77e1",
    --     run = "./install.sh",
    -- })

    use({
        "petertriho/cmp-git",
        commit = "7b292e120ef0f31586908fddfa2e7626f6dcbf98",
    })

    -- Telescope
    use({
        "nvim-telescope/telescope.nvim",
        -- tag = "0.1.1",
        commit = "4b4db1ff7dbedc95975c3bd2a2ba8d2bdf5d6c46",
    })

    use({
        "nvim-telescope/telescope-fzf-native.nvim",
        commit = "9bc8237565ded606e6c366a71c64c0af25cd7a50",
        run = "make",
    })

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

    -- Task runner
    use({
        "stevearc/overseer.nvim",
        commit = "92e4ba8d51191365e1da63f1f1f0e48efbd4ada7",
    })

    -- Quickfix list improvement
    use({
        "yorickpeterse/nvim-pqf",
        commit = "0c83602f9b3de057c5d4bf76e849c3d589a1d836",
    })

    -- LaTeX
    use({
        "lervag/vimtex",
        commit = "13fa591e82f7fe0fedbb097e9869d32f6af207fe",
    })

    -- Neorg
    use({
        "nvim-neorg/neorg",
        tag = "v4.0.0",
        run = ":Neorg sync-parsers",
    })

    -- Automatically center buffer
    use({
        "shortcuts/no-neck-pain.nvim",
        tag = "v1.2.2",
    })

    -- Surround
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

    -- Status line
    use({
        "rebelot/heirline.nvim",
        commit = "2a151df2dc870e79b138a59ebaaaddf3d1b0d703",
    })

    -- Colorizer: make color strings appear colored accordingly
    use({
        "norcalli/nvim-colorizer.lua",
        commit = "36c610a9717cc9ec426a07c8e6bf3b3abcb139d6",
    })

    -- Colorscheme
    use({
        "catppuccin/nvim",
        tag = "v1.2.0",
        as = "catpuccin",
    })

    -- Tmux integration
    use({
        "aserowy/tmux.nvim",
        commit = "3f73843df726e55b92dbb2938edbb3eb6d0746f5",
    })

    -- Save sessions automatically
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
