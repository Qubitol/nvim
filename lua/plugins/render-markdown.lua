return {
    "MeanderingProgrammer/render-markdown.nvim",
    version = "*",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons",
    },
    ft = "markdown",
    opts = {
        anti_conceal = { enabled = false },
        render_modes = { "n", "c", "i" },
        quote = { repeat_linebreak = true },
        win_options = {
            showbreak = {
                default = "",
                rendered = "  ",
            },
            breakindent = {
                default = false,
                rendered = true,
            },
            breakindentopt = {
                default = "",
                rendered = "",
            },
            concealcursor = { rendered = "nc" },
            conceallevel = {
                rendered = 2,
            },
        },
        checkbox = { checked = { scope_highlight = "@markup.strikethrough" } },
        latex = { enabled = true },
    },
}
