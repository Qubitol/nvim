return {
    "mfussenegger/nvim-lint",
    dependencies = {
        "neovim/nvim-lspconfig",
    },
    event = "BufReadPre",
    config = function()
        local lint = require("lint")
        lint.linters_by_ft = {
            lua = { "luacheck" },
            python = { "Flake8" }
        }
    end,
}
