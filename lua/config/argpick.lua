local M = {}

local map = require("config.utils").map

function M.open()
    local args = {}
    for i = 1, vim.fn.argc() do
        args[i] = vim.fn.argv(i - 1)
    end

    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, args)
    vim.bo[buf].buftype = "nofile"
    vim.bo[buf].filetype = "argpick"

    local width = math.max(40, math.floor(vim.o.columns * 0.4))
    local height = math.min(math.max(#args, 1), math.floor(vim.o.lines * 0.5))

    local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = math.floor((vim.o.lines - height) / 2),
        col = math.floor((vim.o.columns - width) / 2),
        style = "minimal",
        border = "solid",
        title = " argpick ",
        title_pos = "center",
    })

    local closed = false

    local function sync()
        if closed then
            return
        end
        closed = true
        local lines = vim.tbl_filter(function(l)
            return l ~= ""
        end, vim.api.nvim_buf_get_lines(buf, 0, -1, false))
        pcall(vim.cmd, "%argdelete")
        for _, f in ipairs(lines) do
            vim.cmd("argadd " .. vim.fn.fnameescape(f))
        end
        if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_close(win, true)
        end
        if vim.api.nvim_buf_is_valid(buf) then
            vim.api.nvim_buf_delete(buf, { force = true })
        end
    end

    local function select()
        local file = vim.api.nvim_get_current_line()
        sync()
        if file ~= "" then
            vim.cmd("edit " .. vim.fn.fnameescape(file))
        end
    end

    map("n", "<CR>", select, "Select arg to open", { buffer = buf })
    map("n", "q", sync, "Close argpick window", { buffer = buf })
    map("n", "<Esc>", sync, "Close argpick window", { buffer = buf })
    for _, key in ipairs({ "i", "I", "a", "A", "o", "O", "c", "C", "s", "S", "R" }) do
        vim.keymap.set("n", key, "<Nop>", { buffer = buf })
    end

    vim.api.nvim_create_autocmd("BufLeave", {
        buffer = buf,
        once = true,
        callback = sync,
    })
end

return M
