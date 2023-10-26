local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

local map = require("utils").map
map("n", "<leader>op", "<cmd>Lazy<CR>", "[O]pen [P]lugin manager")

require("lazy").setup("plugins", {
    root = vim.fn.stdpath("data") .. "/lazy",
    lockfile = vim.fn.stdpath("config") .. "/lazy-lock.json",
    state = vim.fn.stdpath("state") .. "/lazy/state.json",
    checker = {
        enabled = false,
        concurrency = nil,
        notify = true,
        frequency = 3600,
    },
    change_detection = {
        enabled = true,
        notify = false,
    },
    defaults = {
        lazy = true,
    },
    dev = {
        path = "~/Documents/Personal_projects/",
    },
    install = {
        missing = true,
        colorscheme = { "colorscheme" },
    },
    performance = {
        cache = {
            enabled = true,
        },
        reset_packpath = true, -- reset the package path to improve startup time
        rtp = {
            disabled_plugins = {
                "2html_plugin",
                "tohtml",
                "getscript",
                "getscriptPlugin",
                "gzip",
                "logipat",
                "tar",
                "tarPlugin",
                "rrhelper",
                "spellfile_plugin",
                "vimball",
                "vimballPlugin",
                "zip",
                "zipPlugin",
                "tutor",
                "rplugin",
                "synmenu",
                "optwin",
                "bugreport",
            },
        }
    },
    readme = {
        enabled = true,
        root = vim.fn.stdpath("state") .. "/lazy/readme",
        files = { "README.md", "lua/**/README.md" },
        skip_if_doc_exists = true,
    },
    ui = {
        size = { width = 0.8, height = 0.8 },
        wrap = true,
        border = "rounded",
        icons = {
            cmd = " ",
            config = "",
            event = "",
            ft = " ",
            init = " ",
            import = " ",
            keys = " ",
            lazy = "󰒲 ",
            loaded = "●",
            not_loaded = "○",
            plugin = " ",
            runtime = " ",
            source = " ",
            start = "",
            task = "✔ ",
            list = {
                "●",
                "➜",
                "★",
                "‒",
            },
        },
    },
})
