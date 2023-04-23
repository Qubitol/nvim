local status_ok, _ = pcall(require, "undotree")
if not status_ok then
	return
end

vim.keymap.set("n", "<leader>tu", vim.cmd.UndotreeToggle)
