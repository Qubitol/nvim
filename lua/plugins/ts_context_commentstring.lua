return {
    "JoosepAlviste/nvim-ts-context-commentstring",
    dependencies = {
        "nvim-treesitter/nvim-treesitter"
    },
    main = "ts_context_commentstring",
    init = function()
        vim.g.skip_ts_commentstring_module = true
    end,
    opts = {
        enable_autocmd = false,
    },
}
