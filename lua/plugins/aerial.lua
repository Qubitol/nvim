return {
    "stevearc/aerial.nvim",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons",
    },
    opts = {
        backends = { "treesitter", "lsp", "markdown", "man" },

        layout = {
            min_width = 28,
            placement = "edge",
            preserve_equality = true,
        },

        attach_mode = "global",

        filter_kind = false,

        highlight_on_jump = false,

        -- on_attach = function(bufnr)
        -- end,

        show_guides = true,
    },
    keys = function()
        local lazy_map = require("utils").lazy_map
        return {
            lazy_map("n", "<leader>tt", "<cmd>AerialToggle<CR>", "[T]oggle [T]ags sidebar, powered by Aerial"),
        }
    end,
}
