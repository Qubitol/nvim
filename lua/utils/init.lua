local M = {}

M.call_cmd_in_preview_window = function(cmd)
    local win = M.get_preview_window()
    if not win then
        return false
    end
    local replaced_keys = vim.api.nvim_replace_termcodes("normal " .. cmd, true, true, true)
    vim.api.nvim_win_call(win, function()
        vim.cmd(replaced_keys)
    end)
    return true
end

M.safe_call_in_preview_window = function(cmd)
    if M.call_cmd_in_preview_window(cmd) then
        return
    end
    local replaced_keys = vim.api.nvim_replace_termcodes("normal! " .. cmd, true, true, true)
    vim.cmd(replaced_keys)
end

M.concat_file_lines = function(file_path)
    local f = io.open(file_path)
    if not f then
        return {}
    end
    local lines = {}
    for line in f:lines() do
        table.insert(lines, line)
    end
    return lines
end

M.file_exists = function(name)
    local f = io.open(name, "r")
    if f ~= nil then
        io.close(f)
        return true
    else
        return false
    end
end

-- adapted from https://github.com/ethanholz/nvim-lastplace/blob/main/lua/nvim-lastplace/init.lua
M.goto_lastplace = function()
    local ignore_buftype = { "quickfix", "nofile", "help", "terminal" }
    local ignore_filetype = { "gitcommit", "gitrebase", "svn", "hgcommit" }

    if vim.tbl_contains(ignore_buftype, vim.bo.buftype) then
        return
    end

    if vim.tbl_contains(ignore_filetype, vim.bo.filetype) then
        -- reset cursor to first line
        vim.cmd([[normal! gg]])
        return
    end

    -- If a line has already been specified on the command line, we are done
    --   nvim file +num
    if vim.fn.line(".") > 1 then
        return
    end

    local last_line = vim.fn.line([['"]])
    local buff_last_line = vim.fn.line("$")

    -- If the last line is set and the less than the last line in the buffer
    if last_line > 0 and last_line <= buff_last_line then
        local win_last_line = vim.fn.line("w$")
        local win_first_line = vim.fn.line("w0")
        -- Check if the last line of the buffer is the same as the win
        if win_last_line == buff_last_line then
            -- Set line to last line edited
            vim.cmd([[normal! g`"]])
            -- Try to center
        elseif buff_last_line - last_line > ((win_last_line - win_first_line) / 2) - 1 then
            vim.cmd([[normal! g`"zz]])
        else
            vim.cmd([[normal! G'"<c-e>]])
        end
    end
end

M.get_preview_window = function()
    local cur_tabpage_wins = vim.api.nvim_tabpage_list_wins(0)
    for _, win_handle in ipairs(cur_tabpage_wins) do
        if vim.api.nvim_win_get_option(win_handle, "previewwindow") then
            return win_handle
        end
    end
    return false
end

M.quickfix_or_loclist = function()
    local win_id = vim.api.nvim_get_current_win()
    local win_info = vim.fn.getwininfo(win_id)[1]
    if win_info["quickfix"] == 1 then
        return "c"
    end
    if win_info["loclist"] == 1 then
        return "l"
    end
    return false
end

M.map = function(mode, lhs, rhs, desc, opts)
    opts = opts or {}
    vim.keymap.set(
        mode,
        lhs,
        rhs,
        vim.tbl_deep_extend("force", { silent = true, noremap = true }, opts, { desc = desc })
    )
end

M.lazy_map = function(mode, lhs, rhs, desc, opts)
    opts = opts or {}
    return { lhs, rhs, mode, vim.tbl_deep_extend("force", { silent = true, noremap = true }, opts, { desc = desc }) }
end

M.table_length = function(a_table)
    local count = 0
    for _ in pairs(a_table) do
        count = count + 1
    end
    return count
end

M.toggle_qflist = function()
    for _, win in pairs(vim.fn.getwininfo()) do
        if win["quickfix"] == 1 then
            vim.cmd("cclose")
            return
        end
    end
    if not vim.tbl_isempty(vim.fn.getqflist()) then
        vim.cmd("copen")
    end
end

M.toggle_loclist = function()
    for _, win in pairs(vim.fn.getwininfo()) do
        if win["loclist"] == 1 then
            vim.cmd("lclose")
            return
        end
    end
    if not vim.tbl_isempty(vim.fn.getloclist(0)) then
        vim.cmd("lopen")
    end
end

return M
