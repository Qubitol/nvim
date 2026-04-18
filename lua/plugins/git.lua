-- Git

local map = require("config.utils").map

vim.pack.add({
    { src = "https://github.com/tpope/vim-fugitive" },
    { src = "https://github.com/lewis6991/gitsigns.nvim" },
})

-- Fugitive mappings
vim.cmd([[cab git Git]]) -- autocomplete "Git" when writing "git"
map("n", "<leader>gs", vim.cmd.Git, "Run [G]it [S]tatus (open vim-fugitive prompt)")
map("n", "<leader>gp", "<cmd>Git push<CR>", "Run a [G]it [P]ush")
map(
    "n",
    "<leader>gf",
    "<cmd>Git pull --rebase<CR>",
    "Run `git pull --rebase` (a [G]it [F]etch followed by a rebase in the current branch)"
)
map("n", "<leader>gP", ":Git push -u origin ", "Populate command line with [G]it [P]ush -u origin", { silent = false })
map(
    "n",
    "<leader>gF",
    ":Git pull --rebase -u origin ",
    "Populate the command line with `git pull --rebase -u origin`",
    { silent = false }
)
map("n", "<leader>gb", "<cmd>Git blame<CR>", "[G]it [B]lame")
map("v", "<leader>gb", function()
    local start_line = vim.fn.getpos("v")[2]
    local end_line = vim.fn.getpos(".")[2]
    if start_line > end_line then
        start_line, end_line = end_line, start_line
    end
    local relfile = vim.fn.fnamemodify(vim.fn.expand("%"), ":~:.")

    local cmd = string.format(
        "<cmd>Git log --no-patch --format='%%h %%s (%%ad) [%%an]' --date=short -L %d,%d:%s<CR>",
        start_line,
        end_line,
        vim.fn.shellescape(relfile)
    )
    return cmd
end, "[G]it [B]lame -- range history (pickaxe)", { expr = true })
map("n", "<leader>gl", function()
    local cmd = "<cmd>Git log --no-patch --format='%h %s (%ad) [%an]' --date=short"
    if vim.v.count > 0 then
        cmd = cmd .. " -- %"
    end
    return cmd .. "<CR>"
end, "[G]it [L]og, prefix with any count to display only commits that changed the current file", { expr = true })
map("n", "<leader>gd", function()
    local cmd = "<cmd>Gvdiffsplit HEAD"
    if vim.v.count > 0 then
        cmd = cmd .. "~" .. vim.v.count
    end
    return cmd .. "<CR>"
end, "[G]it [D]iff in split window, prefix with any count to display diff with respect to HEAD~(count)", { expr = true })
map("n", "<leader>gD", ":Git difftool ", "Populate command line with [G]it [D]ifftool", { silent = false })

local icons = require("config.ui").icons

-- Gitsigns
require("gitsigns").setup({
    signs = {
        add = { text = icons.gitsigns.signs.add },
        change = { text = icons.gitsigns.signs.change },
        delete = { text = icons.gitsigns.signs.delete },
        topdelete = { text = icons.gitsigns.signs.topdelete },
        changedelete = { text = icons.gitsigns.signs.changedelete },
        untracked = { text = icons.gitsigns.signs.untracked },
    },
    signs_staged = {
        add = { text = icons.gitsigns.signs.add },
        change = { text = icons.gitsigns.signs.change },
        delete = { text = icons.gitsigns.signs.delete },
        topdelete = { text = icons.gitsigns.signs.topdelete },
        changedelete = { text = icons.gitsigns.signs.changedelete },
        untracked = { text = icons.gitsigns.signs.untracked },
    },
    signcolumn = true,
    numhl = false,
    linehl = false,
    word_diff = false,
    watch_gitdir = {
        interval = 1000,
        follow_files = true,
    },
    attach_to_untracked = true,
    current_line_blame = false,
    current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol",
        delay = 1000,
        ignore_whitespace = false,
    },
    current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
    sign_priority = 6,
    update_debounce = 100,
    max_file_length = 40000,
    preview_config = {
        border = "single",
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1,
    },
    on_attach = function(buffer)
        local gs = require("gitsigns")
        map(
            "n",
            "]c",
            function()
                if vim.wo.diff then
                    return "]c"
                end
                vim.schedule(function()
                    gs.next_hunk()
                end)
                return "<Ignore>"
            end,
            "Go to the next [C]hange (git hunk) or [C]onflict marker (in diff mode)",
            {
                expr = true,
                buffer = buffer,
            }
        )
        map(
            "n",
            "[c",
            function()
                if vim.wo.diff then
                    return "[c"
                end
                vim.schedule(function()
                    gs.prev_hunk()
                end)
                return "<Ignore>"
            end,
            "Go to the previous [C]hange (git hunk) or [C]onflict marker (in diff mode)",
            { expr = true, buffer = buffer }
        )
        map("n", "<leader>hs", "<cmd>Gitsigns stage_hunk<CR>", "Current [H]unk and [S]tage it", { buffer = buffer })
        map("n", "<leader>hr", "<cmd>Gitsigns reset_hunk<CR>", "Current [H]unk and [R]eset it", { buffer = buffer })
        map("n", "<leader>hu", gs.undo_stage_hunk, "Current [H]unk and [U]nstage it", { buffer = buffer })
        map("n", "<leader>hp", gs.preview_hunk, "Current [H]unk and [P]review it", { buffer = buffer })
        map(
            "n",
            "<leader>tD",
            "<cmd>Gitsigns toggle_deleted<CR><cmd>Gitsigns toggle_word_diff<CR>",
            "[T]oggle git [D]iff",
            { buffer = buffer }
        )
        map("n", "<leader>tB", function()
            if vim.v.count > 0 then
                gs.blame_line({ full = true })
                return ""
            else
                return "<cmd>Gitsigns toggle_current_line_blame<CR>"
            end
        end, "[T]oggle git [B]lame (full blame with count)", { buffer = buffer, expr = true })
        map("v", "<leader>hs", "<cmd>Gitsigns stage_hunk<CR>", "Current [H]unk and [S]tage it", { buffer = buffer })
        map("v", "<leader>hr", "<cmd>Gitsigns reset_hunk<CR>", "Current [H]unk and [R]eset it", { buffer = buffer })
        map("o", "ih", "<cmd>Gitsigns select_hunk<CR>", "Select [I]nside the current [H]unk", { buffer = buffer })
        map("x", "ih", "<cmd>Gitsigns select_hunk<CR>", "Select [I]nside the current [H]unk", { buffer = buffer })
    end,
})
