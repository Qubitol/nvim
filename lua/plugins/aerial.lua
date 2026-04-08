-- Aerial

local map = require("config.utils").map

vim.pack.add({ "https://github.com/stevearc/aerial.nvim" })

require("aerial").setup({
    backends = { "treesitter", "lsp", "markdown", "man" },
    layout = {
        min_width = 28,
        placement = "edge",
        preserve_equality = true,
    },
    attach_mode = "global",
    filter_kind = false,
    highlight_on_jump = false,
    show_guides = true,
})

map("n", "<leader>tt", "<cmd>AerialToggle<CR>", "[T]oggle [T]ags sidebar, powered by Aerial")
