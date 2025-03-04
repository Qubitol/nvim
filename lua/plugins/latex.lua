return {
    "robbielyman/latex.nvim",
    ft = { "tex", "markdown" },
    options = {
        conceals = {
            enabled = {
                "greek",
                "math",
                "script",
                "delim",
                "font",
            },
            add = {},
        },
        imaps = { enabled = false },
        surrounds = { enabled = false, },
    },
}
