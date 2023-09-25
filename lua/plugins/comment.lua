return {
    "numToStr/Comment.nvim",
    version = "*",
    event = "BufReadPost",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "JoosepAlviste/nvim-ts-context-commentstring",
    },
    opts = {
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
    },
}
