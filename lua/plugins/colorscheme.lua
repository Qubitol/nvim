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
        local palette = require("gruvbox").palette
        local highlight_groups = {
            -- base configs
            NormalFloat = { fg = palette.light0, bg = palette.dark0 },
            FloatBorder = { fg = palette.bright_blue, bg = palette.dark0 },
            SignColumn = { bg = palette.dark0 },
            CursorLineNr = { bg = palette.dark0 },
            GruvboxGreenSign = { fg = vim.api.nvim_get_hl(0, { name = "GruvboxGreenSign" }).fg, bg = palette.dark0 },
            GruvboxAquaSign = { fg = vim.api.nvim_get_hl(0, { name = "GruvboxAquaSign" }).fg, bg = palette.dark0 },
            GruvboxRedSign = { fg = vim.api.nvim_get_hl(0, { name = "GruvboxRedSign" }).fg, bg = palette.dark0 },
            GruvboxYellowSign = { fg = vim.api.nvim_get_hl(0, { name = "GruvboxYellowSign" }).fg, bg = palette.dark0 },
            GruvboxPurpleSign = { fg = vim.api.nvim_get_hl(0, { name = "GruvboxPurpleSign" }).fg, bg = palette.dark0 },
            GruvboxOrangeSign = { fg = vim.api.nvim_get_hl(0, { name = "GruvboxOrangeSign" }).fg, bg = palette.dark0 },
            GruvboxBlueSign = { fg = vim.api.nvim_get_hl(0, { name = "GruvboxBlueSign" }).fg, bg = palette.dark0 },

            -- Dim inactive
            DimInactive = { bg = "#212323" },

            -- native lsp configs
            -- DiagnosticVirtualTextError = { bg = palette.none },
            -- DiagnosticVirtualTextWarn = { bg = palette.none },
            -- DiagnosticVirtualTextInfo = { bg = palette.none },
            -- DiagnosticVirtualTextHint = { bg = palette.none },
            LspInfoBorder = { link = "FloatBorder" },

            -- Mason
            MasonNormal = { fg = palette.light0, bg = palette.dark0_hard },

            -- Lazy
            LazyNormal = { fg = palette.light0, bg = palette.dark0_hard },

            -- nvim-cmp and wilder.nvim
            Pmenu = { fg = palette.light4, bg = palette.dark0 },
            PmenuBorder = { fg = palette.dark3, bg = palette.dark0 },
            PmenuSel = { bg = palette.bright_green, fg = palette.dark0 },
            CmpItemAbbrMatch = { fg = palette.bright_blue },
            CmpDoc = { fg = palette.light0, bg = palette.dark0 },
            CmpDocBorder = { fg = palette.dark3, bg = palette.dark0 },

            -- Telescope
            TelescopeBorder = { fg = palette.dark0_hard, bg = palette.dark0_hard },
            TelescopePreviewBorder = { fg = palette.dark0_hard, bg = palette.dark0_hard },
            TelescopeResultsBorder = { fg = palette.dark0_hard, bg = palette.dark0_hard },
            TelescopePromptBorder = { fg = palette.dark1, bg = palette.dark1 },
            TelescopePromptNormal = { fg = palette.light0, bg = palette.dark1 },
            TelescopePromptPrefix = { fg = palette.light0, bg = palette.dark1 },
            TelescopeNormal = { bg = palette.dark0_hard },
            TelescopePreviewTitle = { fg = palette.dark0_hard, bg = palette.bright_green },
            TelescopePromptTitle = { fg = palette.dark1, bg = palette.bright_purple },
            TelescopeResultsTitle = { fg = palette.dark1, bg = palette.bright_blue },
            TelescopeSelection = { fg = palette.light0, bg = palette.dark0 },
            TelescopeResultsDiffAdd = { fg = palette.bright_green },
            TelescopeResultsDiffChange = { fg = palette.aqua },
            TelescopeResultsDiffDelete = { fg = palette.bright_red },

            -- fzf-lua
            FzfLuaNormal = { bg = palette.dark0_hard },
            FzfLuaTitle = { fg = palette.dark1, bg = palette.bright_purple },
            FzfLuaBorder = { fg = palette.dark0_hard, bg = palette.dark0_hard },
            FzfLuaPreviewNormal = { bg = palette.dark0_hard },
            FzfLuaPreviewTitle = { fg = palette.dark0_hard, bg = palette.bright_green },
            FzfLuaPreviewBorder = { fg = palette.dark0_hard, bg = palette.dark0_hard },
            FzfLuaScrollBorderEmpty = { bg = palette.dark0_hard, fg = palette.dark1 },
            FzfLuaScrollBorderFull = { bg = palette.dark0_hard, fg = palette.dark1 },
            FzfLuaScrollFloatEmpty = { bg = palette.dark0_hard, fg = palette.dark1 },
            FzfLuaScrollFloatFull = { bg = palette.dark0_hard, fg = palette.dark1 },
            FzfLuaFzfSeparator = { bg = palette.dark0_hard, fg = palette.dark1 },
            FzfLuaFzfScrollbar = { bg = palette.dark0_hard, fg = palette.dark1 },
            FzfLuaFzfHeader = { fg = palette.yellow },
            FzfLuaFzfInfo = { fg = palette.yellow },

            -- Harpoon
            HarpoonWindow = { bg = palette.dark0_hard },
            HarpoonBorder = { fg = palette.dark0_hard, bg = palette.dark0_hard },

            -- FileBrowser
            FileBrowser = { bg = palette.dark0_hard, fg = palette.light0 },

            -- DapUI
            DapUINormal = { link = "FileBrowser" },

            -- Quickfix
            Quickfix = { bg = palette.dark0_hard, fg = palette.light0 },
            QuickfixLine = { bg = palette.dark2 },

            -- Treesitter
            ["@keyword.return"] = { fg = palette.neutral_purple },
            TreesitterContext = { bg = palette.dark0_hard },
            TreesitterContextLineNumber = { bg = palette.dark0_hard, fg = palette.light0 },
        }
        -- setup must be called before loading
        require("gruvbox").setup(vim.tbl_deep_extend("force", opts, { overrides = highlight_groups }))
        vim.cmd.colorscheme("gruvbox")
    end,
}
