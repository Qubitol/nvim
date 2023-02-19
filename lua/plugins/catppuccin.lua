local status_ok, catppuccin = pcall(require, "catppuccin")
if not status_ok then
	return
end

catppuccin.setup({
    flavour = "mocha", -- latte, frappe, macchiato, mocha

    background = { -- :h background
        light = "latte",
        dark = "mocha",
    },

    integrations = {
        aerial = true,
        cmp = true,
        gitsigns = true,
        harpoon = true,
        -- lualine = true,
        lsp_trouble = true,
        markdown = true,
        mason = true,
        notify = true,
        telescope = true,
        treesitter = true,
        treesitter_context = true,
    },

    dap = {
        enabled = true,
        enable_ui = false
    },

    indent_blankline = {
        enabled = true,
        colored_indent_levels = false,
    },

    native_lsp = {
        enabled = true,
        virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
        },
        underlines = {
            errors = { "underline" },
            hints = { "underline" },
            warnings = { "underline" },
            information = { "underline" },
        },
    },

    navic = {
        enabled = false,
        custom_bg = "NONE",
    },
})

-- setup must be called before loading
vim.cmd.colorscheme "catppuccin"
