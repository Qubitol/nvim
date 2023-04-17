local status_ok, harpoon = pcall(require, "harpoon")
if not status_ok then
	return
end

harpoon.setup({
    save_on_toggle = true,
    save_on_change = true,
})

local map = vim.keymap.set
local ui = require("harpoon.ui")
local mark = require("harpoon.mark")
map("n", "<leader>ho", ui.toggle_quick_menu)
map("n", "<leader>hm", mark.add_file)
map("n", "<C-h>", function() ui.nav_file(1) end)
map("n", "<C-j>", function() ui.nav_file(2) end)
map("n", "<C-k>", function() ui.nav_file(3) end)
map("n", "<C-l>", function() ui.nav_file(4) end)
