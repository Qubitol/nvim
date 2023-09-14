local status_ok, harpoon = pcall(require, "harpoon")
if not status_ok then
	return
end

local utils = require("core.utils")
local mappings = require("core.mappings")

harpoon.setup({
    save_on_toggle = true,
    save_on_change = true,
})

utils.load_mappings(mappings.plugins["harpoon"])
