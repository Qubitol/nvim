local status_ok, ls = pcall(require, "luasnip")
if not status_ok then
	return
end

-- Useful redefinitions
local sn = ls.snippet_node
local i = ls.insert_node
local types = require("luasnip.util.types")

-- Fetch colors from palette
local colors = require("core.ui.theme").theme

-- Configuration
ls.config.set_config({
	-- Don't store snippet history for less overhead
	history = false,

	-- Enable autotriggered snippets
	enable_autosnippets = true,

	-- Use Tab (or some other key if you prefer) to trigger visual selection
	store_selection_keys = "<Tab>",

	-- Update changes as you type
	updateevents = "TextChanged,TextChangedI",

	-- Extra options
	ext_opts = {
		[types.choiceNode] = {
			active = {
				virt_text = { { "●", colors.yellow } },
			},
		},
		-- [types.insertNode] = {
		-- 	active = {
		-- 		virt_text = { { "●", colors.teal } },
		-- 	},
		-- },
	},
})

-- Mappings
vim.cmd([[
" " press <Tab> to expand or jump in a snippet. These can also be mapped separately
" " via <Plug>luasnip-expand-snippet and <Plug>luasnip-jump-next.
" imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>' 
" " -1 for jumping backwards.
" inoremap <silent> <S-Tab> <cmd>lua require'luasnip'.jump(-1)<Cr>
"
" snoremap <silent> <Tab> <cmd>lua require('luasnip').jump(1)<Cr>
" snoremap <silent> <S-Tab> <cmd>lua require('luasnip').jump(-1)<Cr>

" For changing choices in choiceNodes (not strictly necessary for a basic setup).
imap <silent><expr> <C-N> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-N>'
smap <silent><expr> <C-N> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-N>'
imap <silent><expr> <C-P> luasnip#choice_active() ? '<Plug>luasnip-prev-choice' : '<C-P>'
smap <silent><expr> <C-P> luasnip#choice_active() ? '<Plug>luasnip-prev-choice' : '<C-P>'
]])

-- Load the snippets and map a key to update during runtime
require("luasnip.loaders.from_lua").lazy_load({ paths = "~/.config/nvim/LuaSnip/" })
vim.keymap.set(
	"n",
	"<Leader>U",
	[[<cmd>lua require("luasnip.loaders.from_lua").load({paths = "~/.config/nvim/LuaSnip/"})<CR>]]
)

-- Useful functions for snippets
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
  return vim.fn['vimtex#syntax#in_mathzone']() == 1
end

-- Detect if we are in text
M.in_text = function()
  return not M.in_mathzone()
end

-- Detect if we are in comment
M.in_comment = function()
  return vim.fn['vimtex#syntax#in_comment']() == 1
end

-- Detect if we are in a certain environment
M.in_env = function(name)  -- generic environment detection
    local is_inside = vim.fn['vimtex#env#is_inside'](name)
    return (is_inside[1] > 0 and is_inside[2] > 0)
end

-- Detect if we are in an equation environment
M.in_equation = function()
    return M.in_env('equation')
end

-- Detect if we are in an itemize environment
M.in_itemize = function()
    return M.in_env('itemize')
end

return M
