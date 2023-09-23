local utils = require("utils")

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

-- Resize
local resize_group = augroup("ResizeGroup", {})

autocmd("VimResized", {
    group = resize_group,
    callback = function()
        vim.cmd("tabdo wincmd =")
    end,
})

-- Netrw
--local netrw = require("plugins.netrw")
--local netrw_group = augroup("netrw_group", {})
--
--autocmd("ShellCmdPost", { -- this is fired when Netrw refreshes
--    group = netrw_group,
--    pattern = "netrw",
--    callback = netrw._draw_icons
--})
--
--autocmd("Filetype", {
--    group = netrw_group,
--    pattern = "netrw",
--    callback = function(opts)
--        netrw._draw_icons()
--        netrw._place_cursor()
--        autocmd("TextChanged", {
--            buffer = opts.buf,
--            callback = function()
--                netrw._draw_icons()
--                netrw._place_cursor()
--            end,
--        })
--        autocmd("WinClosed", {
--            buffer = opts.buf,
--            callback = function(opts_win)
--                local win_id = opts_win.match
--                if opts_win["data"] and opts_win.data["match"] then win_id = opts_win.data.match end
--                netrw._neatrw_tree[vim.api.nvim_get_current_tabpage()][tonumber(win_id)] = nil
--            end,
--        })
--        autocmd("TabClosed", {
--            buffer = opts.buf,
--            callback = function(opts_tab)
--                netrw._neatrw_tree[tonumber(opts_tab.match)] = nil
--            end,
--        })
--        -- use a table with unique values because this event is called multiple times
--        local tab = vim.api.nvim_get_current_tabpage()
--        local win = vim.api.nvim_get_current_win()
--        if not netrw._neatrw_tree[tab] then
--            netrw._neatrw_tree[tab] = {}
--        end
--        -- fill only if not already filled (faster and it does not mess up with cwd and similar)
--        if netrw._neatrw_tree[tab][win] then
--            return
--        end
--        netrw._neatrw_tree[tab][win] = {}
--        netrw._neatrw_tree[tab][win].open_target = vim.fn.win_getid(vim.fn.winnr("#"))
--        netrw._neatrw_tree[tab][win].cwd = vim.fn.getcwd(netrw._neatrw_tree[tab][win].open_target)
--    end,
--})
