return {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
        show_end_of_line = false,
        show_current_context = false,
        filetype_exclude = { "harpoon", "help", "lazy", "mason", "netrw", "norg", "undotree" },
    },
}
