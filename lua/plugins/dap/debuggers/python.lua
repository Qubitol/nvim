return {
    adapter = {
        type = "executable",
        command = vim.g.python3_host_prog,
        args = { "-m", "debugpy.adapter" },
    },

    configuration = {
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
    },
}
