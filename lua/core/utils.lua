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

return M
