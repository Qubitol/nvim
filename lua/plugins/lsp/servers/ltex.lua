return {
    on_attach = function(_, _)
        require("ltex_extra").setup({
            load_langs = { "en-US", "it" },
            init_check = true,
            path = vim.fn.expand("~") .. "/.config/nvim/spell",
        })
    end,
    filetypes = { "bib", "gitcommit", "org", "rst", "rnoweb", "tex", "pandoc", "quarto", "rmd", "context", "mail" },
    settings = {
        ltex = {
            enabled = {
                "bibtex",
                "gitcommit",
                "org",
                "tex",
                "restructuredtext",
                "rsweave",
                "latex",
                "quarto",
                "rmd",
                "context",
                "mail",
            },
        },
    },
}
