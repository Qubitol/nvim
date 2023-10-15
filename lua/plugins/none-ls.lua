return {
    "nvimtools/none-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "williamboman/mason.nvim",
        "jay-babu/mason-null-ls.nvim",
    },
    opts = function()
        local null_ls = require("null-ls")
        local opts = {}
        opts.sources = {
            -- latex
            null_ls.builtins.formatting.latexindent,
            -- lua
            null_ls.builtins.formatting.stylua,
            -- python
            null_ls.builtins.formatting.autopep8,
            -- shell
            null_ls.builtins.code_actions.shellcheck,
            null_ls.builtins.diagnostics.shellcheck,
            -- web
            null_ls.builtins.formatting.prettierd,
        }
        return opts
    end,
    config = function(_, opts)
        require("null-ls").setup(opts)
        require("mason-null-ls").setup({
            ensure_installed = nil,
            automatic_installation = true,
        })
    end
}
