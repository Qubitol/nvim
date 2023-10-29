return {
    {
        "mfussenegger/nvim-dap",
        keys = function()
            local lazy_map = require("utils").lazy_map
            local dap = require("dap")
            return {
                lazy_map("n", "<leader>bP", function()
                    dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
                end, "[D]ebug set [B]reakpoint with condition"),
                lazy_map("n", "<leader>bp", function()
                    require("dap").toggle_breakpoint()
                end, "[D]ebug toggle [B]reakpoint"),
                lazy_map("n", "<leader>bc", function()
                    require("dap").continue()
                end, "[D]ebug [C]ontinue"),
                lazy_map("n", "<leader>bC", function()
                    require("dap").run_to_cursor()
                end, "[D]ebug run to [C]ursor"),
                lazy_map("n", "<leader>bn", function()
                    require("dap").step_over()
                end, "[D]ebug [N]ext (step over)"),
                lazy_map("n", "<leader>bs", function()
                    require("dap").step_into()
                end, "[D]ebug [S]tep (step into)"),
                lazy_map("n", "<leader>bg", function()
                    require("dap").goto_()
                end, "[D]ebug [G]o to line (no execute)"),
                lazy_map("n", "<leader>bj", function()
                    require("dap").down()
                end, "[D]ebug go down [J]"),
                lazy_map("n", "<leader>bk", function()
                    require("dap").up()
                end, "[D]ebug go up [K]"),
                lazy_map("n", "<leader>br", function()
                    require("dap").repl.toggle()
                end, "[D]ebug [R]epl"),
                lazy_map("n", "<leader>bq", function()
                    require("dap").terminate()
                end, "[D]ebug [T]erminate"),
                lazy_map("n", "<leader>bw", function()
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

            -- initialize each debugger
            local debuggers = require("plugins.dap.debuggers")
            for _, debugger_name in pairs(debuggers) do
                local require_ok, debugger = pcall(require, "plugins.dap.debuggers." .. debugger_name)
                if require_ok and debugger.adapter and debugger.configuration then
                    dap.adapters[debugger_name] = debugger.adapter
                    dap.configurations[debugger_name] = debugger.configuration
                end
            end
        end,
    },

    {
        "rcarriga/nvim-dap-ui",
        version = "*",
        dependencies = {
            "mfussenegger/nvim-dap",
        },
        keys = function()
            local lazy_map = require("utils").lazy_map
            return {
                lazy_map("n", "<leader>bt", function()
                    require("dapui").toggle()
                end, "[D]ebug UI [T]oggle"),
                lazy_map("n", "<leader>bos", function()
                    require("dapui").float_element("scopes", { enter = true })
                end, "[D]ebug UI Float [O]pen [S]copes"),
                lazy_map("n", "<leader>boc", function()
                    require("dapui").float_element("console", { enter = true, position = "center" })
                end, "[D]ebug UI Float [O]pen [C]onsole"),
                lazy_map("n", "<leader>bob", function()
                    require("dapui").float_element("breakpoints", { enter = true })
                end, "[D]ebug UI Float [O]pen [B]reakpoints"),
                lazy_map("n", "<leader>bor", function()
                    require("dapui").float_element("repl", { enter = true, position = "center" })
                end, "[D]ebug UI Float [O]pen [R]epl"),
                lazy_map("n", "<leader>bot", function()
                    require("dapui").float_element("stacks", { enter = true })
                end, "[D]ebug UI Float [O]pen s[T]acks"),
                lazy_map("n", "<leader>bow", function()
                    require("dapui").float_element("watches", { enter = true })
                end, "[D]ebug UI Float [O]pen [W]atches"),
                lazy_map("n", "<leader>be", function()
                    require("dapui").eval()
                end, "[D]ebug [E]val"),
            }
        end,
        opts = {},
        config = function(_, opts)
            local dap = require("dap")
            local dapui = require("dapui")
            dapui.setup(opts)
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end
        end,
    },
}
