local create_command = vim.api.nvim_create_user_command

create_command("DumpKeymaps", function()
    local keymaps = require("config.utils")._keymaps
    table.sort(keymaps, function(a, b)
        if a.source ~= b.source then
            return a.source < b.source
        end
        if a.mode ~= b.mode then
            return a.mode < b.mode
        end
        return a.lhs < b.lhs
    end)

    local lines = { "| Mode | Keymap | Description | Source |", "|------|--------|-------------|--------|" }
    for _, km in ipairs(keymaps) do
        local source = km.source:gsub(".*/lua/", ""):gsub("%.lua$", "")
        local lhs = km.lhs:gsub("|", "\\|")
        table.insert(lines, string.format("| `%s` | `%s` | %s | %s |", km.mode, lhs, km.desc, source))
    end

    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.bo[buf].filetype = "markdown"
    vim.cmd("split")
    vim.api.nvim_win_set_buf(0, buf)
end, { desc = "Dump all keymaps registered via map() as a Markdown table" })
