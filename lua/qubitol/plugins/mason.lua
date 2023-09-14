local status_ok, mason = pcall(require, "mason")
if not status_ok then
	return
end

mason.setup({
    ui = {
        height = 0.8,
        width = 60,
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
})
