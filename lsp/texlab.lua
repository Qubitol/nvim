---@type vim.lsp.Config
return {
    cmd = { "texlab" },
    filetypes = { "tex", "plaintex", "bib" },
    root_markers = { ".latexmkrc", "latexmkrc", "Tectonic.toml", ".git" },
    settings = {
        texlab = {
            bibtexFormatter = "latexindent",
        },
    },
}
