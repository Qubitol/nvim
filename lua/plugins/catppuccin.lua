local status_ok, catppuccin = pcall(require, "catppuccin")
if not status_ok then
	return
end

-- I took inspiration from https://github.com/ayamir/nvimdots
catppuccin.setup({
    flavour = "mocha", -- latte, frappe, macchiato, mocha

    background = { -- :h background
        light = "latte",
        dark = "mocha",
    },

    dim_inactive = {
        enabled = false,
        shade = "dark",
        percentage = 0.15,
    },

    show_end_of_buffer = false,
    term_colors = true,
    compile_path = vim.fn.stdpath("cache") .. "/catppuccin",

    integrations = {
        aerial = true,
        cmp = true,
        gitsigns = true,
        harpoon = true,
        markdown = true,
        mason = true,
        overseer = true,
        telescope = true,
        treesitter = true,
        treesitter_context = true,
    },

    dap = {
        enabled = true,
        enable_ui = true,
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

    color_overrides = {},
    highlight_overrides = {
        all = function(colors)
            return {
                -- base configs
                NormalFloat = { fg = colors.text, bg = colors.none or colors.mantle },
                FloatBorder = {
                    fg = colors.blue or colors.mantle,
                    bg = colors.none or colors.mantle,
                },

                -- native lsp configs
                DiagnosticVirtualTextError = { bg = colors.none },
                DiagnosticVirtualTextWarn = { bg = colors.none },
                DiagnosticVirtualTextInfo = { bg = colors.none },
                DiagnosticVirtualTextHint = { bg = colors.none },
                LspInfoBorder = { link = "FloatBorder" },

                -- Mason
                MasonNormal = { link = "NormalFloat" },

                -- nvim-cmp and wilder.nvim
                Pmenu = { fg = colors.overlay2, bg = colors.none or colors.base },
                PmenuBorder = { fg = colors.surface1, bg = colors.none or colors.base },
                PmenuSel = { bg = colors.green, fg = colors.base },
                CmpItemAbbr = { fg = colors.overlay2 },
                CmpItemAbbrMatch = { fg = colors.blue, style = { "bold" } },
                CmpDoc = { link = "NormalFloat" },
                CmpDocBorder = {
                    fg = colors.surface1 or colors.mantle,
                    bg = colors.none or colors.mantle,
                },

                -- Fidget
                FidgetTask = { bg = colors.none, fg = colors.surface2 },
                FidgetTitle = { fg = colors.blue, style = { "bold" } },

                -- Telescope
                TelescopeBorder = { fg = colors.mantle, bg = colors.mantle },
                TelescopePromptBorder = { fg = colors.surface0, bg = colors.surface0 },
                TelescopePromptNormal = { fg = colors.text, bg = colors.surface0 },
                TelescopePromptPrefix = { fg = colors.flamingo, bg = colors.surface0 },
                TelescopeNormal = { bg = colors.mantle },
                TelescopePreviewTitle = { fg = colors.base, bg = colors.green },
                TelescopePromptTitle = { fg = colors.base, bg = colors.red },
                TelescopeResultsTitle = { fg = colors.mantle, bg = colors.mantle },
                TelescopeSelection = { fg = colors.text, bg = colors.surface0 },
                TelescopeResultsDiffAdd = { fg = colors.green },
                TelescopeResultsDiffChange = { fg = colors.yellow },
                TelescopeResultsDiffDelete = { fg = colors.red },

                -- Harpoon
                HarpoonWindow = { bg = colors.mantle },
                HarpoonBorder = { fg = colors.mantle, bg = colors.mantle },

                -- Rnvimr
                RnvimrNormal = { bg = colors.mantle, fg = colors.text },

                -- Treesitter
                ["@keyword.return"] = { fg = colors.pink, style = {} },
            }
        end,
    },

})

-- setup must be called before loading
vim.cmd.colorscheme "catppuccin"

-- theme with keywords
local palette = require("catppuccin.palettes").get_palette("mocha")

local theme = {
    red = palette["red"],
    green = palette["green"],
    blue = palette["blue"],
    orange = palette["peach"],
    purple = palette["mauve"],
    cyan = palette["sapphire"],
    yellow = palette["yellow"],
    pink = palette["pink"],
    black1 = palette["crust"],
    black2 = palette["mantle"],
    black3 = palette["base"],
    gray1 = palette["surface0"],
    gray2 = palette["surface1"],
    gray3 = palette["surface2"],
    gray4 = palette["overlay0"],
    gray5 = palette["overlay1"],
    gray6 = palette["overlay2"],
    gray7 = palette["subtext0"],
    gray8 = palette["subtext1"],
    white = palette["text"],
}

return theme
