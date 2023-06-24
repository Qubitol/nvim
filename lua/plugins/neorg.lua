local status_ok, neorg = pcall(require, "neorg")
if not status_ok then
	return
end

local mappings = require("core.mappings")

neorg.setup({
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

                    local neorg_mappings = {}
                    local default_opts = { noremap = true, silent = true }
                    for mode, keys in pairs(mappings.plugins["neorg"]) do
                        neorg_mappings[mode] = {}
                        for key, mapping_info in pairs(keys) do
                            local command = mapping_info[1]
                            local opts = vim.tbl_deep_extend("force",
                                default_opts,
                                mapping_info[3] or {},
                                { desc = mapping_info[2] }
                            )
                            table.insert(neorg_mappings[mode], { key, command, opts })
                        end
                    end

                    keybinds.map_to_mode("norg", neorg_mappings)
                end,

                -- Set neorg leader to <Leader>
                neorg_leader = "<leader>"
            }
        }
	},
})
