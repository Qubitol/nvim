-- gh-link.lua
-- LuaSnip snippet: type gh#123, pick a repo via choice node,
-- expands into [repo#123](https://github.com/owner/repo/issues/123)

-----------------------------------------------------------------------
-- CONFIG: add/remove repos here. Keys = display names, values = base URL.
-----------------------------------------------------------------------
local repos = {
  MadGraph7 = "https://github.com/MadGraphTeam/MadGraph7",
  mg5amcnlo = "https://github.com/mg5amcnlo/mg5amcnlo",
  madgraph4gpu = "https://github.com/madgraph5/madgraph4gpu",
}

-- Order matters for cycling, so define it explicitly.
local repo_order = { "MadGraph7", "mg5amcnlo", "madgraph4gpu" }

-----------------------------------------------------------------------

-- Build choice node entries from the ordered list.
local choices = {}
for _, name in ipairs(repo_order) do
  choices[#choices + 1] = t(name)
end

-- Helper: get the issue/PR number from the regex capture.
local function issue_number(_, snip)
  return snip.captures[1]
end

-- Helper: look up the full URL for the currently selected repo.
local function repo_url(args)
  local selected = args[1][1]
  return repos[selected] or "https://github.com/UNKNOWN"
end

local snippets = {

  s({
    trig = "gh#(%d+)",
    regTrig = true,
    wordTrig = false,
    name = "GitHub issue/PR link",
    dscr = "Expand gh#N into a markdown link to a chosen repo",
  }, {
    -- [repoB#123](https://github.com/authorB/repoB/issues/123)
    t("["),
    c(1, choices),
    t("#"),
    f(issue_number),
    t("]("),
    f(repo_url, { 1 }),  -- re-evaluates when choice node changes
    t("/issues/"),
    f(issue_number),
    t(")"),
  }),

}

local autosnippets = {}

return snippets, autosnippets
