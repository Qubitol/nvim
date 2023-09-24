-- I took inspiration from https://github.com/ayamir/nvimdots
return {
    "ellisonleao/gruvbox.nvim",
    name = "gruvbox",
    lazy = false,
    priority = 1000,
    opts = {
        terminal_colors = true, -- add neovim terminal colors
        undercurl = true,
        underline = true,
        bold = true,
        italic = {
            strings = true,
            emphasis = true,
            comments = true,
            operators = false,
            folds = true,
        },
        strikethrough = true,
        invert_selection = false,
        invert_signs = false,
        invert_tabline = false,
        invert_intend_guides = false,
        inverse = true, -- invert background for search, diffs, statuslines and errors
        contrast = "", -- can be "hard", "soft" or empty string
        palette_overrides = {},
        overrides = {},
        dim_inactive = false,
        transparent_mode = false,
    },

    config = function(_, opts)
        local palette = require("gruvbox.palette")
        local colors = palette.get_base_colors(opts.palette_overrides, vim.o.background, opts.contrast)
        local dark0_hard = "#1d2021"
        local highlight_groups = {
            -- base configs
            NormalFloat = { fg = colors.fg0, bg = colors.none or dark0_hard },
            FloatBorder = {
                fg = colors.blue or dark0_hard,
                bg = colors.none or dark0_hard,
            },

            -- native lsp configs
            DiagnosticVirtualTextError = { bg = colors.none },
            DiagnosticVirtualTextWarn = { bg = colors.none },
            DiagnosticVirtualTextInfo = { bg = colors.none },
            DiagnosticVirtualTextHint = { bg = colors.none },
            LspInfoBorder = { link = "FloatBorder" },

            -- Mason
            MasonNormal = { fg = colors.fg0, bg = dark0_hard },

            -- Lazy
            LazyNormal = { fg = colors.fg0, bg = dark0_hard },

            -- nvim-cmp and wilder.nvim
            Pmenu = { fg = colors.fg4, bg = colors.none or colors.bg1 },
            PmenuBorder = { fg = colors.bg3, bg = colors.none or colors.bg1 },
            PmenuSel = { bg = colors.green, fg = colors.bg1 },
            CmpItemAbbr = { fg = colors.fg4 },
            CmpItemAbbrMatch = { fg = colors.blue },
            CmpDoc = { link = "NormalFloat" },
            CmpDocBorder = {
                fg = colors.bg3 or dark0_hard,
                bg = colors.none or dark0_hard,
            },

            -- Fidget
            FidgetTask = { bg = colors.none, fg = colors.bg4 },
            FidgetTitle = { fg = colors.blue },

            -- Telescope
            TelescopeBorder = { fg = dark0_hard, bg = colors.bg0 },
            TelescopePromptBorder = { fg = colors.bg1, bg = colors.bg1 },
            TelescopePromptNormal = { fg = colors.fg0, bg = colors.bg1 },
            TelescopePromptPrefix = { fg = colors.yellow, bg = colors.bg1 },
            TelescopeNormal = { bg = dark0_hard },
            TelescopePreviewTitle = { fg = dark0_hard, bg = colors.green },
            TelescopePromptTitle = { fg = colors.bg1, bg = colors.yellow },
            TelescopeResultsTitle = { fg = colors.bg1, bg = colors.aqua },
            TelescopeSelection = { fg = colors.fg0, bg = colors.bg1 },
            TelescopeResultsDiffAdd = { fg = colors.green },
            TelescopeResultsDiffChange = { fg = colors.yellow },
            TelescopeResultsDiffDelete = { fg = colors.red },

            -- Harpoon
            HarpoonWindow = { bg = dark0_hard },
            HarpoonBorder = { fg = dark0_hard, bg = colors.bg0 },

            -- File browser
            FileBrowser = { bg = dark0_hard, fg = colors.fg0 },

            -- Quickfix
            Quickfix = { bg = dark0_hard, fg = colors.fg0 },

            -- Treesitter
            ["@keyword.return"] = { fg = colors.neutral_purple },
        }
        require("gruvbox").setup(vim.tbl_deep_extend("force", opts, { overrides = highlight_groups }))
        -- setup must be called before loading
        vim.cmd.colorscheme("gruvbox")
    end,
}
