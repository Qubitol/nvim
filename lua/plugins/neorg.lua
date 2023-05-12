local status_ok, neorg = pcall(require, "neorg")
if not status_ok then
	return
end

neorg.setup({
	load = {
		-- Loads default behaviour
		["core.defaults"] = {
			config = {
				disable = {
					"core.norg.journal",
					"core.norg.news",
				},
			},
		},

		-- Neorg concealer
		["core.concealer"] = {
			config = {
				icon_preset = "diamond",
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

		["core.esupports.metagen"] = {
			config = {
				type = "auto",
				template = {
					{ "title", "" },
					{ "description", "" },
					{ "authors", "" },
					{ "categories", "" },
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
                    local leader = keybinds.leader

                    -- Open looking glass
                    keybinds.map("norg", "n", leader .. "no", "<cmd>Neorg keybind all core.looking-glass.magnify-code-block<CR>")

                    -- Toggle concealer
                    keybinds.map("norg", "n", leader .. "tc", "<cmd>Neorg toggle-concealer<CR>")

                    -- Open toc
                    keybinds.map("norg", "n", leader .. "nt", "<cmd>Neorg toc<CR>")

                    -- Marks the task under the cursor as "undone"
                    keybinds.map("norg", "n", leader .. "nu", "<cmd>Neorg keybind norg core.qol.todo_items.todo.task_undone<CR>")

                    -- Marks the task under the cursor as "pending"
                    keybinds.map("norg", "n", leader .. "np", "<cmd>Neorg keybind norg core.qol.todo_items.todo.task_pending<CR>")

                    -- Marks the task under the cursor as "done"
                    keybinds.map("norg", "n", leader .. "nd", "<cmd>Neorg keybind norg core.qol.todo_items.todo.task_done<CR>")

                    -- Marks the task under the cursor as "on_hold"
                    keybinds.map("norg", "n", leader .. "nh", "<cmd>Neorg keybind norg core.qol.todo_items.todo.task_on_hold<CR>")

                    -- Marks the task under the cursor as "cancelled"
                    keybinds.map("norg", "n", leader .. "nc", "<cmd>Neorg keybind norg core.qol.todo_items.todo.task_cancelled<CR>")

                    -- Marks the task under the cursor as "recurring"
                    keybinds.map("norg", "n", leader .. "nr", "<cmd>Neorg keybind norg core.qol.todo_items.todo.task_recurring<CR>")

                    -- Marks the task under the cursor as "important"
                    keybinds.map("norg", "n", leader .. "ni", "<cmd>Neorg keybind norg core.qol.todo_items.todo.task_important<CR>")

                    -- Switches the task under the cursor between a select few states
                    keybinds.map("norg", "n", "<C-n>", "<cmd>Neorg keybind norg core.qol.todo_items.todo.task_cycle<CR>")
                end,

                -- Set neorg leader to <Leader>
                neorg_leader = "<Leader>"
            }
        }
	},
})
