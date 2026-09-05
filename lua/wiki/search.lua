local config = require("wiki.config")
local dates = require("wiki.dates")
local links = require("wiki.links")
local tags = require("wiki.tags")

local M = {}

local function loaded_lines_by_path()
    local result = {}
    for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buffer) then
            local name = vim.api.nvim_buf_get_name(buffer)
            if name ~= "" then
                local path = vim.uv.fs_realpath(name) or vim.fs.normalize(name)
                result[path] = vim.api.nvim_buf_get_lines(buffer, 0, -1, false)
            end
        end
    end
    return result
end

local function read_lines(path, loaded)
    local normalized = vim.uv.fs_realpath(path) or vim.fs.normalize(path)
    if loaded[normalized] then
        return loaded[normalized]
    end

    local ok, lines = pcall(vim.fn.readfile, path)
    return ok and lines or nil
end

local function source_without_tags(line, line_tags)
    local source = line
    for _, tag in ipairs(line_tags) do
        source = source:gsub(vim.pesc(":" .. tag .. ":"), "")
    end
    return vim.trim(source:gsub("%s+", " "))
end

local function candidate_before(left, right)
    if left.is_journal ~= right.is_journal then
        return left.is_journal
    end
    if left.is_journal then
        if left.journal_date ~= right.journal_date then
            return left.journal_date > right.journal_date
        end
        if left.line ~= right.line then
            return left.line > right.line
        end
        return left.relative_path < right.relative_path
    end
    if left.relative_path ~= right.relative_path then
        return left.relative_path < right.relative_path
    end
    return left.line < right.line
end

---@param root string
---@param filters? { since?: string, until?: string }
---@return table[]?, string?
function M.collect(root, filters)
    filters = filters or {}
    root = vim.uv.fs_realpath(root) or vim.fs.normalize(root)
    local stat = vim.uv.fs_stat(root)
    if not stat or stat.type ~= "directory" then
        return nil, "Could not determine wiki root"
    end

    local journal_only = filters.since ~= nil or filters["until"] ~= nil
    local scan_root = root
    if journal_only then
        scan_root = links.journal_root()
        local journal_stat = scan_root and vim.uv.fs_stat(scan_root)
        if not journal_stat or journal_stat.type ~= "directory" then
            return nil, "Could not determine wiki journal root"
        end
    end

    local files = vim.fs.find(function(name)
        return name:match("%.md$") ~= nil
    end, {
        path = scan_root,
        type = "file",
        limit = math.huge,
    })
    table.sort(files)

    local loaded = loaded_lines_by_path()
    local candidates = {}

    for _, path in ipairs(files) do
        path = vim.uv.fs_realpath(path) or vim.fs.normalize(path)
        local journal = links.journal_target(path)
        local in_range = not journal_only
            or (journal ~= nil
                and (not filters.since or journal.date >= filters.since)
                and (not filters["until"] or journal.date <= filters["until"]))

        if in_range then
            local lines = read_lines(path, loaded)
            if lines then
                local parsed_lines = tags.parse_lines(lines)
                local relative_path = vim.fs.relpath(root, path) or path
                for line_number, line_tags in pairs(parsed_lines) do
                    candidates[#candidates + 1] = {
                        path = path,
                        relative_path = relative_path,
                        line = line_number,
                        is_journal = journal ~= nil,
                        journal_date = journal and journal.date or nil,
                        tags = line_tags,
                        text = source_without_tags(lines[line_number], line_tags),
                    }
                end
            end
        end
    end

    table.sort(candidates, candidate_before)
    return candidates
end

local function display_candidate(candidate)
    local location = candidate.is_journal and candidate.journal_date or candidate.relative_path
    local display = string.format(
        "%s  %d   %s   %s",
        location,
        candidate.line,
        table.concat(candidate.tags, "  "),
        candidate.text
    )

    -- The first tab-separated field remains available to fzf for matching and
    -- to the builtin previewer, while --with-nth shows only the compact UI.
    return string.format(
        "%s:%d:1:\t%s",
        candidate.relative_path,
        candidate.line,
        display
    )
end

local function open_candidate(selected, root)
    local entry = selected and selected[1]
    if not entry then
        return
    end

    local metadata = entry:match("^([^\t]+)") or ""
    local relative_path, line = metadata:match("^(.*):(%d+):%d+:$")
    if not relative_path or not line then
        vim.notify("Could not open wiki search result", vim.log.levels.ERROR, { title = "WikiTagFind" })
        return
    end

    vim.cmd.edit(vim.fn.fnameescape(vim.fs.joinpath(root, relative_path)))
    vim.api.nvim_win_set_cursor(0, { tonumber(line), 0 })
    vim.cmd("normal! zz")
end

---@param arguments? string
function M.find(arguments)
    local options, argument_error = dates.parse_arguments(arguments or "")
    if not options then
        vim.notify(argument_error, vim.log.levels.ERROR, { title = "WikiTagFind" })
        return
    end

    local root = links.wiki_root()
    if not root then
        vim.notify("Could not determine wiki root", vim.log.levels.ERROR, { title = "WikiTagFind" })
        return
    end

    local candidates, collect_error = M.collect(root, options)
    if not candidates then
        vim.notify(collect_error, vim.log.levels.ERROR, { title = "WikiTagFind" })
        return
    end
    if #candidates == 0 then
        vim.notify("No tagged wiki lines found", vim.log.levels.INFO, { title = "WikiTagFind" })
        return
    end

    local journal_only = options.since ~= nil or options["until"] ~= nil
    local state = { show_journal = true }
    local function contents(callback)
        for _, candidate in ipairs(candidates) do
            if state.show_journal or not candidate.is_journal then
                callback(display_candidate(candidate))
            end
        end
        callback()
    end

    local actions = {
        ["enter"] = function(selected)
            open_candidate(selected, root)
        end,
    }
    if not journal_only then
        actions["ctrl-j"] = {
            fn = function()
                state.show_journal = not state.show_journal
            end,
            reload = true,
            header = "toggle journal",
        }
    end

    require("fzf-lua").fzf_exec(contents, {
        cwd = root,
        prompt = "Wiki tags> ",
        query = options.query,
        previewer = "builtin",
        winopts = {
            width = config.ui.picker_width,
            height = config.ui.picker_height,
            title = { { " WikiTagFind ", "FzfLuaTitle" } },
            title_pos = "center",
            preview = {
                hidden = true,
                layout = "flex",
                flip_columns = config.ui.preview_flip_columns,
                horizontal = "right:50%",
                vertical = "down:50%",
                winopts = {
                    cursorline = true,
                    cursorlineopt = "both",
                    number = true,
                },
            },
        },
        keymap = {
            builtin = {
                ["<F4>"] = "toggle-preview",
            },
        },
        fzf_opts = {
            ["--delimiter"] = "\t",
            ["--with-nth"] = "2..",
            ["--no-sort"] = true,
        },
        actions = actions,
    })
end

return M
