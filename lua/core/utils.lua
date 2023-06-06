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

M.load_mappings = function(section)
    local mappings = require("core.mappings")[section]
    local default_opts = { noremap = true, silent = true }
    for mode, mode_mappings in pairs(mappings) do
        for keybind, mapping_info in pairs(mode_mappings) do
            local command = mapping_info[1]
            local opts = vim.tbl_deep_extend("force",
                default_opts,
                mapping_info[3] or {},
                { desc = mapping_info[2] }
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
