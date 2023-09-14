local status_ok, _ = pcall(require, "null-ls")
if not status_ok then
	return
end

require("plugins.null_ls.config")
