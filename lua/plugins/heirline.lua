return {
    "rebelot/heirline.nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    version = "*",
    event = "VeryLazy",
    config = function()
        local heirline = require("heirline")
        local conditions = require("heirline.conditions")
        local utils = require("heirline.utils")
        local dev_icons = require("nvim-web-devicons")
        local icons = require("utils.ui").icons

        -- Condition for special buffers and filetypes
        local special_condition = function()
            return conditions.buffer_matches({
                buftype = { "nofile", "prompt", "help", "quickfix" },
                filetype = { "^Telescope*", "harpoon", "netrw", "fugitive", "undotree", "aerial" },
            })
        end

        -- Colors
        local hl_colors = {
            bright_bg = utils.get_highlight("Folded").bg,
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

        local palette = require("utils.colors").theme
        local my_theme = require("utils.colors").heirline

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
                return { fg = self.mode_colors[mode], bold = true, reverse = false}
            end,

            {
                provider = "%2(%)",
                hl = function(self)
                    local mode = self.mode:sub(1, 1) -- get only the first mode character
                    return { bg = self.mode_colors[mode], fg = "mode_name", bold = true, reverse = false }
                end,
            },
            {
                provider = "",
                hl = { bg = "mode_name", reverse = false },
            },
            {
                provider = function(self)
                    return " %2(" .. self.mode_names[self.mode] .. "%) "
                end,
                hl = { bg = "mode_name", reverse = false },
            },
            {
                provider = "",
                hl = { fg = "mode_name", bg = "bright_bg", reverse = false },
            },
            {
                provider = "",
                hl = { fg = "bright_bg", bg = "bright_black", reverse = false },
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
            hl = { bg = "file_bg", reverse = false },
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
                return { fg = self.icon_color, reverse = false }
            end,
        }

        local FileName = {
            provider = function(self)
                -- first, trim the pattern relative to the current directory. For other
                -- options, see :h filename-modifers
                self.lfilename = vim.fn.fnamemodify(self.filename, ":.")
                if self.lfilename == "" then
                    self.lfilename = "[No Name]"
                end
            end,
            hl = { fg = "file_fg", reverse = false },

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
                hl = { fg = "green", reverse = false },
            },
            {
                condition = function()
                    return not vim.bo.modifiable or vim.bo.readonly
                end,
                provider = "  ",
                hl = { fg = "red", reverse = false },
            },
            -- {
            --     condition = function()
            --         return not vim.bo.modified and not (not vim.bo.modifiable or vim.bo.readonly)
            --     end,
            --     provider = "   ",
            -- },
            -- {
            --     provider = "",
            --     hl = { fg = "file_bg", reverse = false },
            -- },
        }

        -- let's add the children to our FileNameBlock component
        FileNameBlock = utils.insert(
            FileNameBlock,
            { provider = " ", hl = { bg = "file_bg", reverse = false } },
            FileIcon,
            FileName,
            FileFlags
        -- { provider = "%<" }, -- this means that the statusline is cut here when there's not enough space
        -- { provider = "%=" }
        )

        local RulerBlock = {}

        local RulerSymbol = {
            flexible = 1,

            hl = { bg = "file_bg", reverse = false },

            {
                {
                    provider = "",
                    hl = { fg = "bright_bg", reverse = false },
                },
                {
                    provider = "",
                    hl = { fg = "ruler", bg = "bright_bg", reverse = false },
                },
                {
                    provider = "󰦨 ",
                    hl = { fg = "ruler_bg", bg = "ruler", reverse = false },
                },
            },
            {
                provider = "",
            },
        }

        local Ruler = {
            -- %l = current line number
            -- %L = number of lines in the buffer
            -- %c = column number
            -- %P = percentage through file of displayed window
            flexible = 1,
            {
                {
                    provider = " %3(%l%):%-2(%c%) %P ",
                    hl = { fg = "bright_white", bg = "ruler_bg", reverse = false },
                },
            },
            {
                provider = "",
            },
        }

        local ScrollBar = {
            static = {
                -- sbar = { '▁', '▂', '▃', '▄', '▅', '▆', '▇', '█' },
                sbar = { "█", "▇", "▆", "▅", "▄", "▃", "▂", "▁" },
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
            -- hl = { fg = "ruler", bg = "bright_bg", reverse = false },
            hl = { fg = "bright_bg", bg = "ruler", reverse = false },
        }

        RulerBlock = utils.insert(
            RulerBlock,
            RulerSymbol,
            Ruler,
            ScrollBar,
            { provider = "%<" } -- this means that the statusline is cut here when there's not enough space
        )

        local LSPActive = {
            condition = conditions.lsp_attached,
            update = { "LspAttach", "LspDetach" },

            hl = { bg = "file_bg", fg = "lsp", bold = true, reverse = false },

            flexible = 3,

            {
                provider = function()
                    local names = {}
                    for _, server in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
                        table.insert(names, server.name)
                    end
                    return icons.kinds.LSP .. " " .. table.concat(names, " ")
                end,
            },
            {
                provider = "",
            },
        }

        local CopilotActive = {
            condition = function()
                local ok, clients = pcall(vim.lsp.get_active_clients, { name = "copilot", bufnr = 0 })
                return ok and #clients > 0
            end,

            hl = { bg = "file_bg", fg = "copilot", bold = true, reverse = false },

            flexible = 3,

            {
                provider = function()
                    local icon = require("utils.ui").icons.kinds.Copilot
                    local status = require("copilot.api").status.data
                    return icon .. (status.message or "")
                end,
            },

            {
                provider = require("utils.ui").icons.kinds.Copilot,
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

            hl = { bg = "file_bg", reverse = false },

            {
                {
                    provider = function(self)
                        -- 0 is just another output, we can decide to print it or not!
                        return self.errors > 0 and (self.error_icon .. self.errors .. " ")
                    end,
                    hl = { fg = "diag_error", reverse = false },
                },
                {
                    provider = function(self)
                        return self.warnings > 0 and (self.warn_icon .. self.warnings .. " ")
                    end,
                    hl = { fg = "diag_warn", reverse = false },
                },
                {
                    provider = function(self)
                        return self.info > 0 and (self.info_icon .. self.info .. " ")
                    end,
                    hl = { fg = "diag_info", reverse = false },
                },
                {
                    provider = function(self)
                        return self.hints > 0 and (self.hint_icon .. self.hints)
                    end,
                    hl = { fg = "diag_hint", reverse = false },
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
                self.has_changes = self.status_dict.added ~= 0
                    or self.status_dict.removed ~= 0
                    or self.status_dict.changed ~= 0
            end,

            hl = { bg = "file_bg", reverse = false },

            {
                provider = "",
                hl = { fg = "bright_bg", reverse = false },
            },
            {
                provider = "",
                hl = { fg = "git", bg = "bright_bg", reverse = false },
            },
            {
                provider = icons.git.branch,
                hl = { fg = "bright_black", bg = "git", reverse = false },
            },
            { -- git branch name
                provider = function(self)
                    return " " .. self.status_dict.head
                end,
                hl = { fg = "git", bg = "git_branch", bold = true, reverse = false },
            },
        }

        local GitStats = {
            condition = conditions.is_git_repo,

            init = function(self)
                self.status_dict = vim.b.gitsigns_status_dict
                self.has_changes = self.status_dict.added ~= 0
                    or self.status_dict.removed ~= 0
                    or self.status_dict.changed ~= 0
            end,

            hl = { bg = "file_bg", reverse = false },

            flexible = 2,

            {
                {
                    provider = function(self)
                        local count = self.status_dict.added or 0
                        return count > 0 and (" " .. icons.git.added .. count)
                    end,
                    hl = { fg = "git_add", reverse = false },
                },
                {
                    provider = function(self)
                        local count = self.status_dict.removed or 0
                        return count > 0 and (" " .. icons.git.removed .. count)
                    end,
                    hl = { fg = "git_del", reverse = false },
                },
                {
                    provider = function(self)
                        local count = self.status_dict.changed or 0
                        return count > 0 and (" " .. icons.git.modified .. count)
                    end,
                    hl = { fg = "git_change", reverse = false },
                },
            },
            {
                provider = "",
            },
        }

        local WorkDir = {
            init = function(self)
                local cwd = vim.fn.getcwd(0)
                self.cwd = vim.fn.fnamemodify(cwd, ":~")
            end,
            hl = { fg = "white", bg = "file_bg", bold = true, reverse = false },

            flexible = 2,

            {
                -- evaluates to the full-lenth path
                {
                    provider = function(self)
                        local trail = self.cwd:sub(-1) == "/" and "" or "/"
                        return " " .. self.cwd .. trail
                    end,
                },
            },
            {
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
            },
        }

        local Align = {
            provider = "%=",
            hl = { bg = "file_bg", reverse = false },
        }
        local Space = {
            provider = " ",
            hl = { bg = "file_bg", reverse = false },
        }

        -- Statusline
        local DefaultStatusline = {
            ViMode,
            WorkDir,
            FileNameBlock,
            GitStats,
            Align,
            Diagnostics,
            Space,
            LSPActive,
            -- CopilotActive,
            Space,
            Git,
            Space,
            RulerBlock,
        }

        local SpecialStatusline = {
            condition = special_condition,
            ViMode,
            WorkDir,
            Align,
            Space,
            RulerBlock,
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

            SpecialStatusline,
            DefaultStatusline,
        }

        heirline.setup({
            statusline = StatusLines,
            opts = {
                colors = colors,
            },
        })
    end,
}
