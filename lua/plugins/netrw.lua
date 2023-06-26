local utils = require("core.utils")
local mappings = require("core.mappings")
local setup = vim.g

local M = {}

-- Netrw winsize
-- @default = 20
setup.netrw_winsize = 20

-- Netrw banner
-- 0 : Disable banner
-- 1 : Enable banner
setup.netrw_banner = 0

-- Keep the current directory and the browsing directory synced.
-- This helps you avoid the move files error.
setup.netrw_keepdir = 0

-- Show directories first (sorting)
setup.netrw_sort_sequence = [[[\/]$,*]]

-- Human-readable files sizes
setup.netrw_sizestyle = "H"

-- Netrw list style
-- 0 : thin listing (one file per line)
-- 1 : long listing (one file per line with timestamp information and file size)
-- 2 : wide listing (multiple files in columns)
-- 3 : tree style listing
setup.netrw_liststyle = 0

-- Patterns for hiding files, e.g. node_modules
-- NOTE: this works by reading '.gitignore' file
setup.netrw_list_hide = vim.fn["netrw_gitignore#Hide"]()

-- Show hidden files
-- 0 : show all files
-- 1 : show not-hidden files
-- 2 : show hidden files only
setup.netrw_hide = 0

-- Preview files in a vertical split window
-- setup.netrw_preview = 1

-- Open files in split
-- 0 : re-use the same window (default)
-- 1 : horizontally splitting the window first
-- 2 : vertically   splitting the window first
-- 3 : open file in new tab
-- 4 : act like "P" (ie. open previous window)
setup.netrw_browse_split = 4

-- Setup file operations commands
-- TODO: figure out how to add these feature in Windows
-- Enable recursive copy of directories in *nix systems
setup.netrw_localcopydircmd = "cp -r"

-- Enable recursive creation of directories in *nix systems
setup.netrw_localmkdir = "mkdir -p"

-- Enable recursive removal of directories in *nix systems
-- NOTE: we use 'rm' instead of 'rmdir' (default) to be able to remove non-empty directories
setup.netrw_localrmdir = "rm -r"

-- Highlight marked files in the same way search matches are
vim.cmd("hi! link netrwMarkFile Search")

-- Load generic mappings
utils.load_mappings(mappings.plugins.netrw)

-- Draw icons
M.draw_icons = function()
    local is_devicons_available, devicons = pcall(require, "nvim-web-devicons")
    if not is_devicons_available then
        return
    end
    local default_signs = {
        netrw_dir = {
            text = "",
            texthl = "netrwDir",
        },
        netrw_file = {
            text = "",
            texthl = "netrwPlain",
        },
        netrw_exec = {
            text = "",
            texthl = "netrwExe",
        },
        netrw_link = {
            text = "",
            texthl = "netrwSymlink",
        },
    }

    local bufnr = vim.api.nvim_win_get_buf(0)

    -- Unplace all signs
    vim.fn.sign_unplace("*", { buffer = bufnr })

    -- Define default signs
    for sign_name, sign_opts in pairs(default_signs) do
        vim.fn.sign_define(sign_name, sign_opts)
    end

    local cur_line_nr = 1
    local total_lines = vim.fn.line("$")
    while cur_line_nr <= total_lines do
        -- Set default sign
        local sign_name = "netrw_file"

        -- Get line contents
        local line = vim.fn.getline(cur_line_nr)

        if line == "" or line == nil then
            -- If current line is an empty line (newline) then increase current line count
            -- without doing nothing more
            cur_line_nr = cur_line_nr + 1
        else
            if line:find("/$") then
                sign_name = "netrw_dir"
            elseif line:find("@%s+-->") then
                sign_name = "netrw_link"
            elseif line:find("*$") then
                sign_name:find("netrw_exec")
            else
                local filetype = line:match("^.*%.(.*)")
                if not filetype and line:find("LICENSE") then
                    filetype = "md"
                elseif line:find("rc$") then
                    filetype = "conf"
                end

                -- If filetype is still nil after manually setting extensions
                -- for unknown filetypes then let's use 'default'
                if not filetype then
                    filetype = "default"
                end

                local icon, icon_highlight = devicons.get_icon(line, filetype, { default = "" })
                sign_name = "netrw_" .. filetype
                vim.fn.sign_define(sign_name, {
                    text = icon,
                    texthl = icon_highlight,
                })
            end
            vim.fn.sign_place(cur_line_nr, sign_name, sign_name, bufnr, {
                lnum = cur_line_nr,
            })
            cur_line_nr = cur_line_nr + 1
        end
    end
end

M.force_filetype_netrw = function()
    -- used to force the filetype to be 'netrw' because sometimes it gets
    -- it wrong and it is very annoying
    -- local netrw_buf = vim.api.nvim_win_get_buf(0)
    local filetype = vim.api.nvim_win_call(0, function() return vim.bo.filetype end)
    if filetype == "netrw" then
        return
    end
    vim.api.nvim_buf_set_option(0, "filetype", "netrw")
end

M.float_preview = function(opts)
    local min_width = 40
    local min_height = 15
    if opts.width < min_width or opts.height < min_height then
        return
    end
    local win = utils.get_preview_window()
    if not win then
        return
    end
    vim.api.nvim_win_set_option(win, "previewwindow", false)
    local preview_window = vim.api.nvim_open_win(
        -- rows are from 0 to n counting from 
        vim.api.nvim_win_get_buf(win), false, {
            relative = "editor",
            width = opts.width,
            height = opts.height,
            row = opts.corner[1],
            col = opts.corner[2],
            anchor = "NW",
            style = "minimal",
            border = "rounded",
        }
    )
    vim.api.nvim_win_close(win, true)
    vim.api.nvim_win_set_option(preview_window, "previewwindow", true)
end

M.get_netrw_window = function()
    local cur_tabpage_wins = vim.api.nvim_tabpage_list_wins(0)
    for _, win_handle in ipairs(cur_tabpage_wins) do
        if vim.api.nvim_win_call(win_handle, function() return vim.bo.filetype end) == "netrw" then
            return win_handle
        end
    end
    return false
end

M.go_to_netrw_window = function()
    local win = M.get_netrw_window()
    if win then
        return vim.api.nvim_set_current_win(win)
    end
    M.toggle_netrw_current("L")
end

M.place_cursor = function()
    local cur_line = vim.api.nvim_win_get_cursor(0)[1]
    if cur_line < 3 then
        vim.cmd[[normal 3G]]
    end
end

M.toggle_netrw = function(split, dir)
    -- Check if open: if so close (return false), otherwise open (return true)
    local win_handle = M.get_netrw_window()
    if win_handle then
        if #vim.api.nvim_tabpage_list_wins(0) ~= 1 then
            vim.api.nvim_win_close(win_handle, true)
        end
        return false
    end
    -- now we open netrw according to the split
    local cmd = vim.api.nvim_parse_cmd(split .. "explore " .. dir, {})
    vim.api.nvim_cmd(cmd, {})
    -- force filetype to be 'netrw'
    M.force_filetype_netrw()
    return true
end

M.toggle_netrw_current = function(split)
    local head = vim.fn.expand("%:p:h")
    local tail = vim.fn.expand("%:p:t")
    vim.cmd("echo '" .. head .. "'")
    local opened = M.toggle_netrw(split, head)
    if not opened then
        return
    end
    vim.fn.search("\\C^" .. vim.fn.escape(tail, ".^$~[]") .. "\\(@\\s\\+-->\\|\\*\\?$\\)\\?", "cW")
end

return M
