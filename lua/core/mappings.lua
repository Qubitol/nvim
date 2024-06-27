local map = require("utils").map

-- leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

map("n", "<C-u>", "<C-u>zz", "Scroll half-page up and center viewport")
map("n", "<C-d>", "<C-d>zz", "Scroll half-page down and center viewport")
map("n", "n", "nzz", "Find next and center viewport")
map("n", "N", "Nzz", "Find previous and center viewport")
map("n", "'", "`", "Jump to mark (easy to press on my keyboard, and more efficient)")
map("n", "<M-h>", "<cmd>set hlsearch! hlsearch?<CR>", "[T]oggle search-[H]ighlighting")
map("n", "<M-w>", "<cmd>set wrap! wrap?<CR>", "[T]oggle word-[W]rap")
map("n", "<M-d>", "<cmd>bnext<CR><cmd>bdelete#<CR>", "Unload the current [B]uffer and [D]elete it from the list")
map("n", "[b", "<cmd>bprevious<CR>", "Go to previous [B]uffer")
map("n", "]b", "<cmd>bnext<CR>", "Go to next [B]uffer")
map("n", "[B", "<cmd>bfirst<CR>", "Go to first [B]uffer")
map("n", "]B", "<cmd>blast<CR>", "Go to last [B]uffer")
map("n", "[t", "<cmd>tprevious<CR>", "Go to previous [T]ag")
map("n", "]t", "<cmd>tnext<CR>", "Go to next [T]ag")
map("n", "[T", "<cmd>tfirst<CR>", "Go to first [T]ag")
map("n", "]T", "<cmd>tlast<CR>", "Go to last [T]ag")
map("n", "[<C-T>", "<cmd>ptprevious<CR>", "Go to previous tag in the preview window")
map("n", "]<C-T>", "<cmd>ptnext<CR>", "Go to next tag in the preview window")
map("n", "[q", "<cmd>cprevious<CR>zz", "Go to previous [Q]uickfix list element and center viewport")
map("n", "]q", "<cmd>cnext<CR>zz", "Go to next [Q]uickfix list element and center viewport")
map("n", "[Q", "<cmd>cfirst<CR>zz", "Go to first [Q]uickfix list element and center viewport")
map("n", "]Q", "<cmd>clast<CR>zz", "Go to last [Q]uickfix list element and center viewport")
map("n", "[<C-Q>", "<cmd>cpfile<CR>", "Display the first error in the next file in the quickfix list")
map("n", "]<C-Q>", "<cmd>cnfile<CR>", "Display the first error in the next file in the quickfix list")
map("n", "[l", "<cmd>lprevious<CR>zz", "Go to previous [L]ocation list element and center viewport")
map("n", "]l", "<cmd>lnext<CR>zz", "Go to next [L]ocation list element and center viewport")
map("n", "[L", "<cmd>lfirst<CR>zz", "Go to first [L]ocation list element and center viewport")
map("n", "]L", "<cmd>llast<CR>zz", "Go to last [L]ocation list element and center viewport")
map("n", "[<C-L>", "<cmd>lpfile<CR>", "Display the last error in the previous file in the location list")
map("n", "]<C-L>", "<cmd>lnfile<CR>", "Display the first error in the next file in the location list")
map("n", "]d", "<cmd>lua vim.diagnostic.goto_next({ buffer = 0 })<cr>zz", "Go to next [D]iagnostic, center viewport")
map("n", "[d", "<cmd>lua vim.diagnostic.goto_prev({ buffer = 0 })<cr>zz", "Go to previous [D]iagnostic, center viewport")
map("n", "[a", "<cmd>previous<CR>", "Go to previous [A]rg")
map("n", "]a", "<cmd>next<CR>", "Go to next [A]rg")
map("n", "[A", "<cmd>first<CR>", "Go to first [A]rg")
map("n", "]A", "<cmd>last<CR>", "Go to last [A]rg")
map("n", "g[", "<cmd>diffget //2<CR>", "[G]et the merge resolution from the buffer on the left [h] (target parent)")
map("n", "g]", "<cmd>diffget //3<CR>", "[G]et the merge resolution from the buffer on the right [l] (merge parent)")
map("n", "<leader>d", [["_d]], "Delete without polluting the register")
map("n", "<leader>D", [["_D]], "Delete without polluting the register")
map("n", "<M-q>", require("utils").toggle_qflist, "[T]oggle [Q]uickfix list")
map("n", "<M-l>", require("utils").toggle_loclist, "[T]oggle [L]ocation list")
map("v", "<leader>d", [["_d]], "Delete without polluting the register")
map("v", "<leader>D", [["_D]], "Delete without polluting the register")
map(
    "v",
    "<leader>p",
    [["_dP]],
    "Replace selected text with the content of the default register but don't pollute the register itself"
)
map("v", "J", "<Esc><cmd>m '>+1<CR>gv=gv", "Move line down, respect indentation")
map("v", "K", "<Esc><cmd>m '<-2<CR>gv=gv", "Move line up, respect indentation")

-- Readline on command line
map("c", "<C-a>", "<Home>", "Move cursor to the beginning of the line", { silent = false })
map("c", "<C-e>", "<End>", "Move cursor to the end of the line", { silent = false })
map("c", "<C-b>", "<Left>", "Move cursor one character to the left", { silent = false })
map("c", "<C-f>", "<Right>", "Move cursor one character to the right", { silent = false })
map("c", "<C-d>", "<Del>", "Delete the character under the cursor", { silent = false })
map("c", "<M-d>", "<C-Right><C-w>", "Delete the word after the cursor", { silent = false })
map("c", "<C-t>", "<C-R>", "Paste the default register", { silent = false })
map("c", "<M-b>", "<C-Left>", "Move cursor one word to the left", { silent = false })
map("c", "<M-f>", "<C-Right>", "Move cursor one word to the right", { silent = false })
