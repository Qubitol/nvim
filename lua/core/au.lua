local utils = require("core.utils")

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight yanked text
local yank_group = augroup("HighlightYank", {})

autocmd("TextYankPost", {
	group = yank_group,
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({
			higroup = "IncSearch",
			timeout = 40,
		})
	end,
})

-- Filetypes autocommands
local ft_group = augroup("FileTypeGroup", {})

autocmd("FileType", {
	group = ft_group,
	pattern = "TelescopePrompt",
	callback = function()
        local status, cmp = pcall(require, "cmp")
        if not status or not cmp.setup then
            return
        end
        cmp.setup.buffer({
            enabled = false,
        })
	end,
})

-- Autosave on FocusLost
local focuslost_group = augroup("FocusLostGroup", {})

autocmd("FocusLost", {
	group = focuslost_group,
	pattern = "*",
	callback = function()
        vim.cmd("silent! wa")
    end,
})

-- Lastplace
local lastplace_group = augroup("nvim-lastplace", {})

autocmd({ "BufWinEnter", "FileType" }, {
    group = lastplace_group,
    callback = utils.goto_lastplace,
})

-- Netrw
local netrw = require("plugins.netrw")
local netrw_group = augroup("netrw_group", {})

autocmd("Filetype", {
    group = netrw_group,
    pattern = "netrw",
    callback = function(opts)
        netrw.draw_icons()
        netrw.place_cursor()
        autocmd("TextChanged", {
            buffer = opts.buf,
            callback = function()
                netrw.draw_icons()
                netrw.place_cursor()
            end,
        })
    end,
})

autocmd("QuitPre", {
    group = netrw_group,
    pattern = "*",
    callback = function()
        -- if current window is netrw do not do anything
        if vim.api.nvim_buf_get_option(0, "filetype") == "netrw" then
            return
        end
        local win = netrw.get_netrw_window()
        if win then
            vim.api.nvim_win_close(win, true)
        end
    end,
})
--
-- autocmd("BufLeave", {
--     group = netrw_group,
--     callback = function(opts)
--         if not vim.api.nvim_win_get_option(0, "previewwindow") then return end
--         for _, win in ipairs(vim.api.nvim_list_wins()) do
--             if vim.api.nvim_win_get_option(win, "previewwindow") == true then
--                 goto continue
--             end
--             if opts.buf == vim.api.nvim_win_get_buf(win) then
--                 return
--             end
--             ::continue::
--         end
--         vim.api.nvim_buf_delete(opts.buf, { force = true })
--     end,
-- })
