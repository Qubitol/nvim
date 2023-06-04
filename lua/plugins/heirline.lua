local status_ok, heirline = pcall(require, "heirline")
if not status_ok then
    return
end
local status_dev_icons_ok, dev_icons = pcall(require, "nvim-web-devicons")
if not status_dev_icons_ok then
    return
end

local conditions = require("heirline.conditions")
local utils = require("heirline.utils")

-- Condition for special buffers and filetypes
local special_condition = function()
    return conditions.buffer_matches({
        buftype = { "nofile", "prompt", "help", "quickfix" },
        filetype = { "^Telescope*", "harpoon", "rnvimr", "^git.*", "fugitive", "undotree", "aerial" },
    })
end

-- Colors
local hl_colors = {
    bright_bg = utils.get_highlight("Folded").bg,
    bright_fg = utils.get_highlight("Folded").fg,
    dark_red = utils.get_highlight("DiffDelete").bg,
    gray = utils.get_highlight("NonText").fg,
    orange = utils.get_highlight("Constant").fg,
    purple = utils.get_highlight("Statement").fg,
    cyan = utils.get_highlight("Special").fg,
    diag_warn = utils.get_highlight("DiagnosticWarn").fg,
    diag_error = utils.get_highlight("DiagnosticError").fg,
    diag_hint = utils.get_highlight("DiagnosticHint").fg,
    diag_info = utils.get_highlight("DiagnosticInfo").fg,
    git_del = utils.get_highlight("diffRemoved").fg,
    git_add = utils.get_highlight("diffAdded").fg,
    git_change = utils.get_highlight("diffChanged").fg,
}

local palette = require("plugins.catppuccin")
local my_theme = {
    mode_name = palette["black3"],
    file_fg = palette["white"],
    file_bg = palette["black2"],
    file_modified = palette["green"],
    file_locked = palette["orange"],
    git = palette["purple"],
    git_branch = palette["black3"],
    lsp = palette["green"],
    filetype = palette["yellow"],
    work_dir = palette["red"],
    ruler = palette["blue"],
    ruler_bg = palette["black3"],
    git_del = palette["purple"],
    git_add = palette["purple"],
    git_change = palette["purple"],
}

local colors = vim.tbl_deep_extend("force", hl_colors, palette, my_theme)

-- Components
local ViMode = {
    -- get vim current mode, this information will be required by the provider
    -- and the highlight functions, so we compute it only once per component
    -- evaluation and store it as a component attribute
    init = function(self)
        self.mode = vim.fn.mode(1) -- :h mode()

    end,
    -- Now we define some dictionaries to map the output of mode() to the
    -- corresponding string and color. We can put these into `static` to compute
    -- them at initialisation time.
    static = {
        mode_names = { -- change the strings if you like it vvvvverbose!
            n = "N",
            no = "N?",
            nov = "N?",
            noV = "N?",
            ["no\22"] = "N?",
            niI = "Ni",
            niR = "Nr",
            niV = "Nv",
            nt = "Nt",
            v = "V",
            vs = "Vs",
            V = "V_",
            Vs = "Vs",
            ["\22"] = "^V",
            ["\22s"] = "^V",
            s = "S",
            S = "S_",
            ["\19"] = "^S",
            i = "I",
            ic = "Ic",
            ix = "Ix",
            R = "R",
            Rc = "Rc",
            Rx = "Rx",
            Rv = "Rv",
            Rvc = "Rv",
            Rvx = "Rv",
            c = "C",
            cv = "Ex",
            r = "...",
            rm = "M",
            ["r?"] = "?",
            ["!"] = "!",
            t = "T",
        },
        mode_colors = {
            n = "red",
            i = "green",
            v = "cyan",
            V = "cyan",
            ["\22"] = "cyan",
            c = "orange",
            s = "purple",
            S = "purple",
            ["\19"] = "purple",
            R = "orange",
            r = "orange",
            ["!"] = "red",
            t = "red",
        },
    },
    -- We can now access the value of mode() that, by now, would have been
    -- computed by `init()` and use it to index our strings dictionary.
    -- note how `static` fields become just regular attributes once the
    -- component is instantiated.
    -- Same goes for the highlight. Now the foreground will change according to the current mode.
    hl = function(self)
        local mode = self.mode:sub(1, 1) -- get only the first mode character
        return { fg = self.mode_colors[mode], bold = true, }
    end,

    {
        provider = "%2(%)",
        hl = function(self)
            local mode = self.mode:sub(1, 1) -- get only the first mode character
            return { bg = self.mode_colors[mode], fg = "mode_name", bold = true, }
        end,
    },
    {
        provider = "",
        hl = { bg = "mode_name" },
    },
    {
        provider = function(self)
            return " %2("..self.mode_names[self.mode].."%) "
        end,
        hl = { bg = "mode_name" },
    },
    {
        provider = "",
        hl = { fg = "mode_name", bg = "bright_bg" }
    },
    -- Re-evaluate the component only on ModeChanged event!
    -- Also allows the statusline to be re-evaluated when entering operator-pending mode
    update = {
        "ModeChanged",
        pattern = "*:*",
        callback = vim.schedule_wrap(function()
            vim.cmd.redrawstatus()
        end),
    },
}

local FileNameBlock = {
    -- let's first set up some attributes needed by this component and it's children
    init = function(self)
        self.filename = vim.api.nvim_buf_get_name(0)
    end,
}

local FileNameBlockInactive = {
    init = function(self)
        self.filename = vim.api.nvim_buf_get_name(0)
    end,
}

-- We can now define some children separately and add them later
local FileIcon = {
    init = function(self)
        local filename = self.filename
        local extension = vim.fn.fnamemodify(filename, ":e")
        self.icon, self.icon_color = dev_icons.get_icon_color(filename, extension, { default = true })
    end,
    provider = function(self)
        return self.icon and (self.icon .. " ")
    end,
    hl = function(self)
        return { fg = self.icon_color, bg = "file_bg" }
    end
}

local FileName = {
    provider = function(self)
        -- first, trim the pattern relative to the current directory. For other
        -- options, see :h filename-modifers
        self.lfilename = vim.fn.fnamemodify(self.filename, ":.")
        if self.lfilename == "" then self.lfilename = "[No Name]" end
    end,
    hl = { fg = "file_fg", bg = "file_bg" },

    flexible = 1,

    {
        provider = function(self)
            return self.lfilename
        end,
    },
    {
        provider = function(self)
            return vim.fn.pathshorten(self.lfilename)
        end,
    },
}

local FileFlags = {
    {
        condition = function()
            return vim.bo.modified
        end,
        provider = "[+]",
        hl = { fg = "green", bg = "file_bg" },
    },
    {
        condition = function()
            return not vim.bo.modifiable or vim.bo.readonly
        end,
        provider = "  ",
        hl = { fg = "red", bg = "file_bg" },
    },
    {
        condition = function()
            return not vim.bo.modified and not (not vim.bo.modifiable or vim.bo.readonly)
        end,
        provider = "   ",
        hl = { bg = "file_bg" },
    },
    {
        provider = "",
        hl = { fg = "file_bg" },
    },
}

-- let's add the children to our FileNameBlock component
FileNameBlock = utils.insert(FileNameBlock,
    { provider = " ", hl = { bg = "file_bg" } },
    FileIcon,
    FileName,
    FileFlags,
    { provider = "%<"} -- this means that the statusline is cut here when there's not enough space
)

FileNameBlockInactive = utils.insert(FileNameBlockInactive,
    { provider = " ", hl = { bg = "file_bg" } },
    FileIcon,
    { hl = { fg = "gray", force = true }, FileName },
    FileFlags,
    { provider = "%<"} -- this means that the statusline is cut here when there's not enough space
)


local Sep = {
    provider = " │ ",
    hl = { fg = "gray" },
}

local FileType = {
    hl = { fg = utils.get_highlight("Type").fg, bold = true },

    flexible = 3,

    {
        provider = function()
            return string.upper(vim.bo.filetype)
        end,
    },

    {
        provider = "",
    },
}

local FileEncoding = {
    flexible = 3,

    {
        Sep,

        {
            provider = function()
                local enc = (vim.bo.fenc ~= "" and vim.bo.fenc) or vim.o.enc -- :h "enc"
                return enc
            end,
            hl = { italic = true },
        },

    },

    {
        provider = "",
    },
}

local FileSize = {
    hl = { fg = "gray" },

    flexible = 3,

    {
        Sep,

        {
            provider = function()
                -- stackoverflow, compute human readable file size
                local suffix = { "b", "k", "M", "G", "T", "P", "E" }
                local fsize = vim.fn.getfsize(vim.api.nvim_buf_get_name(0))
                fsize = (fsize < 0 and 0) or fsize
                if fsize < 1024 then
                    return fsize .. suffix[1]
                end
                local i = math.floor((math.log(fsize) / math.log(1024)))
                return string.format("%.2g%s", fsize / (1024 ^ i), suffix[i + 1])
            end,
        },
    },

    {
        provider = "",
    },
}

local RulerBlock = {}

local RulerSymbol = {
    {
        provider = "",
        hl = { fg = "bright_bg" },
    },
    {
        provider = "",
        hl = { fg = "ruler", bg = "bright_bg" },
    },
    {
        provider = "󰦨 ",
        hl = { fg = "ruler_bg", bg = "ruler" },
    },
}

local Ruler = {
    -- %l = current line number
    -- %L = number of lines in the buffer
    -- %c = column number
    -- %P = percentage through file of displayed window
    {
        provider = " %3(%l%):%-2(%c%) %P ",
        hl = { bg = "ruler_bg" },
    },
}

local ScrollBar ={
    static = {
        sbar = { '▁', '▂', '▃', '▄', '▅', '▆', '▇', '█' },
    },
    provider = function(self)
        local curr_line = vim.api.nvim_win_get_cursor(0)[1]
        local lines = vim.api.nvim_buf_line_count(0)
        local i
        if lines > 0 then
            i = math.floor((curr_line - 1) / lines * #self.sbar) + 1
        else
            i = #self.sbar
        end
        return string.rep(self.sbar[i], 2)
    end,
    hl = { fg = "ruler", bg = "bright_bg" },
}

RulerBlock = utils.insert(RulerBlock,
    RulerSymbol,
    Ruler,
    ScrollBar,
    { provider = "%<"} -- this means that the statusline is cut here when there's not enough space
)

local LSPActive = {
    condition = conditions.lsp_attached,
    update = {"LspAttach", "LspDetach"},

    hl = { fg = "lsp", bold = true },

    flexible = 3,

    {
        provider = function()
            local names = {}
            for _, server in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
                table.insert(names, server.name)
            end
            return "  " .. table.concat(names, " ")
        end,
    },

    {
        provider = "  LSP"
    },

    {
        provider = "",
    },
}

local Diagnostics = {

    condition = conditions.has_diagnostics,

    static = {
        error_icon = vim.fn.sign_getdefined("DiagnosticSignError")[1].text,
        warn_icon = vim.fn.sign_getdefined("DiagnosticSignWarn")[1].text,
        info_icon = vim.fn.sign_getdefined("DiagnosticSignInfo")[1].text,
        hint_icon = vim.fn.sign_getdefined("DiagnosticSignHint")[1].text,
    },

    init = function(self)
        self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
        self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
        self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
        self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
    end,

    update = { "DiagnosticChanged", "BufEnter" },

    flexible = 2,

    {
        {
            provider = function(self)
                -- 0 is just another output, we can decide to print it or not!
                return self.errors > 0 and (self.error_icon .. self.errors .. " ")
            end,
            hl = { fg = "diag_error" },
        },
        {
            provider = function(self)
                return self.warnings > 0 and (self.warn_icon .. self.warnings .. " ")
            end,
            hl = { fg = "diag_warn" },
        },
        {
            provider = function(self)
                return self.info > 0 and (self.info_icon .. self.info .. " ")
            end,
            hl = { fg = "diag_info" },
        },
        {
            provider = function(self)
                return self.hints > 0 and (self.hint_icon .. self.hints)
            end,
            hl = { fg = "diag_hint" },
        },
    },

    {
        provider = "",
    },
}

local Git = {
    condition = conditions.is_git_repo,

    init = function(self)
        self.status_dict = vim.b.gitsigns_status_dict
        self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
    end,

    {
        provider = " ",
        hl = { fg = "git_branch", bg = "git", bold = true }
    },
    {
        provider = "",
        hl = { fg = "git", bg = "git_branch" }
    },
    {   -- git branch name
        provider = function(self)
            return " " .. self.status_dict.head
        end,
        hl = { fg = "git", bg = "git_branch", bold = true }
    },
    {
        provider = function(self)
            local count = self.status_dict.added or 0
            return count > 0 and ("  " .. count)
        end,
        hl = { fg = "git_add", bg = "git_branch" },
    },
    {
        provider = function(self)
            local count = self.status_dict.removed or 0
            return count > 0 and ("  " .. count)
        end,
        hl = { fg = "git_del", bg = "git_branch" },
    },
    {
        provider = function(self)
            local count = self.status_dict.changed or 0
            return count > 0 and ("  " .. count)
        end,
        hl = { fg = "git_change", bg = "git_branch" },
    },
    {
        provider = "",
        hl = { fg = "git_branch" }
    },
}

local ModeSep = {
    {
        condition = conditions.is_git_repo,
        provider = "",
        hl = { fg = "bright_bg", bg = "git" }
    },
    {
        condition = function()
            return not conditions.is_git_repo()
        end,
        provider = "",
        hl = { fg = "bright_bg" }
    },
}

local WorkDir = {
    init = function(self)
        local cwd = vim.fn.getcwd(0)
        self.cwd = vim.fn.fnamemodify(cwd, ":~")
    end,
    hl = { fg = "gray7", bold = true },

    flexible = 2,

    {
        {
            provider = "",
            hl = { fg = "bright_bg" },
        },
        {
            provider = "",
            hl = { fg = "red", bg = "bright_bg" },
        },
        {
            provider = "󰉋 ",
            hl = { fg = "black3", bg = "red" },
        },
        -- evaluates to the full-lenth path
        {
            provider = function(self)
                local trail = self.cwd:sub(-1) == "/" and "" or "/"
                return " " .. self.cwd .. trail
            end,
        }
    },
    {
        {
            provider = "",
            hl = { fg = "bright_bg" },
        },
        {
            provider = "",
            hl = { fg = "red", bg = "bright_bg" },
        },
        {
            provider = "󰉋 ",
            hl = { fg = "black3", bg = "red" },
        },
        -- evaluates to the shortened path
        {
            provider = function(self)
                local cwd = vim.fn.pathshorten(self.cwd)
                local trail = self.cwd:sub(-1) == "/" and "" or "/"
                return " " .. cwd .. trail
            end,
        },
    },
    {
        -- evaluates to "", hiding the component
        provider = "",
    }
}

local Align = { provider = "%=" }
local Space = { provider = " " }

-- Statusline
local DefaultStatusline = {
    ViMode, ModeSep, Git, Align,
    Diagnostics, Space, LSPActive, Space, WorkDir, Space, RulerBlock
}

-- local InactiveStatusline = {
--     condition = conditions.is_not_active,
--     FileNameBlock, Align, FileEncoding, Space, FileType, FileSize, Space, Ruler
-- }

local SpecialStatusline = {
    condition = special_condition,
    ViMode, ModeSep, Align,
    WorkDir, Space, RulerBlock
}

-- Build the final object
local StatusLines = {

    hl = function()
        if conditions.is_active() then
            return "StatusLine"
        else
            return "StatusLineNC"
        end
    end,

    -- the first statusline with no condition, or which condition returns true is used.
    -- think of it as a switch case with breaks to stop fallthrough.
    fallthrough = false,

    SpecialStatusline, DefaultStatusline,
}

-- Winbar
local DefaultWinbar = {
    condition = conditions.is_active,
    FileNameBlock, Align,
    FileType, FileEncoding, FileSize
}

local InactiveWinbar = {
    FileNameBlockInactive, Align,
    FileType, FileEncoding, FileSize
}

local SpecialWinbar = {
    condition = special_condition,
    Align, FileType
}

-- Build the final object
local WinBars = {

    hl = function()
        if conditions.is_active() then
            return "WinBar"
        else
            return "WinBarNC"
        end
    end,

    fallthrough = false,

    SpecialWinbar, DefaultWinbar, InactiveWinbar,
}

heirline.setup({

    statusline = StatusLines,
    winbar = WinBars,

    opts = {
        colors = colors,

        -- if the callback returns true, the winbar will be disabled for that window
        -- the args parameter corresponds to the table argument passed to autocommand callbacks. :h nvim_lua_create_autocmd()
        disable_winbar_cb = function(args)
            return conditions.buffer_matches({
                buftype = { "nofile", "prompt", "help", "quickfix" },
                filetype = { "^Telescope.*", "harpoon", "rnvimr", "^git.*", "fugitive", "undotree", "aerial" },
            }, args.buf)
        end,
    },
})
