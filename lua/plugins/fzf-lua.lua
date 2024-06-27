return {
    "ibhagwan/fzf-lua",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
        { "junegunn/fzf", build = "./install --bin" },
    },
    config = function()
        local actions = require("fzf-lua.actions")
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
            winopts = {
                split = "aboveleft " .. vim.fn.winheight(0) * 3 / 4 .. "new",
                fullscreen = true,
                preview = {
                    vertical = "down:40%",
                    horizontal = "right:40%",
                },
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
            },
        })
    end,
    keys = function()
        local fzf_lua = require("fzf-lua")
        local lazy_map = require("utils").lazy_map
        return {
            lazy_map("n", "<M-f>", fzf_lua.files, "FZF over files -- [F]ind"),
            lazy_map("n", "<M-b>", fzf_lua.buffers, "FZF over loaded buffers -- [B]uffers"),
            lazy_map("n", "<M-s>", function()
                fzf_lua.lgrep_curbuf({
                    winopts = { preview = { hidden = "hidden" } },
                })
            end, "FZF search in current buffer [/]"),
            lazy_map("n", "<M-e>", fzf_lua.live_grep, "Live grep over files -- [G]rep"),
            lazy_map("n", "<M-g>l", function()
                fzf_lua.git_commits({ winopts = { preview = { hidden = "hidden" } } })
            end, "FZF over [G]it [L]og, checkout on enter"),
            lazy_map("n", "<M-g>c", function()
                fzf_lua.git_bcommits({ winopts = { preview = { hidden = "hidden" } } })
            end, "FZF over [G]it [C]ommits on the current buffer, checkout on enter"),
            lazy_map("n", "<M-g>b", fzf_lua.git_branches, "FZF over [G]it [B]ranches, switch on enter"),
            lazy_map("n", "<M-r>", fzf_lua.resume, "Resume latest FZF search -- [F]ind [F]ind"),
        }
    end,
}
