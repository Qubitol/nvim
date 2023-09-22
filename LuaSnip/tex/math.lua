local luasnip = require("utils.luasnip")
local get_visual = luasnip.get_visual
local in_mathzone = luasnip.in_mathzone
local in_text = luasnip.in_text

local snippets = {}

local autosnippets = {

    s({
        trig = "([^%a])aa",
        wordTrig = false,
        regTrig = true,
        desc = "Expand to siunitx \\ang",
    },
        fmta(
            "<>\\ang{<>}",
            {
                f( function(_, snip) return snip.captures[1] end ),
                i(1, "numbers list"),
            }
        )
    ),

    s({
        trig = "([^%a])nn",
        wordTrig = false,
        regTrig = true,
        desc = "Expand to siunitx \\num",
    },
        fmta(
            "<>\\num{<>}",
            {
                f( function(_, snip) return snip.captures[1] end ),
                i(1, "numbers list"),
            }
        )
    ),

    s({
        trig = "([^%a])nl",
        wordTrig = false,
        regTrig = true,
        desc = "Expand to siunitx \\numlist",
    },
        fmta(
            "<>\\numlist{<>}",
            {
                f( function(_, snip) return snip.captures[1] end ),
                i(1, "numbers list"),
            }
        )
    ),

    s({
        trig = "([^%a])nr",
        wordTrig = false,
        regTrig = true,
        desc = "Expand to siunitx \\numrange",
    },
        fmta(
            "<>\\numrange{<>}{<>}",
            {
                f( function(_, snip) return snip.captures[1] end ),
                i(1, "range min"),
                i(2, "range max"),
            }
        )
    ),

    s({
        trig = "([^%a])nR",
        wordTrig = false,
        regTrig = true,
        desc = "Expand to siunitx \\numrange[range-phrase = --]",
    },
        fmta(
            "<>\\numrange[range-phrase = --]{<>}{<>}",
            {
                f( function(_, snip) return snip.captures[1] end ),
                i(1, "range min"),
                i(2, "range max"),
            }
        )
    ),

    s({
        trig = "([^%a])qq",
        wordTrig = false,
        regTrig = true,
        desc = "Expand to siunitx \\qty",
    },
        fmta(
            "<>\\qty{<>}{<>}",
            {
                f( function(_, snip) return snip.captures[1] end ),
                i(1, "number"),
                i(2, "unit"),
            }
        )
    ),

    s({
        trig = "([^%a])ql",
        wordTrig = false,
        regTrig = true,
        desc = "Expand to siunitx \\qtylist",
    },
        fmta(
            "<>\\qtylist{<>}{<>}",
            {
                f( function(_, snip) return snip.captures[1] end ),
                i(1, "numbers list"),
                i(2, "unit"),
            }
        )
    ),

    s({
        trig = "([^%a])qr",
        wordTrig = false,
        regTrig = true,
        desc = "Expand to siunitx \\qtyrange",
    },
        fmta(
            "<>\\qtyrange{<>}{<>}{<>}",
            {
                f( function(_, snip) return snip.captures[1] end ),
                i(1, "range min"),
                i(2, "range max"),
                i(3, "unit"),
            }
        )
    ),

    s({
        trig = "([^%a])qR",
        wordTrig = false,
        regTrig = true,
        desc = "Expand to siunitx \\qtyrange[range-phrase = --]",
    },
        fmta(
            "<>\\qtyrange[range-phrase = --]{<>}{<>}{<>}",
            {
                f( function(_, snip) return snip.captures[1] end ),
                i(1, "range min"),
                i(2, "range max"),
                i(3, "unit"),
            }
        )
    ),

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
        trig = "([^%a])vv",
        wordTrig = false,
        regTrig = true,
        dscr = "Vector",
    },
        fmta(
            "<>\\vec{<>}",
            {
                f( function(_, snip) return snip.captures[1] end ),
                d(1, get_visual),
            }
        ),
        { condition = in_mathzone }
    ),

    s({
        trig = "([^%a])ff",
        wordTrig = false,
        regTrig = true,
        dscr = "Fraction"
    },
        fmta(
            "<>\\frac{<>}{<>}",
            {
                f( function(_, snip) return snip.captures[1] end ),
                d(1, get_visual),
                i(2)
            }
        ),
        { condition = in_mathzone }
    ),

    s({
        trig = "([^%a])odv",
        wordTrig = false,
        regTrig = true,
        dscr = "Ordinary derivative",
    },
        fmta(
            "<>\\odv{<>}{<>}",
            {
                f( function(_, snip) return snip.captures[1] end ),
                i(1),
                i(2)
            }
        ),
        { condition = in_mathzone }
    ),

    s({
        trig = "([^%a])pdv",
        wordTrig = false,
        regTrig = true,
        dscr = "Partial derivative",
    },
        fmta(
            "<>\\pdv{<>}{<>}",
            {
                f( function(_, snip) return snip.captures[1] end ),
                i(1),
                i(2)
            }
        ),
        { condition = in_mathzone }
    ),

    s({
        trig = "([^%a])dd",
        wordTrig = false,
        regTrig = true,
        dscr = "Differential",
    },
        fmta(
            "<>\\odif{<>}",
            {
                f( function(_, snip) return snip.captures[1] end ),
                i(1),
            }
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
        trig = "([%w%)%]%}]);",
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
        trig = "([%w%)%]%}])'",
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
        trig = "([%w%)%]%}]),;",
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
        trig = "([%w%)%]%}]),'",
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
        trig = "(%^[^%s%}]-)pp",
        wordTrig = false,
        regTrig = true,
        dscr = "Prime"
    },
        fmta(
            "<>\\prime",
            { f( function(_, snip) return snip.captures[1] end ) }
        ),
        { condition = in_mathzone }
    ),

    s({
        trig = "([%w%)%]%}]):([%w])",
        wordTrig = false,
        regTrig = true,
        dscr = "First alphanumeric character into a subscript"
    },
        fmta(
            "<>_{<>}",
            {
                f( function(_, snip) return snip.captures[1] end ),
                f( function(_, snip) return snip.captures[2] end )
            }
        ),
        { condition = in_mathzone }
    ),

    s({
        trig = "([%w%)%]%}])\"([%w])",
        wordTrig = false,
        regTrig = true,
        dscr = "First alphanumeric character into a superscript"
    },
        fmta(
            "<>^{<>}",
            {
                f( function(_, snip) return snip.captures[1] end ),
                f( function(_, snip) return snip.captures[2] end )
            }
        ),
        { condition = in_mathzone }
    ),

    s({
        trig = "([%w%)%]%}])%+%+",
        wordTrig = false,
        regTrig = true,
        dscr = "Superscript plus"
    },
        fmta(
            "<>^{+}",
            { f( function(_, snip) return snip.captures[1] end ) }
        ),
        { condition = in_mathzone }
    ),

    s({
        trig = "([%w%)%]%}])%-%-",
        wordTrig = false,
        regTrig = true,
        dscr = "Superscript minus"
    },
        fmta(
            "<>^{-}",
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

    s({
        trig = ">=",
        dscr = "Greater than or equal to"
    },
        t( "\\geq" ),
        { condition = in_mathzone }
    ),

    s({
        trig = "<=",
        dscr = "Lower than or equal to"
    },
        t( "\\leq" ),
        { condition = in_mathzone }
    ),

    s({
        trig = ">>",
        dscr = "Much great than"
    },
        t( "\\gg" ),
        { condition = in_mathzone }
    ),

    s({
        trig = "<<",
        dscr = "Much less than"
    },
        t( "\\ll" ),
        { condition = in_mathzone }
    ),

    s({
        trig = "!=",
        dscr = "Not equal to"
    },
        t( "\\neq" ),
        { condition = in_mathzone }
    ),

    s({
        trig = "~~",
        dscr = "Approximately equal to"
    },
        t( "\\approx" ),
        { condition = in_mathzone }
    ),

    s({
        trig = ">~",
        dscr = "Greater than or approximately equal to"
    },
        t( "\\gtrapprox" ),
        { condition = in_mathzone }
    ),

    s({
        trig = "<~",
        dscr = "Less than or approximately equal to"
    },
        t( "\\lessapprox" ),
        { condition = in_mathzone }
    ),
}

-- Create autosnippets for Greek letters
local greek_letters = {
    ["a"] = "\\alpha",
    ["b"] = "\\beta",
    ["g"] = "\\gamma",
    ["d"] = "\\delta",
    ["e"] = "\\epsilon",
    ["z"] = "\\zeta",
    ["h"] = "\\eta",
    ["o"] = "\\theta",
    ["k"] = "\\kappa",
    ["l"] = "\\lambda",
    ["m"] = "\\mu",
    ["n"] = "\\nu",
    ["x"] = "\\xi",
    ["i"] = "\\pi",
    ["r"] = "\\rho",
    ["s"] = "\\sigma",
    ["t"] = "\\tau",
    ["u"] = "\\upsilon",
    ["f"] = "\\phi",
    ["c"] = "\\chi",
    ["p"] = "\\psi",
    ["w"] = "\\omega",
}

for trig, latex in pairs(greek_letters) do
    local letter = string.gsub(latex, "\\", "")
    local snippet = s(
        {
            trig = ";" .. trig,
            dscr = "Expand to greek letter " .. letter,
        },
        t(latex),
        { condition = in_mathzone }
    )
    table.insert(autosnippets, snippet)
    -- Capital greek letter
    trig = string.upper(trig)
    letter = string.gsub(letter, "^(%l)", string.upper)
    snippet = s(
        {
            trig = ";" .. trig,
            dscr = "Expand to greek letter " .. letter,
        },
        t("\\" .. letter),
        { condition = in_mathzone }
    )
    table.insert(autosnippets, snippet)
end

-- Create autosnippets for SI units
local si_units = {
    ["Q"] = "\\Quetta",
    ["R"] = "\\Ronna",
    ["Y"] = "\\yotta",
    ["Z"] = "\\zetta",
    ["E"] = "\\exa",
    ["P"] = "\\peta",
    ["T"] = "\\tera",
    ["G"] = "\\giga",
    ["M"] = "\\mega",
    ["k"] = "\\kilo",
    ["he"] = "\\hecto",
    ["da"] = "\\deca",
    ["de"] = "\\deci",
    ["ce"] = "\\centi",
    ["mi"] = "\\milli",
    ["mu"] = "\\micro",
    ["n"] = "\\nano",
    ["pi"] = "\\pico",
    ["f"] = "\\femto",
    ["a"] = "\\atto",
    ["z"] = "\\zepto",
    ["y"] = "\\yocto",
    ["r"] = "\\ronto",
    ["q"] = "\\quecto",
    ["me"] = "\\metre",
    ["se"] = "\\second",
    ["g"] = "\\gram",
    ["N"] = "\\newton",
    ["J"] = "\\joule",
    ["hz"] = "\\hertz",
    ["K"] = "\\kelvin",
    ["pa"] = "\\pascal",
    ["O"] = "\\ohm",
    ["V"] = "\\volt",
    ["W"] = "\\watt",
    ["rad"] = "\\radian",
    ["ev"] = "\\electronvolt",
    ["b"] = "\\barn",
    ["pc"] = "\\parsec",
    ["sq"] = "\\square",
    ["cu"] = "\\cubic",
    ["p2"] = "\\tothe{2}",
    ["p3"] = "\\tothe{3}",
    ["p4"] = "\\tothe{4}",
    ["p5"] = "\\tothe{5}",
    ["pp"] = "\\percent",
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
                dscr = "Expand in siunitx " .. cmd .. " : '" .. si_prefix .. "' -> '" .. latex .. "'",
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
