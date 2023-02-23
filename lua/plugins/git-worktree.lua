local status_ok, git_worktree = pcall(require, "git-worktree")
if not status_ok then
	return
end

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

git_worktree.on_tree_change(function(op, metadata)
	if op == git_worktree.Operations.Switch then
		print("Switched from " .. metadata.prev_path .. " to " .. metadata.path)
	end
end)
