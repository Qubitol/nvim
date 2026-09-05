local config = require("wiki.config")
local links = require("wiki.links")
local projects = require("wiki.projects")
local search = require("wiki.search")
local tags = require("wiki.tags")

local M = {}

local function create_commands()
    vim.api.nvim_create_user_command("WikiTagFind", function(command)
        search.find(command.args)
    end, { nargs = "*", desc = "Browse tagged wiki lines" })

    vim.api.nvim_create_user_command("WikiMentions", function()
        search.find("@")
    end, { desc = "Browse wiki mentions" })

    vim.api.nvim_create_user_command("WikiProjectTags", function()
        search.find("p/")
    end, { desc = "Browse wiki project tags" })

    vim.api.nvim_create_user_command("WikiTagInsert", tags.pick_generic, {
        desc = "Insert generic wiki tags",
    })

    vim.api.nvim_create_user_command("WikiProjectTag", projects.pick, {
        desc = "Insert a Taskwarrior project tag",
    })

    vim.api.nvim_create_user_command("WikiMention", function(command)
        if command.args == "" then
            tags.prompt_mention()
        else
            tags.insert_mention(command.args)
        end
    end, { nargs = "?", desc = "Insert a person mention" })

    vim.api.nvim_create_user_command("WikiLinkAlternate", function(command)
        links.insert_alternate(command.count > 0)
    end, { count = true, desc = "Insert a Markdown link to the alternate buffer" })
end

local function create_mappings()
    local map = require("config.utils").map
    local mappings = config.mappings

    map("n", mappings.alternate_link, function()
        links.insert_alternate(vim.v.count > 0)
    end, "Insert Markdown link to alternate buffer")
    map("n", mappings.generic_tags, tags.pick_generic, "Insert wiki tag(s)")
    map("n", mappings.project_tag, projects.pick, "Insert Taskwarrior project tag")
    map("n", mappings.mention, tags.prompt_mention, "Insert person mention")
    map("i", mappings.insert_generic_tags, tags.pick_generic, "Insert wiki tag(s)")
    map("i", mappings.insert_mention, tags.prompt_mention, "Insert person mention")
    map("i", mappings.insert_project_tag, projects.pick, "Insert Taskwarrior project tag")
    map("n", mappings.tag_find, function()
        search.find("")
    end, "Find tagged wiki lines")
    map("n", mappings.mentions, function()
        search.find("@")
    end, "Find wiki mentions")
    map("n", mappings.projects, function()
        search.find("p/")
    end, "Find wiki project tags")
end

local function create_journal_template_autocommand()
    local group = vim.api.nvim_create_augroup("WikiAutomation", { clear = true })
    vim.api.nvim_create_autocmd("BufNewFile", {
        group = group,
        pattern = "*.md",
        callback = function(event)
            -- Resolve this at event time: vim.pack.add() may still be finishing
            -- wiki.vim's initialization while the main config is sourced.
            local path = vim.api.nvim_buf_get_name(event.buf)
            if not links.journal_target(path) then
                return
            end

            local generator = vim.fs.joinpath(vim.fn.stdpath("config"), "bin", "generate-wiki-research-journal-template")
            local ok, result = pcall(function()
                return vim.system({ generator, vim.fs.basename(path) }, { text = true }):wait()
            end)
            if not ok then
                vim.notify("Could not generate wiki journal template", vim.log.levels.ERROR, { title = "Wiki" })
                return
            end
            if result.code ~= 0 then
                vim.notify("Could not generate wiki journal template", vim.log.levels.ERROR, { title = "Wiki" })
                return
            end

            local lines = vim.split(result.stdout or "", "\n", { plain = true })
            if lines[#lines] == "" then
                table.remove(lines)
            end
            vim.api.nvim_buf_set_lines(event.buf, 0, -1, false, lines)
        end,
    })
end

---@param options? { load_plugins?: boolean }
function M.setup(options)
    if M._did_setup then
        return
    end

    options = options or {}
    if options.load_plugins ~= false then
        require("wiki.plugins")
    end

    M._did_setup = true

    create_commands()
    create_mappings()
    create_journal_template_autocommand()
end

return M
