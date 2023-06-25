local M = {}

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
    local ignore_buftype = { "quickfix", "nofile", "help" }
    local ignore_filetype = { "gitcommit", "gitrebase", "svn", "hgcommit" }

    if vim.tbl_contains(ignore_buftype, vim.bo.buftype) then
        return
    end

    if vim.tbl_contains(ignore_filetype, vim.bo.filetype) then
        -- reset cursor to first line
        vim.cmd [[normal! gg]]
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
            vim.cmd [[normal! g`"]]
            -- Try to center
        elseif buff_last_line - last_line > ((win_last_line - win_first_line) / 2) - 1 then
            vim.cmd [[normal! g`"zz]]
        else
            vim.cmd [[normal! G'"<c-e>]]
        end
    end
end

M.is_preview_window_open = function()
    local cur_tabpage_wins = vim.api.nvim_tabpage_list_wins(0)
    for _, win_handle in ipairs(cur_tabpage_wins) do
        local previewwindow = vim.api.nvim_win_get_option(win_handle, "previewwindow")
        if previewwindow then
            return true
        end
    end
    return false
end

M.load_mappings = function(mappings, additional_opts)
    local default_opts = { noremap = true, silent = true }
    for mode, mode_mappings in pairs(mappings) do
        for keybind, mapping_info in pairs(mode_mappings) do
            local command = mapping_info[1]
            local opts = vim.tbl_deep_extend("force",
                default_opts,
                mapping_info[3] or {},
                { desc = mapping_info[2] },
                additional_opts or {}
            )
            vim.keymap.set(mode, keybind, command, opts)
        end
    end
end

M.original_cwd = vim.fn.getcwd()

M.toggle_qf = function()
    local qf_exists = false
    for _, win in pairs(vim.fn.getwininfo()) do
        if win["quickfix"] == 1 then
            qf_exists = true
        end
    end
    if qf_exists == true then
        vim.cmd "cclose"
        return
    end
    if not vim.tbl_isempty(vim.fn.getqflist()) then
        vim.cmd "copen"
    end
end

return M
