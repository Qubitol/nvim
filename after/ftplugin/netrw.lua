local netrw = require("plugins.netrw")
local utils = require("core.utils")
local set = vim.opt_local
local map = vim.keymap.set
local opts = { buffer = true, noremap = true, silent = true }

-- Open file and close netrw
map("n", "l", netrw.forward, opts)

-- Go up with h
-- apparently, I could not do simply
-- nmap <buffer> h -
-- because it seems mappings are reset, so I need the function workaround
-- (at the end I also needed to put other stuff in the function, but I keep
-- this thing here as a note)
-- map("n", "h", function() vim.cmd("normal -") end, opts)
map("n", "h", netrw.backward, opts)

-- Preview
map("n", "P", function()
    local scrolloff = vim.api.nvim_get_option("scrolloff")
    local explorer_width = vim.api.nvim_win_get_width(0)
    local explorer_height = vim.api.nvim_win_get_height(0) -- includes winbar
    -- Check if only one window (which is netrw buffer)
    if #vim.api.nvim_tabpage_list_wins(0) == 1 then
        -- if only one window that is the file explorer: spawn float starting from the size specified for Lexplore + scrolloff
        local explorer_winsize = vim.api.nvim_get_var("explorer_winsize")
        vim.cmd("normal p")
        netrw.float_preview({
            corner = { scrolloff, explorer_winsize + scrolloff },
            width = explorer_width - explorer_winsize - 2 * scrolloff,
            height = explorer_height - 2 * scrolloff,
        })
        return
    end
    -- Get windows dimensions and see if we can create a float preview
    -- position is (row, col) from top left corner
    local explorer_pos = vim.api.nvim_win_get_position(0)
    local ui = vim.api.nvim_list_uis()[1]
    local cmd_height = vim.api.nvim_get_option("cmdheight")
    local status_height = 0
    if vim.api.nvim_get_option("laststatus") ~= 0 then
        status_height = 1
    end
    local tabline_height = 0
    if #vim.api.nvim_list_tabpages() > 1 then
        tabline_height = 1
    end
    vim.cmd("normal p")
    -- require explorer to span the whole height of the ui
    if explorer_height ~= (ui.height - tabline_height - status_height - cmd_height) then
        return
    end
    local width = ui.width - explorer_width - 2 * scrolloff
    local height = explorer_height - 2 * scrolloff
    -- left explorer
    if explorer_pos[2] == 0 then
        netrw.float_preview({
            corner = {
                scrolloff,                  -- row
                explorer_width + scrolloff, -- col
            },
            width = width,
            height = height,
        })
        return
    end
    -- right explorer
    if explorer_pos[2] == ui.width - explorer_width then
        netrw.float_preview({
            corner = { scrolloff, scrolloff },
            width = width,
            height = height,
        })
        return
    end
end, opts)

-- Update preview if open
local function update_preview(move)
    local count = vim.api.nvim_get_vvar("count1")
    vim.api.nvim_command("normal! " .. count .. move) -- use "!" to avoid recursion and execute original version of j
    local pwin = utils.get_preview_window()
    if pwin and not netrw._is_cur_line_dir() then
        local pbuf = vim.api.nvim_win_get_buf(pwin)
        vim.cmd("normal P") -- no "!" because we need to execute what p is mapped to
        for _, win in ipairs(vim.api.nvim_list_wins()) do
            if vim.api.nvim_win_get_option(win, "previewwindow") == true then
                goto continue
            end
            if pbuf == vim.api.nvim_win_get_buf(win) then
                return
            end
            ::continue::
        end
        vim.api.nvim_buf_delete(pbuf, { force = true })
    end
end

map("n", "J", netrw.go_down_and_open_preview, opts)
map("n", "K", netrw.go_up_and_open_preview, opts)

-- Scroll preview
map("n", "<C-u>", function() utils.safe_call_in_preview_window("<C-u>") end, opts)
map("n", "<C-d>", function() utils.safe_call_in_preview_window("<C-d>") end, opts)
map("n", "<C-b>", function() utils.safe_call_in_preview_window("<C-b>") end, opts)
map("n", "<C-f>", function() utils.safe_call_in_preview_window("<C-f>") end, opts)

-- Copy path in clipboard
map("n", "y", netrw.yank_path_under_cursor, opts)
map("n", "Y", netrw.yank_relative_path_under_cursor, opts)
map("n", "<C-Y>", netrw.yank_full_path_under_cursor, opts)

-- Create file
map("n", "f", netrw.create_file, opts)

-- Quick one-character search
-- local one_char = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXUZ123456789._-$~[]"
-- for c in one_char:gmatch(".") do
--     map("n", "f" .. c, function()
--         vim.fn.search("\\C^" .. vim.fn.escape(c, ".$~[]"), "cw")
--     end, opts)
--     map("n", "F" .. c, function()
--         vim.fn.search("\\C^" .. vim.fn.escape(c, ".$~[]"), "cw")
--     end, opts)
-- end

-- Mark files with Tab
map("n", "<Tab>", netrw.mark_and_go_down, opts)
map("n", "<S-Tab>", netrw.mark_and_go_up, opts)

-- options
set.colorcolumn = ""
set.signcolumn = "yes"
set.showmatch = true
set.synmaxcol = 100
set.cursorline = true
set.wrap = false
set.list = false
set.scrolloff = 0
set.bufhidden = "wipe" -- remove annoying NoName hidden buffers

-- highlighting groups
set.winhighlight = "Normal:FileBrowser"
