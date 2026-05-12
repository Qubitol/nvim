local M = {}

local map = require("config.utils").map

local STATE = "PinFiles" -- vim.g.<STATE>
local SEP = "\x1f" -- (ASCII Unit Separator, impossible in a filename)

local function get()
    local raw = vim.g[STATE]
    if not raw or raw == "" then
        return {}
    end
    return vim.split(raw, SEP, { plain = true })
end

local function put(files)
    vim.g[STATE] = table.concat(files, SEP)
end

-- Display path: abs -> relative to base (cwd), or ~-prefixed, or absolute
local function shorten(abs, base)
    abs = vim.fs.normalize(abs)
    base = vim.fs.normalize(base)
    if vim.startswith(abs, base .. "/") then
        return abs:sub(#base + 2)
    end
    local home = vim.fs.normalize(vim.env.HOME or "")
    if home ~= "" and vim.startswith(abs, home .. "/") then
        return "~/" .. abs:sub(#home + 2)
    end
    return abs
end

-- Storage path: line (possibly relative) -> normalized absolute, anchored to base
local function resolve(line, base)
    line = vim.fn.expand(line) -- handles ~
    if not vim.startswith(line, "/") then
        line = base .. "/" .. line
    end
    return vim.fs.normalize(line)
end

function M.add(path)
    path = path or vim.api.nvim_buf_get_name(0)
    if path == "" then
        return
    end
    path = vim.fs.normalize(vim.fn.fnamemodify(path, ":p"))
    local files = get()
    for _, f in ipairs(files) do
        if f == path then
            return
        end
    end
    files[#files + 1] = path
    put(files)
end

function M.remove(path)
    path = vim.fs.normalize(vim.fn.fnamemodify(path or vim.api.nvim_buf_get_name(0), ":p"))
    local out = {}
    for _, f in ipairs(get()) do
        if f ~= path then
            out[#out + 1] = f
        end
    end
    put(out)
end

function M.clear()
    put({})
end

function M.list()
    return get()
end

function M.open()
    local cwd = vim.fn.getcwd() -- captured before float steals focus
    local files = get()

    local lines = {}
    for i, abs in ipairs(files) do
        lines[i] = shorten(abs, cwd)
    end

    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.bo[buf].buftype = "nofile"
    vim.bo[buf].filetype = "pin"

    local width = math.max(40, math.floor(vim.o.columns * 0.4))
    local height = math.min(math.max(#lines, 1), math.floor(vim.o.lines * 0.5))

    local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = math.floor((vim.o.lines - height) / 2),
        col = math.floor((vim.o.columns - width) / 2),
        style = "minimal",
        border = "single",
        title = { { " pin ", "PinTitle" } },
        title_pos = "center",
    })

    local closed = false

    local function sync()
        if closed then
            return
        end
        closed = true
        local raw = vim.tbl_filter(function(l)
            return l ~= ""
        end, vim.api.nvim_buf_get_lines(buf, 0, -1, false))
        local new = {}
        for _, line in ipairs(raw) do
            new[#new + 1] = resolve(line, cwd)
        end
        put(new)
        if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_close(win, true)
        end
        if vim.api.nvim_buf_is_valid(buf) then
            vim.api.nvim_buf_delete(buf, { force = true })
        end
    end

    local function select()
        local line = vim.api.nvim_get_current_line()
        sync()
        if line ~= "" then
            vim.cmd("edit " .. vim.fn.fnameescape(resolve(line, cwd)))
        end
    end

    map("n", "<CR>", select, "Open selected file", { buffer = buf })
    map("n", "q", sync, "Close pin window", { buffer = buf })
    map("n", "<Esc>", sync, "Close pin window", { buffer = buf })
    for _, key in ipairs({ "i", "I", "a", "A", "o", "O", "c", "C", "s", "S", "R" }) do
        vim.keymap.set("n", key, "<Nop>", { buffer = buf })
    end

    vim.api.nvim_create_autocmd("BufLeave", {
        buffer = buf,
        once = true,
        callback = sync,
    })
end

M.open_n = function(n)
    local files = get()
    local count = #files
    if count == 0 then
        vim.notify("Pin list is empty", vim.log.levels.WARN)
        return
    end
    if n < 1 or n > count then
        vim.notify("Pin index out of range: " .. n .. " (max " .. count .. ")", vim.log.levels.WARN)
        return
    end
    vim.cmd("edit " .. vim.fn.fnameescape(files[n]))
end

map("n", "<leader>po", function()
    M.open()
end, "[P]inned files [O]pen picker")
map("n", "<leader>pa", function()
    M.add()
end, "[P]inned files [A]dd the current file")
map("n", "<C-h>", function()
    M.open_n(1)
end, "Edit 1st element of arglist")
map("n", "<C-j>", function()
    M.open_n(2)
end, "Edit 2nd element of arglist")
map("n", "<C-k>", function()
    M.open_n(3)
end, "Edit 3rd element of arglist")
map("n", "<C-l>", function()
    M.open_n(4)
end, "Edit 4th element of arglist")

return M
