-- Colors

local colorscheme = "gruvbox"
vim.pack.add({
    { src = "https://github.com/ellisonleao/gruvbox.nvim", name = colorscheme },
})

require(colorscheme).setup({
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
})

-- Helper: extract colors from existing highlight groups
local function get_hl(name, field)
    local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
    if field == "fg" then
        return hl.fg and string.format("#%06x", hl.fg) or nil
    elseif field == "bg" then
        return hl.bg and string.format("#%06x", hl.bg) or nil
    end
    return hl
end

local function darken(hex, amount)
    local r = math.max(0, tonumber(hex:sub(2, 3), 16) - amount)
    local g = math.max(0, tonumber(hex:sub(4, 5), 16) - amount)
    local b = math.max(0, tonumber(hex:sub(6, 7), 16) - amount)
    return string.format("#%02x%02x%02x", r, g, b)
end

local function apply_custom_highlights()
    -- Derive a palette from whatever colorscheme is active
    local bg = get_hl("Normal", "bg") or "#1e1e1e"
    local p = {
        bg = bg,
        fg = get_hl("Normal", "fg") or "#d4d4d4",
        bg_dark = darken(bg, 10),
        comment = get_hl("Comment", "fg") or "#6a6a6a",
        string = get_hl("String", "fg") or "#a0a0a0",
        keyword = get_hl("Keyword", "fg") or "#b0b0b0",
        func = get_hl("Function", "fg") or "#c0c0c0",
        error = get_hl("DiagnosticError", "fg") or "#ff5555",
        warn = get_hl("DiagnosticWarn", "fg") or "#ffaa55",
        info = get_hl("DiagnosticInfo", "fg") or "#55aaff",
        hint = get_hl("DiagnosticHint", "fg") or "#55ffaa",
        diff_add = get_hl("DiffAdd", "bg") or "#2a3a2a",
        diff_del = get_hl("DiffDelete", "bg") or "#3a2a2a",
    }

    local highlights = {
        -- Floats
        NormalFloat = { fg = p.fg, bg = p.bg_dark },
        FloatBorder = { fg = p.bg_dark, bg = p.bg_dark },

        -- Dimmed windows
        -- NormalNC = { bg = darken(p.bg, 5), fg = darken(p.fg, 30) },

        -- Sign column: match background
        FoldColumn = { bg = "none" },
        SignColumn = { bg = "none" },
        CursorLineNr = { bg = "none" },
        ColorColumn = { link = "CursorLine" },

        -- Statusline
        StatusLine = { link = "NormalFloat" },
        StatusLineNC = { link = "StatusLine" },
        StatusLineFilename = { fg = darken(p.fg, 60), bg = "none" },
        WinBar = { link = "StatusLine" },
        WinBarNC = { bg = darken(p.bg, 5), fg = darken(p.fg, 60) },

        -- DiagnosticSign
        DiagnosticSignError = { bg = "none" },
        DiagnosticSignWarn = { bg = "none" },
        DiagnosticSignHint = { bg = "none" },
        DiagnosticSignInfo = { bg = "none" },
        DiagnosticSignOk = { bg = "none" },

        -- DiagnosticSignStatusLine
        DiagnosticSignStatusLineError = { link = "DiagnosticSignError" },
        DiagnosticSignStatusLineWarn = { link = "DiagnosticSignWarn" },
        DiagnosticSignStatusLineHint = { link = "DiagnosticSignHint" },
        DiagnosticSignStatusLineInfo = { link = "DiagnosticSignInfo" },
        DiagnosticSignStatusLineOk = { link = "DiagnosticSignOk" },

        -- ModeStatusLine
        ModeStatusLine1 = { link = "DiagnosticSignStatusLineError" },
        ModeStatusLine2 = { link = "DiagnosticSignStatusLineWarn" },
        ModeStatusLine3 = { link = "DiagnosticSignStatusLineHint" },
        ModeStatusLine4 = { link = "DiagnosticSignStatusLineInfo" },
        ModeStatusLine5 = { link = "DiagnosticSignStatusLineOk" },

        -- GitStatusLine
        GitStatusLine = { link = "QuickFixLine" },

        -- LSPStatusLine
        LSPStatusLine = { link = "DiagnosticSignStatusLineOk" },

        -- FileIcon
        FileIcon = { fg = p.fg, bg = "none" },

        -- Plugin panels
        FileBrowser = { fg = p.fg, bg = p.bg_dark },
        MasonNormal = { link = "FileBrowser" },

        -- Treesitter context
        ["@keyword.return"] = { fg = get_hl("Special", "fg") or p.keyword },
        TreesitterContext = { bg = p.bg_dark },
        TreesitterContextLineNumber = { bg = p.bg_dark, fg = p.fg },

        -- fzf-lua
        FzfLuaNormal = { bg = p.bg_dark },
        FzfLuaTitle = { fg = p.bg_dark, bg = p.warn },
        FzfLuaBorder = { fg = p.bg_dark, bg = p.bg_dark },
        FzfLuaPreviewNormal = { bg = p.bg_dark },
        FzfLuaPreviewTitle = { fg = p.bg_dark, bg = p.hint },
        FzfLuaPreviewBorder = { fg = p.bg_dark, bg = p.bg_dark },
        FzfLuaScrollBorderEmpty = { fg = p.bg, bg = p.bg_dark },
        FzfLuaScrollBorderFull = { fg = p.bg, bg = p.bg_dark },
        FzfLuaScrollFloatEmpty = { fg = p.bg, bg = p.bg_dark },
        FzfLuaScrollFloatFull = { fg = p.bg, bg = p.bg_dark },
        FzfLuaFzfSeparator = { fg = p.bg, bg = p.bg_dark },
        FzfLuaFzfScrollbar = { fg = p.bg, bg = p.bg_dark },
        FzfLuaFzfHeader = { fg = p.warn },
        FzfLuaFzfInfo = { fg = p.warn },

        -- CodeCompanion
        CodeCompanionNormal = { link = "FileBrowser" },
    }

    for group, hl in pairs(highlights) do
        vim.api.nvim_set_hl(0, group, vim.tbl_deep_extend("force", hl, { update = true }))
    end
end

vim.opt.background = "dark"
vim.cmd.colorscheme(colorscheme)
apply_custom_highlights()

-- Reapply after any colorscheme change
vim.api.nvim_create_autocmd("ColorScheme", {
    callback = apply_custom_highlights,
})
