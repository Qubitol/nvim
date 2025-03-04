return {
    "3rd/image.nvim",
    event = "VeryLazy",
    dependencies = "nvim-treesitter/nvim-treesitter",
    opts = {
        backend = "kitty",
        integrations = {
            markdown = {
                enabled = true,
                clear_in_insert_mode = false,
                download_remote_images = true,
                only_render_image_at_cursor = false,
            },
            neorg = { enabled = false },
            typst = { enabled = false },
            html = { enabled = false },
            css = { enabled = false },
        },
        tmux_show_only_in_active_window = true, -- otherwise in tmux it will permanently show the image in every window
    },
}
