local luasnip = require("utils.luasnip")
local get_visual = luasnip.get_visual
local in_mathzone = luasnip.in_mathzone
local in_text = luasnip.in_text

local set_label = function(args, _, _)
    local outs = string.gsub(args[1][1], "%$", "")
    outs = string.gsub(outs, "\\texorpdfstring{[^{]-}{([^{]-)}", "%1")
    outs = string.gsub(outs, "\\text(%w*)", "%1")
    outs = string.gsub(outs, "\\%w*", "")
    outs = string.gsub(outs, "%s", "_")
    outs = string.gsub(outs, "['\"%%{}()*[%]@#$?^<>,]", "")
    return string.lower(outs)
end

local snippets = {}

local autosnippets = {

    s({
        trig = "...",
        dscr = "Dots"
    },
        t("\\dots")
    ),

    s({
        trig = "cha",
        dscr = "Chapter"
    },
        -- c(1, {
        --     sn(nil, fmta(
        --         [[
        --             \chapter{<>}
        --
        --         ]],
        --         { r(1, "the_title") }
        --     )),
        --     sn(nil, fmta(
        --         [[
        --             \chapter{<>}
        --             \label{ch:<>}
        --
        --         ]],
        --         {
        --             r(1, "the_title"),
        --             f(set_label, {1}),
        --         }
        --     ))
        -- }),
        -- c(1, {
        --     sn(nil, { t("\\chapter{"), r(1, "the_title"), t({ "}", "" }) }),
        --     sn(nil, {
        --         t("\\chapter{"), r(1, "the_title"), t({ "}", "" }),
        --         t("\\label{ch:"), f(set_label, {1}), t({ "}", "" })
        --     })
        -- })},
        -- {
        --     stored = { ["the_title"] = i(1, "title") },
        --     condition = conds.line_begin
        -- }
        fmta(
            [[
                \chapter{<>}
                \label{ch:<>}

            ]],
            {
                i(1, "title"),
                f(set_label, {1}),
            }
        ),
        { condition = conds.line_begin }
    ),

    s({
        trig = "sec",
        dscr = "Section"
    },
        fmta(
            [[
                \section{<>}
                \label{sec:<>}

            ]],
            {
                i(1, "title"),
                f(set_label, {1}),
            }
        ),
        { condition = conds.line_begin }
    ),

    s({
        trig = "sse",
        dscr = "Subsection"
    },
        fmta(
            [[
                \subsection{<>}
                \label{ssec:<>}

            ]],
            {
                i(1, "title"),
                f(set_label, {1}),
            }
        ),
        { condition = conds.line_begin }
    ),

    s({
        trig = "sss",
        dscr = "Subsubsection"
    },
        fmta(
            [[
                \subsubsection{<>}
                \label{sssec:<>}

            ]],
            {
                i(1, "title"),
                f(set_label, {1}),
            }
        ),
        { condition = conds.line_begin }
    ),

    s({
        trig = "benv",
        dscr = "Generic environment"
    },
        fmta(
            [[
                \begin{<>}
                    <>
                \end{<>}

            ]],
            {
                i(1, "environment"),
                d(2, get_visual),
                rep(1)
            }
        ),
        { condition = conds.line_begin }
    ),

    s({
        trig = "bit",
        dscr = "Itemize"
    },
        fmta(
            [[
                \begin{itemize}
                    \item <>
                \end{itemize}

            ]],
            { i(0) }
        ),
        { condition = conds.line_begin }
    ),

    s({
        trig = "benu",
        dscr = "Enumerate"
    },
        fmta(
            [[
                \begin{enumerate}
                    \item <>
                \end{enumerate}

            ]],
            { i(0) }
        ),
        { condition = conds.line_begin }
    ),

    s({
        trig = "([^%a])tbf",
        wordTrig = false,
        regTrig = true,
        dscr = "Bold"
    },
        fmta(
            "<>\\textbf{<>}",
            {
                f( function(_, snip) return snip.captures[1] end ),
                d(1, get_visual)
            }
        ),
        { condition = in_text }
    ),

    s({
        trig = "([^%a])tph",
        wordTrig = false,
        regTrig = true,
        dscr = "Emphasis"
    },
        fmta(
            "<>\\emph{<>}",
            {
                f( function(_, snip) return snip.captures[1] end ),
                d(1, get_visual)
            }
        ),
        { condition = in_text }
    ),

    s({
        trig = "([^%a])ttt",
        wordTrig = false,
        regTrig = true,
        dscr = "Monospace"
    },
        fmta(
            "<>\\texttt{<>}",
            {
                f( function(_, snip) return snip.captures[1] end ),
                d(1, get_visual)
            }
        ),
        { condition = in_text }
    ),

    s({
        trig = "([^%a])mrm",
        wordTrig = false,
        regTrig = true,
        dscr = "Mathrm"
    },
        fmta(
            "<>\\mathrm{<>}",
            {
                f( function(_, snip) return snip.captures[1] end ),
                d(1, get_visual)
            }
        ),
        { condition = in_mathzone }
    ),

    s({
        trig = "([^%a])mcc",
        wordTrig = false,
        regTrig = true,
        dscr = "Mathcal"
    },
        fmta(
            "<>\\mathcal{<>}",
            {
                f( function(_, snip) return snip.captures[1] end ),
                d(1, get_visual)
            }
        ),
        { condition = in_mathzone }
    ),

}

return snippets, autosnippets
