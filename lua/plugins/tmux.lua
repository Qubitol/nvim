return {
    "aserowy/tmux.nvim",
    opts = {
        copy_sync = {
            enable = false,
            sync_clipboard = false,
            sync_registers = false,
            sync_deletes = false,
            sync_unnamed = false,
        },
        navigation = {
            enable_default_keybindings = false,
            persist_zoom = false,
        },
        resize = {
            enable_default_keybindings = false,
            resize_step_x = 5,
            resize_step_y = 5,
        },
    },
    keys = function()
        local lazy_map = require("utils").lazy_map
        local tmux = require("tmux")
        return {
            lazy_map("n", "<A-r>h", function()
                tmux.resize_left()
            end, "Resize left [h] (tmux aware)"),
            lazy_map("n", "<A-r>j", function()
                tmux.resize_bottom()
            end, "Resize bottom [j] (tmux aware)"),
            lazy_map("n", "<A-r>k", function()
                tmux.resize_top()
            end, "Resize top [k] (tmux aware)"),
            lazy_map("n", "<A-r>l", function()
                tmux.resize_right()
            end, "Resize right [l] (tmux aware)"),
            lazy_map("n", "<A-r><enter>", "<Nop>", "Exit resize mode"),
        }
    end,
}
