return {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    event = "InsertEnter",
    config = function()
        require("copilot").setup({
            panel = {
                enabled = true,
                auto_refresh = true,
            },
            suggestion = {
                enabled = true,
                auto_trigger = true,
                keymap = {
                    accept = "<C-y>",
                    next = "<C-n>",
                    prev = "<C-p>",
                    dismiss = "<C-e>",
                },
            },
        })

        -- hide copilot suggestions when cmp menu is open
        -- to prevent odd behavior/garbled up suggestions
        local cmp_status_ok, cmp = pcall(require, "cmp")
        if cmp_status_ok then
            cmp.event:on("menu_opened", function()
                vim.b.copilot_suggestion_hidden = true
            end)

            cmp.event:on("menu_closed", function()
                vim.b.copilot_suggestion_hidden = false
            end)
        end
    end,

    keys = function()
        local lazy_map = require("utils").lazy_map
        return {
            lazy_map("n", "<leader>tc", "<cmd>Copilot toggle<CR>", "[T]oggle [C]opilot"),
        }
    end,
}
