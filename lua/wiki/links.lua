local M = {}

local function normalize_path(path)
    path = vim.fn.fnamemodify(vim.fn.expand(path), ":p")
    path = vim.fs.normalize(path)
    return vim.uv.fs_realpath(path) or path
end

---@return string?
function M.wiki_root()
    local ok, root = pcall(vim.fn["wiki#get_root_global"])
    if ok and type(root) == "string" and root ~= "" then
        return normalize_path(root)
    end

    root = vim.g.wiki_root
    if type(root) == "string" and root ~= "" then
        return normalize_path(root)
    end
end

---@return string?
function M.journal_root()
    local root = M.wiki_root()
    if not root then
        return nil
    end

    local ok, journal = pcall(vim.fn["wiki#journal#get_root"], root)
    if not ok or type(journal) ~= "string" or journal == "" then
        return nil
    end

    return normalize_path(journal)
end

local function relative_descendant(root, path)
    root = normalize_path(root)
    path = normalize_path(path)
    if path == root then
        return ""
    end
    if path:sub(1, #root + 1) ~= root .. "/" then
        return nil
    end
    return path:sub(#root + 2)
end

---Return configured daily-journal metadata for a path.
---@param path string
---@return table?
function M.journal_target(path)
    local root = M.journal_root()
    if not root then
        return nil
    end

    local relative = relative_descendant(root, path)
    if not relative or not relative:match("%.md$") then
        return nil
    end

    local node = relative:gsub("%.md$", "")
    local ok, parsed = pcall(vim.fn["wiki#journal#node_to_date"], node)
    if not ok or type(parsed) ~= "table" or parsed[2] ~= "daily" or parsed[1] == "" then
        return nil
    end

    -- node_to_date() is deliberately permissive. Round-trip through the
    -- configured format so that only actual journal filenames are accepted.
    local reverse_ok, reverse = pcall(vim.fn["wiki#journal#date_to_node"], parsed[1])
    if not reverse_ok or type(reverse) ~= "table" or reverse[1] ~= node then
        return nil
    end

    return {
        date = parsed[1],
        node = node,
        root = root,
    }
end

local function markdown_heading(line)
    local indent, hashes, text = line:match("^(%s*)(#+)[ \t]+(.+)$")
    if not hashes or #indent > 3 or #hashes > 6 then
        return nil
    end

    text = text:gsub("[ \t]+#+[ \t]*$", "")
    text = vim.trim(text)
    return text ~= "" and text or nil
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

    return { char = char, length = #run, rest = rest }
end

---Conservative GitHub-like slugging for Markdown ATX headings.
---@param text string
---@return string
function M.slugify_heading(text)
    local slug = vim.fn.tolower(text)
    slug = slug:gsub("<[^>]->", "")
    slug = slug:gsub("%p", function(char)
        return (char == "-" or char == "_") and char or ""
    end)
    return slug:gsub("%s+", "-")
end

---@param lines string[]
---@param target_line integer
---@return table?
function M.heading_before_lines(lines, target_line)
    local used_slugs = {}
    local nearest
    local fence

    for line_number = 1, math.min(target_line, #lines) do
        local line = lines[line_number]
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
            local text = markdown_heading(line)
            if text then
                local base = M.slugify_heading(text)
                if base ~= "" then
                    local slug = base
                    local suffix = 0
                    while used_slugs[slug] do
                        suffix = suffix + 1
                        slug = base .. "-" .. suffix
                    end
                    used_slugs[slug] = true
                    nearest = { text = text, slug = slug, line = line_number }
                end
            end
        end
    end

    return nearest
end

local function relative_path(base, target)
    local base_parts = vim.split(vim.fs.normalize(base), "/", { plain = true, trimempty = true })
    local target_parts = vim.split(vim.fs.normalize(target), "/", { plain = true, trimempty = true })
    local common = 0

    for index = 1, math.min(#base_parts, #target_parts) do
        if base_parts[index] ~= target_parts[index] then
            break
        end
        common = index
    end

    local result = {}
    for _ = common + 1, #base_parts do
        result[#result + 1] = ".."
    end
    for index = common + 1, #target_parts do
        result[#result + 1] = target_parts[index]
    end
    return table.concat(result, "/")
end

local function encode_markdown_path(path)
    return vim.uri_encode(path):gsub("%(", "%%28"):gsub("%)", "%%29")
end

local function escape_markdown_label(label)
    return label:gsub("\\", "\\\\"):gsub("%[", "\\["):gsub("%]", "\\]")
end

---@param current_path string
---@param target_path string
---@param lines string[]
---@param target_line integer
---@param label? string
---@return string
function M.build_link(current_path, target_path, lines, target_line, label)
    current_path = normalize_path(current_path)
    target_path = normalize_path(target_path)

    local heading = M.heading_before_lines(lines, target_line)
    local journal = M.journal_target(target_path)
    local destination

    if journal then
        destination = "journal:" .. journal.date
    else
        destination = encode_markdown_path(relative_path(vim.fs.dirname(current_path), target_path))
    end
    if heading then
        destination = destination .. "#" .. heading.slug
    end

    local default_label = vim.fs.basename(target_path):gsub("%.md$", "")
    return string.format("[%s](%s)", escape_markdown_label(label or default_label), destination)
end

local function insert_at_cursor(text)
    local buffer = vim.api.nvim_get_current_buf()
    local cursor = vim.api.nvim_win_get_cursor(0)
    vim.api.nvim_buf_set_text(buffer, cursor[1] - 1, cursor[2], cursor[1] - 1, cursor[2], { text })
    vim.api.nvim_win_set_cursor(0, { cursor[1], cursor[2] + #text })
end

---@param custom_label boolean
function M.insert_alternate(custom_label)
    local current_buffer = vim.api.nvim_get_current_buf()
    local alternate_buffer = vim.fn.bufnr("#")

    if alternate_buffer <= 0 or not vim.api.nvim_buf_is_valid(alternate_buffer) then
        vim.notify("No alternate buffer", vim.log.levels.WARN, { title = "Markdown link" })
        return
    end
    if not vim.api.nvim_buf_is_loaded(alternate_buffer) then
        vim.fn.bufload(alternate_buffer)
    end

    local current_path = vim.api.nvim_buf_get_name(current_buffer)
    local target_path = vim.api.nvim_buf_get_name(alternate_buffer)
    if current_path == "" then
        vim.notify("Current buffer has no filename", vim.log.levels.WARN, { title = "Markdown link" })
        return
    end
    if target_path == "" then
        vim.notify("Alternate buffer has no filename", vim.log.levels.WARN, { title = "Markdown link" })
        return
    end

    local mark = vim.api.nvim_buf_get_mark(alternate_buffer, '"')
    local target_line = math.max(mark[1], 1)
    local lines = vim.api.nvim_buf_get_lines(alternate_buffer, 0, -1, false)
    local default_label = vim.fs.basename(target_path):gsub("%.md$", "")
    local label

    if custom_label then
        label = vim.fn.input("Link text: ", default_label)
        if label == "" then
            return
        end
    end

    insert_at_cursor(M.build_link(current_path, target_path, lines, target_line, label))
end

return M
