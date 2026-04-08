---@type vim.lsp.Config
return {
    cmd = { "vim-language-server", "--stdio" },
    filetypes = { "vim" },
    root_markers = { ".git" },
}
