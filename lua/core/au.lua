local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight yanked text
local yank_group = augroup('HighlightYank', {})

autocmd('TextYankPost', {
    group = yank_group,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 40,
        })
    end,
})

-- -- Use trouble to manage quickfix and loclist
-- function ToggleTroubleAuto()
--     local buftype = "quickfix"
--     local close_command = "cclose"
--     if vim.fn.getloclist(0, { filewinid = 1 }).filewinid ~= 0 then
--         buftype = "loclist"
--         close_command = "lclose"
--     end
--
--     local status_trouble_ok, trouble = pcall(require, "trouble")
--     if status_trouble_ok then
--         vim.defer_fn(function()
--             vim.cmd(close_command)
--             trouble.toggle(buftype)
--         end, 0)
--     else
--         local set = vim.opt_local
--         set.colorcolumn = ""
--         set.number = false
--         set.relativenumber = false
--         set.signcolumn = "no"
--     end
-- end
--
-- vim.cmd [[autocmd BufWinEnter quickfix silent :lua ToggleTroubleAuto()]]

-- autosave when focus lost
vim.cmd [[autocmd FocusLost * silent! wa]]
