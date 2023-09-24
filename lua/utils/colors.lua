local M = {}

local gruvbox = require("gruvbox.palette")
local palette = gruvbox.get_base_colors({}, "dark", "")
local dark0_hard = "#1d2021"

M.theme = {
    black = dark0_hard,
    red = palette.red,
    green = palette.green,
    yellow = palette.yellow,
    blue = palette.blue,
    magenta = palette.purple,
    cyan = palette.aqua,
    white = palette.fg4,
    bright_black = palette.bg0,
    bright_red = palette.neutral_red,
    bright_green = palette.neutral_green,
    bright_yellow = palette.neutral_yellow,
    bright_blue = palette.neutral_blue,
    bright_magenta = palette.neutral_purple,
    bright_cyan = palette.neutral_aqua,
    bright_white = palette.fg0,
}

M.heirline = {
    -- bright_bg = palette.bg1,
    mode_name = M.theme["bright_black"],
    file_fg = M.theme["bright_white"],
    file_bg = M.theme["black"],
    file_modified = M.theme["green"],
    file_locked = palette.orange,
    git = M.theme["magenta"],
    git_branch = M.theme["black"],
    lsp = M.theme["green"],
    filetype = M.theme["yellow"],
    work_dir = M.theme["red"],
    ruler = M.theme["blue"],
    ruler_bg = M.theme["black"],
    git_del = M.theme["magenta"],
    git_add = M.theme["magenta"],
    git_change = M.theme["magenta"],
    copilot = palette.aqua,
}

return M
