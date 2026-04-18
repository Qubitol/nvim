local set = vim.opt_local
local map = require("config.utils").map
local opts = { buffer = true, noremap = true, silent = true }

local function is_loclist()
    return vim.fn.getloclist(0, { filewinid = 0 }).filewinid ~= 0
end

map("n", "p", "<CR>zz<C-w>p", "Preview location on file, keep focus on loclist/quickfix", opts)
map("n", "J", "j<CR>zz<C-w>p", "Scroll down the list while previewing the location on file, keep focus on loclist/quickfix", opts)
map("n", "K", "k<CR>zz<C-w>p", "Scroll up the list while previewing the location on file, keep focus on loclist/quickfix", opts)

map("n", "dd", function()
    local entry = vim.fn.line(".")
    if is_loclist() then
        local list = vim.fn.getloclist(0)
        table.remove(list, entry)
        vim.fn.setloclist(0, list)
        if #list > 0 then
            vim.cmd.ll({ count = math.min(entry, #list) })
        end
        vim.cmd.lopen()
    else
        local list = vim.fn.getqflist()
        table.remove(list, entry)
        vim.fn.setqflist(list)
        if #list > 0 then
            vim.cmd.cfirst({ count = math.min(entry, #list) })
        end
        vim.cmd.copen()
    end
end, "Delete entry from the list", opts)

-- options
set.colorcolumn = ""
set.wrap = false
set.relativenumber = false
set.statusline = ""
