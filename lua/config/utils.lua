local M = {}

M._keymaps = {}

M.map = function(mode, lhs, rhs, desc, opts)
    opts = opts or {}
    -- accumulate keymaps for later logging
    table.insert(M._keymaps, {
        mode = type(mode) == "table" and table.concat(mode, ",") or mode,
        lhs = lhs,
        desc = desc or "",
        source = debug.getinfo(2, "S").short_src,
    })
    vim.keymap.set(
        mode,
        lhs,
        rhs,
        vim.tbl_deep_extend("force", { silent = true, noremap = true }, opts, { desc = desc })
    )
end

M.bufdelete = function()
    local buf_to_delete = vim.api.nvim_get_current_buf()
    local bufs = vim.tbl_filter(function(b)
        return vim.api.nvim_buf_is_loaded(b) and b ~= buf_to_delete
    end, vim.api.nvim_list_bufs())

    if #bufs == 0 then
        -- Last buffer: create a blank one, then delete the old
        vim.cmd("enew")
        vim.cmd("bdelete! " .. buf_to_delete)
        return
    end

    -- Prefer the alternate buffer if it's still valid
    local alt = vim.fn.bufnr("#")
    local target
    if alt > 0 and alt ~= buf_to_delete and vim.api.nvim_buf_is_loaded(alt) then
        target = alt
    else
        target = bufs[1]
    end

    -- Switch all windows showing this buffer
    for _, win in ipairs(vim.fn.win_findbuf(buf_to_delete)) do
        vim.api.nvim_win_set_buf(win, target)
    end

    -- Set the alternate buffer to something sensible
    -- so <C-^> doesn't point to a dead buffer
    local new_alt = bufs[1] ~= target and bufs[1] or bufs[2]
    if new_alt then
        -- briefly visit it to register as alternate, then come back
        vim.cmd("buffer " .. new_alt)
        vim.cmd("buffer " .. target)
    end

    vim.cmd("bdelete " .. buf_to_delete)
end

M.open_n_arg_file = function(n)
    local argc = vim.fn.argc()
    if argc == 0 then
        vim.notify("Arglist is empty", vim.log.levels.WARN)
        return
    end
    if n < 0 or n >= argc then
        vim.notify("Arg index out of range: " .. n .. " (max " .. (argc - 1) .. ")", vim.log.levels.WARN)
        return
    end
    vim.cmd("edit " .. vim.fn.fnameescape(vim.fn.argv(n)))
end

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

M.toggle_qflist = function()
    for _, win in pairs(vim.fn.getwininfo()) do
        if win["quickfix"] == 1 then
            vim.cmd("cclose")
            return
        end
    end
    if #vim.fn.getqflist() > 0 then
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
    if #vim.fn.getloclist(0) > 0 then
        vim.cmd("lopen")
    end
end



return M
