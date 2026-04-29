-- Netrw

local map = require("config.utils").map
local ui = require("config.ui")

local NETRW_WINSIZE = 30

-- Global netrw settings ------------------------------------------------------
vim.g.netrw_banner = 0
vim.g.netrw_browse_split = 4 -- open files in the previous (non-netrw) window
vim.g.netrw_winsize = -1 * NETRW_WINSIZE -- Lexplore width: negative = absolute cols
vim.g.netrw_liststyle = 0 -- thin: one entry per line (parser depends on it)
vim.g.netrw_altv = 1 -- vertical splits open right
vim.g.netrw_keepdir = 0 -- keep :cwd in sync with browsing dir
vim.g.netrw_localcopydircmd = "cp -r"

-- Helpers --------------------------------------------------------------------
local function netrw_dir()
    return vim.b.netrw_curdir or vim.fn.expand("%:p:h")
end

-- Sign-based icons -----------------------------------------------------------
local SIGN_GROUP = "netrw_icons"
local defined = {}

local function ensure_sign(name, icon, hl)
    if defined[name] then
        return
    end
    vim.fn.sign_define(name, { text = icon, texthl = hl })
    defined[name] = true
end

local function place_icons(buf)
    if not vim.g.pretty then
        return
    end
    local ok, devicons = pcall(require, "nvim-web-devicons")
    if not ok then
        return
    end

    vim.fn.sign_unplace(SIGN_GROUP, { buffer = buf })

    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    for lnum, line in ipairs(lines) do
        -- liststyle=0: "name", "name/", "name*", "name@", "name="
        local s = line:gsub("^%s+", "")
        if s ~= "" and s ~= "../" and s ~= "./" then
            local is_dir = s:sub(-1) == "/"
            local name = s:gsub("[/*=|@]+$", "")
            local icon, hl
            if is_dir then
                icon = (ui.icons.folder and ui.icons.folder.closed) or ""
                hl = "Directory"
            else
                icon, hl = devicons.get_icon(name, vim.fn.fnamemodify(name, ":e"), { default = true })
            end
            if icon and hl then
                local sign_name = "netrw_" .. hl
                ensure_sign(sign_name, icon, hl)
                vim.fn.sign_place(0, SIGN_GROUP, sign_name, buf, { lnum = lnum })
            end
        end
    end
end

-- Per-buffer setup -----------------------------------------------------------
local function setup_buffer()
    local buf = vim.api.nvim_get_current_buf()

    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.colorcolumn = ""
    vim.opt_local.signcolumn = vim.g.pretty and "yes" or "no"
    vim.opt_local.winhighlight = "Normal:FileBrowser,netrwMarkFile:Search"

    -- Replaces the banner: shows the marked target directory at the top
    vim.opt_local.winbar = "%{'Target: ' . netrw#Expose('netrwmftgt')}"

    place_icons(buf)

    -- Buffer-local maps; remap=true because -, <CR>, R, u are netrw mappings
    local rmp = { buffer = buf, remap = true }
    map("n", "h", "-^", "Up one directory", rmp)
    map("n", "l", "<CR>", "Open file / descend", rmp)
    map("n", "L", "<CR>:Lexplore<CR>", "Open file and close netrw", rmp)
    map("n", ".", "gh", "Toggle dotfiles visibility", rmp)
    map("n", "r", "R", "Rename", rmp)
    map("n", "<Tab>", "mf", "Toggle mark on file/directory", rmp)
    map("n", "<S-Tab>", "mF", "Unmark all files/directories in current buffer", rmp)
    map("n", "<Leader><Tab>", "mu", "Remove all the mark on all files/directories", rmp)
    map(
        "n",
        "fl",
        [[<cmd>echo join(netrw#Expose("netrwmarkfilelist"), "\n")<CR>]],
        "List all markrd files/directories",
        rmp
    )

    -- Jump to the marked target
    map("n", "<C-t>", function()
        local t = vim.g.netrwmftgt
        if t and t ~= "" then
            vim.cmd.edit(vim.fn.fnameescape(t))
        else
            vim.notify("No netrw target set (use 'mt' to mark one)", vim.log.levels.WARN)
        end
    end, "Switch to target dir", { buffer = buf })

    -- Open a terminal buffer rooted at the current netrw dir
    map("n", "T", function()
        local dir = netrw_dir()
        local cur = vim.api.nvim_get_current_win()
        vim.cmd("wincmd p")
        if vim.api.nvim_get_current_win() == cur then
            -- No previous window (e.g. netrw is the only window) — make one
            vim.cmd("rightbelow vsplit")
        end
        vim.cmd("enew")
        vim.cmd.lcd(vim.fn.fnameescape(dir))
        vim.cmd.terminal()
        vim.cmd("Lexplore")
    end, "Terminal in current dir", { buffer = buf })

    -- Fuzzy find inside current netrw dir (files + dirs + symlinks, recursive, hidden)
    map("n", "fo", function()
        local ok, fzf = pcall(require, "fzf-lua")
        if not ok then
            vim.notify("fzf-lua not available", vim.log.levels.WARN)
            return
        end
        local dir = netrw_dir()
        fzf.files({
            cwd = dir,
            prompt = "netrw> ",
            -- fd_opts = "--color=never --type f --type d --type l --hidden --follow --no-ignore-vcs",
            actions = {
                ["default"] = function(selected)
                    if not selected or #selected == 0 then
                        return
                    end
                    local entry = fzf.path.entry_to_file(selected[1], { cwd = dir })
                    local path = entry.path
                    local stat = vim.uv.fs_stat(path)
                    local target = (stat and stat.type == "directory") and path or vim.fs.dirname(path)
                    vim.cmd.edit(vim.fn.fnameescape(target))
                end,
            },
        })
    end, "Fuzzy find in netrw dir", { buffer = buf })

    map("n", "a", function()
        local dir = netrw_dir()
        local name = vim.fn.input("New (trailing / = dir): ", "", "file")
        if name == "" then
            return
        end
        local path = dir .. "/" .. name
        local is_dir = name:sub(-1) == "/"
        if vim.uv.fs_stat(path:gsub("/$", "")) then
            vim.notify("Already exists", vim.log.levels.WARN)
            return
        end
        if is_dir then
            vim.fn.mkdir(path, "p")
            vim.cmd("edit " .. vim.fn.fnameescape(dir))
        else
            vim.fn.mkdir(vim.fs.dirname(path), "p")
            vim.cmd.edit(vim.fn.fnameescape(path))
            vim.cmd.write()
        end
    end, "Create file or dir (trailing /) in netrw dir", { buffer = buf })

    -- Skip the ../ (and ./) entries on entry: only move if cursor actually
    -- landed on one, so that "go-back-to-where-you-came-from" still works.
    vim.schedule(function()
        if not vim.api.nvim_buf_is_valid(buf) then
            return
        end
        if vim.api.nvim_get_current_buf() ~= buf then
            return
        end
        if vim.b[buf].netrw_skipped_dots then
            return
        end -- already done once
        local cur = vim.api.nvim_get_current_line():gsub("^%s+", "")
        if cur ~= "../" and cur ~= "./" then
            return
        end
        local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
        for i, l in ipairs(lines) do
            local s = l:gsub("^%s+", "")
            if s ~= "" and s ~= "../" and s ~= "./" then
                vim.api.nvim_win_set_cursor(0, { i, 0 })
                vim.b[buf].netrw_skipped_dots = true
                return
            end
        end
    end)
end

-- Autocmds -------------------------------------------------------------------
-- Netrw fires FileType=netrw on every (re)load (descend, mh, refresh, etc.)
-- so this single hook also keeps the icon signs in sync.
local group = vim.api.nvim_create_augroup("NetrwConfig", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = "netrw",
    callback = setup_buffer,
})

-- Global mappings ------------------------------------------------------------
local function lexplore(path)
    vim.cmd("Lexplore " .. vim.fn.fnameescape(path))
end

map("n", "<leader>e", function()
    local path
    if vim.bo.buftype == "terminal" then
        path = vim.fn.getcwd(0) -- window-local lcd of the terminal
    else
        path = vim.fn.expand("%:p:h")
        if path == "" then
            path = vim.fn.getcwd()
        end
    end
    lexplore(path)
end, "Netrw left: file or terminal dir")

map("n", "<leader>E", function()
    lexplore(vim.fn.getcwd())
end, "Netrw left: nvim cwd")

map("n", "<leader>ge", function()
    local root = vim.fs.root(0, ".git")
    if not root then
        vim.notify("Not in a git repository", vim.log.levels.WARN)
        return
    end
    lexplore(root)
end, "Netrw left: git root")
