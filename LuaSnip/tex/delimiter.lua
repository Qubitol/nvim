local luasnip = require("plugins.luasnip")
local get_visual = luasnip.get_visual
local in_mathzone = luasnip.in_mathzone
local in_text = luasnip.in_text

local snippets = {}

local autosnippets = {

    s({
        trig = "([^%a])b%(",
        regTrig = true,
        wordTrig = false,
        dscr = "Big round parenthesis"
    },
        fmta(
            "<>\\bigl(<>\\bigr)",
            {
                f( function(_, snip) return snip.captures[1] end ),
                d(1, get_visual),
            }
        ),
        { condition = in_mathzone }
    ),

    s({
        trig = "([^%a])b%[",
        regTrig = true,
        wordTrig = false,
        dscr = "Big square brackets"
    },
        fmta(
            "<>\\bigl[<>\\bigr]",
            {
                f( function(_, snip) return snip.captures[1] end ),
                d(1, get_visual),
            }
        ),
        { condition = in_mathzone }
    ),

    s({
        trig = "([^%a])b%{",
        regTrig = true,
        wordTrig = false,
        dscr = "Big curly brackets"
    },
        fmta(
            "<>\\bigl\\{<>\\bigr\\}",
            {
                f( function(_, snip) return snip.captures[1] end ),
                d(1, get_visual),
            }
        ),
        { condition = in_mathzone }
    ),

}

return snippets, autosnippets
