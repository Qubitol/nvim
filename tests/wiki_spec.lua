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
