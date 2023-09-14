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
setup.netrw_browse_split = 0

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

M.margin_top_bottom = 0.05 -- fraction
M.margin_left_right = 0.1 -- fraction
M.min_width = 40 -- columns
M.min_height = 15 -- rows

M.backward = function()
    -- close preview window if open
    local win = utils.get_preview_window()
    if win then
        vim.api.nvim_win_close(win, true)
    end
    vim.cmd("normal -")
    M._force_filetype_netrw()
end

M._neatrw_tree = {}

M._clean_current_line = function()
    local line = vim.api.nvim_get_current_line()
    if line:find("@%s+-->") then
        local tail = string.gsub(line, "(.*)@%s+-->.*$", "%1")
        return tail
    elseif line:find("*$") then
        return string.gsub(line, "(.*)%*$", "%1")
    end
    -- normal file and directories included here
    return line
end

M.create_file = function()
    local file_name = vim.fn.input("Enter filename: ")
    vim.cmd("silent exec \"!touch " .. file_name .. "\"")
end

-- Draw icons
M._draw_icons = function()-- {{{
    local is_devicons_available, devicons = pcall(require, "nvim-web-devicons")
    if not is_devicons_available then
        return
    end
    local default_signs = {
        explorer_dir = {
            text = "",
            texthl = "netrwDir",
        },
        explorer_file = {
            text = "",
            texthl = "netrwPlain",
        },
        explorer_exec = {
            text = "",
            texthl = "netrwExe",
        },
        explorer_link = {
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
        local sign_name = "explorer_file"

        -- Get line contents
        local line = vim.fn.getline(cur_line_nr)

        if line == "" or line == nil then
            -- If current line is an empty line (newline) then increase current line count
            -- without doing nothing more
            cur_line_nr = cur_line_nr + 1
        else
            if line:find("/$") then
                sign_name = "explorer_dir"
            elseif line:find("@%s+-->") then
                sign_name = "explorer_link"
            elseif line:find("*$") then
                sign_name:find("explorer_exec")
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
                sign_name = "explorer_" .. filetype
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
end-- }}}

M._fill_current_register = function(content)
    local register = vim.api.nvim_get_vvar("register")
    vim.cmd("let @" .. register .. " = '" .. content .. "'")
end

M._find_value = function(array, value)
    for i = 1, #array do
        if array[i] == value then
            return i
        end
    end
end

M._force_filetype_netrw = function()
    -- used to force the filetype to be 'netrw' because sometimes it gets
    -- it wrong and it is very annoying
    if vim.api.nvim_buf_get_option(0, "filetype") == "netrw" then return end
    vim.api.nvim_buf_set_option(0, "filetype", "netrw")
end

M.forward = function()
    local explorer_win = vim.api.nvim_get_current_win()
    local path = M.full_path_under_cursor()
    -- close preview window if open
    local win = utils.get_preview_window()
    if win then vim.api.nvim_win_close(win, true) end
    if path:find("/$") then
        M._run_keys("normal <CR>")
        M._force_filetype_netrw()
        return
    end
    local neatrw_leaf = M._get_current_neatrw_branch()[explorer_win]
    if not neatrw_leaf then
        vim.cmd("edit " .. path)
        return
    end
    local target_win = neatrw_leaf.open_target
    -- check if the target window (the previous window from where netrw has been called)
    -- is still open and check if the value of target_win is not nil, this could happen
    -- if netrw has been opened as first window, for example when running "nvim ." from
    -- command line. In this cases simply open the file in the same netrw window.
    -- However, we need to fire anyway the WinClosed event so it will update the info table.
    if not M._find_value(vim.api.nvim_tabpage_list_wins(0), target_win) then
        vim.api.nvim_exec_autocmds("WinClosed", {
            buffer = vim.fn.bufnr(),
            data = { match = explorer_win },
        })
        vim.cmd("edit " .. path)
        return
    end
    vim.api.nvim_set_current_win(target_win)
    if #vim.api.nvim_tabpage_list_wins(0) ~= 1 then
        vim.api.nvim_win_close(explorer_win, true)
    end
    vim.cmd("edit " .. path)
end

M.float_preview = function(opts)-- {{{
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
end-- }}}

M.full_path_under_cursor = function()
    -- do not use vim.fn.expand("%:p") because when opening a vim instance
    -- on netrw, apparently it expands to empty
    local head = vim.fn.getcwd(0,0) .. "/"
    return head .. M._clean_current_line()
end

M._get_current_neatrw_branch = function()
    local branch = M._neatrw_tree[vim.api.nvim_get_current_tabpage()]
    if not branch then
        return {}
    end
    return branch
end

M.get_explorer_window = function()
    return next(M._get_current_neatrw_branch())
end

M.go_down_and_open_preview = function()
end

M.go_up_and_open_preview = function()
end

M.go_to_explorer_window = function()
    local win = M.get_explorer_window()
    if win then
        return vim.api.nvim_set_current_win(win)
    end
    M.toggle_explorer_current("L")
end

M._is_cur_line_dir = function()
    return vim.api.nvim_get_current_line():find("/$")
end

M.mark_and_go_down = function()
    vim.cmd("normal mfj")
end

M.mark_and_go_up = function()
    vim.cmd("normal mfk")
end

M._place_cursor = function()
    if vim.api.nvim_win_get_cursor(0)[1] < 3 then vim.cmd[[normal 3G]] end
end

M._run_keys = function(keys)
    local replaced_keys = vim.api.nvim_replace_termcodes(keys, true, true, true)
    vim.cmd(replaced_keys)
end

M.toggle_explorer = function(split, dir, open_in_opposite_direction)
    -- Check if open: if so close (return false), otherwise open (return true)
    local win_handle = M.get_explorer_window()
    if win_handle then
        if #vim.api.nvim_tabpage_list_wins(0) > 1 then
            vim.api.nvim_win_close(win_handle, true)
        end
        return
    end
    -- now we open netrw according to the split
    local modifier = ""
    if open_in_opposite_direction then modifier = "!" end
    local cmd = vim.api.nvim_parse_cmd(split .. "explore" .. modifier .. " " .. dir, {})
    vim.api.nvim_cmd(cmd, {})
    -- force filetype to be 'netrw'
    M._force_filetype_netrw()
    return true
end

M.toggle_explorer_current = function(split, open_in_opposite_direction)
    local head = vim.fn.expand("%:p:h")
    local tail = vim.fn.expand("%:p:t")
    local opened = M.toggle_explorer(split, head, open_in_opposite_direction)
    if not opened then
        return
    end
    vim.fn.search("\\C^" .. vim.fn.escape(tail, ".^$~[]") .. "\\(@\\s\\+-->\\|\\*\\?$\\)\\?", "cW")
end

M.yank_path_under_cursor = function()
    local line = M._clean_current_line()
    M._fill_current_register(line)
end

M.yank_relative_path_under_cursor = function()
    local explorer_win = vim.api.nvim_get_current_win()
    local neatrw_leaf = M._get_current_neatrw_branch()[explorer_win]
    local line = M._clean_current_line()
    local path = vim.fn.getcwd(0,0) .. "/" .. line
    local cwd = neatrw_leaf.cwd .. "/"
    -- I need to use the following workaround because realpath --zero does not work
    local relative_path = vim.fn.system("realpath --relative-to=\"" .. cwd .. "\" \"" .. path .. "\" | xargs echo -n ")
    M._fill_current_register(relative_path)
end

M.yank_full_path_under_cursor = function()
    local line = M._clean_current_line()
    local head = vim.fn.getcwd(0,0) .. "/"
    M._fill_current_register(head .. line)
end

return M
