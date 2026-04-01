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
                },
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
                    -- Scroll preview
                    ["<S-Left>"] = "preview-reset",
                    ["<S-down>"] = "preview-page-down",
                    ["<S-up>"] = "preview-page-up",
                    ["<M-S-down>"] = "preview-down",
                    ["<M-S-up>"] = "preview-up",
                },
                fzf = {
                    ["ctrl-z"] = "abort",
                    ["ctrl-u"] = "unix-line-discard",
                    ["alt-v"] = "toggle-all",
                    ["ctrl-d"] = "delete-char/eof",
                    ["ctrl-j"] = "",
                    ["ctrl-k"] = "kill-line",
                    -- Only valid with fzf previewers (bat/cat/git/etc)
                    ["f3"] = "toggle-preview-wrap",
                    ["f4"] = "toggle-preview",
                    -- Scroll preview
                    ["shift-down"] = "preview-page-down",
                    ["shift-up"] = "preview-page-up",
                    -- Movements
                    ["ctrl-n"] = "down",
                    ["ctrl-p"] = "up",
                },
            },
            actions = {
                "hide",
                files = {
                    ["enter"] = actions.file_edit,
                    ["ctrl-s"] = actions.file_split,
                    ["ctrl-v"] = actions.file_vsplit,
                    ["ctrl-t"] = actions.file_tabedit,
                    ["ctrl-q"] = {
                        fn = actions.file_sel_to_qf,
                        prefix = "transform([ $FZF_SELECT_COUNT -eq 0 ] && echo select-all)",
                    },
                    -- Toggle search mode
                    ["ctrl-h"] = actions.toggle_hidden,
                    ["ctrl-g"] = actions.toggle_ignore, -- because ctrl-i is actually the <TAB> key, which I want to be binded to "select"
                    ["ctrl-l"] = actions.toggle_follow,
                    -- Pickers inheriting these actions:
                    --   files, git_files, git_status, grep, lsp, oldfiles, quickfix, loclist,
                    --   tags, btags, args, buffers, tabs, lines, blines
                    ["alt-d"] = { fn = actions.buf_del, reload = true },
                },
            },
            files = {
                winopts = {
                    title = { { " Find Files ", "FzfLuaTitle" } },
                    title_pos = "center",
                },
                find_opts = [[-type f -not -path '*/\.git/*' -not -path '*/\.bzr/*' -not -path '*/\.bare/*' -printf '%P\n']],
                rg_opts = [[--color=never --files -g '!.git' -g '!.bzr' -g '!.bare']],
                fd_opts = [[--color=never --type f --threads 4 --relative-path --exclude .git --exclude .bzr --exclude .bare]],
                hidden = true,
                no_ignore = false,
                follow = false,
            },
            grep = {
                winopts = {
                    title = { { " Search ", "FzfLuaTitle" } },
                    title_pos = "center",
                    preview = { vertical = "up:55%", layout = "vertical" },
                },
                rg_opts = [[--color=never --ignore-case -g '!.git' -g '!.bzr' -g '!.bare']],
                hidden = true,
                no_ignore = false,
                follow = false,
            },
            args = {
                prompt = "Args❯ ",
                files_only = true,
                winopts = {
                    title = { { " Args ", "FzfLuaTitle" } },
                    title_pos = "center",
                    title_flags = false,
                    preview = { hidden = "hidden" },
                    width = 0.4,
                    height = 0.3,
                    row = 0.4,
                    col = 0.5,
                },
                actions = {
                    ["alt-d"] = { fn = actions.arg_del, reload = true },
                },
            },
        })
    end,
    keys = function()
        local fzf_lua = require("fzf-lua")
        local lazy_map = require("utils").lazy_map
        return {
            lazy_map("n", "<leader>fo", fzf_lua.files, "FZF over files -- [F]ind [O]pen"),
            lazy_map("n", "<leader>fO", function()
                fzf_lua.files({
                    hidden = true,
                    no_ignore = true,
                    follow = true,
                })
            end, "FZF over files [unrestricted] -- [F]ind [O]pen"),
            lazy_map("n", "<leader>fb", fzf_lua.buffers, "FZF over loaded buffers -- [F]ind [B]uffers"),
            lazy_map("n", "<leader>fq", fzf_lua.quickfix_stack, "FZF over quickfix stack -- [F]ind [Q]uickfix"),
            lazy_map("n", "<leader>/", function()
                fzf_lua.lgrep_curbuf({
                    winopts = { preview = { hidden = "hidden" } },
                })
            end, "FZF search in current buffer [/]"),
            lazy_map("n", "<leader>go", fzf_lua.live_grep, "Live grep over files -- [G]rep [O]pen"),
            lazy_map("n", "<leader>gO", function()
                fzf_lua.live_grep({
                    hidden = true,
                    no_ignore = true,
                    follow = true,
                })
            end, "Live grep over files [unrestricted] -- [G]rep [O]pen"),
            lazy_map("n", "<leader>gt", function()
                fzf_lua.grep_cword({
                    winopts = { preview = { hidden = "hidden" } },
                })
            end, "Live grep of the word under the cursor -- [G]rep [T]his"),
            lazy_map("n", "<leader>gT", function()
                fzf_lua.grep_cWORD({
                    winopts = { preview = { hidden = "hidden" } },
                })
            end, "Live grep of the WORD under the cursor -- [G]rep [T]his"),
            lazy_map("n", "<leader>fa", fzf_lua.args, "FZF over args -- [F]ind [A]rgs"),
            lazy_map("n", "<leader>gl", function()
                fzf_lua.git_commits({
                    winopts = { preview = { hidden = "hidden" } },
                })
            end, "FZF over [G]it [L]og, checkout on enter"),
            lazy_map("n", "<leader>gc", function()
                fzf_lua.git_bcommits({
                    winopts = { preview = { hidden = "hidden" } },
                })
            end, "FZF over [G]it [C]ommits on the current buffer, checkout on enter"),
            lazy_map("n", "<leader>gb", fzf_lua.git_branches, "FZF over [G]it [B]ranches, switch on enter"),
            lazy_map("n", "<leader>gB", fzf_lua.git_blame, "FZF over [G]it [B]lame, go-to on enter"),
            lazy_map("n", "<leader>ff", fzf_lua.resume, "Resume latest FZF search -- [F]ind [F]ind"),
            -- search over wiki files
            lazy_map("n", "<leader>fw", function()
                fzf_lua.files({
                    find_opts = [[-type f -iname "*.md" -not -path '*/\.git/*' -not -path '*/\.bzr/*' -not -path '*/\.bare/*' -printf '%P\n']],
                    rg_opts = [[--color=never --files -g '!.git' -g '!.bzr' -g '!.bare' **/*.md]],
                    fd_opts = [[--color=never --type f --threads 4 --relative-path --exclude .git --exclude .bzr --exclude .bare -e md]],
                    hidden = true,
                    no_ignore = false,
                    follow = true,
                })
            end, "FZF over wiki files -- [F]ind [W]iki"),
            lazy_map("n", "<leader>gw", function()
                fzf_lua.live_grep({
                    rg_opts = [[--color=never --ignore-case -g '!.git' -g '!.bzr' -g '!.bare']],
                    filter = "rg '\\.md'",
                    debug = true,
                })
            end, "Live grep over files -- [G]rep [W]iki"),
            lazy_map("n", "<leader>sf", function()
                fzf_lua.lsp_document_symbols({
                    winopts = {
                        title = { { " LSP file ", "FzfLuaTitle" } },
                        title_pos = "center",
                        preview = { vertical = "up:55%", layout = "vertical" },
                    },
                })
            end, "FZF over LSP [S]ymbols in the current [F]ile"),
            -- see https://github.com/ibhagwan/fzf-lua/issues/732 for python
            lazy_map("n", "<leader>sw", function()
                fzf_lua.lsp_workspace_symbols({
                    winopts = {
                        title = { { " LSP workspace ", "FzfLuaTitle" } },
                        title_pos = "center",
                        preview = { vertical = "up:55%", layout = "vertical" },
                    },
                })
            end, "FZF over LSP [S]ymbols in the current [W]orkspace"),
        }
    end,
}
