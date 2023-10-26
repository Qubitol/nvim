return {
    "lukas-reineke/indent-blankline.nvim",
    version = "*",
    main = "ibl",
    event = { "BufReadPre" },
    opts = {
        indent = {
            char = "▏",
        },
        scope = {
            show_start = false,
            show_end = false,
        },
        exclude = {
            filetypes = { "harpoon", "help", "lazy", "mason", "netrw", "norg", "undotree" },
        },
    },
}
