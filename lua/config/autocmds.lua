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
