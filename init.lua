-- See https://echasnovski.com/blog/2026-03-13-a-guide-to-vim-pack
-- «It implements some dark “fast load” magic that was blessed by Folke himself»
vim.loader.enable()

-- Globals
vim.g.pretty = vim.env.NOPRETTY == nil -- requires nerd font
vim.g.ai = vim.env.NOAI == nil
vim.g.mapleader = vim.keycode("<space>")
vim.g.maplocalleader = vim.keycode("<space>")

-- Load config
require("plugins")
require("config")
