local M = {}

M.generic_tags = {
    -- Knowledge / state
    {
        name = "bug",
        icon = " ",
        highlight = {
            fg = "#ffffff",
            bg = "#d20f39",
            bold = true,
        },
    },
    "idea",
    "question",
    "decision",
    "finding",
    "result",
    "blocker",
    "workaround",

    -- Interaction
    "request",
    "delegated",
    "feedback",
    "discussion",
    "meeting",
    "supervision",
    "review",

    -- Engineering activity
    "investigation",
    "debugging",
    "design",
    "implementation",
    "refactor",
    "optimization",
    "profiling",
    "benchmark",
    "validation",
    "testing",
    "setup",
    "configuration",
    "documentation",
    "reading",

    -- Outputs
    "paper",
    "presentation",

    -- Computing concepts
    "performance",
    "hpc",
    "cpu",
    "gpu",
    "simd",
    "simt",
    "numa",

    -- Technologies / vendors
    {
        name = "nvidia",
        highlight = {
            fg = "#76b900",
            bold = true,
        },
    },
    "amd",
    "intel",
    "cuda",
    "rocm",
    {
        name = "cpp",
        -- Matches nvim-web-devicons' C++ glyph.
        icon = " ",
    },
    {
        name = "python",
        -- Matches nvim-web-devicons' Python glyph and stays theme-aware.
        icon = " ",
        highlight = "DiagnosticWarn",
    },
    "fortran",
}

M.render = {
    default_tag = {
        icon = " ",
        highlight = "DiagnosticInfo",
        padding = 0,
    },
    project = {
        icon = " ",
        highlight = "Special",
        padding = 0,
    },
    mention = {
        icon = " ",
        highlight = "DiagnosticWarn",
        padding = 0,
    },
}

M.namespaces = {
    mention = "@",
    project = "p/",
}

M.mappings = {
    alternate_link = "<leader>ml",
    generic_tags = "<leader>mt",
    project_tag = "<leader>mp",
    mention = "<leader>mm",
    insert_generic_tags = "<C-g>t",
    insert_mention = "<C-g>m",
    insert_project_tag = "<C-g>p",
    tag_find = "<leader>ft",
    mentions = "<leader>fm",
    projects = "<leader>fp",
}

M.ui = {
    preview_flip_columns = 140,
    picker_height = 0.85,
    picker_width = 1,
}

---@param style table
---@return { icon: string, highlight: string|table, padding: integer }
function M.normalize_render_style(style)
    assert(type(style) == "table", "wiki render styles must be tables")
    assert(
        type(style.highlight) == "string" or type(style.highlight) == "table",
        "wiki render highlights must be a group name or nvim_set_hl table"
    )

    local padding = tonumber(style.padding) or 0
    return {
        icon = vim.g.pretty and (style.icon or "") or "",
        highlight = type(style.highlight) == "table" and vim.deepcopy(style.highlight) or style.highlight,
        padding = math.max(0, math.floor(padding)),
    }
end

---Normalize the string and structured generic-tag forms into one shape.
---@param entry string|table
---@return { name: string, icon: string, highlight: string|table, padding: integer, custom_highlight: boolean }
function M.normalize_generic_tag(entry)
    local item = type(entry) == "string" and { name = entry } or entry
    assert(type(item) == "table", "wiki generic tags must be strings or tables")
    assert(type(item.name) == "string" and item.name ~= "", "wiki generic tags require a name")
    assert(not item.name:find("[:%s]"), "wiki generic tag names cannot contain colons or whitespace")

    local defaults = M.normalize_render_style(M.render.default_tag)
    local icon = item.icon ~= nil and item.icon or M.render.default_tag.icon
    local highlight = item.highlight ~= nil and item.highlight or defaults.highlight
    local padding = item.padding ~= nil and item.padding or defaults.padding
    assert(type(icon) == "string", "wiki generic tag icons must be strings")
    assert(
        type(highlight) == "string" or type(highlight) == "table",
        "wiki generic tag highlights must be a group name or nvim_set_hl table"
    )

    return {
        name = item.name,
        icon = vim.g.pretty and icon or "",
        highlight = type(highlight) == "table" and vim.deepcopy(highlight) or highlight,
        padding = math.max(0, math.floor(tonumber(padding) or 0)),
        custom_highlight = item.highlight ~= nil,
    }
end

---@return table[]
function M.normalized_generic_tags()
    return vim.tbl_map(M.normalize_generic_tag, M.generic_tags)
end

---@return table<string, table>
function M.generic_tag_lookup()
    local lookup = {}
    for _, tag in ipairs(M.normalized_generic_tags()) do
        lookup[tag.name] = tag
    end
    return lookup
end

return M
