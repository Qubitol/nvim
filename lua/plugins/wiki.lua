return {
    "lervag/wiki.vim",
    version = "*",
    dependencies = {
        "MeanderingProgrammer/render-markdown.nvim",
        "itchyny/calendar.vim",
        "junegunn/vim-easy-align",
        {
            "dhruvasagar/vim-table-mode",
            init = function()
                vim.g.table_mode_tableize_map = "<Leader>to"
            end,
        },
        "qadzek/link.vim",
    },
    ft = "markdown",
    init = function()
        vim.g.wiki_root = os.getenv("HOME") .. "/Research/Wiki"
        vim.g.wiki_journal = {
            name = "Journal",
        }
        vim.g.wiki_journal_index = {
            reverse = true,
        }
        vim.g.wiki_mappings_local_journal = {
            ["<plug>(wiki-journal-prev)"] = "[w",
            ["<plug>(wiki-journal-next)"] = "]w",
        }

        local CONFIG = os.getenv("XDG_CONFIG_HOME")
        local wiki_group = vim.api.nvim_create_augroup("Wiki", {})
        vim.api.nvim_create_autocmd("BufNewFile", {
            group = wiki_group,
            pattern = vim.g.wiki_root .. "/Journal/*.md",
            callback = function()
                local command = ":silent 0r !" .. CONFIG .. "/nvim/bin/generate-wiki-research-journal-template '%:t'"
                vim.cmd(command)
            end,
        })
        vim.api.nvim_create_autocmd("FileType", {
            group = wiki_group,
            pattern = "calendar",
            callback = function()
                vim.keymap.set("n", "<CR>", function()
                    vim.cmd([[
                    let b:view = b:calendar.view.get_calendar_views()
                    let b:year = printf("%02d", b:calendar.day().get_year())
                    let b:month = printf("%02d", b:calendar.day().get_month())
                    if b:view == 'year'
                        let b:cmd = '<cmd>Calendar -position=here -view=month -year=' . b:year . ' -month=' . b:month . '<CR>'
                    elseif b:view == 'day'
                        let b:cmd = ""
                    else "If it is not year or day then I want to open the journal for the selected day
                        let b:calendar_buf_nr = bufnr()
                        let b:day = printf("%02d", b:calendar.day().get_day())
                        let b:cmd = '<C-w>w<cmd>call wiki#journal#open("' . b:year . '-' . b:month . '-' . b:day . '") | bdelete ' . b:calendar_buf_nr . '<CR>'
                    endif
                    ]])
                    local cmd = vim.b.cmd
                    return cmd
                end, { buffer = true, expr = true, noremap = true, silent = true })
            end,
        })
    end,
}
