local map = require("utils").map

-- leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

map("n", "<M-t>", "<cmd>silent! doautocmd User TmuxAttach | silent! doautocmd BufRead<CR>", "Fire the TmuxAttach event")
map("n", "<C-u>", "<C-u>zz", "Scroll half-page up and center viewport")
map("n", "<C-d>", "<C-d>zz", "Scroll half-page down and center viewport")
map("n", "n", "nzz", "Find next and center viewport")
map("n", "N", "Nzz", "Find previous and center viewport")
map("n", "'", "`", "Jump to mark (easy to press on my keyboard, and more efficient)")
map(
    "n",
    "<leader>sr",
    ":%s/\\<<C-r><C-w>\\>//gI<left><left><left>",
    "[S]earch and [R]eplace the word under the cursor",
    { silent = false }
)
map("n", "<leader>th", "<cmd>set hlsearch! hlsearch?<CR>", "[T]oggle search-[H]ighlighting")
map("n", "<leader>tw", "<cmd>set wrap! wrap?<CR>", "[T]oggle word-[W]rap")
map("n", "<leader>x", "<cmd>!chmod +x %<CR>", "Make file e[X]ecutable")
map("n", "<leader>bd", "<cmd>bnext<CR><cmd>bdelete#<CR>", "Unload the current [B]uffer and [D]elete it from the list")
map("n", "[b", "<cmd>bprevious<CR>", "Go to previous [B]uffer")
map("n", "]b", "<cmd>bnext<CR>", "Go to next [B]uffer")
map("n", "[B", "<cmd>bfirst<CR>", "Go to first [B]uffer")
map("n", "]B", "<cmd>blast<CR>", "Go to last [B]uffer")
map("n", "<leader>ct", "<cmd>!ctags -R .<CR>", "[C]reate [T]ags file")
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
map("n", "<leader>qn", "<cmd>cnewer<CR>", "Go to the [Q]uickfix list [N]ext")
map("n", "<leader>qp", "<cmd>colder<CR>", "Go to the [Q]uickfix list [P]revious")
map("n", "[l", "<cmd>lprevious<CR>zz", "Go to previous [L]ocation list element and center viewport")
map("n", "]l", "<cmd>lnext<CR>zz", "Go to next [L]ocation list element and center viewport")
map("n", "[L", "<cmd>lfirst<CR>zz", "Go to first [L]ocation list element and center viewport")
map("n", "]L", "<cmd>llast<CR>zz", "Go to last [L]ocation list element and center viewport")
map("n", "[<C-L>", "<cmd>lpfile<CR>", "Display the last error in the previous file in the location list")
map("n", "]<C-L>", "<cmd>lnfile<CR>", "Display the first error in the next file in the location list")
map("n", "<leader>ln", "<cmd>lnewer<CR>", "Go to the [L]oclist [N]ext")
map("n", "<leader>lp", "<cmd>lolder<CR>", "Go to the [L]oclist [P]revious")
map("n", "[a", "<cmd>previous<CR>", "Go to previous [A]rg")
map("n", "]a", "<cmd>next<CR>", "Go to next [A]rg")
map("n", "[A", "<cmd>first<CR>", "Go to first [A]rg")
map("n", "]A", "<cmd>last<CR>", "Go to last [A]rg")
map("n", "g[", "<cmd>diffget //2<CR>", "[G]et the merge resolution from the buffer on the [left (target parent)")
map("n", "g]", "<cmd>diffget //3<CR>", "[G]et the merge resolution from the buffer on the right] (merge parent)")
map("n", "<leader>cd", "<cmd>cd %:p:h<CR>", "[C]hange current [D]irectory to the base directory of the active buffer")
map(
    "n",
    "<leader>tcd",
    "<cmd>tcd %:p:h<CR>",
    "[C]hange current directory to the base directory of the active buffer, locally to the [T]ab page"
)
map("n", "<leader>d", [["_d]], "Delete without polluting the register")
map("n", "<leader>D", [["_D]], "Delete without polluting the register")
map("n", "<leader>tq", require("utils").toggle_qflist, "[T]oggle [Q]uickfix list")
map("n", "<leader>tl", require("utils").toggle_loclist, "[T]oggle [L]ocation list")
map(
    "v",
    "<leader>fi",
    [[""y/\v<C-r>=escape('<C-r>"', '/\\(){}+?~"^')<CR><CR>]],
    "[FI]nd the visual selection in the current file",
    { silent = false }
)
map(
    "v",
    "<leader>sr",
    [[""y:%s/\v<C-r>=escape('<C-r>"', '/\\(){}+?~"^')<CR>//gI<left><left><left>]],
    "[S]earch and [R]eplace the visual selection",
    { silent = false }
)
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
map(
    "x",
    "<leader>p",
    [["_dP]],
    "Replace selected text with the content of the default register but don't pollute the register itself"
)

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
