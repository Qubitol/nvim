return {
    "L3MON4D3/LuaSnip",
    version = "*",
    build = "make install_jsregexp",
    priority = 100, -- needs to be loaded before nvim-cmp
    event = { "InsertEnter" },
    config = function()
        -- Useful redefinitions
        local ls = require("luasnip")
        local types = require("luasnip.util.types")

        -- Fetch colors from palette
        local colors = require("utils.colors").theme

        -- Configuration
        ls.config.set_config({
            -- Don't store snippet history for less overhead
            history = false,

            -- Enable autotriggered snippets
            enable_autosnippets = true,

            -- Use Tab (or some other key if you prefer) to trigger visual selection
            store_selection_keys = "<Tab>",

            -- Update changes as you type
            updateevents = "TextChanged,TextChangedI",

            -- Extra options
            ext_opts = {
                [types.choiceNode] = {
                    active = {
                        virt_text = { { "●", colors.yellow } },
                    },
                },
                -- [types.insertNode] = {
                --     active = {
                --         virt_text = { { "●", colors.teal } },
                --     },
                -- },
            },
        })

        -- Load the snippets
        require("luasnip.loaders.from_lua").lazy_load({ paths = "~/.config/nvim/LuaSnip/" })

        -- Mappings, to be defined here because they are not lazy
        local map = require("utils").map
        map("i", "<Tab>", function()
            if ls.expand_or_locally_jumpable() then
                return [[<cmd>lua require("luasnip").expand_or_jump()<CR>]]
            else
                return "<Tab>"
            end
        end, "If there is an expandable snippet, expand it, otherwise jump forward or fallback to default map", { noremap = false, expr = true })
        map("i", "<S-Tab>", function() ls.jump(-1) end, "When inside a snippet, jump back")
        map({"i", "n"}, "<C-n>", function()
            if ls.choice_active() then
                return [[<cmd>lua require("luasnip").next_choice()<CR>]]
            else
                return "<C-n>"
            end
        end, "When inside a choice node, select next choice", { noremap = false, expr = true })
        map({"i", "n"}, "<C-p>", function()
            if ls.choice_active() then
                return [[<cmd>lua require("luasnip").prev_choice()<CR>]]
            else
                return "<C-p>"
            end
        end, "When inside a choice node, select previous choice", { noremap = false, expr = true })
        map("s", "<Tab>", function() require("luasnip").jump(1) end, "When inside a snippet, jump forward")
        map("s", "<S-Tab>", function() require("luasnip").jump(-1) end, "When inside a snippet, jump back")
    end,

    keys = function()
        local lazy_map = require("utils").lazy_map
        return {
            lazy_map(
            "n",
            "<leader>U",
            [[<cmd>lua require("luasnip.loaders.from_lua").load({paths = "~/.config/nvim/LuaSnip/"})<CR>]],
            "Reload/[U]pdate the snippets at runtime"
            ),
        }
    end,
}
