local status_ok, pqf = pcall(require, "pqf")
if not status_ok then
	return
end

pqf.setup({
	signs = {
        error = vim.fn.sign_getdefined("DiagnosticSignError")[1].text,
        warning = vim.fn.sign_getdefined("DiagnosticSignWarn")[1].text,
        info = vim.fn.sign_getdefined("DiagnosticSignInfo")[1].text,
        hint = vim.fn.sign_getdefined("DiagnosticSignHint")[1].text,
	},
	show_multiple_lines = false,
})
