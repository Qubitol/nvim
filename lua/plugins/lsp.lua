-- LSP

local map = require("config.utils").map
local ui = require("config.ui")

-- Mason: tool installer
-- PackChanged hook must come before vim.pack.add()
vim.api.nvim_create_autocmd("PackChanged", {
    callback = function(ev)
        if ev.data.spec.name == "mason.nvim" and ev.data.kind == "update" then
            if not ev.data.active then vim.cmd.packadd("mason.nvim") end
            vim.cmd("MasonUpdate")
        end
    end,
})

vim.pack.add({ "https://github.com/mason-org/mason.nvim" })

require("mason").setup({
    ui = {
        border = "rounded",
        height = 0.8,
        icons = ui.icons.mason,
    },
    max_concurrent_installers = 4,
})

map("n", "<leader>om", "<cmd>Mason<CR>", "[O]pen [M]ason dashboard")

-- Conform: formatting
vim.pack.add({ "https://github.com/stevearc/conform.nvim" })

vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

require("conform").setup({
    formatters_by_ft = {
        bash       = { "shfmt" },
        c          = { "clang-format" },
        cpp        = { "clang-format" },
        css        = { "prettierd", "prettier", stop_after_first = true },
        html       = { "prettierd", "prettier", stop_after_first = true },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        latex      = { "latexindent" },
        lua        = { "stylua" },
        python     = { "ruff", "black", stop_after_first = true },
        yaml       = { "prettierd", "prettier", stop_after_first = true },
        json       = { "prettierd", "prettier", stop_after_first = true },
    },
    formatters = {
        shfmt  = { prepend_args = { "-i", "2" } },
        stylua = { prepend_args = { "--indent-type", "Spaces" } },
        yamlfix = { env = { YAMLFIX_LINE_LENGTH = "80" } },
    },
})

map("n", "<leader>cf", function()
    require("conform").format({ async = true, lsp_fallback = true })
end, "[C]ode [F]ormatting")

-- nvim-lint: linting
vim.pack.add({ "https://github.com/mfussenegger/nvim-lint" })

local lint = require("lint")

lint.linters_by_ft = {
    bash   = { "shellcheck" },
    cmake  = { "cmakelint" },
    cpp    = { "cpplint" },
    lua    = { "luacheck" },
    python = { "ruff" },
    sh     = { "shellcheck" },
    yaml   = { "yamllint" },
    zsh    = { "shellcheck" },
    ["*"]  = {},
    ["_"]  = {},
}

local function do_lint()
    local names = lint._resolve_linter_by_ft(vim.bo.filetype)
    if #names == 0 then
        vim.list_extend(names, lint.linters_by_ft["_"] or {})
    end
    vim.list_extend(names, lint.linters_by_ft["*"] or {})

    local ctx = { filename = vim.api.nvim_buf_get_name(0) }
    ctx.dirname = vim.fn.fnamemodify(ctx.filename, ":h")
    names = vim.tbl_filter(function(name)
        local linter = lint.linters[name]
        if not linter then
            vim.notify("[nvim-lint] Linter not found: " .. name, vim.log.levels.WARN)
        end
        return linter and not (type(linter) == "table" and linter.condition and not linter.condition(ctx))
    end, names)

    if #names > 0 then
        lint.try_lint(names)
    end
end

local lint_timer = vim.uv.new_timer()
local function debounced_lint()
    lint_timer:start(100, 0, function()
        lint_timer:stop()
        vim.schedule(do_lint)
    end)
end

vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
    group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
    callback = debounced_lint,
})

-- LSP: enable servers and configure on attach
-- Server configs live in lsp/ directory at the config root.
-- Each file returns a vim.lsp.Config table.
-- See https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
-- for proper name, cmd, default filetypes, and root_markers
vim.lsp.enable({
    "awk_ls",
    "bashls",
    "clangd",
    "cmake",
    "cssls",
    "dockerls",
    "fortls",
    "htmlls",
    "jsonls",
    "ltex-plus",
    "lua_ls",
    "texlab",
    "ty",
    "vimls",
    "yamlls",
})

vim.diagnostic.config({
    virtual_text = true,
    severity_sort = true,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = ui.icons.diagnostics.Error,
            [vim.diagnostic.severity.WARN]  = ui.icons.diagnostics.Warn,
            [vim.diagnostic.severity.INFO]  = ui.icons.diagnostics.Info,
            [vim.diagnostic.severity.HINT]  = ui.icons.diagnostics.Hint,
        },
    },
})

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if not client then return end

        -- Enable omnifunc completion: <C-x><C-o> to trigger
        if client:supports_method("textDocument/completion") then
            vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
        end

        -- Extra mappings beyond 0.12 built-in defaults
        local function bmap(mode, lhs, rhs, desc)
            map(mode, lhs, rhs, desc, { buffer = ev.buf })
        end

        bmap("n", "<leader>sd", vim.lsp.buf.declaration, "Go to [S]ymbol [D]eclaration")
        bmap("n", "<leader>sh", vim.lsp.buf.signature_help, "[S]ignature [H]elp")
        bmap("i", "<C-s>", vim.lsp.buf.signature_help, "Signature help (insert mode)")

        -- Diagnostics with centering (override the built-in [d / ]d)
        bmap("n", "[d", function()
            vim.diagnostic.jump({ count = -1 })
            vim.cmd("normal! zz")
        end, "Go to previous [D]iagnostic, center viewport")
        bmap("n", "]d", function()
            vim.diagnostic.jump({ count = 1 })
            vim.cmd("normal! zz")
        end, "Go to next [D]iagnostic, center viewport")

        -- Inlay hints toggle (if supported)
        if client:supports_method("textDocument/inlayHint") then
            bmap("n", "<leader>ti", function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf }), { bufnr = ev.buf })
            end, "[T]oggle [I]nlay hints")
        end

        -- Toggle virtual text diagnostic
        bmap("n", "<leader>tv", function()
            local new_config = not vim.diagnostic.config().virtual_text
            vim.diagnostic.config({ virtual_text = new_config })
        end, "[T]oggle [V]irtual text in diagnostic")

        -- Toggle lists
        bmap("n", "<leader>lq", vim.diagnostic.setqflist, "Open the [L]ist of diagnostics in the [Q]uickfix list")
        bmap("n", "<leader>ll", vim.diagnostic.setloclist, "Open the [L]ist of diagnostics in the [L]ocation list")
    end,
})
