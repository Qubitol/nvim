return {
	"mhartington/formatter.nvim",
	dependencies = {
		"neovim/nvim-lspconfig",
	},
	event = "BufReadPre",
    opts = {
        logging = true,
        log_level = vim.log.levels.WARN,
        filetype = {
            lua = { require("formatter.filetypes.lua").stylua },
            python = { require("formatter.filetypes.python").black }
        },
    },
}

