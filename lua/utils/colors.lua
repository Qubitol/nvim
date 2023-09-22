local M = {}

local palette = require("catppuccin.palettes").get_palette("mocha")

M.theme = {
	black = palette["crust"],
	red = palette["red"],
	green = palette["green"],
	yellow = palette["yellow"],
	blue = palette["blue"],
	magenta = palette["mauve"],
	cyan = palette["sapphire"],
	white = palette["subtext1"],
	bright_black = palette["base"],
	bright_red = palette["flamingo"],
	bright_green = palette["teal"],
	bright_yellow = palette["yellow"],
	bright_blue = palette["blue"],
	bright_magenta = palette["lavender"],
	bright_cyan = palette["sky"],
	bright_white = palette["text"],
}

M.heirline = {
	mode_name = M.theme["bright_black"],
	file_fg = M.theme["bright_white"],
	file_bg = palette["mantle"],
	file_modified = M.theme["green"],
	file_locked = palette["orange"],
	git = palette["mauve"],
	git_branch = palette["crust"],
	lsp = M.theme["green"],
	filetype = M.theme["yellow"],
	work_dir = M.theme["red"],
	ruler = M.theme["blue"],
	ruler_bg = palette["mantle"],
	git_del = palette["mauve"],
	git_add = palette["mauve"],
	git_change = palette["mauve"],
}

return M
