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

-- Quickfix
local qf_group = augroup("Quickfix", {})
autocmd("FileType", {
    pattern = "qf",
    group = qf_group,
    callback = function()
        local set = vim.opt
        local map = vim.keymap.set
        local opts = { buffer = true, noremap = true, silent = true }
        -- preview the diagnostic location
        map("n", "p", "<CR>zz<C-w>w", opts)
        -- remove element from quickfix
        map("n", "dd", "<cmd>setlocal modifiable<CR>dd<cmd>setlocal nomodifiable<CR>", opts)
        map("v", "d", "<esc><cmd>setlocal modifiable<CR>gvd<cmd>setlocal nomodifiable<CR>", opts)
        -- options
        set.colorcolumn = ""
    end,
})

-- autosave when focus lost
vim.cmd([[autocmd FocusLost * silent! wa]])
