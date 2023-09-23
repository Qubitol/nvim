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
                "<leader>gC",
                ":Git commit ",
                "Populate command line with [G]it [C]ommit",
                { silent = false }
            ),
            lazy_map(
                "n",
                "<leader>gB",
                ":Git branch ",
                "Populate command line with [G]it [B]ranch",
                { silent = false }
            ),
            lazy_map(
                "n",
                "<leader>gZ",
                ":Git stash ",
                "Populate command line with [G]it Stash (mnemonic: S and [Z] are similar)",
                { silent = false }
            ),
            lazy_map(
                "n",
                "<leader>gO",
                ":Git checkout ",
                "Populate command line with [G]it Check[O]ut",
                { silent = false }
            ),
            lazy_map("n", "<leader>gL", ":Git log ", "Populate command line with [G]it [L]og", { silent = false }),
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
                "Populate the command line with `git pull --rebase` (a [G]it [F]etch followed by a rebase in the current branch)",
                { silent = false }
            ),
        }
    end,
}
