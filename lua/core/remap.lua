-- Set the leader key
local g = vim.g
g.mapleader = " "
g.maplocalleader = "\\"

-- Shorten function name
local map = vim.keymap.set

-- Import utilities
local utils = require("core.utils")

-- Set mapping options
local opts = { noremap = true, silent = true }
local term_opts = { silent = true }

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Center while scrolling/searching
map("n", "<C-u>", "<C-u>zz", opts)
map("n", "<C-d>", "<C-d>zz", opts)
map("n", "n", "nzz", opts)
map("n", "N", "Nzz", opts)

-- Substitute work under cursor
map("n", "<Leader>sr", ":%s/\\<<C-r><C-w>\\>//gI<left><left><left>", opts)
-- Search/Substitute visual selection
map("v", "<Leader>fi", [[""y/\v<C-r>=escape('<C-r>"', '/(){}+?"')<CR><CR>]], opts)
map("v", "<Leader>sr", [[""y:%s/\v<C-r>=escape('<C-r>"', '/(){}+?"')<CR>//gI<left><left><left>]], opts)

-- Toggle search highlighting
map("n", "<Leader>th", "<cmd>set hlsearch! hlsearch?<CR>", opts)
-- Toggle line wrap
map("n", "<Leader>tw", "<cmd>set wrap! wrap?<CR>", opts)

-- Delete to the black hole (use [[ and ]] to string delimit, so no need to escape)
map({"n", "v"}, "<Leader>d", [["_d]], opts)
map({"n", "v"}, "<Leader>D", [["_D]], opts)
map({"n", "v"}, "<Leader>c", [["_c]], opts)
map({"n", "v"}, "<Leader>C", [["_C]], opts)

-- Paste over and continue to paste the same word
map({"v", "x"}, "<Leader>p", [["_dP]], opts)

-- Make current buffer file executable
map("n", "<Leader>x", "<cmd>!chmod +x %<CR>", opts)

-- Shortcut to split current buffer
map("n", [[<C-w>\]], ":vsplit<CR>", opts)
map("n", [[<C-w>-]], ":split<CR>", opts)

-- Navigate buffers
map("n", "[b", ":bprevious<CR>", opts)
map("n", "]b", ":bnext<CR>", opts)
map("n", "[B", ":bfirst<CR>", opts)
map("n", "]B", ":blast<CR>", opts)

-- Navigate tags
map("n", "[t", ":tprevious<CR>", opts)
map("n", "]t", ":tnext<CR>", opts)
map("n", "[T", ":tfirst<CR>", opts)
map("n", "]T", ":tlast<CR>", opts)
map("n", "[<C-T>", ":ptprevious<CR>", opts)
map("n", "]<C-T>", ":ptnext<CR>", opts)

-- Navigate quickfix
map("n", "[q", ":cprevious<CR>zz", opts)
map("n", "]q", ":cnext<CR>zz", opts)
map("n", "[Q", ":cfirst<CR>zz", opts)
map("n", "]Q", ":clast<CR>zz", opts)
map("n", "[<C-Q>", ":cpfile<CR>", opts)
map("n", "]<C-Q>", ":cnfile<CR>", opts)
map("n", "<leader>qn", ":cnewer<CR>", opts)
map("n", "<leader>qp", ":colder<CR>", opts)
map("n", "<leader>tq", utils.toggle_qf, opts)

-- Navigate loclist
map("n", "[l", ":lprevious<CR>zz", opts)
map("n", "]l", ":lnext<CR>zz", opts)
map("n", "[L", ":lfirst<CR>zz", opts)
map("n", "]L", ":llast<CR>zz", opts)
map("n", "[<C-L>", ":lpfile<CR>", opts)
map("n", "]<C-L>", ":lnfile<CR>", opts)

-- Navigate arglist
map("n", "[a", ":previous<CR>", opts)
map("n", "]a", ":next<CR>", opts)
map("n", "[A", ":first<CR>", opts)
map("n", "]A", ":last<CR>", opts)

-- Unload the current buffer
map("n", "<leader>bd", ":bnext<CR>:bdelete#<CR>", opts)

-- Git
map("n", "<leader>gC", ":Git commit", opts)
map("n", "<leader>gB", ":Git branch", opts)
map("n", "<leader>gZ", ":Git stash", opts)
map("n", "<leader>gO", ":Git checkout", opts)
map("n", "<leader>gp", "<cmd>Git push<CR>", opts)
map("n", "<leader>gP", ":Git push -u origin", opts)
map("n", "<leader>gu", "<cmd>Git pull --rebase<CR>", opts)
map("n", "<leader>gU", ":Git pull --rebase -u origin", opts)

-- Diff
map("n", "gl", "<cmd>diffget //3<CR>", opts)
map("n", "gh", "<cmd>diffget //2<CR>", opts)

-- Change dir to current file root
map("n", "<leader>cd", [[<cmd>cd `=expand("%:p:h")`<CR>]], opts)
map("n", "<leader>ct", [[<cmd>tcd `=expand("%:p:h")`<CR>]], opts)

-- Move text up and down
map("v", "J", "<Esc>:m '>+1<CR>gv=gv", opts)
map("v", "K", "<Esc>:m '<-2<CR>gv=gv", opts)
