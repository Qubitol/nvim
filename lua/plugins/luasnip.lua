local status_ok, ls = pcall(require, "luasnip")
if not status_ok then
	return
end

-- Define module to export
local M = {}

-- Useful redefinitions
local sn = ls.snippet_node
local i = ls.insert_node

-- Configuration
ls.config.set_config({
    -- Don't store snippet history for less overhead
    history = false,

    -- Enable autotriggered snippets
    enable_autosnippets = true,

    -- Use Tab (or some other key if you prefer) to trigger visual selection
    store_selection_keys = "<Tab>",
})

-- Mappings
vim.cmd [[
" press <Tab> to expand or jump in a snippet. These can also be mapped separately
" via <Plug>luasnip-expand-snippet and <Plug>luasnip-jump-next.
imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>' 
" -1 for jumping backwards.
inoremap <silent> <S-Tab> <cmd>lua require'luasnip'.jump(-1)<Cr>

snoremap <silent> <Tab> <cmd>lua require('luasnip').jump(1)<Cr>
snoremap <silent> <S-Tab> <cmd>lua require('luasnip').jump(-1)<Cr>

" For changing choices in choiceNodes (not strictly necessary for a basic setup).
imap <silent><expr> <C-E> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'
smap <silent><expr> <C-E> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'
]]

-- Load the snippets and map a key to update during runtime
require("luasnip.loaders.from_lua").lazy_load({ paths = "~/.config/nvim/LuaSnip/" })
vim.keymap.set("", "<Leader>U",
    [[<cmd>lua require("luasnip.loaders.from_lua").lazy_load({paths = "~/.config/nvim/LuaSnip/"})<CR>]])

-- get_visual function to store deleted text to insert in next snippet
-- Summary: When `SELECT_RAW` is populated with a visual selection, the function
-- returns an insert node whose initial text is set to the visual selection.
-- When `SELECT_RAW` is empty, the function simply returns an empty insert node.
function M.get_visual(args, parent)
    if (#parent.snippet.env.SELECT_RAW > 0) then
        return sn(nil, i(1, parent.snippet.env.SELECT_RAW))
    else -- If SELECT_RAW is empty, return a blank insert node
        return sn(nil, i(1))
    end
end

return M
