return {
    "itchyny/calendar.vim",
    cmd = "Calendar",
    keys = function()
        local lazy_map = require("utils").lazy_map
        return {
            lazy_map(
                "n",
                "<leader>co",
                "<cmd>Calendar -date_month_name -view=month -split=horizontal -position=below -height=25<CR>",
                "[C]alendar ([O]pen) for the current month"
            ),
            lazy_map(
                "n",
                "<leader>cy",
                "<cmd>Calendar -date_full_month_name -view=year -position=here<CR>",
                "[C]alendar for the current [Y]ear"
            ),
        }
    end,
}
