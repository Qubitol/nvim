return {
    "nvim-treesitter/nvim-treesitter-context",
    version = "*",
    dependencies = {
        "nvim-treesitter/nvim-treesitter"
    },
    event = { "BufReadPost", "BufNewFile" },
    opts = {
        enable = true,
    },
}
