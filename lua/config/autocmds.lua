local utils = require("config.utils")

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Insert mode triggers :lcd on current file path to help file-path completion
-- reset path on leave, use only on relevant filetypes
local group = vim.api.nvim_create_augroup("PathComplFromFile", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = { "markdown", "wiki" },
    callback = function(args)
        vim.api.nvim_create_autocmd("InsertEnter", {
            group = group,
            buffer = args.buf,
            callback = function()
                local file_dir = vim.fn.expand("%:p:h")
                if file_dir == "" or vim.fn.isdirectory(file_dir) == 0 then
                    return
                end
                -- stash the prior cwd on the window so we can restore it
                vim.w.precompl_cwd = vim.fn.getcwd(0)
                pcall(vim.cmd.lcd, vim.fn.fnameescape(file_dir))
            end,
        })

        vim.api.nvim_create_autocmd("InsertLeave", {
            group = group,
            buffer = args.buf,
            callback = function()
                if vim.w.precompl_cwd then
                    pcall(vim.cmd.lcd, vim.fn.fnameescape(vim.w.precompl_cwd))
                    vim.w.precompl_cwd = nil
                end
            end,
        })
    end,
})

-- Terminal
local terminal_group = augroup("Terminal", {})

autocmd("TermOpen", {
    group = terminal_group,
    callback = function()
        -- Need to set the highlighting and mode also here since TermOpen fires after BufType
        -- It is essential to use vim.opt_local
        vim.opt_local.winhighlight = "Normal:TermNormal,NormalNC:TermNormalNC"
        vim.cmd.startinsert()
        vim.opt_local.colorcolumn = ""
    end,
})

-- Quit neovim if, after closing a terminal buffer, the only remaining buffer
-- is a [No Name]
autocmd("TermClose", {
    group = terminal_group,
    callback = function()
        vim.schedule(function()
            if (vim.bo.buftype == "" and vim.api.nvim_buf_get_name(0) == "") then
                vim.cmd.q()
            end
        end)
    end,
})

-- Set insert mode whenever we enter a terminal, and keep the cwd
local saved_lcds = {} -- keyed by window id

autocmd("BufEnter", {
    group = terminal_group,
    callback = function()
        local win = vim.api.nvim_get_current_win()
        if vim.bo.buftype == "terminal" then
            if not saved_lcds[win] then
                saved_lcds[win] = vim.fn.getcwd(0)
            end
        else
            if saved_lcds[win] then
                vim.cmd.lcd(saved_lcds[win])
                saved_lcds[win] = nil
            end
        end
    end,
})

autocmd({ "TermRequest" }, {
    desc = "Handles OSC 7 dir change requests",
    group = terminal_group,
    callback = function(ev)
        local val, n = string.gsub(ev.data.sequence, "\027]7;file://[^/]*", "")
        if n > 0 then
            -- OSC 7: dir-change
            local dir = val
            if vim.fn.isdirectory(dir) == 0 then
                vim.notify("invalid dir: " .. dir)
                return
            end
            vim.b[ev.buf].osc7_dir = dir
            if vim.api.nvim_get_current_buf() == ev.buf then
                vim.cmd.lcd(dir)
            end
        end
    end,
})

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

-- We need the following because the runtime ftplugins (by other plugins) can
-- modify the formatoptions via `setlocal`, so my global default is never
-- applied. With a FileType autocommand, I can set it explicitly.
autocmd("FileType", {
    desc = "Override ftplugin formatoptions",
    group = ft_group,
    callback = function()
        vim.opt_local.formatoptions = "qnj1cr"
    end,
})

autocmd("FileType", {
    pattern = "gitcommit",
    callback = function()
        vim.opt_local.formatoptions:append("t")
    end,
})

autocmd("FileType", {
    desc = "Common background for some filetypes",
    group = ft_group,
    pattern = { "aerial", "calendar", "fugitive", "fugitiveblame", "git", "help", "qf", "undotree" },
    callback = function()
        local set = vim.opt_local
        set.colorcolumn = ""
        set.signcolumn = "no"
        set.wrap = false
        set.list = false
        set.winhighlight = "Normal:FileBrowser"
    end,
})

-- Fix filetype for help files
autocmd("BufRead", {
    group = ft_group,
    pattern = "*",
    callback = function()
        if vim.o.filetype == "" and vim.o.buftype == "help" then
            vim.o.filetype = "help"
        end
    end,
})

-- Autosave on FocusLost
local autosave_group = augroup("AutosaveGroup", {})

autocmd("FocusLost", {
    group = autosave_group,
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
