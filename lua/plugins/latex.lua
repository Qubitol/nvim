-- LaTeX

vim.pack.add({
    "https://github.com/lervag/vimtex",
    { src = "https://github.com/Qubitol/ltex_extra.nvim", version = "fix-typo-ltex-plus" },
})

require("ltex_extra").setup({
    load_langs = { "en-US", "it" },
    path = vim.fn.stdpath("config") .. "/spell",
})
