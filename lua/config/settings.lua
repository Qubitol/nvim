local set = vim.opt
local HOME = os.getenv("HOME")

-- Line numbers and relative line numbers are default
set.number = true
set.relativenumber = true
set.numberwidth = 3

-- Disable mouse mode, no one should be able to use my computer
set.mouse = ""

-- Don't show the mode, since it's already in the status line
set.showmode = false

-- Sync clipboard between OS and Neovim.
-- Schedule the setting after `UiEnter` because it can increase startup-time.
vim.schedule(function()
    set.clipboard = "unnamedplus"
end)

-- Load file on change and save it often
set.autoread = true

-- Enable break indent
set.breakindent = true

-- Enable undo and disable backups
set.undodir = HOME .. "/.config/nvim/undo//"
set.undofile = true
set.backup = false
set.writebackup = false

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
set.ignorecase = true
set.smartcase = true
set.incsearch = true -- immediately show the match
set.hlsearch = false

-- Keep signcolumn on by default
set.signcolumn = "yes"

-- Timings
set.ttimeout = true
set.ttimeoutlen = 200
set.updatetime = 250

-- Configure how new splits should be opened
set.splitright = true
set.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
set.list = true
set.listchars = { tab = "» ", trail = "·", nbsp = "␣", extends = "›", precedes = "‹" }
set.showbreak = "↪"
set.formatoptions = "qnj1cr" -- q - comment formatting; n - numbered lists; j - remove comment when joining lines; 1 - don't break after one-letter word; c - auto-wrap comments; r - continue comment leader on enter

-- Fold
set.foldenable = true -- enable fold
set.foldlevel = 99 -- start editing with all folds opened

-- Diff
set.diffopt:append("linematch:60") -- second stage diff to align lines

-- Preview substitutions live
set.inccommand = "split"

-- Project local configs
-- vim.o.exrc = true
-- vim.o.secure = true
-- vim.cmd[[set runtimepath+=.nvim]]

-- Cosmetics
set.showmatch = true
set.scrolloff = 5
set.sidescrolloff = 5
set.synmaxcol = 500
set.laststatus = 3
set.colorcolumn = "80"
set.ruler = true
set.cursorline = true
set.termguicolors = true
set.wrap = false
set.shortmess:append("I")

-- Indentation settings
set.autoindent = true
set.smartindent = true
set.tabstop = 4
set.shiftwidth = 4
set.expandtab = true

-- Commands mode
set.wildmenu = true
set.wildignore = {
    "deps",
    ".svn",
    "CVS",
    ".git",
    ".hg",
    "*.o",
    "*.a",
    "*.class",
    "*.mo",
    "*.la",
    "*.so",
    "*.obj",
    "*.swp",
    "*.jpg",
    "*.png",
    "*.xpm",
    "*.gif",
    ".DS_Store",
    "*.aux",
    "*.out",
    "*.toc",
    "*.pyc",
    "*.pdf",
}

-- Completion
set.completeopt = { "menu", "menuone", "noselect", "fuzzy" }
set.pumheight = 10 -- max height of completion menu

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
set.confirm = true

local function find_prog(name)
    local path = vim.fn.exepath(name)
    return path ~= "" and path or nil
end

local providers = {
    node = "neovim-node-host",
    perl = false,
    python3 = "pynvim-python",
    ruby = false,
}

for provider, bin in pairs(providers) do
    if bin then
        local provider_path = find_prog(bin)
        if provider_path then
            vim.g[provider .. "_host_prog"] = provider_path
        end
    else
        vim.g["loaded_" .. provider .. "_provider"] = 0
    end
end
