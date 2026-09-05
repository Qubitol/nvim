local config = require("wiki.config")
local tags = require("wiki.tags")

local M = {}

local function open_picker(projects, target)
    require("fzf-lua").fzf_exec(projects, {
        prompt = "Project> ",
        winopts = {
            title = { { " Taskwarrior projects ", "FzfLuaTitle" } },
            title_pos = "center",
        },
        actions = {
            ["enter"] = function(selected)
                local project = selected and selected[1]
                if not project or project == "" then
                    return
                end
                tags.insert_text(":" .. config.namespaces.project .. project .. ":", target)
            end,
        },
    })
end

function M.pick()
    local target = tags.capture_target()

    vim.system({ "task", "_unique", "project" }, { text = true }, function(result)
        vim.schedule(function()
            if result.code ~= 0 then
                vim.notify("Could not read Taskwarrior projects", vim.log.levels.ERROR, {
                    title = "Wiki project",
                })
                return
            end

            local projects = {}
            local seen = {}
            for project in (result.stdout or ""):gmatch("[^\r\n]+") do
                project = vim.trim(project)
                if project ~= "" and not seen[project] then
                    projects[#projects + 1] = project
                    seen[project] = true
                end
            end
            table.sort(projects)

            if #projects == 0 then
                vim.notify("No Taskwarrior projects found", vim.log.levels.INFO, {
                    title = "Wiki project",
                })
                return
            end

            open_picker(projects, target)
        end)
    end)
end

return M
