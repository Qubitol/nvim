-- Wiki

local map = require("config.utils").map
local icons = require("config.ui").icons.render_markdown

-- Devicons: only when pretty mode is on
if vim.g.pretty then
    vim.pack.add({ "https://github.com/nvim-tree/nvim-web-devicons" })
    require("nvim-web-devicons").setup({
        override = {
            zsh = { icon = "", color = "#428850", cterm_color = "65", name = "Zsh" },
        },
        color_icons = true,
        default = true,
        strict = true,
        override_by_filename = {
            [".gitignore"] = { icon = "", color = "#f1502f", name = "Gitignore" },
        },
        override_by_extension = {
            ["log"] = { icon = "", color = "#81e043", name = "Log" },
        },
    })
end

-- Image rendering (kitty-only)
if vim.g.pretty and vim.env.TERM == "xterm-kitty" or vim.env.TERM_PROGRAM == "kitty" then
    vim.pack.add({ "https://github.com/3rd/image.nvim" })
    require("image").setup({
        backend = "kitty",
        integrations = {
            markdown = {
                enabled = true,
                clear_in_insert_mode = false,
                download_remote_images = true,
                only_render_image_at_cursor = true,
            },
            neorg = { enabled = false },
            typst = { enabled = false },
            html = { enabled = false },
            css = { enabled = false },
        },
        tmux_show_only_in_active_window = true,
        latex = { enabled = false }, -- to disable warnings
    })
end

-- Calendar
vim.pack.add({ "https://github.com/itchyny/calendar.vim" })

map(
    "n",
    "<leader>cm",
    "<cmd>Calendar -date_month_name -view=month -split=horizontal -position=below -height=25<CR>",
    "[C]alendar for the current [M]onth"
)
map(
    "n",
    "<leader>cy",
    "<cmd>Calendar -date_full_month_name -view=year -position=here<CR>",
    "[C]alendar for the current [Y]ear"
)

-- Render markdown
vim.pack.add({ "https://github.com/MeanderingProgrammer/render-markdown.nvim" })
require("render-markdown").setup({
    file_types = { 'markdown', 'codecompanion' },
    anti_conceal = { enabled = false },
    render_modes = { "n", "c", "i" },
    win_options = {
        showbreak = { default = "", rendered = "  " },
        breakindent = { default = false, rendered = true },
        breakindentopt = { default = "", rendered = "" },
        concealcursor = { rendered = "nc" },
        conceallevel = { rendered = 2 },
    },
    latex = { enabled = true },
    heading = icons.heading,
    code = icons.code,
    dash = {
        icon = icons.dash,
    },
    bullet = {
        icons = icons.bullet,
    },
    checkbox = {
        unchecked = {
            icon = icons.checkbox.unchecked,
        },
        checked = {
            icon = icons.checkbox.checked,
            scope_highlight = "@markup.strikethrough",
        },
    },
    custom = {
        todo = {
            rendered = icons.custom.todo,
        },
    },
    quote = {
        icon = icons.quote,
        repeat_linebreak = true,
    },
    pipe_table = {
        border = icons.table,
    },
    callout = {
        note = { rendered = icons.callout.note .. "Note" },
        tip = { rendered = icons.callout.tip .. "Tip" },
        important = { rendered = icons.callout.important .. "Important" },
        warning = { rendered = icons.callout.warning .. "Warning" },
        caution = { rendered = icons.callout.caution .. "Caution" },
        abstract = { rendered = icons.callout.abstract .. "Abstract" },
        summary = { rendered = icons.callout.summary .. "Summary" },
        tldr = { rendered = icons.callout.tldr .. "Tldr" },
        info = { rendered = icons.callout.info .. "Info" },
        todo = { rendered = icons.callout.todo .. "Todo" },
        hint = { rendered = icons.callout.hint .. "Hint" },
        success = { rendered = icons.callout.success .. "Success" },
        check = { rendered = icons.callout.check .. "Check" },
        done = { rendered = icons.callout.done .. "Done" },
        question = { rendered = icons.callout.question .. "Question" },
        help = { rendered = icons.callout.help .. "Help" },
        faq = { rendered = icons.callout.faq .. "Faq" },
        attention = { rendered = icons.callout.attention .. "Attention" },
        failure = { rendered = icons.callout.failure .. "Failure" },
        fail = { rendered = icons.callout.fail .. "Fail" },
        missing = { rendered = icons.callout.missing .. "Missing" },
        danger = { rendered = icons.callout.danger .. "Danger" },
        error = { rendered = icons.callout.error .. "Error" },
        bug = { rendered = icons.callout.bug .. "Bug" },
        example = { rendered = icons.callout.example .. "Example" },
        quote = { rendered = icons.callout.quote .. "Quote" },
        cite = { rendered = icons.callout.cite .. "Cite" },
    },
    link = {
        footnote = {
            icon = icons.link.footnote,
        },
        image = icons.link.image,
        email = icons.link.email,
        hyperlink = icons.link.hyperlink,
        wiki = {
            icon = icons.link.wiki,
        },
        custom = {
            web = { icon = icons.link.custom.web },
            apple = { icon = icons.link.custom.apple },
            discord = { icon = icons.link.custom.discord },
            github = { icon = icons.link.custom.github },
            gitlab = { icon = icons.link.custom.gitlab },
            google = { icon = icons.link.custom.google },
            hackernews = { icon = icons.link.custom.hackernews },
            linkedin = { icon = icons.link.custom.linkedin },
            microsoft = { icon = icons.link.custom.microsoft },
            neovim = { icon = icons.link.custom.neovim },
            reddit = { icon = icons.link.custom.reddit },
            slack = { icon = icons.link.custom.slack },
            stackoverflow = { icon = icons.link.custom.stackoverflow },
            steam = { icon = icons.link.custom.steam },
            twitter = { icon = icons.link.custom.twitter },
            wikipedia = { icon = icons.link.custom.wikipedia },
            x = { icon = icons.link.custom.x },
            youtube = { icon = icons.link.custom.youtube },
            youtube_short = { icon = icons.link.custom.youtube_short },
        },
    },
    indent = {
        icon = icons.indent,
    },
})

map("n", "<leader>tc", function()
    require("render-markdown").toggle()
end, "[T]oggle render-markdown [C]oncealment")

-- Table mode and easy align
vim.g.table_mode_tableize_map = "<Leader>to"
vim.pack.add({
    "https://github.com/dhruvasagar/vim-table-mode",
    "https://github.com/junegunn/vim-easy-align",
    "https://github.com/qadzek/link.vim",
})

-- Wiki (must come after its dependencies are on the runtimepath)
vim.g.wiki_root = os.getenv("HOME") .. "/Research/Wiki"
vim.g.wiki_journal = { name = "Journal" }
vim.g.wiki_journal_index = { reverse = true }
vim.g.wiki_mappings_local_journal = {
    ["<plug>(wiki-journal-prev)"] = "[w",
    ["<plug>(wiki-journal-next)"] = "]w",
}

vim.pack.add({ "https://github.com/lervag/wiki.vim" })

-- Wiki autocommands
local wiki_group = vim.api.nvim_create_augroup("Wiki", {})
local CONFIG = os.getenv("XDG_CONFIG_HOME")

vim.api.nvim_create_autocmd("BufNewFile", {
    group = wiki_group,
    pattern = vim.g.wiki_root .. "/Journal/*.md",
    callback = function()
        local command = ":silent 0r !" .. CONFIG .. "/nvim/bin/generate-wiki-research-journal-template '%:t'"
        vim.cmd(command)
    end,
})
