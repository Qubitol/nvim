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
map("n", "<C-b>", "<C-b>zz", opts)
map("n", "<C-f>", "<C-f>zz", opts)
map("n", "<leader>n", "nzz", opts)
map("n", "<leader>N", "Nzz", opts)

-- Toggle search highlighting
map("n", "<Leader>th", "<cmd>set hlsearch! hlsearch?<CR>", opts)
-- Toggle line wrap
map("n", "<Leader>tw", "<cmd>set wrap! wrap?<CR>", opts)

-- Navigate seamlessly across wrapped paragraph
--map("n", "j", "gj", opts)
--map("n", "k", "gk", opts)

-- Delete to the black hole (use [[ and ]] to string delimit, so no need to escape)
map("n", "<Leader>d", [["_d]], opts)
map("n", "<Leader>D", [["_D]], opts)

-- Shortcut to split current buffer
map("n", [[<C-w>\]], ":vsplit<CR>", opts)
map("n", [[<C-w>-]], ":split<CR>", opts)

-- Navigate buffers
map("n", "]b", ":bnext<CR>", opts)
map("n", "[b", ":bprevious<CR>", opts)

-- Navigate tabs
map("n", "]t", ":tabnext<CR>", opts)
map("n", "[t", ":tabprevious<CR>", opts)

-- Move tabs
map("n", "]T", ":tabmove +1<CR>", opts)
map("n", "[T", ":tabmove -1<CR>", opts)

-- Navigate quickfix
map("n", "]c", ":cnext<CR>zz", opts)
map("n", "[c", ":cprevious<CR>zz", opts)

-- Navigate loclist
map("n", "]l", ":lnext<CR>zz", opts)
map("n", "[l", ":lprevious<CR>zz", opts)

-- Split window with opened buffer
-- map("n", "<Leader>sb", ":buffers<CR>:sbuffer<Space>", opts)
-- map("n", "<Leader>vb", ":buffers<CR>:vertical sbuffer<Space>", opts)

-- Delete the current buffer
map("n", "<Leader>bd", ":bnext<CR>:bdelete#<CR>", opts)

-- Insert --

-- Visual --
-- Delete to the black hole
map("v", "<Leader>d", [["_d]], opts)

-- Move text up and down
map("v", "J", "<Esc>:m '>+1<CR>gv=gv", opts)
map("v", "K", "<Esc>:m '<-2<CR>gv=gv", opts)

-- Visual block --

-- Terminal --

-- Command --
