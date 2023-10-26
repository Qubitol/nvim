return {
    "rcarriga/nvim-dap-ui",
    dependencies = {
        "mfussenegger/nvim-dap",
    },
    keys = function()
        local lazy_map = require("utils").lazy_map
        return {
            lazy_map("n", "<leader>dt", function()
                require("dapui").toggle()
            end, "[D]ebug UI [T]oggle"),
            lazy_map("n", "<leader>dos", function()
                require("dapui").float_element("scopes", { enter = true })
            end, "[D]ebug UI Float [O]pen [S]copes"),
            lazy_map("n", "<leader>doc", function()
                require("dapui").float_element("console", { enter = true, position = "center" })
            end, "[D]ebug UI Float [O]pen [C]onsole"),
            lazy_map("n", "<leader>dob", function()
                require("dapui").float_element("breakpoints", { enter = true })
            end, "[D]ebug UI Float [O]pen [B]reakpoints"),
            lazy_map("n", "<leader>dor", function()
                require("dapui").float_element("repl", { enter = true, position = "center" })
            end, "[D]ebug UI Float [O]pen [R]epl"),
            lazy_map("n", "<leader>dot", function()
                require("dapui").float_element("stacks", { enter = true })
            end, "[D]ebug UI Float [O]pen s[T]acks"),
            lazy_map("n", "<leader>dow", function()
                require("dapui").float_element("watches", { enter = true })
            end, "[D]ebug UI Float [O]pen [W]atches"),
            lazy_map("n", "<leader>de", function()
                require("dapui").eval()
            end, "[D]ebug [E]val"),
            lazy_map("v", "<leader>de", function()
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
}
