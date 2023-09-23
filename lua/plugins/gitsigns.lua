return {
    "lewis6991/gitsigns.nvim",
    commit = "d4f8c01280413919349f5df7daccd0c172143d7c",
    -- event = "VeryLazy",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
        signs = {
            add = { hl = "GitSignsAdd", text = "│", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
            change = { hl = "GitSignsChange", text = "│", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
            delete = { hl = "GitSignsDelete", text = "_", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
            topdelete = { hl = "GitSignsDelete", text = "‾", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
            changedelete = {
                hl = "GitSignsChange",
                text = "~",
                numhl = "GitSignsChangeNr",
                linehl = "GitSignsChangeLn",
            },
            untracked = { hl = "GitSignsAdd", text = "┆", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
        },

        signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`

        numhl = false, -- Toggle with `:Gitsigns toggle_numhl`

        linehl = false, -- Toggle with `:Gitsigns toggle_linehl`

        word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`

        watch_gitdir = {
            interval = 1000,
            follow_files = true,
        },

        attach_to_untracked = true,

        current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`

        current_line_blame_opts = {
            virt_text = true,
            virt_text_pos = "eol", -- "eol" | "overlay" | "right_align"
            delay = 1000,
            ignore_whitespace = false,
        },

        current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",

        sign_priority = 6,

        update_debounce = 100,

        status_formatter = nil, -- Use default

        max_file_length = 40000, -- Disable if file is longer than this (in lines)

        preview_config = {
            -- Options passed to nvim_open_win
            border = "single",
            style = "minimal",
            relative = "cursor",
            row = 0,
            col = 1,
        },

        yadm = {
            enable = false,
        },

        on_attach = function(buffer)
            local gs = package.loaded.gitsigns
            local map = require("utils").map
            map(
                "n",
                "]c",
                function()
                    if vim.wo.diff then
                        vim.fn.search("^\\(<<<<<<<\\||||||||\\|=======\\|>>>>>>>\\)$", "csw")
                        return "<Ignore>"
                    end
                    vim.schedule(function()
                        gs.next_hunk()
                    end)
                    return "<Ignore>"
                end,
                "Go to the next [C]hange (git hunk) or [C]onflict marker (in diff mode)",
                { expr = true, buffer = buffer }
            )
            map(
                "n",
                "[c",
                function()
                    if vim.wo.diff then
                        vim.fn.search("^\\(>>>>>>>\\|=======\\||||||||\\|<<<<<<<\\)$", "csw")
                        return "<Ignore>"
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
                "<leader>tb",
                "<cmd>Gitsigns toggle_current_line_blame<CR>",
                "[T]oggle inline [B]lame",
                { buffer = buffer }
            )
            map("n", "<leader>td", "<cmd>Gitsigns toggle_deleted<CR>", "[T]oggle [D]eleted lines", { buffer = buffer })
            map("n", "<leader>tB", function()
                gs.blame_line({ full = true })
            end, "[T]oggle full [B]lame preview for the current line")
            map("n", "<leader>dv", function()
                gs.diffthis(nil, { vertical = true })
            end, "Open a [D]iff view of the current buffer in a [V]ertical split", { buffer = buffer })
            map("v", "<leader>hs", "<cmd>Gitsigns stage_hunk<CR>", "Current [H]unk and [S]tage it", { buffer = buffer })
            map("v", "<leader>hr", "<cmd>Gitsigns reset_hunk<CR>", "Current [H]unk and [R]eset it", { buffer = buffer })
            map(
                "o",
                "ih",
                "<cmd><C-U>Gitsigns select_hunk<CR>",
                "Select [I]nside the current [H]unk",
                { buffer = buffer }
            )
            map(
                "x",
                "ih",
                "<cmd><C-U>Gitsigns select_hunk<CR>",
                "Select [I]nside the current [H]unk",
                { buffer = buffer }
            )
        end,
    },
}
