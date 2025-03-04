return {
    "MeanderingProgrammer/render-markdown.nvim",
    version = "*",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons",
        "robbielyman/latex.nvim"
    },
    ft = "markdown",
    opts = {
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
            conceallevel = {
                rendered = 2,
            },
        },
        checkbox = { checked = { scope_highlight = "@markup.strikethrough" } },
        latex = { enabled = false },
    },
}
