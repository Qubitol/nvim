local M = {}

M.icons = {
    dap = {
        Stopped = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
        Breakpoint = " ",
        BreakpointCondition = " ",
        BreakpointRejected = { " ", "DiagnosticError" },
        LogPoint = ".>",
    },
    diagnostics = {
        Error = " ",
        Warn = " ",
        Hint = " ",
        Info = " ",
    },
    git = {
        added = " ",
        modified = " ",
        removed = " ",
        branch = " ", -- 
    },
    --   פּ ﯟ     some other good icons
    kinds = {
        Array = " ",
        Boolean = " ",
        Class = "󰠱",
        Color = "",
        Constant = "󰏿",
        Constructor = "", -- ""
        Copilot = " ",
        Enum = " ",
        EnumMember = " ",
        Event = " ",
        Field = "󰜢 ",
        File = " ",
        Folder = " ",
        Formatter = "󰛘",
        Function = " ",
        Interface = " ",
        Key = " ",
        Keyword = " ",
        Linter = "",
        LSP = " ",
        Method = "m",
        Module = " ",
        Namespace = " ",
        Null = " ",
        Number = " ",
        Object = " ",
        Operator = " ",
        Package = " ",
        Property = "󰜢 ",
        Reference = " ",
        Snippet = " ",
        String = " ",
        Struct = " ",
        Text = " ",
        TypeParameter = " ",
        Unit = " ",
        Value = " ",
        Variable = "󰀫 ",
    },
}

return M
