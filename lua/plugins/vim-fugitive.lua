return {
    "tpope/vim-fugitive",
    cmd = "Git",
    keys = function()
        local lazy_map = require("utils").lazy_map
        return {
            lazy_map("n", "<leader>gs", vim.cmd.Git, "Run [G]it [S]tatus (open vim-fugitive prompt)"),
            lazy_map("n", "<leader>gp", "<cmd>Git push<CR>", "Run a [G]it [P]ush"),
            lazy_map(
                "n",
                "<leader>gf",
                "<cmd>Git pull --rebase<CR>",
                "Run `git pull --rebase` (a [G]it [F]etch followed by a rebase in the current branch)"
            ),
            lazy_map(
                "n",
                "<leader>gP",
                ":Git push -u origin ",
                "Populate command line with [G]it [P]ush -u origin",
                { silent = false }
            ),
            lazy_map(
                "n",
                "<leader>gF",
                ":Git pull --rebase -u origin ",
                "Populate the command line with `git pull --rebase -u origin` (a [G]it [F]etch followed by a rebase in the current branch)",
                { silent = false }
            ),
        }
    end,
}
