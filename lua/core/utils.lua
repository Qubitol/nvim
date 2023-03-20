local M = {}

M.original_cwd = vim.fn.getcwd()

M.file_exists = function(name)
	local f = io.open(name, "r")
	if f ~= nil then
		io.close(f)
		return true
	else
		return false
	end
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

return M
