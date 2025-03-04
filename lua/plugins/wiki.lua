return {
    "lervag/wiki.vim",
    version = "*",
    dependencies = {
        "MeanderingProgrammer/render-markdown.nvim",
        "itchyny/calendar.vim",
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
        vim.api.nvim_create_autocmd("BufNewFile", {
            pattern = vim.g.wiki_root .. "/Journal/*.md",
            callback = function()
                local command = ":silent 0r !" .. CONFIG .. "/nvim/bin/generate-wiki-research-journal-template"
                vim.cmd(command)
            end,
        })
    end,
}
