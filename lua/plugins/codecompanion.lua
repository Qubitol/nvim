-- CodeCompanion

vim.pack.add({
    { src = "https://www.github.com/nvim-lua/plenary.nvim" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
    {
        src = "https://www.github.com/olimorris/codecompanion.nvim",
        version = vim.version.range("^19.0.0"),
    },
})

-- Somewhere in your config
require("codecompanion").setup({
    interactions = {
        chat = {
            adapter = "copilot",
        },
        inline = {
            adapter = "copilot",
        },
        cmd = {
            adapter = "copilot",
        },
        cli = {
            agent = "claude_code",
            agents = {
                claude_code = {
                    cmd = "claude",
                    args = {},
                    description = "Claude Code CLI",
                    provider = "terminal",
                },
            },
        },
    },
})

local map = require("config.utils").map

map({ "n", "v" }, "<leader>cc", "<cmd>CodeCompanionActions<cr>", "[C]ode[C]ompanion Actions")
map({ "n", "v" }, "<leader>co", "<cmd>CodeCompanionChat Toggle<cr>", "[C]odeCompation Chat [O]pen")
map({ "n", "v" }, "<leader>ca", "<cmd>CodeCompanionCLI<cr>", "[C]odeCompation CLI for [A]gent interaction")
map("v", "ga", "<cmd>CodeCompanionChat Add<cr>", "Add visually selected chat to the current chat buffer")

-- Expand 'cc' into 'CodeCompanion' in the command line
vim.cmd([[cab cc CodeCompanion]])
