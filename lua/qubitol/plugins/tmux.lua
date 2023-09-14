local status_ok, tmux = pcall(require, "tmux")
if not status_ok then
	return
end

tmux.setup({
    copy_sync = {
        enable = false,
    },

    navigation = {
        -- cycles to opposite pane while navigating into the border
        cycle_navigation = true,

        -- enables default keybindings (C-hjkl) for normal mode
        enable_default_keybindings = false,

        -- prevents unzoom tmux when navigating beyond vim border
        persist_zoom = false,
    },

    resize = {
        -- enables default keybindings (A-hjkl) for normal mode
        enable_default_keybindings = false,

        -- sets resize steps for x axis
        resize_step_x = 2,

        -- sets resize steps for y axis
        resize_step_y = 2,
    }
})

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Navigate
map("n", "<C-w>h", [[<cmd>lua require("tmux").move_left()<cr>]], opts)
map("n", "<C-w>j", [[<cmd>lua require("tmux").move_bottom()<cr>]], opts)
map("n", "<C-w>k", [[<cmd>lua require("tmux").move_top()<cr>]], opts)
map("n", "<C-w>l", [[<cmd>lua require("tmux").move_right()<cr>]], opts)

-- Resize
map("n", "<A-r>h", [[<cmd>lua require("tmux").resize_left()<cr>]], opts)
map("n", "<A-r>j", [[<cmd>lua require("tmux").resize_bottom()<cr>]], opts)
map("n", "<A-r>k", [[<cmd>lua require("tmux").resize_top()<cr>]], opts)
map("n", "<A-r>l", [[<cmd>lua require("tmux").resize_right()<cr>]], opts)
map("n", "<A-r><enter>", "<nop>", opts)
