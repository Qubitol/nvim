return {
    "mbbill/undotree",
    event = "VeryLazy",
    keys = function()
        local lazy_map = require("utils").lazy_map
        return {
            lazy_map("n", "<leader>tu", vim.cmd.UndotreeToggle, "[T]oggle [U]ndotree"),
        }
    end,
}
