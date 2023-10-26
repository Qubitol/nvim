return {
    "nvim-treesitter/nvim-treesitter-context",
    version = "*",
    dependencies = {
        "nvim-treesitter/nvim-treesitter"
    },
    event = { "BufReadPre" },
    opts = {
        enable = true,
    },
}
