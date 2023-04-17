local M = {}

M.setup = function()
    local signs = {
        { name = "DiagnosticSignError", text = "" },
        { name = "DiagnosticSignWarn", text = "" },
        { name = "DiagnosticSignHint", text = "" },
        { name = "DiagnosticSignInfo", text = "" },
    }

    for _, sign in ipairs(signs) do
        vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
    end

    local config = {
        virtual_text = false, -- disable virtual text
        signs = {
            active = signs, -- show signs
        },
        update_in_insert = false,
        underline = true,
        severity_sort = true,
        float = {
            focusable = true,
            style = "minimal",
            border = "rounded",
            source = "always",
            header = "",
            prefix = "",
        },
    }

    vim.diagnostic.config(config)

    -- Set rounded borders
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "rounded",
    })

    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "rounded",
    })

    -- Delay update diagnostics
    -- vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    --     update_in_insert = false,
    -- })
end

local function lsp_keymaps(bufnr)
    local opts = { noremap = true, silent = true }
    local keymap = vim.api.nvim_buf_set_keymap
    keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
    keymap(bufnr, "n", "g|D", "<cmd>vsplit | lua vim.lsp.buf.declaration()<CR>", opts)
    keymap(bufnr, "n", "g_D", "<cmd>split | lua vim.lsp.buf.declaration()<CR>", opts)
    keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
    keymap(bufnr, "n", "g|d", "<cmd>vsplit | lua vim.lsp.buf.definition()<CR>", opts)
    keymap(bufnr, "n", "g_d", "<cmd>split | lua vim.lsp.buf.definition()<CR>", opts)
    keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
    keymap(bufnr, "n", "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
    keymap(bufnr, "n", "<leader>lf", "<cmd>lua vim.lsp.buf.format{ async = true }<cr>", opts)
    keymap(bufnr, "n", "<leader>li", "<cmd>LspInfo<cr>", opts)
    keymap(bufnr, "n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
    keymap(bufnr, "n", "]d", "<cmd>lua vim.diagnostic.goto_next({buffer=0})<cr>zz", opts)
    keymap(bufnr, "n", "[d", "<cmd>lua vim.diagnostic.goto_prev({buffer=0})<cr>zz", opts)
    keymap(bufnr, "n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
    keymap(bufnr, "n", "<C-h>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
    -- if status_trouble_ok then
    --     keymap(bufnr, "n", "gr", "<cmd>TroubleToggle lsp_references<cr>", { silent = true, noremap = true })
    --     keymap(bufnr, "n", "<leader>tl", "<cmd>TroubleToggle loclist<CR>", opts)
    --     keymap(bufnr, "n", "<leader>tq", "<cmd>TroubleToggle quickfix<CR>", opts)
    -- else
    keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
    keymap(bufnr, "n", "<leader>tl", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
    keymap(bufnr, "n", "<leader>tq", "<cmd>lua vim.diagnostic.setqflist()<CR>", opts)
    -- end
end

M.on_attach = function(client, bufnr)
    -- if client.name == "tsserver" then
    --     client.server_capabilities.documentFormattingProvider = false
    -- end

    -- if client.name == "sumneko_lua" then
    --     client.server_capabilities.documentFormattingProvider = false
    -- end

    lsp_keymaps(bufnr)
end

return M
