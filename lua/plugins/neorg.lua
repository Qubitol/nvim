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
	},
})
