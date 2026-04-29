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
-- handles correctly
local function buf_relpath(buf)
    local name = vim.api.nvim_buf_get_name(buf)
    if name == "" then
        return "[No Name]"
    end
    local rel = vim.fn.fnamemodify(name, ":.")
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
    return table.concat(parts, "/") -- all non-filename components already at 1 char
end

local function file_path_parts(buf)
    local name = vim.api.nvim_buf_get_name(buf)
    if name == "" then return "", "[No Name]" end

    local cwd_abs  = vim.fn.getcwd()
    local file_abs = vim.fn.expand(name)  -- resolve to absolute
    local cwd_tilde = vim.fn.fnamemodify(cwd_abs, ":~")

    local rel = vim.fn.fnamemodify(file_abs, ":.")
    if rel:sub(1, 1) ~= "/" then
        -- file is inside cwd, straightforward
        return cwd_tilde, "/" .. rel
    end

    -- file is outside cwd: compute real relative path via common ancestor
    local cwd_parts  = vim.split(cwd_abs,  "/", { plain = true })
    local file_parts = vim.split(file_abs, "/", { plain = true })

    local common = 0
    for i = 1, math.min(#cwd_parts, #file_parts) do
        if cwd_parts[i] == file_parts[i] then common = i
        else break end
    end

    local rel_parts = {}
    for _ = common + 1, #cwd_parts do
        rel_parts[#rel_parts + 1] = ".."
    end
    for i = common + 1, #file_parts do
        rel_parts[#rel_parts + 1] = file_parts[i]
    end

    return cwd_tilde, "/" .. table.concat(rel_parts, "/")
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

-- Special buffers to treat bars differently
local _special_buftypes = { nofile = true, prompt = true }

local function special_buf(buf)
    return _special_buftypes[vim.bo[buf].buftype] == true
end

-- Special filetypes to treat bars differently
local _special_filetypes = { qf = true, argpick = true, git = true, fugitive = true, codecompanion_input = true }

local function special_ft(buf)
    return _special_filetypes[vim.bo[buf].filetype] == true
end

-- No filename in Statusline
local _no_filename_buftypes = { terminal = true, nofile = true, prompt = true, quickfix = true }

local function no_filename_statusline(buf)
    return _no_filename_buftypes[vim.bo[buf].buftype] == true
end

local _no_filename_filetypes = { netrw = true, fugitive = true, argpick = true, codecompanion_input = true }

local function no_filename_statusline_ft(buf)
    return _no_filename_filetypes[vim.bo[buf].filetype] == true
end

-- Statusline
--
-- Active:   [MODE]  cwd │ %= diagnostics │ line,col   pct%
-- Inactive: cwd  %=  line,col   pct%

function M.render()
    local buf = vim.api.nvim_get_current_buf()
    local win_width = vim.o.columns
    local cwd_part, file_part = "", ""
    local raw_cwd, raw_file = file_path_parts(buf)
    local cwd_limit = math.floor(win_width * 0.5)
    local file_limit = math.floor(win_width * 0.35)
    cwd_part = hl(hl_statusline, "StatusLineCwd", compact_path(raw_cwd, cwd_limit))
    if not (no_filename_statusline(buf) or no_filename_statusline_ft(buf)) then
        file_part = hl(hl_statusline, "StatusLineFilename", compact_path(raw_file, file_limit))
    end

    local sep = (icons.statusline and icons.statusline.sep) or "|"
    local end_part = "%l,%c%V   %P "

    local mode = vim.api.nvim_get_mode().mode
    local mode_label = mode_names[mode] or mode:upper()
    local mode_initial = mode:sub(1, 1) -- get only the first mode character
    local branch = git_branch()
    local branch_str = branch ~= "" and (branch .. "  " .. sep .. "  ") or ""

    local left = table.concat({
        hl(hl_statusline, mode_colors[mode_initial], " " .. mode_label .. " "),
        " ",
        cwd_part,
        file_part,
        " ",
        "%h%q",
        " ",
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
    if special_buf(buf) or special_ft(buf) then
        return ""
    end

    local active = is_active()

    local icon = filetype_icon(buf, active)
    local win_width = vim.api.nvim_win_get_width(0)
    local path_limit = math.floor(win_width * 0.5) -- 50% of the window for the path
    local path = compact_path(buf_relpath(buf), path_limit)

    local flags = ""
    if vim.bo[buf].modified then
        flags = flags .. " " .. ((icons.winbar and icons.winbar.modified) or "[+]")
    end
    if vim.bo[buf].readonly or not vim.bo[buf].modifiable then
        flags = flags .. " " .. ((icons.winbar and icons.winbar.readonly) or "[RO]")
    end

    local left = " " .. icon .. path .. flags .. " %w"

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
    vim.api.nvim_create_autocmd("BufWinEnter", {
        group = group,
        callback = function()
            local buf = vim.api.nvim_get_current_buf()
            local no_show = special_buf(buf) or special_ft(buf)
            vim.wo.winbar = no_show and "" or "%{%v:lua.require('config.statusline').winbar()%}"
        end,
    })
end

return M
