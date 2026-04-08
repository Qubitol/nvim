-- Snippets

local map = require("config.utils").map

-- Build hook: compile jsregexp when luasnip is installed or updated
vim.api.nvim_create_autocmd("PackChanged", {
    callback = function(ev)
        local name, kind = ev.data.spec.name, ev.data.kind
        if name == "LuaSnip" and (kind == "install" or kind == "update") then
            vim.system({ "make", "install_jsregexp" }, { cwd = ev.data.path }):wait()
        end
    end,
})

vim.pack.add({ "https://github.com/L3MON4D3/LuaSnip" })

local ls = require("luasnip")
local types = require("luasnip.util.types")
local icons = require("config.ui").icons

ls.config.set_config({
    history = false,
    enable_autosnippets = true,
    store_selection_keys = "<Tab>",
    updateevents = "TextChanged,TextChangedI",
    ext_opts = {
        [types.choiceNode] = {
            active = {
                virt_text = { { icons.luasnip.choice_node, "DiagnosticWarn" } },
            },
        },
    },
})

-- Load snippets from custom directory
require("luasnip.loaders.from_lua").lazy_load({
    paths = vim.fn.stdpath("config") .. "/LuaSnip/",
})

-- Reload snippets at runtime
map("n", "<leader>U", function()
    require("luasnip.loaders.from_lua").load({
        paths = vim.fn.stdpath("config") .. "/LuaSnip/",
    })
end, "Reload/[U]pdate the snippets at runtime")

-- Insert mode: expand or jump
map("i", "<Tab>", function()
    if ls.expand_or_locally_jumpable() then
        ls.expand_or_jump()
    else
        -- Return actual Tab
        vim.api.nvim_feedkeys(
            vim.api.nvim_replace_termcodes("<Tab>", true, false, true),
            "n", false
        )
    end
end, "Expand snippet or jump forward, fallback to Tab")

map("i", "<S-Tab>", function() ls.jump(-1) end, "When inside a snippet, jump back")

-- Choice node navigation
map({ "i", "n" }, "<C-n>", function()
    if ls.choice_active() then
        ls.change_choice(1)
    else
        vim.api.nvim_feedkeys(
            vim.api.nvim_replace_termcodes("<C-n>", true, false, true),
            "n", false
        )
    end
end, "When inside a choice node, select next choice")

map({ "i", "n" }, "<C-p>", function()
    if ls.choice_active() then
        ls.change_choice(-1)
    else
        vim.api.nvim_feedkeys(
            vim.api.nvim_replace_termcodes("<C-p>", true, false, true),
            "n", false
        )
    end
end, "When inside a choice node, select previous choice")

-- Select mode: jump through snippet stops
map("s", "<Tab>", function() ls.jump(1) end, "When inside a snippet, jump forward")
map("s", "<S-Tab>", function() ls.jump(-1) end, "When inside a snippet, jump back")

-- Utilities
local sn = ls.snippet_node
local i = ls.insert_node

local M = {}

-- get_visual function to store deleted text to insert in next snippet
-- Summary: When `SELECT_RAW` is populated with a visual selection, the function
-- returns an insert node whose initial text is set to the visual selection.
-- When `SELECT_RAW` is empty, the function simply returns an empty insert node.
function M.get_visual(_, parent)
    if #parent.snippet.env.SELECT_RAW > 0 then
        return sn(nil, i(1, parent.snippet.env.SELECT_RAW))
    else -- If SELECT_RAW is empty, return a blank insert node
        return sn(nil, i(1))
    end
end

-- Detect if we are in math
function M.in_mathzone()
    -- The `in_mathzone` function requires the VimTeX plugin
    return vim.fn["vimtex#syntax#in_mathzone"]() == 1
end

-- Detect if we are in text
M.in_text = function()
    return not M.in_mathzone()
end

-- Detect if we are in comment
M.in_comment = function()
    return vim.fn["vimtex#syntax#in_comment"]() == 1
end

-- Detect if we are in a certain environment
M.in_env = function(name) -- generic environment detection
    local is_inside = vim.fn["vimtex#env#is_inside"](name)
    return (is_inside[1] > 0 and is_inside[2] > 0)
end

-- Detect if we are in an equation environment
M.in_equation = function()
    return M.in_env("equation")
end

-- Detect if we are in an itemize environment
M.in_itemize = function()
    return M.in_env("itemize")
end

return M
