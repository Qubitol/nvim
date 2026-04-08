local M = {}

local hl_statusline = "StatusLine"
local hl_statusline_nc = "StatusLineNC"
local hl_winbar = "WinBar"
local hl_winbar_nc = "WinBarNC"


local function get_hl_base(hl, hl_nc, active)
    if active == nil then
        active = true
    end
    local hl_base = hl
    if not active then
        hl_base = hl_nc
    end
    return hl_base
end

-- Focus tracking
-- When Neovim evaluates a %!expr statusline, it temporarily sets curwin to
-- the window being drawn, so nvim_get_current_win() inside the expression
-- returns the drawn window, not the focused one.  We track focus ourselves.
local _focused_win = vim.api.nvim_get_current_win()

vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter" }, {
    group = vim.api.nvim_create_augroup("StatuslineFocus", { clear = true }),
    callback = function()
        _focused_win = vim.api.nvim_get_current_win()
    end,
})

local function is_active()
    return vim.api.nvim_get_current_win() == _focused_win
end

-- Highlight helper
-- Wraps content in %#Group# ... %#Base# so callers don't have to manage resets.
local function hl(base, group, content)
    return ("%%#%s#%s%%#%s#"):format(group, content, base)
end

-- Icons
local icons = require("config.ui").icons

local mode_names = {
    n = "NORMAL",
    no = " N·OP ",
    nov = " N·OP ",
    v = "VISUAL",
    vs = "VISUAL",
    V = "V·LINE",
    Vs = "V·LINE",
    ["\22"] = "V·BLCK",
    ["\22s"] = "V·BLCK",
    s = "SELECT",
    S = "S·LINE",
    ["\19"] = "S·BLCK",
    i = "INSERT",
    ic = "INSERT",
    ix = "INSERT",
    R = " REPL ",
    Rc = " REPL ",
    Rv = "V·REPL",
    Rvc = "V·REPL",
    Rvx = "V·REPL",
    c = " CMD  ",
    cv = "  EX  ",
    r = "PROMPT",
    rm = " MORE ",
    ["r?"] = " Y/N ",
    ["!"] = "SHELL ",
    t = " TERM ",
    nt = "NORMAL",
    niI = "NORMAL",
    niR = "NORMAL",
}

local mode_colors = {
    n = "ModeStatusLine1",
    i = "ModeStatusLine2",
    v = "ModeStatusLine5",
    V = "ModeStatusLine5",
    ["\22"] = "ModeStatusLine5",
    c = "ModeStatusLine4",
    s = "ModeStatusLine3",
    S = "ModeStatusLine3",
    ["\19"] = "ModeStatusLine3",
    R = "ModeStatusLine4",
    r = "ModeStatusLine4",
    ["!"] = "ModeStatusLine1",
    t = "ModeStatusLine1",
}

-- Devicons (loaded once, only when pretty)
local _devicons -- false = unavailable, nil = not yet tried

local function get_devicons()
    if _devicons ~= nil then
        return _devicons
    end
    if not vim.g.pretty then
        _devicons = false
        return false
    end
    local ok, di = pcall(require, "nvim-web-devicons")
    _devicons = ok and di or false
    return _devicons
end

local function filetype_icon(buf, active)
    local hl_base = get_hl_base(hl_winbar, hl_winbar_nc, active)
    local dev_icons = get_devicons()
    if not dev_icons then
        return ""
    end
    local name = vim.api.nvim_buf_get_name(buf)
    local icon, icon_color =
        dev_icons.get_icon_color(vim.fn.fnamemodify(name, ":t"), vim.fn.fnamemodify(name, ":e"), { default = true })
    vim.api.nvim_set_hl(0, "FileIcon", { fg = icon_color, update = true })
    local str = hl(hl_base, "FileIcon", icon)
    if icon then
        str = str .. " "
    end
    return str
end

-- Path helpers
-- Returns the buffer path relative to cwd via fnamemodify ":." which Neovim
-- handles correctly; falls back to ":~" (home-relative) if outside cwd.
local function buf_relpath(buf)
    local name = vim.api.nvim_buf_get_name(buf)
    if name == "" then
        return "[No Name]"
    end
    local rel = vim.fn.fnamemodify(name, ":.")
    if rel:sub(1, 1) == "/" then
        rel = vim.fn.fnamemodify(name, ":~")
    end
    return rel
end

-- Compact from the left (farthest from filename), preserving the filename always.
-- Stages: full → reduce leftmost long segment → ... → all initials → filename only
local function compact_path(path, max_len)
    if #path <= max_len then
        return path
    end
    local parts = vim.split(path, "/", { plain = true })
    if #parts <= 1 then
        return path
    end
    -- shrink segments one by one from the left
    for i = 1, #parts - 1 do
        if #parts[i] > 1 then
            parts[i] = parts[i]:sub(1, 1)
            local candidate = table.concat(parts, "/")
            if #candidate <= max_len then
                return candidate
            end
        end
    end
    return parts[#parts] -- last resort: filename only
end

local function cwd_display(max_len)
    return compact_path(vim.fn.fnamemodify(vim.fn.getcwd(), ":~"), max_len)
end

-- Git (via gitsigns buffer variable)
local function git_changes(buf, active)
    local hl_base = get_hl_base(hl_statusline, hl_statusline_nc, active)
    local d = vim.b[buf].gitsigns_status_dict
    if not d then
        return ""
    end
    local parts = {}
    local function add(n, sym)
        if (n or 0) > 0 then
            parts[#parts + 1] = sym .. n
        end
    end
    add(d.added, icons.git.added)
    add(d.changed, icons.git.modified) -- gitsigns calls it "changed"
    add(d.removed, icons.git.removed)
    return hl(hl_base, "GitStatusLine", table.concat(parts, " "))
end

-- Git branch (via vim-fugitive)
local function git_branch(active)
    local hl_base = get_hl_base(hl_statusline, hl_statusline_nc, active)
    local status_dict = vim.b.gitsigns_status_dict
    if not status_dict then
        return ""
    end
    return hl(hl_base, "GitStatusLine", icons.git.branch .. status_dict.head)
end

-- LSP
local function lsp_diagnostics(buf, active)
    local hl_base = get_hl_base(hl_statusline, hl_statusline_nc, active)
    local counts = vim.diagnostic.count(buf)
    local sev = vim.diagnostic.severity
    local parts = {}
    local function add(level, key)
        local n = counts[level] or 0
        if n > 0 then
            parts[#parts + 1] = hl(
                hl_base,
                "DiagnosticSignStatusLine" .. key,
                icons.diagnostics[key] .. (vim.g.pretty and "" or ":") .. n
            )
        end
    end
    add(sev.ERROR, "Error")
    add(sev.WARN, "Warn")
    add(sev.HINT, "Hint")
    add(sev.INFO, "Info")
    return table.concat(parts, " ")
end

local function has_lsp(buf)
    return #vim.lsp.get_clients({ bufnr = buf }) > 0
end

-- Special buffers to treat bars differently: terminal, quickfix, loclist, etc.
local _special_buftypes = { terminal = true, quickfix = true, nofile = true, prompt = true }

local function special_buf(buf)
    return _special_buftypes[vim.bo[buf].buftype] == true
end

-- Statusline
--
-- Active:   [MODE]  cwd │ %= diagnostics │ line,col   pct%
-- Inactive: cwd  %=  line,col   pct%

function M.render()
    local buf = vim.api.nvim_get_current_buf()
    if special_buf(buf) then
        return "%h%q%w"
    end

    local sep = (icons.statusline and icons.statusline.sep) or "|"
    local end_part = "%l,%c%V   %P "

    if not is_active() then
        return cwd_display(50) .. "%=" .. end_part
    end

    local mode = vim.api.nvim_get_mode().mode
    local mode_label = mode_names[mode] or mode:upper()
    local mode_initial = mode:sub(1, 1) -- get only the first mode character
    local branch = git_branch()
    local branch_str = branch ~= "" and (branch .. "  " .. sep .. "  ") or ""

    local cwd_limit = math.floor(vim.api.nvim_win_get_width(0) * 0.4)
    local left = table.concat({
        hl(hl_statusline, mode_colors[mode_initial], " " .. mode_label .. " "),
        " ",
        "%h%q",
        " ",
        cwd_display(cwd_limit),
    })

    local diag = lsp_diagnostics(buf)
    local diag_str = diag ~= "" and (diag .. "  " .. sep .. "  ") or ""

    local right = branch_str .. diag_str .. end_part

    return left .. "%=" .. right
end

-- Winbar
-- Active:   [icon] path/file [+][RO]  git changes  %= encoding │ [L]
-- Inactive: [icon] path/file [+][RO]

function M.winbar()
    local buf = vim.api.nvim_get_current_buf()

    local active = is_active()

    local icon = filetype_icon(buf, active)
    local win_width = vim.api.nvim_win_get_width(0)
    local path_limit = math.floor(win_width * 0.7) -- 70% of the window for the path
    local path = compact_path(buf_relpath(buf), path_limit)

    local flags = ""
    if vim.bo[buf].modified then
        flags = flags .. " " .. ((icons.winbar and icons.winbar.modified) or "[+]")
    end
    if vim.bo[buf].readonly or not vim.bo[buf].modifiable then
        flags = flags .. " " .. ((icons.winbar and icons.winbar.readonly) or "[RO]")
    end

    local left = " " .. icon .. path .. flags

    if not active then
        -- Inactive: no git, no encoding, no lsp — just let WinBarNC handle the dimming
        return left .. " "
    end

    local git = git_changes(buf)
    local git_str = git ~= "" and ("  " .. git) or ""

    local enc = vim.bo[buf].fileencoding
    if enc == "" then
        enc = vim.o.encoding
    end
    if enc == "utf-8" then
        enc = ""
    end

    local lsp_str = ""
    if has_lsp(buf) then
        lsp_str = "  " .. hl(hl_winbar, "LSPStatusLine", ((icons.winbar and icons.winbar.lsp) or "[L]"))
    end

    return left .. git_str .. "%=" .. enc .. lsp_str .. " "
end

-- Setup
function M.setup()
    vim.o.statusline = "%!v:lua.require('config.statusline').render()"

    local group = vim.api.nvim_create_augroup("StatuslineWinbar", { clear = true })
    vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter", "WinNew" }, {
        group = group,
        callback = function()
            local buf = vim.api.nvim_get_current_buf()
            vim.wo.winbar = special_buf(buf) and "" or "%{%v:lua.require('config.statusline').winbar()%}"
        end,
    })
end

return M
