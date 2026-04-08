-- Indent

vim.pack.add({ "https://github.com/lukas-reineke/indent-blankline.nvim" })

local icons = require("config.ui").icons

require("ibl").setup({
    indent = {
        char = icons.indent.char
    },
    scope = {
        show_start = false,
        show_end = false,
    },
    exclude = {
        filetypes = { "argpick", "help", "mason", "netrw", "undotree" },
    },
})
