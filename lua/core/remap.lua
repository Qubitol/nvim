-- Set the leader key
local g = vim.g
g.mapleader = " "
g.maplocalleader = "\\"

-- Shorten function name
local map = vim.keymap.set

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

-- Normal --
-- Center while scrolling/searching
map("n", "<C-u>", "<C-u>zz", opts)
map("n", "<C-d>", "<C-d>zz", opts)
map("n", "<leader>n", "nzz", opts)
map("n", "<leader>N", "Nzz", opts)

-- Substitute work under cursor
map("n", "<Leader>s", ":%s/\\<<C-r><C-w>>\\/<C-r><C-w>/gI<left><left><left>", opts)

-- Toggle search highlighting
map("n", "<Leader>th", "<cmd>set hlsearch! hlsearch?<CR>", opts)
-- Toggle line wrap
map("n", "<Leader>tw", "<cmd>set wrap! wrap?<CR>", opts)

-- Delete to the black hole (use [[ and ]] to string delimit, so no need to escape)
map("n", "<Leader>d", [["_d]], opts)
map("n", "<Leader>D", [["_D]], opts)

-- Make current buffer file executable
map("n", "<Leader>x", "<cmd>!chmod +x %<CR>", opts)

-- Shortcut to split current buffer
map("n", [[<C-w>\]], ":vsplit<CR>", opts)
map("n", [[<C-w>-]], ":split<CR>", opts)

-- Navigate buffers
map("n", "]b", ":bnext<CR>", opts)
map("n", "[b", ":bprevious<CR>", opts)

-- Navigate tabs
map("n", "]t", ":tabnext<CR>", opts)
map("n", "[t", ":tabprevious<CR>", opts)

-- Navigate quickfix
map("n", "]c", ":cnext<CR>zz", opts)
map("n", "[c", ":cprevious<CR>zz", opts)

-- Navigate loclist
map("n", "]l", ":lnext<CR>zz", opts)
map("n", "[l", ":lprevious<CR>zz", opts)

-- Unload the current buffer
map("n", "<leader>bd", ":bnext<CR>:bdelete#<CR>", opts)

-- Git --
map("n", "<leader>gc", ":Git commit -m<Space>", opts)
map("n", "<leader>gC", "<cmd>Git commit<CR>", opts)
map("n", "<leader>gf", "<cmd>Git pull<CR>", opts)
map("n", "<leader>gp", "<cmd>Git push<CR>", opts)

-- Change dir to current file root
map("n", "<leader>cd", [[<cmd>:cd `=expand("%:p:h")`<CR>]], opts)
map("n", "<leader>ct", [[<cmd>:tcd `=expand("%:p:h")`<CR>]], opts)

-- Insert --

-- Visual --
-- Delete to the black hole
map("v", "<leader>d", [["_d]], opts)
map({"v", "x"}, "<Leader>p", [["_dP]], opts)

-- Search/Substitute visual selection
map("v", "<leader>f", [[""y/<C-r>"<CR>]], opts)
map("v", "<leader>s", [[""y:%s/<C-r>"/<C-r>"/gI<left><left><left>]], opts)

-- Move text up and down
map("v", "J", "<Esc>:m '>+1<CR>gv=gv", opts)
map("v", "K", "<Esc>:m '<-2<CR>gv=gv", opts)

-- Visual block --

-- Terminal --

-- Command --
