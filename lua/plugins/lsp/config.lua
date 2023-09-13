local status_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if not status_ok then
	return
end

local servers = {
    "awk_ls",
    -- "angularls",
    -- "arduino_language_server",
    "bashls",
    "clangd",
    -- "csharp_ls",
    "cmake",
	"cssls",
    "dockerls",
    -- "emmet_ls",
    "fortls",
    -- "ltex",
	"html",
	-- "jsonls",
	-- "tsserver",
    -- "julials",
    "texlab",
	"sumneko_lua",
    -- "zk",
    "pyright",
    "rust_analyzer",
    -- "sqls",
    -- "tamplo",
    -- "volar",
	-- "yamlls",
}

mason_lspconfig.setup({
	ensure_installed = servers,
	automatic_installation = true,
})

local lspconfig = require("lspconfig")

-- default options for each language server
local opts = {
    on_attach = require("plugins.lsp.handlers").on_attach,
    capabilities = require("plugins.lsp.handlers").capabilities,
    handlers = require("plugins.lsp.handlers").handlers,
}

for _, server in pairs(servers) do
	server = vim.split(server, "@")[1]

	local require_ok, settings_ls = pcall(require, "plugins.lsp.settings." .. server)
	if require_ok then
        -- add settings of each language server
		opts["settings"] = settings_ls
	end

	lspconfig[server].setup(opts)
end
