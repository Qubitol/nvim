return {
    on_attach = function(_, _)
        require("ltex_extra").setup({
            load_langs = { "en-US", "it" },
            init_check = true,
            path = vim.fn.expand("~") .. "/.config/nvim/spell",
        })
    end,
    settings = {
        ltex = {},
    },
}
