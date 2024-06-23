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

-- DAP autocommands
local dap_group = augroup("DAPGroup", {})

autocmd("BufWinEnter", { -- also BufEnter works
    group = dap_group,
    pattern = "DAP *,\\[dap-repl\\]",
    callback = function()
        vim.opt_local.cursorline = false
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

-- Resize
local resize_group = augroup("ResizeGroup", {})

autocmd("VimResized", {
    group = resize_group,
    callback = function()
        vim.cmd("tabdo wincmd =")
    end,
})
