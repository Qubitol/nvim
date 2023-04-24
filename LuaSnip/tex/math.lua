local luasnip = require("plugins.luasnip")
local get_visual = luasnip.get_visual
local in_mathzone = luasnip.in_mathzone
local in_text = luasnip.in_text

local snippets = {

    s({
        trig = "q([+-]?%d*%.%d*)(e[+-]?%d+)",
        wordTrig = false,
        regTrig = true,
        desc = "Expand to siunitx \\qty",
    },
        fmta(
            "\\qty{<>}{<>}",
            {
                f(
                    function(_, snip)
                        local out = ""
                        local mantissa = tonumber(snip.captures[1])
                        if mantissa ~= 1 and mantissa ~= -1
                        then
                            out = out .. mantissa
                        end
                        out = out .. snip.captures[2]
                        return out
                    end
                ),
                i(1),
            }
        ),
        { condition = in_mathzone }
    ),

    s({
        trig = "q([+-]?%d*)(e[+-]?%d+)",
        wordTrig = false,
        regTrig = true,
        desc = "Expand to siunitx \\qty",
    },
        fmta(
            "\\qty{<>}{<>}",
            {
                f(
                    function(args, snip)
                        local out = ""
                        local mantissa = tonumber(snip.captures[1])
                        if mantissa ~= 1 and mantissa ~= -1
                        then
                            out = out .. mantissa
                        end
                        out = out .. snip.captures[2]
                        return out
                    end
                ),
                i(1),
            }
        ),
        { condition = in_mathzone }
    ),

    s({
        trig = "q([+-]?%d*%.%d*)",
        wordTrig = false,
        regTrig = true,
        desc = "Expand to siunitx \\qty",
    },
        fmta(
            "\\qty{<>}{<>}",
            {
                f( function(_, snip) return snip.captures[1] end ),
                i(1),
            }
        ),
        { condition = in_mathzone }
    ),
}

local autosnippets = {

    s({
        trig = "([^%a])mm",
        wordTrig = false,
        regTrig = true,
        dscr = "Inline math",
    },
        fmta(
            "<>$<>$",
            {
                f( function(_, snip) return snip.captures[1] end ),
                d(1, get_visual),
            }
        ),
        { condition = in_text }
    ),

    s({
        trig = "vv",
        wordTrig = false,
        regTrig = true,
        dscr = "Vector",
    },
        fmta(
            "\\vec{<>}",
            { d(1, get_visual) }
        ),
        { condition = in_mathzone }
    ),

    s({
        trig = "ff",
        dscr = "Create a fraction"
    },
        fmta(
            "\\frac{<>}{<>}",
            { i(1), i(2) }
        ),
        { condition = in_mathzone }
    ),

    s({
        trig = "beq",
        dscr = "Equation environment"
    },
        fmta(
            [[
                \begin{equation}
                    <>
                \end{equation}

            ]],
            { i(1) }
        ),
        { condition = conds.line_begin }
    ),

    s({
        trig = "bes",
        dscr = "Subequation environment"
    },
        fmta(
            [[
                \begin{subequations}
                    <>
                \end{subequations}

            ]],
            { i(1) }
        ),
        { condition = conds.line_begin }
    ),

    s({
        trig = "bal",
        dscr = "Align environment"
    },
        fmta(
            [[
                \begin{align}
                    <>
                \end{align}

            ]],
            { i(1) }
        ),
        { condition = conds.line_begin }
    ),

    s({
        trig = "bga",
        dscr = "Gather environment"
    },
        fmta(
            [[
                \begin{gather}
                    <>
                \end{gather}

            ]],
            { i(1) }
        ),
        { condition = conds.line_begin }
    ),

    s({
        trig = "([^%s])__",
        wordTrig = false,
        regTrig = true,
        dscr = "Subscript"
    },
        fmta(
            "<>_{<>}",
            {
                f( function(_, snip) return snip.captures[1] end ),
                i(1)
            }
        ),
        { condition = in_mathzone }
    ),

    s({
        trig = "([^%s])%*%*",
        wordTrig = false,
        regTrig = true,
        dscr = "Superscript"
    },
        fmta(
            "<>^{<>}",
            {
                f( function(_, snip) return snip.captures[1] end ),
                i(1)
            }
        ),
        { condition = in_mathzone }
    ),

    s({
        trig = "([^%s])_t",
        wordTrig = false,
        regTrig = true,
        dscr = "Textup subscript"
    },
        fmta(
            "<>_\\textup{<>}",
            {
                f( function(_, snip) return snip.captures[1] end ),
                i(1)
            }
        ),
        { condition = in_mathzone }
    ),

    s({
        trig = "([^%s])%*t",
        wordTrig = false,
        regTrig = true,
        dscr = "Textup superscript"
    },
        fmta(
            "<>^\\textup{<>}",
            {
                f( function(_, snip) return snip.captures[1] end ),
                i(1)
            }
        ),
        { condition = in_mathzone }
    ),

    s({
        trig = "([^%s])%+%+",
        wordTrig = false,
        regTrig = true,
        dscr = "Superscript plus"
    },
        fmta(
            "<>^+",
            { f( function(_, snip) return snip.captures[1] end ) }
        ),
        { condition = in_mathzone }
    ),

    s({
        trig = "([^%s])%-%-",
        wordTrig = false,
        regTrig = true,
        dscr = "Superscript minus"
    },
        fmta(
            "<>^-",
            { f( function(_, snip) return snip.captures[1] end ) }
        ),
        { condition = in_mathzone }
    ),

    s({
        trig = "->",
        dscr = "Right arrow"
    },
        t( "\\to" ),
        { condition = in_mathzone }
    ),

    s({
        trig = "=>",
        dscr = "Double right arrow"
    },
        t( "\\Rightarrow" ),
        { condition = in_mathzone }
    ),

}

-- Create autosnippets for SI units
local si_units = {
    ["E"] = "\\exa",
    ["P"] = "\\peta",
    ["T"] = "\\tera",
    ["G"] = "\\giga",
    ["M"] = "\\mega",
    ["k"] = "\\kilo",
    ["cm"] = "\\centi",
    ["mi"] = "\\milli",
    ["mu"] = "\\micro",
    ["n"] = "\\nano",
    ["pi"] = "\\pico",
    ["me"] = "\\metre",
    ["se"] = "\\second",
    ["g"] = "\\gram",
    ["K"] = "\\kelvin",
    ["rad"] = "\\radian",
    ["ev"] = "\\electronvolt",
    ["pc"] = "\\parsec",
    ["sq"] = "\\square",
    ["cu"] = "\\cubic",
    ["p2"] = "\\tothe{2}",
    ["p3"] = "\\tothe{3}",
    ["p4"] = "\\tothe{4}",
    ["p5"] = "\\tothe{5}",
}

local si_triggers = {
    ["\\qty"] = "(\\qty%{.-%})(%{[^%s%}]-)%s?",
    ["\\qty[*]"] = "(\\qty%[.-%]%{.-%})(%{[^%s%}]-)%s?",
    ["\\qtylist"] = "(\\qtylist%{.-%})(%{[^%s%}]-)%s?",
    ["\\qtylist[*]"] = "(\\qtylist%[.-%]%{.-%})(%{[^%s%}]-)%s?",
    ["\\qtyrange"] = "(\\qtyrange%{.-%}%{.-%})(%{[^%s%}]-)%s?",
    ["\\qtyrange[*]"] = "(\\qtyrange%[.-%]%{.-%}%{.-%})(%{[^%s%}]-)%s?",
    ["\\unit"] = "(\\unit)(%{[^%s%}]-)%s?",
    ["\\unit[*]"] = "(\\unit%[.-%])(%{[^%s%}]-)%s?",
}

for si_prefix, latex in pairs(si_units) do
    local expand = "<><>" .. latex
    for cmd, trig_prefix in pairs(si_triggers) do
        local snippet = s(
            {
                trig = trig_prefix .. si_prefix,
                wordTrig = false,
                regTrig = true,
                desc = "Expand in siunitx " .. cmd .. " : '" .. si_prefix .. "' -> '" .. latex .. "'",
            },
            fmta(
                expand,
                {
                    f( function(_, snip) return snip.captures[1] end ),
                    f( function(_, snip) return snip.captures[2] end ),
                }
            )
        )
        table.insert(autosnippets, snippet)
    end
end

return snippets, autosnippets
