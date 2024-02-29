local M = {}

local palette = require("gruvbox").palette

M.theme = {
    black = palette.dark0_hard,
    red = palette.bright_red,
    green = palette.bright_green,
    yellow = palette.bright_yellow,
    blue = palette.bright_blue,
    magenta = palette.bright_purple,
    cyan = palette.aqua,
    white = palette.light4,
    bright_black = palette.dark0,
    bright_red = palette.neutral_red,
    bright_green = palette.neutral_green,
    bright_yellow = palette.neutral_yellow,
    bright_blue = palette.neutral_blue,
    bright_magenta = palette.neutral_purple,
    bright_cyan = palette.neutral_aqua,
    bright_white = palette.light0,
}

M.heirline = {
    mode_name = M.theme["bright_black"],
    file_fg = M.theme["bright_white"],
    file_bg = M.theme["black"],
    file_modified = M.theme["green"],
    file_locked = palette.orange,
    git = M.theme["magenta"],
    git_branch = M.theme["black"],
    lsp = M.theme["green"],
    linter = M.theme["yellow"],
    formatter = palette.bright_orange,
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
