return {
	"williamboman/mason.nvim",
	build = ":MasonUpdate",
	opts = {
		ui = {
			border = "rounded",
			height = 0.8,
			icons = {
				package_installed = "✓",
				package_pending = "➜",
				package_uninstalled = "✗",
			},
		},
		max_concurrent_installers = 4,
	},
	keys = function()
		local lazy_map = require("utils").lazy_map
		return {
			lazy_map("n", "<leader>om", "<cmd>Mason<CR>", "[O]pen [M]ason dashboard"),
		}
	end,
}
