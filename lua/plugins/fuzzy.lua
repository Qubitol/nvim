-- Fuzzy

local map = require("config.utils").map

vim.pack.add({ "https://github.com/ibhagwan/fzf-lua" })

local fzf_lua = require("fzf-lua")
local actions = require("fzf-lua.actions")

-- Helper: yank SHA from an fzf git entry
local function copy_sha(selected)
    local sha = selected[1]:match("(%x+)")
    if sha then
        vim.fn.setreg("+", sha)
        vim.notify("Copied: " .. sha)
    end
end

fzf_lua.setup({
    fzf_colors = true,
    keymap = {
        builtin = {
            ["<F1>"] = "toggle-help",
            ["<F2>"] = "toggle-fullscreen",
            ["<F3>"] = "toggle-preview-wrap",
            ["<F4>"] = "toggle-preview",
            ["<F5>"] = "toggle-preview-ccw",
            ["<F6>"] = "toggle-preview-cw",
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
            ["f3"] = "toggle-preview-wrap",
            ["f4"] = "toggle-preview",
            ["shift-down"] = "preview-page-down",
            ["shift-up"] = "preview-page-up",
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
            ["ctrl-h"] = actions.toggle_hidden,
            ["ctrl-g"] = actions.toggle_ignore,
            ["ctrl-l"] = actions.toggle_follow,
            ["alt-d"] = { fn = actions.buf_del, reload = true },
        },
    },
    winopts = {
        backdrop = false,
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
        rg_opts = [[--color=never --line-number --column --ignore-case -g '!.git' -g '!.bzr' -g '!.bare']],
        hidden = true,
        no_ignore = false,
        follow = false,
    },
})

-- Files
map("n", "<leader>fo", fzf_lua.files, "FZF over files -- [F]ind [O]pen")
map("n", "<leader>fO", function()
    fzf_lua.files({ hidden = true, no_ignore = true, follow = true })
end, "FZF over files [unrestricted] -- [F]ind [O]pen")
map("n", "<leader>fb", fzf_lua.buffers, "FZF over loaded buffers -- [F]ind [B]uffers")
map("n", "<leader>fq", fzf_lua.quickfix_stack, "FZF over quickfix stack -- [F]ind [Q]uickfix")
map("n", "<leader>ff", fzf_lua.resume, "Resume latest FZF search -- [F]ind [F]ind")

-- Grep
map("n", "<leader>/", function()
    fzf_lua.lgrep_curbuf({ winopts = { preview = { hidden = "hidden" } } })
end, "FZF search in current buffer [/]")
map("n", "<leader>go", fzf_lua.live_grep, "Live grep over files -- [G]rep [O]pen")
map("n", "<leader>gO", function()
    fzf_lua.live_grep({ hidden = true, no_ignore = true, follow = true })
end, "Live grep over files [unrestricted] -- [G]rep [O]pen")
map("n", "<leader>gt", function()
    fzf_lua.grep_cword({ winopts = { preview = { hidden = "hidden" } } })
end, "Live grep of the word under the cursor -- [G]rep [T]his")
map("n", "<leader>gT", function()
    fzf_lua.grep_cWORD({ winopts = { preview = { hidden = "hidden" } } })
end, "Live grep of the WORD under the cursor -- [G]rep [T]his")

-- Git
map("n", "<leader>gl", function()
    fzf_lua.git_commits({ winopts = { preview = { hidden = "hidden" } } })
end, "FZF over [G]it [L]og, checkout on enter")
map("n", "<leader>gb", fzf_lua.git_branches, "FZF over [G]it [B]ranches, switch on enter")

-- Git blame: file history (normal) and range history (visual)
-- Delta is auto-detected as pager, ctrl-y to copy SHA
map("n", "<leader>gB", function()
    fzf_lua.git_bcommits({
        winopts = {
            title = { { " File History ", "FzfLuaTitle" } },
            title_pos = "center",
            preview = { vertical = "up:55%", layout = "vertical" },
        },
        actions = {
            ["ctrl-y"] = { fn = copy_sha, exec_silent = true },
        },
    })
end, "FZF over [G]it [B]lame -- file history, ctrl-y to copy SHA")

map("v", "<leader>gB", function()
    local start_line = vim.fn.getpos("v")[2]
    local end_line = vim.fn.getpos(".")[2]
    if start_line > end_line then
        start_line, end_line = end_line, start_line
    end
    local relfile = vim.fn.fnamemodify(vim.fn.expand("%"), ":~:.")

    local cmd = string.format(
        "git log --no-patch --format='%%h %%ad %%an: %%s' --date=short -L %d,%d:%s",
        start_line,
        end_line,
        vim.fn.shellescape(relfile)
    )

    fzf_lua.fzf_exec(cmd, {
        winopts = {
            title = { { " Range History ", "FzfLuaTitle" } },
            title_pos = "center",
            preview = { vertical = "up:55%", layout = "vertical" },
        },
        preview = "git show --color=always {1} | delta --width=$FZF_PREVIEW_COLUMNS",
        actions = {
            ["enter"] = function(selected)
                local sha = selected[1]:match("(%x+)")
                if sha then
                    vim.cmd("Git show " .. sha)
                end
            end,
            ["ctrl-y"] = { fn = copy_sha, exec_silent = true },
        },
    })
end, "FZF over [G]it [B]lame -- range history (pickaxe), ctrl-y to copy SHA")

-- Wiki
map("n", "<leader>fw", function()
    fzf_lua.files({
        find_opts = [[-type f -iname "*.md" -not -path '*/\.git/*' -not -path '*/\.bzr/*' -not -path '*/\.bare/*' -printf '%P\n']],
        rg_opts = [[--color=never --files -g '!.git' -g '!.bzr' -g '!.bare' **/*.md]],
        fd_opts = [[--color=never --type f --threads 4 --relative-path --exclude .git --exclude .bzr --exclude .bare -e md]],
        hidden = true,
        no_ignore = false,
        follow = true,
    })
end, "FZF over wiki files -- [F]ind [W]iki")
map("n", "<leader>gw", function()
    fzf_lua.live_grep({
        rg_opts = [[--color=never --ignore-case -g '!.git' -g '!.bzr' -g '!.bare']],
        filter = "rg '\\.md'",
        debug = true,
    })
end, "Live grep over files -- [G]rep [W]iki")

-- LSP symbols
map("n", "<leader>sf", function()
    fzf_lua.lsp_document_symbols({
        winopts = {
            title = { { " LSP file ", "FzfLuaTitle" } },
            title_pos = "center",
            preview = { vertical = "up:55%", layout = "vertical" },
        },
    })
end, "FZF over LSP [S]ymbols in the current [F]ile")
map("n", "<leader>sw", function()
    fzf_lua.lsp_live_workspace_symbols({
        winopts = {
            title = { { " LSP workspace ", "FzfLuaTitle" } },
            title_pos = "center",
            preview = { vertical = "up:55%", layout = "vertical" },
        },
    })
end, "FZF over LSP [S]ymbols in the current [W]orkspace")
