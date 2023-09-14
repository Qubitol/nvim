local status_ok, mason_null_ls = pcall(require, "mason-null-ls")
if not status_ok then
	return
end

HOME = os.getenv("HOME")

local null_ls = require("null-ls")

local code_actions = null_ls.builtins.code_actions
local diagnostics = null_ls.builtins.diagnostics
local formatting = null_ls.builtins.formatting

null_ls.setup({
    sources = {
        code_actions.gitsigns,
        -- code_actions.ltrs.with({ extra_filetypes = { "tex" }, }),
        -- code_actions.proselint.with({ extra_filetypes = { "tex" }, }),
        -- diagnostics.proselint.with({ extra_filetypes = { "tex" }, }),
        -- diagnostics.ltrs.with({ extra_filetypes = { "tex" }, }),
        -- diagnostics.pylint,
        -- diagnostics.flake8,
        -- diagnostics.vale.with({
        --     extra_filetypes = { "txt", "text", "md", "wiki", "markdown" },
        --     extra_args = { "--config=" .. HOME .. "/.config/vale/.vale.ini" },
        -- }),
        formatting.prettier.with({ extra_args = { "--no-semi" } }),
        formatting.black.with({ extra_args = { "--fast" } }),
        formatting.stylua,
    }
})

mason_null_ls.setup({
    ensure_installed = nil,
    automatic_installation = true,
    automatic_setup = false,
})
