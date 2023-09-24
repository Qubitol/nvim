return {
    "ThePrimeagen/harpoon",
    keys = function()
        local lazy_map = require("utils").lazy_map
        local harpoon_ui = require("harpoon.ui")
        return {
            lazy_map("n", "<leader>ho", harpoon_ui.toggle_quick_menu, "Toggle [H]arpoon menu [O]pening"),
            lazy_map("n", "<leader>hm", require("harpoon.mark").add_file, "Add current file to [H]arpoon [M]arks"),
            lazy_map("n", "<C-h>", function()
                harpoon_ui.nav_file(1)
            end, "Navigate to first mark (mnemonic: [H]jkl)"),
            lazy_map("n", "<C-j>", function()
                harpoon_ui.nav_file(2)
            end, "Navigate to first mark (mnemonic: h[J]kl)"),
            lazy_map("n", "<C-k>", function()
                harpoon_ui.nav_file(3)
            end, "Navigate to first mark (mnemonic: hj[K]l)"),
            lazy_map("n", "<C-l>", function()
                harpoon_ui.nav_file(4)
            end, "Navigate to first mark (mnemonic: hjk[L])"),
        }
    end,
    opts = {
        save_on_toggle = true,
        save_on_change = true,
    },
}
