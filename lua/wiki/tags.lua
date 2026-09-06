local config = require("wiki.config")

local M = {}

local fallback_parser = {
    re_match = [[\v%(^|\s):[^: ]+:]],
    re_parse = [[\v:\zs[^: ]+\ze:]],
}

local function native_parsers()
    local parsers = vim.g.wiki_tag_parsers
    if type(parsers) ~= "table" or #parsers == 0 then
        return { fallback_parser }
    end

    local usable = {}
    for _, parser in ipairs(parsers) do
        if type(parser) == "table"
            and type(parser.re_match) == "string"
            and type(parser.re_parse) == "string"
        then
            usable[#usable + 1] = parser
        end
    end

    return #usable > 0 and usable or { fallback_parser }
end

---Parse all native wiki.vim colon tags on one line.
---The configured vocabulary intentionally has no bearing on recognition.
---@param line string
---@return string[]
function M.parse_line(line)
    local result = {}
    local seen = {}

    for _, parser in ipairs(native_parsers()) do
        if vim.fn.match(line, parser.re_match) >= 0 then
            local occurrence = 1
            while true do
                local tag = vim.fn.matchstr(line, parser.re_parse, 0, occurrence)
                if tag == "" then
                    break
                end
                if not seen[tag] then
                    result[#result + 1] = tag
                    seen[tag] = true
                end
                occurrence = occurrence + 1
            end
        end
    end

    return result
end

local function fence_at(line)
    local indent, run, rest = line:match("^(%s*)([`~]+)(.*)$")
    if not run or #indent > 3 or #run < 3 then
        return nil
    end

    local char = run:sub(1, 1)
    if run ~= char:rep(#run) then
        return nil
    end

    return {
        char = char,
        length = #run,
        rest = rest,
    }
end

---Parse tagged lines while applying wiki.vim's fenced-code exclusion.
---Tilde fences are accepted as the Markdown equivalent of backtick fences.
---@param lines string[]
---@return table<integer, string[]>
function M.parse_lines(lines)
    local result = {}
    local fence

    for line_number, line in ipairs(lines) do
        local marker = fence_at(line)
        local skip = fence ~= nil

        if not fence and marker then
            fence = marker
            skip = true
        elseif fence and marker
            and marker.char == fence.char
            and marker.length >= fence.length
            and marker.rest:match("^%s*$")
        then
            fence = nil
            skip = true
        end

        if not skip then
            local parsed = M.parse_line(line)
            if #parsed > 0 then
                result[line_number] = parsed
            end
        end
    end

    return result
end

---@return { buffer: integer, window: integer, row: integer, column: integer }
function M.capture_target()
    local cursor = vim.api.nvim_win_get_cursor(0)
    return {
        buffer = vim.api.nvim_get_current_buf(),
        window = vim.api.nvim_get_current_win(),
        row = cursor[1] - 1,
        column = cursor[2],
    }
end

---@param text string
---@param target? { buffer: integer, window: integer, row: integer, column: integer }
---@return boolean
function M.insert_text(text, target)
    target = target or M.capture_target()
    if not vim.api.nvim_buf_is_valid(target.buffer)
        or not vim.api.nvim_buf_is_loaded(target.buffer)
    then
        vim.notify("Insertion buffer is no longer available", vim.log.levels.WARN, { title = "Wiki" })
        return false
    end

    local line_count = vim.api.nvim_buf_line_count(target.buffer)
    local row = math.min(target.row, math.max(line_count - 1, 0))
    local line = vim.api.nvim_buf_get_lines(target.buffer, row, row + 1, false)[1] or ""
    local column = math.min(target.column, #line)

    vim.api.nvim_buf_set_text(target.buffer, row, column, row, column, { text })

    if vim.api.nvim_win_is_valid(target.window)
        and vim.api.nvim_win_get_buf(target.window) == target.buffer
    then
        vim.api.nvim_win_set_cursor(target.window, { row + 1, column + #text })
    end

    return true
end

function M.pick_generic()
    local target = M.capture_target()
    local normalized = config.normalized_generic_tags()
    local names = {}
    local order = {}
    for index, tag in ipairs(normalized) do
        names[#names + 1] = tag.name
        order[tag.name] = index
    end

    require("fzf-lua").fzf_exec(names, {
        prompt = "Tags> ",
        winopts = {
            title = { { " Wiki tags ", "FzfLuaTitle" } },
            title_pos = "center",
        },
        fzf_opts = {
            ["--multi"] = true,
            ["--header"] = "Tab: select multiple",
        },
        actions = {
            ["enter"] = function(selected)
                if not selected or #selected == 0 then
                    return
                end
                table.sort(selected, function(left, right)
                    return order[left] < order[right]
                end)
                local serialized = vim.tbl_map(function(tag)
                    return ":" .. tag .. ":"
                end, selected)
                M.insert_text(table.concat(serialized, " "), target)
            end,
        },
    })
end

---@param name string
---@return string?, string?
function M.normalize_mention(name)
    name = vim.trim(name or "")
    name = name:gsub("^:+", ""):gsub(":+$", ""):gsub("^@", "")

    if name == "" then
        return nil, "Mention cannot be empty"
    end
    if name:find("%s") then
        return nil, "Mention identifiers cannot contain whitespace"
    end
    if name:find(":", 1, true) then
        return nil, "Mention identifiers cannot contain ':'"
    end

    return config.namespaces.mention .. name
end

---@param name string
---@param target? table
---@return boolean
function M.insert_mention(name, target)
    local mention, err = M.normalize_mention(name)
    if not mention then
        vim.notify(err, vim.log.levels.WARN, { title = "Wiki mention" })
        return false
    end
    return M.insert_text(":" .. mention .. ":", target)
end

function M.prompt_mention()
    local target = M.capture_target()
    vim.ui.input({ prompt = "Mention: " }, function(input)
        if input == nil or input == "" then
            return
        end
        M.insert_mention(input, target)
    end)
end

return M
