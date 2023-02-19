local status_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if not status_ok then
	return
end

local servers = {
    -- "awk_ls",
    -- "angularls",
    -- "arduino_language_server",
    "bashls",
    "clangd",
    -- "csharp_ls",
    "cmake",
	"cssls",
    -- "dockerls",
    -- "emmet_ls",
    "fortls",
    "ltex",
	"html",
	-- "jsonls",
	-- "tsserver",
    -- "julials",
    "texlab",
	"sumneko_lua",
    "zk",
    "pyright",
    -- "rust_analyzer",
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

local opts = {}

for _, server in pairs(servers) do
    -- default options for each language server
	opts = {
		on_attach = require("plugins.lsp.handlers").on_attach,
		-- capabilities = require("plugins.lsp.handlers").capabilities,
	}

	server = vim.split(server, "@")[1]

	local require_ok, conf_opts = pcall(require, "plugins.lsp.settings." .. server)
	if require_ok then
        -- if there are additional options for this language server, add them to
        -- the default options
		opts = vim.tbl_deep_extend("force", conf_opts, opts)
	end

	lspconfig[server].setup(opts)
end
