local config = require("wiki.config")

local M = {}

local groups = {
    default_tag = "WikiTagDefault",
    project = "WikiProject",
    mention = "WikiMention",
}

---@param name string
---@return string
local function sanitized_name(name)
    local result = {}
    for part in name:gmatch("[%w]+") do
        result[#result + 1] = part:sub(1, 1):upper() .. part:sub(2)
    end
    return #result > 0 and table.concat(result) or "Unknown"
end

---@param name string
---@return string
function M.tag_highlight_group(name)
    return "WikiTag" .. sanitized_name(name)
end

---@param group string
---@param highlight string|table
local function set_highlight(group, highlight)
    local definition = type(highlight) == "string" and { link = highlight } or vim.deepcopy(highlight)
    vim.api.nvim_set_hl(0, group, definition)
end

function M.apply_highlights()
    set_highlight(groups.default_tag, config.render.default_tag.highlight)
    set_highlight(groups.project, config.render.project.highlight)
    set_highlight(groups.mention, config.render.mention.highlight)

    for _, tag in ipairs(config.normalized_generic_tags()) do
        if tag.custom_highlight then
            set_highlight(M.tag_highlight_group(tag.name), tag.highlight)
        end
    end
end

function M.setup()
    M.apply_highlights()
    local group = vim.api.nvim_create_augroup("WikiRenderHighlights", { clear = true })
    vim.api.nvim_create_autocmd("ColorScheme", {
        group = group,
        callback = M.apply_highlights,
        desc = "Reapply wiki tag highlights",
    })
end

---@param tag string
---@return "generic"|"project"|"mention", string
function M.classify(tag)
    local project = config.namespaces.project
    local mention = config.namespaces.mention

    if tag:sub(1, #project) == project and #tag > #project then
        return "project", tag:sub(#project + 1)
    end
    if tag:sub(1, #mention) == mention and #tag > #mention then
        return "mention", tag:sub(#mention + 1)
    end
    return "generic", tag
end

---@param node TSNode
---@return boolean
local function inside_code_span(node)
    while node do
        if node:type() == "code_span" then
            return true
        end
        node = node:parent()
    end
    return false
end

---@param buffer integer
---@param row integer
---@param column integer
---@return boolean
local function inside_markdown_code_block(buffer, row, column)
    local ok, node = pcall(vim.treesitter.get_node, {
        bufnr = buffer,
        pos = { row, column },
        lang = "markdown",
        ignore_injections = true,
    })
    if not ok then
        return false
    end

    while node do
        local kind = node:type()
        if kind == "fenced_code_block" or kind == "indented_code_block" then
            return true
        end
        node = node:parent()
    end
    return false
end

---@param root TSNode
---@param row integer
---@param column integer
---@return boolean
local function is_literal_colon(root, row, column)
    local node = root:descendant_for_range(row, column, row, column + 1)
    if not node or node:type() ~= ":" or inside_code_span(node) then
        return false
    end
    local start_row, start_col, end_row, end_col = node:range()
    return start_row == row
        and start_col == column
        and end_row == row
        and end_col == column + 1
end

---@param kind "generic"|"project"|"mention"
---@param tag string
---@param lookup table<string, table>
---@return table, string
local function presentation(kind, tag, lookup)
    if kind == "project" then
        return config.normalize_render_style(config.render.project), groups.project
    end
    if kind == "mention" then
        return config.normalize_render_style(config.render.mention), groups.mention
    end

    local configured = lookup[tag]
    local style = configured or config.normalize_generic_tag(tag)
    local highlight = style.custom_highlight and M.tag_highlight_group(tag) or groups.default_tag
    return style, highlight
end

---@param buffer integer
---@param line string
---@param row integer
---@param root TSNode
---@param lookup table<string, table>
---@param marks render.md.Mark[]
local function parse_line(buffer, line, row, root, lookup, marks)
    local offset = 1
    while true do
        local start_byte, end_byte, tag = line:find(":([^:%s]+):", offset)
        if not start_byte then
            return
        end

        local before = start_byte == 1 and "" or line:sub(start_byte - 1, start_byte - 1)
        local start_col = start_byte - 1
        local end_col = end_byte
        if (start_byte == 1 or before:match("%s"))
            and not inside_markdown_code_block(buffer, row, start_col)
            and is_literal_colon(root, row, start_col)
            and is_literal_colon(root, row, end_col - 1)
        then
            local kind, label = M.classify(tag)
            local style, highlight = presentation(kind, tag, lookup)
            local padding = string.rep(" ", style.padding)
            local label_start = start_col + 1 + (#tag - #label)
            local label_end = end_col - 1

            local prefix_options = {
                end_row = row,
                end_col = label_start,
                conceal = "",
                priority = 1000,
            }
            local icon = padding .. style.icon
            if icon ~= "" then
                prefix_options.virt_text = { { icon, highlight } }
                prefix_options.virt_text_pos = "inline"
            end
            marks[#marks + 1] = {
                conceal = true,
                start_row = row,
                start_col = start_col,
                opts = prefix_options,
            }
            marks[#marks + 1] = {
                conceal = false,
                start_row = row,
                start_col = label_start,
                opts = {
                    end_row = row,
                    end_col = label_end,
                    hl_group = highlight,
                    hl_mode = "combine",
                    priority = 1000,
                },
            }

            local suffix_options = {
                end_row = row,
                end_col = end_col,
                conceal = "",
                priority = 1000,
            }
            if padding ~= "" then
                suffix_options.virt_text = { { padding, highlight } }
                suffix_options.virt_text_pos = "inline"
            end
            marks[#marks + 1] = {
                conceal = true,
                start_row = row,
                start_col = label_end,
                opts = suffix_options,
            }
        end
        offset = end_byte + 1
    end
end

---Render wiki.vim colon tags from a markdown_inline Tree-sitter root.
---@param ctx render.md.handler.Context
---@return render.md.Mark[]
function M.parse(ctx)
    local marks = {}
    local lookup = config.generic_tag_lookup()
    local start_row, _, end_row = ctx.root:range()
    local line_count = vim.api.nvim_buf_line_count(ctx.buf)
    local lines = vim.api.nvim_buf_get_lines(ctx.buf, start_row, math.min(end_row + 1, line_count), false)
    for index, line in ipairs(lines) do
        parse_line(ctx.buf, line, start_row + index - 1, ctx.root, lookup, marks)
    end
    return marks
end

---@return render.md.Handler
function M.handler()
    return {
        extends = true,
        parse = M.parse,
    }
end

---Toggle whether render-markdown conceals markup on the cursor line.
---Other lines and the renderer's global enabled state are left untouched.
---@return boolean concealed
function M.toggle_cursor_conceal()
    local buffer = vim.api.nvim_get_current_buf()
    local window = vim.api.nvim_get_current_win()
    local state = require("render-markdown.state")
    local buffer_config = state.get(buffer)
    buffer_config.anti_conceal.enabled = not buffer_config.anti_conceal.enabled
    require("render-markdown.core.ui").update(buffer, window, "WikiCursorConceal", false)
    return not buffer_config.anti_conceal.enabled
end

return M
