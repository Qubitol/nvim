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
        local filetype = vim.api.nvim_win_call(0, function() return vim.bo.filetype end)
        if filetype == "netrw" then
            return
        end
        local cur_tabpage_wins = vim.api.nvim_tabpage_list_wins(0)
        for _, win_handle in ipairs(cur_tabpage_wins) do
            filetype = vim.api.nvim_win_call(win_handle, function() return vim.bo.filetype end)
            if filetype == "netrw" then
                -- assuming only one netrw split is open
                vim.api.nvim_win_close(win_handle, true)
                return
            end
        end
    end,
})
