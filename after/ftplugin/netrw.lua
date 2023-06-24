local netrw = require("plugins.netrw")
local set = vim.opt
local map = vim.keymap.set
local opts = { buffer = true, noremap = true, silent = true }

-- Open file and close netrw
map("n", "l", function()
    local cur_line = vim.api.nvim_win_get_cursor(0)
    local line = vim.fn.getline(cur_line[1])
    local replaced_keys = vim.api.nvim_replace_termcodes("normal <CR>", true, true, true)
    vim.cmd(replaced_keys)
    if not line:find("/$") then
        netrw.toggle_netrw()
    end
end, opts)

-- Go up with h
-- apparently, I could not do simply
-- nmap <buffer> h -
-- because it seems mappings are reset, so I need this workaround
map("n", "h", function() vim.cmd("normal -") end, { buffer = true, silent = true })

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

netrw.draw_icons()
