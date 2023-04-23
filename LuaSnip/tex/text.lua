local luasnip = require("plugins.luasnip")
local get_visual = luasnip.get_visual

local snippets = {}

local autosnippets = {

    s({
        trig = "...",
        dscr = "Dots"
    },
        t("\\dots")
    ),

}

return snippets, autosnippets
