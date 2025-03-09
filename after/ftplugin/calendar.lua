local set = vim.opt_local
local map = vim.keymap.set

-- highlighting groups
set.winhighlight = "Normal:FileBrowser"

-- open selected day when pressing enter
map("n", "<CR>", function()
    vim.cmd([[
    let b:cmd = '<cmd>Calendar -position=here '
    let b:view = b:calendar.view.get_calendar_views()
    let b:year = printf("%02d", b:calendar.day().get_year())
    let b:month = printf("%02d", b:calendar.day().get_month())
    if b:view == 'year'
        let b:cmd = b:cmd . '-view=month -year=' . b:year . ' -month=' . b:month . '<CR>'
    elseif b:view == 'day'
        let b:cmd = ""
    else "If it is not year or day then I want to display the day even if the view is week, week_4
        let b:day = printf("%02d", b:calendar.day().get_day())
        let b:cmd = b:cmd . '-view=day -year=' . b:year . ' -month=' . b:month . ' -day=' . b:day . '<CR>'
    endif
    ]])
    local cmd = vim.b.cmd
    return cmd
end, { buffer = true, noremap = true, silent = true, expr = true })
