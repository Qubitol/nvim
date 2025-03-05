return {
    "lervag/wiki.vim",
    version = "*",
    dependencies = {
        "MeanderingProgrammer/render-markdown.nvim",
        {
            "itchyny/calendar.vim",
            keys = function()
                local lazy_map = require("utils").lazy_map
                return {
                    lazy_map(
                        "n",
                        "<leader>oc",
                        "<cmd>Calendar -date_month_name -view=month -split=horizontal -position=below -height=25<CR>",
                        "[O]pen [C]alendar for the current month"
                    ),
                }
            end,
        },
        "junegunn/vim-easy-align",
        "dhruvasagar/vim-table-mode",
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
                    vim.cmd([[let _year = printf("%02d", b:calendar.day().get_year())]])
                    vim.cmd([[let _month = printf("%02d", b:calendar.day().get_month())]])
                    vim.cmd([[let _day = printf("%02d", b:calendar.day().get_day())]])
                    return [[<C-W>q<cmd>call wiki#journal#open(_year . "-" . _month . "-" . _day)<CR>]]
                end, { buffer = true, expr = true, noremap = true, silent = true })
            end,
        })
    end,
}
