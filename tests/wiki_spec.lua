local function equal(actual, expected, message)
    assert(vim.deep_equal(actual, expected), string.format(
        "%s\nexpected: %s\nactual:   %s",
        message,
        vim.inspect(expected),
        vim.inspect(actual)
    ))
end

local dates = require("wiki.dates")
local links = require("wiki.links")
local render = require("wiki.render")
local search = require("wiki.search")
local tags = require("wiki.tags")

local now = os.time({ year = 2026, month = 9, day = 5, hour = 12 })
equal(dates.parse("today", now), "2026-09-05", "today")
equal(dates.parse("yesterday", now), "2026-09-04", "yesterday")
equal(dates.parse("2 weeks ago", now), "2026-08-22", "weeks ago")
equal(dates.parse("3 months ago", now), "2026-06-05", "months ago")
equal(dates.parse("last monday", now), "2026-08-31", "last weekday")
equal(dates.parse("2024-02-29", now), "2024-02-29", "leap day")
assert(select(1, dates.parse("2026-02-30", now)) == nil, "invalid ISO date")

local arguments = assert(dates.parse_arguments('@jorgen --since="2 weeks ago" --until=yesterday', now))
equal(arguments, {
    query = "@jorgen",
    since = "2026-08-22",
    ["until"] = "2026-09-04",
}, "command arguments")

equal(tags.parse_line("Work :bug: :gpu: :p/example: :@alice:"), {
    "bug",
    "gpu",
    "p/example",
    "@alice",
}, "native tags")
equal(tags.parse_lines({
    "outside :bug:",
    "```markdown",
    "inside :gpu:",
    "```",
    "~~~",
    "inside :nvidia:",
    "~~~",
    "outside :result:",
}), {
    [1] = { "bug" },
    [8] = { "result" },
}, "fenced tags")
equal(tags.normalize_mention(":@Jorgen:"), "@Jorgen", "mention normalization")
assert(select(1, tags.normalize_mention("two people")) == nil, "mention whitespace")

local wiki_config = require("wiki.config")
local generic_config = wiki_config.normalized_generic_tags()
equal(generic_config[1].name, "bug", "structured generic tag normalization")
equal(generic_config[2].name, "idea", "string generic tag normalization")
assert(generic_config[1].custom_highlight, "bug retains its custom highlight")
assert(not generic_config[2].custom_highlight, "plain tags inherit the default highlight")
local original_pretty = vim.g.pretty
vim.g.pretty = true
assert(wiki_config.normalize_generic_tag(wiki_config.generic_tags[1]).icon ~= "", "pretty tag icon")
vim.g.pretty = false
equal(wiki_config.normalize_generic_tag(wiki_config.generic_tags[1]).icon, "", "plain tag icon")
vim.g.pretty = original_pretty
equal({ render.classify("p/madgraph.validation") }, { "project", "madgraph.validation" }, "project classification")
equal({ render.classify("@jorgen") }, { "mention", "jorgen" }, "mention classification")
equal({ render.classify("legacy-tag") }, { "generic", "legacy-tag" }, "generic classification")
equal(render.tag_highlight_group("madgraph.validation"), "WikiTagMadgraphValidation", "sanitized highlight")

render.setup()
assert(next(vim.api.nvim_get_hl(0, { name = "WikiTagBug" })) ~= nil, "custom tag highlight")
equal(
    vim.api.nvim_get_hl(0, { name = "WikiTagPython", link = true }).link,
    "DiagnosticWarn",
    "existing highlight group support"
)
vim.api.nvim_exec_autocmds("ColorScheme", {})
assert(next(vim.api.nvim_get_hl(0, { name = "WikiTagNvidia" })) ~= nil, "tag highlight after colorscheme")

local render_source = "outside :bug: `inside :gpu:` :p/madgraph.validation:. :@jorgen: :legacy-tag:"
vim.o.swapfile = false
vim.api.nvim_buf_set_lines(0, 0, -1, false, { render_source })
local render_tree = vim.treesitter.get_string_parser(render_source, "markdown_inline"):parse()[1]
vim.g.pretty = true
local render_marks = render.parse({ buf = 0, root = render_tree:root(), last = true })
vim.g.pretty = original_pretty
equal(#render_marks, 12, "three render marks per tag, excluding inline code")

local bug_prefix, bug_label, bug_suffix = unpack(render_marks, 1, 3)
equal(render_source:sub(bug_prefix.start_col + 1, bug_prefix.opts.end_col), ":", "generic prefix concealment")
equal(bug_prefix.opts.virt_text[1], { " ", "WikiTagBug" }, "only the generic icon is virtual")
equal(render_source:sub(bug_label.start_col + 1, bug_label.opts.end_col), "bug", "generic label is buffer text")
equal(bug_label.opts.hl_group, "WikiTagBug", "real generic label highlight")
assert(not bug_label.conceal and bug_label.opts.virt_text == nil, "generic label is not concealed or virtual")
equal(render_source:sub(bug_suffix.start_col + 1, bug_suffix.opts.end_col), ":", "generic suffix concealment")

local project_prefix, project_label, project_suffix = unpack(render_marks, 4, 6)
equal(render_source:sub(project_prefix.start_col + 1, project_prefix.opts.end_col), ":p/", "project prefix concealment")
equal(project_prefix.opts.virt_text[1], { " ", "WikiProject" }, "only the project icon is virtual")
equal(
    render_source:sub(project_label.start_col + 1, project_label.opts.end_col),
    "madgraph.validation",
    "project label is buffer text"
)
assert(not project_label.conceal and project_label.opts.virt_text == nil, "project label is not concealed or virtual")
equal(render_source:sub(project_suffix.start_col + 1, project_suffix.opts.end_col), ":", "project suffix concealment")
equal(render_source:sub(project_suffix.opts.end_col + 1, project_suffix.opts.end_col + 1), ".", "adjacent punctuation")

local mention_prefix, mention_label = unpack(render_marks, 7, 8)
equal(render_source:sub(mention_prefix.start_col + 1, mention_prefix.opts.end_col), ":@", "mention prefix concealment")
equal(render_source:sub(mention_label.start_col + 1, mention_label.opts.end_col), "jorgen", "mention label is buffer text")
assert(not mention_label.conceal and mention_label.opts.virt_text == nil, "mention label is not concealed or virtual")

local historical_label = render_marks[11]
equal(historical_label.opts.hl_group, "WikiTagDefault", "historical tag fallback")
equal(
    vim.api.nvim_buf_get_lines(0, 0, 1, false)[1],
    render_source,
    "render marks leave serialized tags unchanged"
)
vim.g.pretty = false
local plain_render_marks = render.parse({ buf = 0, root = render_tree:root(), last = true })
vim.g.pretty = original_pretty
assert(plain_render_marks[1].opts.virt_text == nil, "plain mode adds no virtual tag icon")
equal(
    render_source:sub(plain_render_marks[2].start_col + 1, plain_render_marks[2].opts.end_col),
    "bug",
    "plain mode keeps the real tag label"
)

vim.api.nvim_buf_set_lines(0, 0, -1, false, {
    "outside",
    "```markdown",
    "fenced :nvidia:",
    "```",
})
vim.treesitter.get_parser(0, "markdown"):parse(true)
local nested_source = "\n\nfenced :nvidia:"
local nested_tree = vim.treesitter.get_string_parser(nested_source, "markdown_inline"):parse()[1]
equal(
    render.parse({ buf = 0, root = nested_tree:root(), last = true }),
    {},
    "wiki render marks exclude fenced code injections"
)

local original_render_state = package.loaded["render-markdown.state"]
local original_render_ui = package.loaded["render-markdown.core.ui"]
local cursor_config = { anti_conceal = { enabled = false } }
local cursor_updates = 0
local cursor_update_force
package.loaded["render-markdown.state"] = {
    get = function()
        return cursor_config
    end,
}
package.loaded["render-markdown.core.ui"] = {
    update = function(_, _, _, force)
        cursor_updates = cursor_updates + 1
        cursor_update_force = force
    end,
}
equal(render.toggle_cursor_conceal(), false, "cursor-line concealment disabled")
assert(cursor_config.anti_conceal.enabled, "anti-conceal enabled for cursor-line reveal")
equal(render.toggle_cursor_conceal(), true, "cursor-line concealment restored")
assert(not cursor_config.anti_conceal.enabled, "anti-conceal disabled for cursor-line rendering")
equal(cursor_updates, 2, "cursor-line toggle refreshes render-markdown")
equal(cursor_update_force, false, "cursor-line toggle uses a display-only refresh")
package.loaded["render-markdown.state"] = original_render_state
package.loaded["render-markdown.core.ui"] = original_render_ui

local original_fzf_tags = package.loaded["fzf-lua"]
package.loaded["fzf-lua"] = {
    fzf_exec = function(contents, options)
        equal(contents[1], "bug", "structured picker entry uses its semantic name")
        equal(contents[2], "idea", "plain picker entry remains unchanged")
        options.actions.enter({ "python", "bug" })
    end,
}
vim.api.nvim_buf_set_lines(0, 0, -1, false, { "" })
vim.api.nvim_win_set_cursor(0, { 1, 0 })
tags.pick_generic()
equal(
    vim.api.nvim_get_current_line(),
    ":bug: :python:",
    "picker serializes structured tags in configured order"
)
package.loaded["fzf-lua"] = original_fzf_tags

local headings = {
    "# GPU",
    "## Results",
    "```markdown",
    "## Not a heading",
    "```",
    "## Results",
    "body",
}
equal(links.heading_before_lines(headings, 7), {
    text = "Results",
    slug = "results-1",
    line = 6,
}, "duplicate heading anchors")

local temporary = vim.fn.tempname()
local journal = vim.fs.joinpath(temporary, "Journal")
local topics = vim.fs.joinpath(temporary, "topics")
vim.fn.mkdir(journal, "p")
vim.fn.mkdir(topics, "p")
vim.g.wiki_root = temporary
vim.g.wiki_journal = {
    name = "Journal",
    root = "",
    frequency = "daily",
    date_format = {
        daily = "%Y-%m-%d",
        weekly = "%Y_w%V",
        monthly = "%Y_m%m",
    },
}

local today = vim.fs.joinpath(journal, "2026-09-05.md")
local yesterday = vim.fs.joinpath(journal, "2026-09-04.md")
local topic = vim.fs.joinpath(topics, "gpu.md")
vim.fn.writefile({
    "# 2026-09-05",
    "older :bug: :gpu: :p/example:",
    "```",
    "ignored :bug:",
    "```",
    "newer :@alice: :request:",
}, today)
vim.fn.writefile({ "# 2026-09-04", "previous :result:" }, yesterday)
vim.fn.writefile({ "# GPU", "topical :nvidia: :gpu:" }, topic)

equal(links.journal_target(today).date, "2026-09-05", "configured journal detection")
equal(
    links.build_link(today, topic, headings, 7),
    "[gpu](../topics/gpu.md#results-1)",
    "topical alternate link"
)
equal(
    links.build_link(topic, today, { "# 2026-09-05", "## Meeting", "text" }, 3),
    "[2026-09-05](journal:2026-09-05#meeting)",
    "journal alternate link"
)

local candidates = assert(search.collect(temporary, {}))
equal(#candidates, 4, "one search candidate per tagged line")
equal({ candidates[1].journal_date, candidates[1].line }, { "2026-09-05", 6 }, "journal order")
equal({ candidates[2].journal_date, candidates[2].line }, { "2026-09-05", 2 }, "journal line order")
equal(candidates[3].journal_date, "2026-09-04", "journal date order")
equal(candidates[4].relative_path, "topics/gpu.md", "topical results follow journals")
equal(candidates[2].tags, { "bug", "gpu", "p/example" }, "line tag aggregation")

local filtered = assert(search.collect(temporary, {
    since = "2026-09-05",
    ["until"] = "2026-09-05",
}))
equal(#filtered, 2, "inclusive date-filtered journal search")
assert(vim.tbl_isempty(vim.tbl_filter(function(candidate)
    return not candidate.is_journal
end, filtered)), "date filtering is journal-only")

local original_fzf = package.loaded["fzf-lua"]
package.loaded["fzf-lua"] = {
    fzf_exec = function(contents, options)
        local function gather()
            local emitted = {}
            contents(function(entry)
                if entry then
                    emitted[#emitted + 1] = entry
                end
            end)
            return emitted
        end

        equal(options.query, "@alice", "initial fzf query")
        assert(options.winopts.preview.hidden, "preview starts hidden")
        equal(#gather(), 4, "unrestricted picker contents")
        assert(options.actions["ctrl-j"], "journal toggle is available")
        options.actions["ctrl-j"].fn()
        equal(#gather(), 1, "journal toggle hides journal candidates")
        options.actions["ctrl-j"].fn()
        equal(#gather(), 4, "journal toggle restores journal candidates")
    end,
}
search.find("@alice")
package.loaded["fzf-lua"] = original_fzf

require("wiki").setup({ load_plugins = false })
for _, command in ipairs({
    "WikiTagFind",
    "WikiMentions",
    "WikiProjectTags",
    "WikiTagInsert",
    "WikiProjectTag",
    "WikiMention",
    "WikiLinkAlternate",
}) do
    assert(vim.fn.exists(":" .. command) == 2, command .. " was not registered")
end
for _, mapping in ipairs({ "<C-g>t", "<C-g>m", "<C-g>p" }) do
    assert(vim.fn.maparg(mapping, "i") ~= "", mapping .. " was not registered in Insert mode")
end
for _, builtin in ipairs({ "<C-t>", "<C-m>", "<C-p>" }) do
    assert(vim.fn.maparg(builtin, "i") == "", builtin .. " was unexpectedly replaced")
end

local new_journal = vim.fs.joinpath(journal, "2026-09-06.md")
vim.o.swapfile = false
vim.cmd.edit(vim.fn.fnameescape(new_journal))
assert(vim.api.nvim_buf_get_lines(0, 0, 1, false)[1]:match("^# 2026%-09%-06"), "journal template")
vim.cmd("bdelete!")

vim.fn.delete(temporary, "rf")
print("wiki_spec: ok")
