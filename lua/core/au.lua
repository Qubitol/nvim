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
