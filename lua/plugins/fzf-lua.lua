return {
    "ibhagwan/fzf-lua",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
        { "junegunn/fzf", build = "./install --bin" },
    },
    config = function()
        local actions = require("fzf-lua.actions")
        local function title(str)
            return {
                winopts = {
                    -- passthrough options to main window's `nvim_open_win`
                    title = { { " " .. str .. " ", "IncSearch" } },
                    title_pos = "center",
                }
            }
        end
        require("fzf-lua").setup({
            fzf_colors = true,
            keymap = {
                builtin = {
                    -- neovim `:tmap` mappings for the fzf win
                    ["<F1>"] = "toggle-help",
                    ["<F2>"] = "toggle-fullscreen",
                    -- Only valid with the 'builtin' previewer
                    ["<F3>"] = "toggle-preview-wrap",
                    ["<F4>"] = "toggle-preview",
                    -- Rotate preview clockwise/counter-clockwise
                    ["<F5>"] = "toggle-preview-ccw",
                    ["<F6>"] = "toggle-preview-cw",
                    ["<C-n>"] = "preview-page-down",
                    ["<C-p>"] = "preview-page-up",
                    ["<C-o>"] = "preview-page-reset",
                },
                fzf = {
                    ["ctrl-z"] = "abort",
                    ["ctrl-u"] = "unix-line-discard",
                    ["alt-v"] = "toggle-all",
                    ["ctrl-d"] = "delete-char/eof",
                    ["ctrl-q"] = "select-all+accept",
                },
            },
            actions = {
                ["ctrl-q"] = actions.file_sel_to_ql,
            },
            files = {
                winopts = {
                    title = { { " Find Files ", "FzfLuaTitle" } },
                    title_pos = "center",
                },
                find_opts = [[-type f -not -path '*/\.git/*' -not -path '*/\.bzr/*' -not -path '*/\.bare/*' -printf '%P\n']],
                rg_opts = [[--color=never --files --hidden --follow -g "!.git" -g "!.bzr" -g "!.bare"]],
                fd_opts = [[--color=never --type f --threads 4 --relative-path --hidden --follow --exclude .git --exclude .bzr --exclude .bare]],
            },
            grep = {
                winopts = {
                    title = { { " Search ", "FzfLuaTitle" } },
                    title_pos = "center",
                },
            }
        })
    end,
    keys = function()
        local fzf_lua = require("fzf-lua")
        local lazy_map = require("utils").lazy_map
        return {
            lazy_map("n", "<leader>fo", fzf_lua.files, "FZF over files -- [F]ind [O]pen"),
            lazy_map("n", "<leader>fO", function()
                fzf_lua.files({
                    rg_opts = [[--color=never --files --hidden --unrestricted --follow -g "!.git" -g "!.bzr" -g "!.bare"]],
                    fd_opts = [[--color=never --type f --hidden --unrestricted --follow --exclude .git --exclude .bzr --exclude .bare]],
                })
            end, "FZF over files [unrestricted] -- [F]ind [O]pen"),
            lazy_map("n", "<leader>fb", fzf_lua.buffers, "FZF over loaded buffers -- [F]ind [B]uffers"),
            lazy_map("n", "<leader>ft", fzf_lua.tags, "FZF over tags -- [F]ind [T]ags"),
            lazy_map("n", "<leader>fq", fzf_lua.quickfix_stack, "FZF over quickfix stack -- [F]ind [Q]uickfix"),
            lazy_map("n", "<leader>/", function()
                fzf_lua.lgrep_curbuf({
                    winopts = { preview = { hidden = "hidden", vertical = "up:55%", layout = "horizontal" } },
                })
            end, "FZF search in current buffer [/]"),
            lazy_map("n", "<leader>go", function()
                fzf_lua.live_grep({
                    winopts = {
                        preview = {
                            vertical = "up:55%",
                            layout = "vertical",
                        },
                    },
                })
            end, "Live grep over files -- [G]rep [O]pen"),
            lazy_map("n", "<leader>gt", function()
                fzf_lua.grep_cword({
                    winopts = { preview = { hidden = "hidden", vertical = "up:55%", layout = "horizontal" } },
                })
            end, "Live grep of the word under the cursor -- [G]rep [T]his"),
            lazy_map("n", "<leader>gT", function()
                fzf_lua.grep_cWORD({
                    winopts = { preview = { hidden = "hidden", vertical = "up:55%", layout = "horizontal" } },
                })
            end, "Live grep of the WORD under the cursor -- [G]rep [T]his"),
            lazy_map("n", "<leader>sf", fzf_lua.lsp_document_symbols, "FZF over LSP [S]ymbols in the current [F]ile"),
            lazy_map("n", "<leader>gl", function()
                fzf_lua.git_commits({ winopts = { preview = { hidden = "hidden" } } })
            end, "FZF over [G]it [L]og, checkout on enter"),
            lazy_map("n", "<leader>gc", function()
                fzf_lua.git_bcommits({ winopts = { preview = { hidden = "hidden" } } })
            end, "FZF over [G]it [C]ommits on the current buffer, checkout on enter"),
            lazy_map("n", "<leader>gb", fzf_lua.git_branches, "FZF over [G]it [B]ranches, switch on enter"),
            lazy_map("n", "<leader>ff", fzf_lua.resume, "Resume latest FZF search -- [F]ind [F]ind"),
        }
    end,
}
