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
            NormalFloat = { fg = colors.fg0, bg = colors.bg0 },
            FloatBorder = { fg = colors.blue, bg = colors.bg0 },
            SignColumn = { bg = colors.bg0 },
            CursorLineNr = { bg = colors.bg0 },
            GruvboxGreenSign = { fg = vim.api.nvim_get_hl(0, { name = "GruvboxGreenSign" }).fg, bg = colors.bg0 },
            GruvboxAquaSign = { fg = vim.api.nvim_get_hl(0, { name = "GruvboxAquaSign" }).fg, bg = colors.bg0 },
            GruvboxRedSign = { fg = vim.api.nvim_get_hl(0, { name = "GruvboxRedSign" }).fg, bg = colors.bg0 },
            GruvboxYellowSign = { fg = vim.api.nvim_get_hl(0, { name = "GruvboxYellowSign" }).fg, bg = colors.bg0 },
            GruvboxPurpleSign = { fg = vim.api.nvim_get_hl(0, { name = "GruvboxPurpleSign" }).fg, bg = colors.bg0 },
            GruvboxOrangeSign = { fg = vim.api.nvim_get_hl(0, { name = "GruvboxOrangeSign" }).fg, bg = colors.bg0 },
            GruvboxBlueSign = { fg = vim.api.nvim_get_hl(0, { name = "GruvboxBlueSign" }).fg, bg = colors.bg0 },

            -- Dim inactive
            DimInactive = { bg = "#212323" },

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
            Pmenu = { fg = colors.fg4, bg = colors.bg0 },
            PmenuBorder = { fg = colors.bg3, bg = colors.bg0 },
            PmenuSel = { bg = colors.green, fg = colors.bg0 },
            CmpItemAbbrMatch = { fg = colors.blue },
            CmpDoc = { fg = colors.fg0, bg = colors.bg0 },
            CmpDocBorder = { fg = colors.bg3, bg = colors.bg0 },

            -- Telescope
            TelescopeBorder = { fg = dark0_hard, bg = dark0_hard },
            TelescopePreviewBorder = { fg = dark0_hard, bg = dark0_hard },
            TelescopeResultsBorder = { fg = dark0_hard, bg = dark0_hard },
            TelescopePromptBorder = { fg = colors.bg1, bg = colors.bg1 },
            TelescopePromptNormal = { fg = colors.fg0, bg = colors.bg1 },
            TelescopePromptPrefix = { fg = colors.fg0, bg = colors.bg1 },
            TelescopeNormal = { bg = dark0_hard },
            TelescopePreviewTitle = { fg = dark0_hard, bg = colors.green },
            TelescopePromptTitle = { fg = colors.bg1, bg = colors.purple },
            TelescopeResultsTitle = { fg = colors.bg1, bg = colors.aqua },
            TelescopeSelection = { fg = colors.fg0, bg = colors.bg0 },
            TelescopeResultsDiffAdd = { fg = colors.green },
            TelescopeResultsDiffChange = { fg = colors.aqua },
            TelescopeResultsDiffDelete = { fg = colors.red },

            -- Harpoon
            HarpoonWindow = { bg = dark0_hard },
            HarpoonBorder = { fg = dark0_hard, bg = dark0_hard },

            -- FileBrowser
            FileBrowser = { bg = dark0_hard, fg = colors.fg0 },

            -- Quickfix
            Quickfix = { bg = dark0_hard, fg = colors.fg0 },
            QuickfixLine = { bg = colors.bg2 },

            -- Treesitter
            ["@keyword.return"] = { fg = colors.neutral_purple },
        }
        -- setup must be called before loading
        require("gruvbox").setup(vim.tbl_deep_extend("force", opts, { overrides = highlight_groups }))
        vim.cmd.colorscheme("gruvbox")
    end,
}
