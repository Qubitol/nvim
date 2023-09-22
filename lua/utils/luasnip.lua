-- Useful functions for snippets
local ls = require("luasnip")
local sn = ls.snippet_node
local i = ls.insert_node

local M = {}

-- get_visual function to store deleted text to insert in next snippet
-- Summary: When `SELECT_RAW` is populated with a visual selection, the function
-- returns an insert node whose initial text is set to the visual selection.
-- When `SELECT_RAW` is empty, the function simply returns an empty insert node.
function M.get_visual(_, parent)
	if #parent.snippet.env.SELECT_RAW > 0 then
		return sn(nil, i(1, parent.snippet.env.SELECT_RAW))
	else -- If SELECT_RAW is empty, return a blank insert node
		return sn(nil, i(1))
	end
end

-- Detect if we are in math
function M.in_mathzone()
	-- The `in_mathzone` function requires the VimTeX plugin
	return vim.fn["vimtex#syntax#in_mathzone"]() == 1
end

-- Detect if we are in text
M.in_text = function()
	return not M.in_mathzone()
end

-- Detect if we are in comment
M.in_comment = function()
	return vim.fn["vimtex#syntax#in_comment"]() == 1
end

-- Detect if we are in a certain environment
M.in_env = function(name) -- generic environment detection
	local is_inside = vim.fn["vimtex#env#is_inside"](name)
	return (is_inside[1] > 0 and is_inside[2] > 0)
end

-- Detect if we are in an equation environment
M.in_equation = function()
	return M.in_env("equation")
end

-- Detect if we are in an itemize environment
M.in_itemize = function()
	return M.in_env("itemize")
end

return M
