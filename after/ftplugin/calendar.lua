local map = require("config.utils").map

map("n", "<CR>", function()
    vim.cmd([[
            let b:view = b:calendar.view.get_calendar_views()
            let b:year = printf("%02d", b:calendar.day().get_year())
            let b:month = printf("%02d", b:calendar.day().get_month())
            if b:view == 'year'
                let b:cmd = '<cmd>Calendar -position=here -view=month -year=' . b:year . ' -month=' . b:month . '<CR>'
            elseif b:view == 'day'
                let b:cmd = ""
            else
                let b:calendar_buf_nr = bufnr()
                let b:day = printf("%02d", b:calendar.day().get_day())
                let b:cmd = '<C-w>w<cmd>call wiki#journal#open("' . b:year . '-' . b:month . '-' . b:day . '") | bdelete ' . b:calendar_buf_nr . '<CR>'
            endif
            ]])
    return vim.b.cmd
end, "Open the wiki journal at that day", { buffer = true, expr = true, noremap = true, silent = true })
