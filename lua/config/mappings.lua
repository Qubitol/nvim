local utils = require("config.utils")
local map = utils.map

map("n", "<C-u>", "<C-u>zz", "Scroll half-page up and center viewport")
map("n", "<C-d>", "<C-d>zz", "Scroll half-page down and center viewport")
map("n", "n", "nzz", "Find next and center viewport")
map("n", "N", "Nzz", "Find previous and center viewport")
map("n", "<leader>n", "n", "Find next (original)")
map("n", "<leader>N", "N", "Find previous (original)")
map("n", "'", "`", "Jump to mark (easy to press on my keyboard, and more efficient)")
map(
    "n",
    "<leader>sr",
    ":%s/\\<<C-r><C-w>\\>//gI<left><left><left>",
    "[S]earch and [R]eplace the word under the cursor",
    { silent = false }
)
map("n", "<leader>th", "<cmd>set hlsearch! hlsearch?<CR>", "[T]oggle search-[H]ighlighting")
map("n", "<Esc>", "<cmd>set nohlsearch<CR>", "Disable search-highlighting")
map("n", "<leader>tw", "<cmd>set wrap! wrap?<CR>", "[T]oggle word-[W]rap")
map("n", "<leader>tn", "<cmd>set relativenumber! relativenumber?<CR>", "[T]oggle relative line [N]umbers")
map("n", "<leader>bd", utils.bufdelete, "Unload the current [B]uffer and [D]elete it from the list")
map("n", "[b", "<cmd>bprevious<CR>", "Go to previous [B]uffer")
map("n", "]b", "<cmd>bnext<CR>", "Go to next [B]uffer")
map("n", "[B", "<cmd>bfirst<CR>", "Go to first [B]uffer")
map("n", "]B", "<cmd>blast<CR>", "Go to last [B]uffer")
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
map("n", "]d", "<cmd>lua vim.diagnostic.jump({ count = 1 })<cr>zz", "Go to next [D]iagnostic, center viewport")
map("n", "[d", "<cmd>lua vim.diagnostic.jump({ count = -1 })<cr>zz", "Go to previous [D]iagnostic, center viewport")
map("n", "[a", "<cmd>previous<CR>", "Go to previous [A]rg")
map("n", "]a", "<cmd>next<CR>", "Go to next [A]rg")
map("n", "[A", "<cmd>first<CR>", "Go to first [A]rg")
map("n", "]A", "<cmd>last<CR>", "Go to last [A]rg")
map("n", "g[", "<cmd>diffget //2<CR>", "[G]et the merge resolution from the buffer on the left [h] (target parent)")
map("n", "g]", "<cmd>diffget //3<CR>", "[G]et the merge resolution from the buffer on the right [l] (merge parent)")
map("n", "<leader>d", [["_d]], "Delete without polluting the register")
map("n", "<leader>D", [["_D]], "Delete without polluting the register")
map("n", "<leader>tq", utils.toggle_qflist, "[T]oggle [Q]uickfix list")
map("n", "<leader>tl", utils.toggle_loclist, "[T]oggle [L]ocation list")
map("v", "<leader>fi", function()
    vim.cmd('noau normal! "vy')
    local text = vim.fn.getreg("v")
    local escaped = vim.fn.escape(text, "\\/")
    vim.api.nvim_feedkeys("/\\V" .. escaped .. "\n", "n", false)
end, "[FI]nd the visual selection in the current file", { silent = false })
map("v", "<leader>sr", function()
    vim.cmd('noau normal! "vy')
    local text = vim.fn.getreg("v")
    local escaped = vim.fn.escape(text, "\\/")
    local keys = ":%s/\\V" .. escaped .. "//gI"
    local left = vim.api.nvim_replace_termcodes("<Left><Left><Left>", true, false, true)
    vim.api.nvim_feedkeys(keys .. left, "n", false)
end, "[S]earch and [R]eplace the visual selection", { silent = false })
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
local function nparent()
    local count = vim.v.count or 0
    local path = vim.fn.expand("%:p:h")
    for _ = 1, count do
        path = path .. "/.."
    end
    return path
end
map("n", "<leader>cd", function()
    return "<cmd>cd " .. nparent() .. "<CR>"
end, "[C]hange current [D]irectory to the base directory of the active buffer (use count n to target the n-parent)", { expr = true })
map("n", "<leader>lcd", function()
    return "<cmd>lcd " .. nparent() .. "<CR>"
end, "[C]hange current [L]ocal [D]irectory to the base directory of the active buffer (use count n to target the n-parent)", { expr = true })
map("n", "<leader>tcd", function()
    return "<cmd>tcd " .. nparent() .. "<CR>"
end, "[C]hange current [T]ab [D]irectory to the base directory of the active buffer (use count n to target the n-parent)", { expr = true })

-- Navigation
map("n", "<A-h>", "<C-w>h", "Navigate to window to the left")
map("n", "<A-j>", "<C-w>j", "Navigate to window below")
map("n", "<A-k>", "<C-w>k", "Navigate to window above")
map("n", "<A-l>", "<C-w>l", "Navigate to window to the right")
map("i", "<A-h>", [[<C-\><C-N><C-w>h]], "Navigate to window to the left")
map("i", "<A-j>", [[<C-\><C-N><C-w>j]], "Navigate to window below")
map("i", "<A-k>", [[<C-\><C-N><C-w>k]], "Navigate to window above")
map("i", "<A-l>", [[<C-\><C-N><C-w>l]], "Navigate to window to the right")

-- Terminal
map("t", "<Esc>", [[<C-\><C-N>]], "Go back to normal mode from terminal mode")
map("t", "<C-R>", function()
    return [[<C-\><C-N>]] .. vim.fn.nr2char(vim.fn.getchar()) .. "pi"
end, "Emulate <C-R> in terminal mode", { expr = true })
map("t", "<C-6>", [[<C-\><C-N><C-^>]], "Emulate <C-^> in terminal mode")
map("t", "<A-h>", [[<C-\><C-N><C-w>h]], "Navigate to window to the left")
map("t", "<A-j>", [[<C-\><C-N><C-w>j]], "Navigate to window below")
map("t", "<A-k>", [[<C-\><C-N><C-w>k]], "Navigate to window above")
map("t", "<A-l>", [[<C-\><C-N><C-w>l]], "Navigate to window to the right")
map({ "n", "t" }, "<A-w>v", function() vim.cmd.vsplit() vim.cmd.terminal() end, "Vertical split terminal")
map({ "n", "t" }, "<A-w>s", function() vim.cmd.split() vim.cmd.terminal() end, "Horizontal split terminal")
map({ "n", "t" }, "<A-w>n", function() vim.cmd.terminal() end, "Terminal in current window")
map({ "n", "t" }, "<A-w>t", function() vim.cmd.tabnew() vim.cmd.terminal() end, "Terminal in new tab")
-- Toggle zoom window (open it in a new tabpage)
local zoom_tabpage = nil
map({ "n", "t" }, "<A-z>", function()
    if zoom_tabpage and vim.api.nvim_tabpage_is_valid(zoom_tabpage) then
        vim.cmd.tabclose()
        zoom_tabpage = nil
    else
        vim.cmd(vim.bo.buftype == "terminal" and "tabnew | b #" or "tabnew %")
        zoom_tabpage = vim.api.nvim_get_current_tabpage()
    end
end, "Zoom current window")

-- Argpick
map("n", "<leader>oa", function() require("config.argpick").open() end, "[O]pen [A]rglist picker")
map("n", "<leader>aa", ":argadd % | argdedupe <CR>", "[A]dd the current file to the [A]rg list and remove possible duplicates")
map("n", "<C-h>", function() utils.open_n_arg_file(0) end, "Edit 1st element of arglist")
map("n", "<C-j>", function() utils.open_n_arg_file(1) end, "Edit 2nd element of arglist")
map("n", "<C-k>", function() utils.open_n_arg_file(2) end, "Edit 3rd element of arglist")
map("n", "<C-l>", function() utils.open_n_arg_file(3) end, "Edit 4th element of arglist")

-- Undotree
map("n", "<leader>tu", "<CMD>Undotree<CR>", "[T]oggle [U]ndotree")

-- Readline on command line
map("c", "<C-a>", "<Home>", "Move cursor to the beginning of the line", { silent = false })
map("c", "<C-e>", "<End>", "Move cursor to the end of the line", { silent = false })
map("c", "<C-b>", "<Left>", "Move cursor one character to the left", { silent = false })
map("c", "<C-f>", "<Right>", "Move cursor one character to the right", { silent = false })
map("c", "<C-d>", "<Del>", "Delete the character under the cursor", { silent = false })
map("c", "<M-d>", "<C-Right><C-w>", "Delete the word after the cursor", { silent = false })
map("c", "<M-b>", "<C-Left>", "Move cursor one word to the left", { silent = false })
map("c", "<M-f>", "<C-Right>", "Move cursor one word to the right", { silent = false })
