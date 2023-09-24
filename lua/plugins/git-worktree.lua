return {
    -- "ThePrimeagen/git-worktree.nvim",
    "brandoncc/git-worktree.nvim",
    branch = "catch-and-handle-telescope-related-error",
    lazy = true,
    config = function()
        -- op = Operations.Switch, Operations.Create, Operations.Delete
        -- metadata = table of useful values (structure dependent on op)
        --      Switch
        --          path = path you switched to
        --          prev_path = previous worktree path
        --      Create
        --          path = path where worktree created
        --          branch = branch name
        --          upstream = upstream remote name
        --      Delete
        --          path = path where worktree deleted
        local git_worktree = require("git-worktree")
        git_worktree.on_tree_change(function(op, metadata)
            if op == git_worktree.Operations.Switch then
                print("Switched from " .. metadata.prev_path .. " to " .. metadata.path)
            end
        end)
    end,
}
