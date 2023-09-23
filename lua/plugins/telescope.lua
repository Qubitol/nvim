return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make",
        },
        "stevearc/aerial.nvim",
        "brandoncc/git-worktree.nvim",
    },
    version = false,
    cmd = "Telescope",

    opts = function()
        local actions = require("telescope.actions")
        local actions_layout = require("telescope.actions.layout")
        local action_state = require("telescope.actions.state")
        local telescope_config = require("telescope.config")

        local function open_selected_quickfix(prompt_bufnr)
            local nr = action_state.get_selected_entry().nr
            actions.close(prompt_bufnr)
            vim.cmd(nr .. "chistory")
            vim.cmd("copen")
        end

        -- Clone the default Telescope configuration
        local vimgrep_arguments = { unpack(telescope_config.values.vimgrep_arguments) }

        -- I want to search in hidden/dot files.
        table.insert(vimgrep_arguments, "--hidden")
        -- I don't want to search in the VCS directories.
        table.insert(vimgrep_arguments, "--glob")
        table.insert(vimgrep_arguments, "!**/.git/*")
        table.insert(vimgrep_arguments, "--glob")
        table.insert(vimgrep_arguments, "!**/.bzr/*")
        table.insert(vimgrep_arguments, "--glob")
        table.insert(vimgrep_arguments, "!**/.bare/*")

        return {
            defaults = {
                prompt_prefix = " ",
                selection_caret = "❯ ",
                entry_prefix = "  ",
                multi_icon = "",
                initial_mode = "insert",
                selection_strategy = "reset",
                -- sorting_strategy = "ascending",
                layout_strategy = "horizontal",
                layout_config = {
                    horizontal = {
                        prompt_position = "bottom",
                        preview_width = 0.55,
                        results_width = 0.8,
                    },
                    vertical = {
                        mirror = false,
                    },
                    width = 0.87,
                    height = 0.80,
                    preview_cutoff = 120,
                },
                path_display = { "truncate" },
                winblend = 0,
                border = {},
                -- borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
                color_devicons = true,
                mappings = {
                    i = {
                        ["<C-/>"] = actions_layout.toggle_preview,
                        ["<C-l>"] = actions.cycle_previewers_next,
                        ["<C-h>"] = actions.cycle_previewers_prev,
                        ["<C-j>"] = actions.move_selection_next,
                        ["<C-k>"] = actions.move_selection_previous,
                        ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
                        ["<C-x>"] = actions.smart_add_to_qflist + actions.open_qflist,
                        ["<M-q>"] = actions.nop, -- clash with map from tmux
                    },
                    n = {
                        ["<C-/>"] = actions_layout.toggle_preview,
                        ["<C-l>"] = actions.cycle_previewers_next,
                        ["<C-h>"] = actions.cycle_previewers_prev,
                        ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
                        ["<C-x>"] = actions.smart_add_to_qflist + actions.open_qflist,
                        ["<M-q>"] = actions.nop, -- clash with map from tmux
                    },
                },
                vimgrep_arguments = vimgrep_arguments,
            },

            pickers = {
                find_files = {
                    -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
                    -- find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
                    find_command = {
                        "fd",
                        "--type",
                        "f",
                        "--threads",
                        "4",
                        "--color",
                        "never",
                        "--relative-path",
                        "--hidden",
                        "--exclude",
                        "**/.git/*",
                        "--exclude",
                        "**/.bzr/*",
                        "--exclude",
                        "**/.bare/*",
                        ".",
                    },
                },
                buffers = {
                    sort_lastused = true,
                    sort_mru = true,
                    ignore_current_buffer = true,
                    mappings = {
                        n = {
                            ["D"] = actions.delete_buffer,
                            ["dd"] = actions.delete_buffer,
                        },
                    },
                },
                quickfixhistory = {
                    mappings = {
                        i = {
                            ["<CR>"] = open_selected_quickfix,
                        },
                        n = {
                            ["<CR>"] = open_selected_quickfix,
                        },
                    },
                },
            },
        }
    end,

    config = function(_, opts)
        local telescope = require("telescope")
        -- Setup telescope
        telescope.setup(opts)
        -- Load extensions
        telescope.load_extension("fzf")
        telescope.load_extension("aerial")
        telescope.load_extension("git_worktree")
    end,

    keys = function()
        local lazy_map = require("utils").lazy_map
        return {
            lazy_map("n", "<leader>fo", "<cmd>Telescope find_files<CR>", "Telescope over files -- [F]ind [O]pen"),
            lazy_map(
                "n",
                "<leader>fb",
                "<cmd>Telescope buffers<CR>",
                "Telescope over loaded buffers -- [F]ind [B]uffers"
            ),
            lazy_map("n", "<leader>ft", "<cmd>Telescope aerial<CR>", "Telescope over documents tags -- [F]ind [T]ags"),
            lazy_map(
                "n",
                "<leader>fq",
                "<cmd>Telescope quickfixhistory<CR>",
                "Telescope over quickfix lists history -- [F]ind [Q]uickfix"
            ),
            lazy_map("n", "<leader>/", function()
                require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
                    winblend = 0,
                    previewer = false,
                }))
            end, "Fuzzy search in current buffer [/]"),
            lazy_map("n", "<leader>go", "<cmd>Telescope live_grep<CR>", "Live grep over files -- [G]rep [O]pen"),
            lazy_map(
                "n",
                "<leader>gt",
                "<cmd>Telescope grep_string<CR>",
                "Live grep of the word under the cursor -- [G]rep [T]his"
            ),
            lazy_map(
                "n",
                "<leader>sf",
                "<cmd>Telescope lsp_document_symbols<CR>",
                "Telescope over LSP [S]ymbols in the current [F]ile"
            ),
            lazy_map(
                "n",
                "<leader>sw",
                "<cmd>Telescope lsp_workspace_symbols<CR>",
                "Telescope over LSP [S]ymbols in the current [W]orkspace"
            ),
            lazy_map(
                "n",
                "<leader>gl",
                "<cmd>Telescope git_commits<CR>",
                "Telescope over [G]it [L]og, checkout on enter"
            ),
            lazy_map(
                "n",
                "<leader>gc",
                "<cmd>Telescope git_bcommits<CR>",
                "Telescope over [G]it [C]ommits on the current buffer, checkout on enter"
            ),
            lazy_map(
                "n",
                "<leader>gb",
                "<cmd>Telescope git_branches<CR>",
                "Telescope over [G]it [B]ranches, switch on enter"
            ),
            lazy_map(
                "n",
                "<leader>gz",
                "<cmd>Telescope git_stash<CR>",
                "Telescope over [G]it Stashes (mnemonic: S is similar to [Z])"
            ),
            lazy_map(
                "n",
                "<leader>gw",
                [[<cmd>lua require("telescope").extensions.git_worktree.git_worktrees()<CR>]],
                "Open a different [G]it [W]orktree"
            ),
            lazy_map(
                "n",
                "<leader>gW",
                [[<cmd>lua require("telescope").extensions.git_worktree.create_git_worktree()<CR>]],
                "Run `git worktree add ...`, choosing the branch with Telescope -- [G]it [W]orktree"
            ),
            lazy_map("n", "<leader>ff", "<cmd>Telescope resume<CR>", "Resume latest Telescope search -- [F]ind [F]ind"),
            lazy_map(
                "v",
                "<leader>gc",
                "<cmd>Telescope git_bcommits_range<CR>",
                "Telescope over [G]it [C]ommits on the selected range of lines, checkout on enter"
            ),
        }
    end,
}
