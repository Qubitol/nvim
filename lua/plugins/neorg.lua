return {
    "nvim-neorg/neorg",
    dependencies = {
        "hrsh7th/nvim-cmp",
    },
    version = "*",
    ft = "norg",
    build = ":Neorg sync-parsers",
    opts = function()
        local neorg_mappings = {
            n = {
                { "<leader>tn", "<cmd>Neorg toggle-concealer<CR>", "[T]oggle [N]eorg concelaer" },
                {
                    "<leader>no",
                    "<cmd>Neorg keybind all core.looking-glass.magnify-code-block<CR>",
                    "Run [N]eorg looking glass to [O]pen code blocks in separate buffers",
                },
                { "<leader>nt", "<cmd>Neorg toc<CR>",              "Open [N]eorg [T]oc" },
                {
                    "<leader>nu",
                    "<cmd>Neorg keybind norg core.qol.todo_items.todo.task_undone<CR>",
                    "Mark the [N]eorg task under the cursor as '[U]ndone'",
                },
                {
                    "<leader>np",
                    "<cmd>Neorg keybind norg core.qol.todo_items.todo.task_pending<CR>",
                    "Mark the [N]eorg task under the cursor as '[P]ending'",
                },
                {
                    "<leader>nd",
                    "<cmd>Neorg keybind norg core.qol.todo_items.todo.task_done<CR>",
                    "Mark the [N]eorg task under the cursor as '[D]one'",
                },
                {
                    "<leader>nh",
                    "<cmd>Neorg keybind norg core.qol.todo_items.todo.task_on_hold<CR>",
                    "Mark the [N]eorg task under the cursor as 'on [H]old'",
                },
                {
                    "<leader>nc",
                    "<cmd>Neorg keybind norg core.qol.todo_items.todo.task_cancelled<CR>",
                    "Mark the [N]eorg task under the cursor as '[C]ancelled'",
                },
                {
                    "<leader>nr",
                    "<cmd>Neorg keybind norg core.qol.todo_items.todo.task_recurring<CR>",
                    "Mark the [N]eorg task under the cursor as '[R]ecurring'",
                },
                {
                    "<leader>ni",
                    "<cmd>Neorg keybind norg core.qol.todo_items.todo.task_important<CR>",
                    "Mark the [N]eorg task under the cursor as '[I]mportant'",
                },
                {
                    "<C-n>",
                    "<cmd>Neorg keybind norg core.qol.todo_items.todo.task_cycle<CR>",
                    "Cycle among [N]eorg task statuses",
                },
                {
                    ">>",
                    "<cmd>Neorg keybind norg core.promo.promote_range<CR><cmd>Neorg keybind norg core.promo.promote<CR>",
                    "Promote list item (recursively)",
                },
                {
                    "<<",
                    "<cmd>Neorg keybind norg core.promo.promote_range<CR><cmd>Neorg keybind norg core.promp.demote<CR>",
                    "Demote list item (recursively)",
                },
                { ">.", "<cmd>Neorg keybind norg core.promo.promote<CR>", "Promote list item (non-recursively)" },
                { "<.", "<cmd>Neorg keybind norg core.promp.demote<CR>",  "Demote list item (non-recursively)" },
            },
            i = {
                {
                    "<C-t>",
                    "<cmd>Neorg keybind norg core.promo.promote<CR>",
                    "Promote list item (non-recursively)",
                },
                {
                    "<C-d>",
                    "<cmd>Neorg keybind norg core.promp.demote<CR>",
                    "Demote list item (non-recursively)",
                },
                { "<C-n>", "<cmd>Neorg keybind norg core.itero.next-iteration<CR>", "Create next list item" },
            },
        }
        return {
            load = {
                -- Loads default behaviour
                ["core.defaults"] = {
                    config = {
                        disable = {
                            "core.journal",
                        },
                    },
                },

                -- Neorg concealer
                ["core.concealer"] = {
                    config = {
                        icon_preset = "diamond",
                    },
                },

                -- Completion engines
                ["core.completion"] = {
                    config = {
                        engine = "nvim-cmp",
                    },
                },

                -- Manages Neorg workspaces
                ["core.dirman"] = {
                    config = {
                        workspaces = {
                            default = "~/Documents/Notes",
                        },
                    },
                },

                -- Metadata
                ["core.esupports.metagen"] = {
                    config = {
                        type = "none",
                        template = {
                            { "title",       "" },
                            { "description", "" },
                            { "authors",     "" },
                            { "categories",  "" },
                            {
                                "created",
                                function()
                                    return os.date("%Y-%m-%d")
                                end,
                            },
                            {
                                "updated",
                                function()
                                    return os.date("%Y-%m-%d")
                                end,
                            },
                            { "version", "1.0" },
                        },
                        update_date = true,
                    },
                },

                -- Export functionalities
                ["core.export"] = {},

                -- Export to markdown
                ["core.export.markdown"] = {
                    config = { extensions = "all" },
                },

                -- Set keybinds
                ["core.keybinds"] = {
                    config = {
                        -- Do not use defaults
                        default_keybinds = false,

                        -- Set new keybinds
                        hook = function(keybinds)
                            local keymaps = {}
                            local default_opts = { noremap = true, silent = true }
                            for mode, keys in pairs(neorg_mappings) do
                                keymaps[mode] = {}
                                for _, mapping_info in ipairs(keys) do
                                    local lhs = mapping_info[1]
                                    local rhs = mapping_info[2]
                                    local opts = vim.tbl_deep_extend(
                                        "force",
                                        default_opts,
                                        mapping_info[4] or {},
                                        { desc = mapping_info[3] }
                                    )
                                    table.insert(keymaps[mode], { lhs, rhs, opts })
                                end
                            end

                            keybinds.map_to_mode("norg", keymaps)
                        end,

                        -- Set neorg leader to <leader>
                        neorg_leader = "<leader>",
                    },
                },
            },
        }
    end,
}
