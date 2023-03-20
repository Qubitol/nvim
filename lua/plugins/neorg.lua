local status_ok, neorg = pcall(require, "neorg")
if not status_ok then
	return
end

neorg.setup({
	load = {
		["core.defaults"] = { -- Loads default behaviour
            config = {
                disable = {
                    "core.integrations.truezen",
                    "core.integrations.zen_mode",
                    "core.presenter",
                },
            },
        },
		["core.norg.dirman"] = { -- Manages Neorg workspaces
			config = {
				workspaces = {
					notes = "~/Documents/Notes",
				},
			},
		},
	},
})
