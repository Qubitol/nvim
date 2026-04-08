---@type vim.lsp.Config
return {
    cmd = {
        "fortls",
        "--incremental_sync",
        "--hover_signature",
        "--hover_language=fortran",
        "--use_signature_help",
        "--enable_code_actions",
    },
    filetypes = { "fortran" },
    root_markers = { ".fortls", ".git" },
}
