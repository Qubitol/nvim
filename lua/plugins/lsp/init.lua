return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        {
            "williamboman/mason-lspconfig.nvim",
            opts = {
                ensure_installed = require("plugins.lsp.servers"),
                automatic_installation = true,
            },
        },
        "williamboman/mason.nvim",
        "hrsh7th/cmp-nvim-lsp",
        {
            "barreiroleo/ltex_extra.nvim",
            ft = { "markdown", "tex" },
        },
    },

    config = function()
        local cmp_nvim_lsp = require("cmp_nvim_lsp")
        local lspconfig = require("lspconfig")
        local diagnostic_icons = require("utils.ui").icons.diagnostics

        -- Diagnostics
        local signs = {
            { name = "DiagnosticSignError", text = diagnostic_icons.Error },
            { name = "DiagnosticSignWarn",  text = diagnostic_icons.Warn },
            { name = "DiagnosticSignHint",  text = diagnostic_icons.Hint },
            { name = "DiagnosticSignInfo",  text = diagnostic_icons.Info },
        }

        for _, sign in ipairs(signs) do
            vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
        end

        local config = {
            virtual_text = false, -- disable virtual text
            signs = {
                active = signs,   -- show signs
            },
            update_in_insert = false,
            underline = true,
            severity_sort = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
                suffix = "",
            },
        }

        vim.diagnostic.config(config)

        -- Handlers
        -- Fix lsp showing two equal results in quickfix when going to definition
        local function get_first_if_equal(result)
            if not vim.tbl_islist(result) or type(result) ~= "table" then
                return result
            end
            return { result[1] }
        end

        local handlers = {
            ["textDocument/definition"] = function(err, result, ctx, conf)
                vim.lsp.handlers["textDocument/definition"](err, get_first_if_equal(result), ctx, conf)
            end,
            -- Set rounded borders
            ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
                border = "rounded",
            }),
            -- Set rounded borders
            ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
                border = "rounded",
            }),
        }

        -- Capabilities
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities.textDocument.completion.completionItem.snippetSupport = true
        capabilities = cmp_nvim_lsp.default_capabilities(capabilities)

        -- On attach
        local map = require("utils").map
        local on_attach = function(client, bufnr)
            local opts = { buffer = bufnr }
            map(
                "n",
                "gD",
                "<cmd>lua vim.lsp.buf.declaration()<CR>",
                "[G]o to [D]eclaration of identifier under the cursor",
                opts
            )
            map(
                "n",
                "<C-W>gD",
                "<cmd>vsplit | lua vim.lsp.buf.declaration()<CR>",
                "Split [W]indow vertically and [G]o to [D]eclaration of identifier under the cursor",
                opts
            )
            map("n", "<C-W><C-G>D", "<cmd>vsplit | lua vim.lsp.buf.declaration()<CR>", "Same as 'CTRL-W gD'", opts)
            map(
                "n",
                "<C-W>D",
                "<cmd>split | lua vim.lsp.buf.declaration()<CR>",
                "Split [W]indow and jump to [D]eclaration of identifier under the cursor",
                opts
            )
            map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", "[G]o to [D]efinition under the cursor", opts)
            map(
                "n",
                "<C-W>gd",
                "<cmd>vsplit | lua vim.lsp.buf.definition()<CR>",
                "Split [W]indow vertically and [G]o to [D]efinition under the cursor",
                opts
            )
            map("n", "<C-W><C-G>d", "<cmd>vsplit | lua vim.lsp.buf.definition()<CR>", "Same as 'CTRL-W gd'", opts)
            map(
                "n",
                "<C-W>d",
                "<cmd>split | lua vim.lsp.buf.definition()<CR>",
                "Split [W]indow and jump to [D]efinition under the cursor",
                opts
            )
            map("n", "<C-W><C-D>", "<cmd>split | lua vim.lsp.buf.definition()<CR>", "Same as 'CTRL-W d'", opts)
            map(
                "n",
                "<leader>li",
                "<cmd>lua vim.lsp.buf.implementation()<CR>",
                "[L]ist of [I]mplementations under the cursor in quickfix window",
                opts
            )
            map(
                "n",
                "<leader>lr",
                "<cmd>lua vim.lsp.buf.references()<CR>",
                "[L]ist of [R]eferences under the cursor in quickfix window",
                opts
            )
            -- map("n", "gtd", "<cmd>vsplit | lua vim.lsp.buf.definition()<CR><C-w>T", "[G]o to a new [T]ab with [D]efinition of the term under the cursor", opts)
            map(
                "n",
                "K",
                "<cmd>lua vim.lsp.buf.hover()<CR>",
                "Show information about the term under the cursor, like hovering",
                opts
            )
            map(
                "n",
                "<leader>cf",
                "<cmd>lua vim.lsp.buf.format({ async = true })<cr>",
                "Run the [C]ode [F]ormatter on the current file",
                opts
            )
            map(
                "n",
                "<leader>ca",
                "<cmd>lua vim.lsp.buf.code_action()<cr>",
                "Open possible LSP [C]ode [A]ctions for the diagnostic under the cursor",
                opts
            )
            map(
                "n",
                "]d",
                "<cmd>lua vim.diagnostic.goto_next({ buffer = 0 })<cr>zz",
                "Go to next [D]iagnostic, center viewport",
                opts
            )
            map(
                "n",
                "[d",
                "<cmd>lua vim.diagnostic.goto_prev({ buffer = 0 })<cr>zz",
                "Go to previous [D]iagnostic, center viewport",
                opts
            )
            map("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename the identifier under the cursor", opts)
            map(
                "n",
                "<leader>H",
                "<cmd>lua vim.lsp.buf.signature_help()<CR>",
                "Show an [H]elper with the signature of the term under the cursor",
                opts
            )
            map(
                "n",
                "<leader>ll",
                "<cmd>lua vim.diagnostic.setloclist()<CR>",
                "Open the [L]SP diagnostics in the [L]ocation list",
                opts
            )
            map(
                "n",
                "<leader>lq",
                "<cmd>lua vim.diagnostic.setqflist()<CR>",
                "Open the [L]SP diagnostics in the [Q]uickfix list",
                opts
            )

            -- Get on attach for each server
            local require_ok, server = pcall(require, "plugins.lsp.servers." .. client.name)
            if require_ok and server.on_attach then
                server.on_attach(client, bufnr)
            end
        end

        -- initialize each language server
        local servers = require("plugins.lsp.servers")
        for _, server_name in pairs(servers) do
            server_name = vim.split(server_name, "@")[1]

            -- default options for each language server
            local opts = {
                on_attach = on_attach,
                capabilities = capabilities,
                handlers = handlers,
            }

            local require_ok, server = pcall(require, "plugins.lsp.servers." .. server_name)
            if require_ok and server.settings then
                opts["settings"] = server.settings
            end

            lspconfig[server_name].setup(opts)
        end
    end,

    keys = function()
        local lazy_map = require("utils").lazy_map
        return {
            lazy_map("n", "<leader>ol", "<cmd>LspInfo<CR>", "[O]pen [L]sp info"),
        }
    end,
}
