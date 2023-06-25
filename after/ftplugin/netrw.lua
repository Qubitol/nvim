local netrw = require("plugins.netrw")
local utils = require("core.utils")
local set = vim.opt_local
local map = vim.keymap.set
local opts = { buffer = true, noremap = true, silent = true }

-- Open file and close netrw
map("n", "l", function()
    local cur_line = vim.api.nvim_win_get_cursor(0)[1]
    local line = vim.fn.getline(cur_line)
    local replaced_keys = vim.api.nvim_replace_termcodes("normal <CR>", true, true, true)
    vim.cmd(replaced_keys)
    if not line:find("/$") then
        netrw.toggle_netrw()
        return
    end
    netrw.force_filetype_netrw()
end, opts)

-- Go up with h
-- apparently, I could not do simply
-- nmap <buffer> h -
-- because it seems mappings are reset, so I need the function workaround
-- (at the end I also needed to put other stuff in the function, but I keep
-- this thing here as a note)
-- map("n", "h", function() vim.cmd("normal -") end, opts)
map("n", "h", function()
    vim.cmd("normal -")
    netrw.force_filetype_netrw()
end, opts)

-- Update preview if open
local function is_cur_line_dir()
    local cur_line = vim.api.nvim_win_get_cursor(0)
    local line = vim.fn.getline(cur_line[1])
    return line:find("/$")
end

map("n", "j", function()
    local count = vim.api.nvim_get_vvar("count1")
    vim.api.nvim_command("normal! " .. count .. "j") -- use "!" to avoid recursion and execute original version of j
    if utils.is_preview_window_open() and not is_cur_line_dir() then
        vim.cmd("normal p") -- no "!" because we need to execute what p is mapped to
    end
end, opts)

map("n", "k", function()
    local count = vim.api.nvim_get_vvar("count1")
    vim.api.nvim_command("normal! " .. count .. "k")
    if utils.is_preview_window_open() and not is_cur_line_dir() then
        vim.cmd("normal p")
    end
end, opts)

map("n", "J", function() -- like the lowercase but always open the preview
    local count = vim.api.nvim_get_vvar("count1")
    vim.api.nvim_command("normal! " .. count .. "j")
    if not is_cur_line_dir() then
        vim.cmd("normal p")
    end
end, opts)

map("n", "K", function()
    local count = vim.api.nvim_get_vvar("count1")
    vim.api.nvim_command("normal! " .. count .. "k")
    if not is_cur_line_dir() then
        vim.cmd("normal p")
    end
end, opts)

-- Copy current selection in clipboard
map("n", "y", [["+yy]], opts)

-- Copy current selection full path in clipboard
-- (the path of the directory in netrw contains the trailing /)
map("n", "Y", [["+yy<cmd>let @+=@%.@+<CR>]], opts)

-- Create file
map("n", "f", "%:w<CR>:buffer #<CR>", opts)

-- options
set.colorcolumn = ""
set.signcolumn = "yes"
set.showmatch = true
set.synmaxcol = 100
set.cursorline = true
set.wrap = false
set.list = false

-- highlighting groups
set.winhighlight = "Normal:FileBrowser"
