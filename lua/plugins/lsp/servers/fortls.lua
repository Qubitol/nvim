local util = require("nvim_lsp.util")

return {
	settings = {
		cmd = {
			"fortls",
			"--symbol_skip_mem",
			"--incrmental_sync",
			"--autocomplete_no_prefix",
			"--autocomplete_name_only",
			"--variable_hover",
		},

		root_dir = util.path.dirname,
	},
}
