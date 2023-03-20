local set = vim.opt
local g = vim.g

HOME = os.getenv("HOME")

g.compatible = false

-- basic settings
set.encoding = "utf-8"
set.backspace = "indent,eol,start" -- backspace works on every char in insert mode
set.completeopt = 'menuone,noselect'
set.history = 100
set.hidden = true
set.lazyredraw = true
-- set.dictionary = '/usr/share/dict/words'
-- set.startofline = false
set.confirm = true
set.clipboard = "unnamedplus"

-- Time
set.timeout = false
set.ttimeout = true
set.ttimeoutlen = 200
set.updatetime = 250

-- Display
set.showmatch = true -- show matching brackets
set.scrolloff = 3 -- always show 3 rows from edge of the screen
set.synmaxcol = 500 -- stop syntax highlight after x lines for performance
set.laststatus = 2 -- always show status line
set.colorcolumn = "80,100,120"
set.ruler = true
set.cursorline = true

-- set.foldenable = false
-- set.foldlevel = 4 -- limit folding to 4 levels
set.foldmethod = "marker" -- enable folding (default "foldmarker")
set.wrap = false -- do not wrap lines even if very long
set.eol = false -- show if there's no eol char
set.showbreak= '↪' -- character to show when line is broken

-- Sidebar
set.number = true -- line number on the left
set.relativenumber = true -- line number on the left
set.numberwidth = 3 -- always reserve 3 spaces for line number
set.signcolumn = "yes" -- keep 1 column for coc.vim  check
set.modelines = 0
set.showcmd = true -- display command in bottom bar

-- Interface
set.shortmess:append "sI"
set.splitright = true
set.splitbelow = true
set.termguicolors = true

-- Search
set.incsearch = true -- starts searching as soon as typing, without enter needed
set.ignorecase = true -- ignore letter case when searching
set.smartcase = true -- case insentive unless capitals used in search
set.hlsearch = false -- highlight searches (use C-L to temporarily turn off highlightning)

-- set.matchtime = 2 -- delay before showing matching paren
-- set.mps = opt.mps .. ",<:>"

-- White characters
set.autoindent = true
set.smartindent = true
set.tabstop = 4 -- \t = 4 spaces
set.softtabstop = 2 -- 1 tab press = 2 spaces
set.shiftwidth = 4 -- indentation rule
set.formatoptions = 'qnj1t' -- q  - comment formatting; n - numbered lists; j - remove comment when joining lines; 1 - don't break after one-letter word
set.expandtab = true -- expand tab to spaces

-- Files
set.undodir = HOME .. '/.config/nvim/undo//'     -- undo files
set.undofile = true
set.backupdir = HOME .. '/.config/nvim/backup//' -- backups
set.backup = true
set.writebackup = true

-- Commands mode
set.wildmenu = true -- on TAB, complete options for system command
set.wildignore = 'deps,.svn,CVS,.git,.hg,*.o,*.a,*.class,*.mo,*.la,*.so,*.obj,*.swp,*.jpg,*.png,*.xpm,*.gif,.DS_Store,*.aux,*.out,*.toc,*.pyc'

-- disable some builtin vim plugins
local default_plugins = {
    "2html_plugin",
    "getscript",
    "getscriptPlugin",
    "gzip",
    "logipat",
    "netrw",
    "netrwPlugin",
    "netrwSettings",
    "netrwFileHandlers",
    "matchit",
    "tar",
    "tarPlugin",
    "rrhelper",
    "spellfile_plugin",
    "vimball",
    "vimballPlugin",
    "zip",
    "zipPlugin",
    "tutor",
    "rplugin",
    "synmenu",
    "optwin",
    "compiler",
    "bugreport",
    "ftplugin",
}

for _, plugin in pairs(default_plugins) do
    g["loaded_" .. plugin] = 1
end

local default_providers = {
--    "node",
    "perl",
--    "python3",
    "ruby",
}

for _, provider in ipairs(default_providers) do
    g["loaded_" .. provider .. "_provider"] = 0
end

-- Node
g.node_host_prog = HOME .. "/.nvm/versions/node/NodeNvim/lib/node_modules/neovim"

-- Python
g.python3_host_prog = HOME .. "/Apps/venvs/PyNvim/bin/python"
