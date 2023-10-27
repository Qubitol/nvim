return {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = function()
        local lazy_map = require("utils").lazy_map
        return {
            lazy_map("n", "<leader>cf", function()
                require("conform").format({ async = true, lsp_fallback = true })
            end, "[C]onform [F]ormat buffer"),
        }
    end,
    -- Everything in opts will be passed to setup()
    opts = {
        -- Define your formatters
        formatters_by_ft = {
            bash = { "shfmt" },
            c = { "clang-format" },
            cpp = { "clang-format" },
            latex = { "latexindent" },
            lua = { "stylua" },
            -- Conform will run multiple formatters sequentially
            -- python = { "isort", "black" },
            python = { "black" },
            -- Use a sub-list to run only the first available formatter
            javascript = { { "prettierd", "prettier" } },
            html = { { "prettierd", "prettier" } },
            css = { { "prettierd", "prettier" } },
            -- Use the "*" filetype to run formatters on all filetypes.
            -- ["*"] = { "codespell" },
            -- Use the "_" filetype to run formatters on filetypes that don't
            -- have other formatters configured.
            -- ["_"] = { "trim_whitespace" },
        },
        -- Set up format-on-save
        -- format_on_save = {
        --     timeout_ms = 500,
        --     lsp_fallback = true
        -- },
        -- Customize formatters
        formatters = {
            shfmt = {
                prepend_args = { "-i", "2" },
            },
            stylua = {
                prepend_args = { "--indent-type", "Spaces" },
            },
        },
    },
    init = function()
        -- If you want the formatexpr, here is the place to set it
        vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
}
