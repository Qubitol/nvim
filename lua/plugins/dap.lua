return {
    "mfussenegger/nvim-dap",
    keys = function()
        local lazy_map = require("utils").lazy_map
        local dap = require("dap")
        return {
            lazy_map("n", "<leader>dB", function()
                dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
            end, "[D]ebug set [B]reakpoint with condition"),
            lazy_map("n", "<leader>db", function()
                require("dap").toggle_breakpoint()
            end, "[D]ebug toggle [B]reakpoint"),
            lazy_map("n", "<leader>dc", function()
                require("dap").continue()
            end, "[D]ebug [C]ontinue"),
            lazy_map("n", "<leader>dC", function()
                require("dap").run_to_cursor()
            end, "[D]ebug run to [C]ursor"),
            lazy_map("n", "<leader>dn", function()
                require("dap").step_over()
            end, "[D]ebug [N]ext (step over)"),
            lazy_map("n", "<leader>ds", function()
                require("dap").step_into()
            end, "[D]ebug [S]tep (step into)"),
            lazy_map("n", "<leader>dg", function()
                require("dap").goto_()
            end, "[D]ebug [G]o to line (no execute)"),
            lazy_map("n", "<leader>dj", function()
                require("dap").down()
            end, "[D]ebug go down [J]"),
            lazy_map("n", "<leader>dk", function()
                require("dap").up()
            end, "[D]ebug go up [K]"),
            lazy_map("n", "<leader>dr", function()
                require("dap").repl.toggle()
            end, "[D]ebug [R]epl"),
            lazy_map("n", "<leader>dq", function()
                require("dap").terminate()
            end, "[D]ebug [T]erminate"),
            lazy_map("n", "<leader>dw", function()
                require("dap.ui.widgets").hover()
            end, "[D]ebug [W]idgets"),
        }
    end,

    config = function()
        local icons = {
            Stopped = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
            Breakpoint = " ",
            BreakpointCondition = " ",
            BreakpointRejected = { " ", "DiagnosticError" },
            LogPoint = ".>",
        }
        vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })
        for name, sign in pairs(icons) do
            sign = type(sign) == "table" and sign or { sign }
            vim.fn.sign_define(
                "Dap" .. name,
                { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
            )
        end

        local dap = require("dap")

        -- Adapters

        dap.adapters.python = {
            type = "executable",
            command = vim.g.python3_host_prog,
            args = { "-m", "debugpy.adapter" },
        }

        -- Configurations
        dap.configurations.python = {
            {
                type = "python",
                request = "launch",
                name = "Launch file",
                program = "${file}",
                pythonPath = function()
                    -- return vim.fn.input("pythonPath: ")
                    return "/usr/bin/python"
                end,
            },
        }
    end,
}
