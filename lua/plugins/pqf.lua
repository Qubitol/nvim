local status_ok, pqf = pcall(require, "pqf")
if not status_ok then
	return
end

pqf.setup({
	signs = {
        error = "",
        warning = "",
        info = "",
        hint = "",
	},
	show_multiple_lines = false,
})
