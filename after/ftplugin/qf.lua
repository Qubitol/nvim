local set = vim.opt_local
local map = vim.keymap.set
local opts = { buffer = true, noremap = true, silent = true }

-- preview the diagnostic location
map("n", "p", "<CR>zz<C-w>p", opts)
map("n", "J", "j<CR>zz<C-w>p", opts)
map("n", "K", "k<CR>zz<C-w>p", opts)

-- close quickfix buffer
map("n", "gq", function()
	local list_type = require("utils").quickfix_or_loclist()
	if list_type then
		vim.cmd(list_type .. "close")
	end
end, opts)

map("n", "f", function()
	local list_type = require("utils").quickfix_or_loclist()
	if list_type then
		return ":" .. string.upper(list_type) .. "filter "
	end
    return "<Ignore>"
end, { buffer = true, noremap = true, expr = true })

map("n", "do", function()
	local list_type = require("utils").quickfix_or_loclist()
	if list_type then
        return ":" .. list_type .. "do "
	end
    return "<Ignore>"
end, { buffer = true, noremap = true, expr = true })

-- e - error message
--  		    w - warning message
--  		    i - info message
--  		    n - note message  => hint

-- options
set.colorcolumn = ""
set.wrap = false

-- highlighting groups
set.winhighlight = "Normal:Quickfix"
