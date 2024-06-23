local set = vim.opt
local g = vim.g

local HOME = os.getenv("HOME")

local BIN_PATH
if vim.fn.has("macunix") then
    BIN_PATH="/opt/homebrew/bin"
else
    BIN_PATH="/usr/bin"
end

g.compatible = false

-- basic settings
set.encoding = "utf-8"
set.backspace = "indent,eol,start"
set.completeopt = "menu,menuone,noinsert,noselect"
set.history = 100
set.hidden = true
set.lazyredraw = true
set.confirm = true
set.clipboard = "unnamedplus"
set.mouse = ""

-- Time
set.timeout = false
set.ttimeout = false
set.ttimeoutlen = 200
set.updatetime = 250

-- Display
set.showmatch = true
set.scrolloff = 3
set.sidescrolloff = 5
set.synmaxcol = 500
set.laststatus = 3
set.colorcolumn = "80"
set.ruler = true
set.cursorline = true

set.foldenable = false
-- set.foldlevel = 4 -- limit folding to 4 levels
set.foldmethod = "marker" -- enable folding (default "foldmarker")
set.wrap = false
set.eol = false
set.showbreak = "↪"
set.list = true
set.listchars:append "eol:↴"

-- Sidebar
set.number = true
set.relativenumber = true
set.numberwidth = 3
set.signcolumn = "yes"
set.modelines = 0
set.showcmd = true

-- Interface
set.shortmess:append("I")
set.splitright = true
set.splitbelow = true
set.termguicolors = true

-- Search
set.incsearch = true
set.ignorecase = true
set.smartcase = true
set.hlsearch = false

-- White characters
set.autoindent = true
set.smartindent = true
set.tabstop = 4             -- \t = 4 spaces
set.softtabstop = 2         -- 1 tab press = 2 spaces
set.shiftwidth = 4
set.formatoptions = "qnj1t" -- q  - comment formatting; n - numbered lists; j - remove comment when joining lines; 1 - don't break after one-letter word
set.expandtab = true

-- Files
set.undodir = HOME .. '/.config/nvim/undo//' -- undo files
set.undofile = true
set.backup = false
set.writebackup = false

-- Commands mode
set.wildmenu = true
set.wildignore =
'deps,.svn,CVS,.git,.hg,*.o,*.a,*.class,*.mo,*.la,*.so,*.obj,*.swp,*.jpg,*.png,*.xpm,*.gif,.DS_Store,*.aux,*.out,*.toc,*.pyc'

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
g.node_host_prog = BIN_PATH .. "/neovim-node-host"

-- Python
g.python3_host_prog = HOME .. "/Apps/venvs/PyNvim/bin/python"
