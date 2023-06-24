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

autocmd("TextChanged", {
    group = netrw_group,
    pattern = "*",
    callback = netrw.draw_icons,
})
