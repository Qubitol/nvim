local status_ok, aerial = pcall(require, "aerial")
if not status_ok then
	return
end

aerial.setup({
    backends = { "treesitter", "lsp", "markdown", "man" },

    layout = {
        min_width = 28,
        placement = "edge",
        preserve_equality = true,
    },

    attach_mode = "global",

    filter_kind = false,

    highlight_on_jump = false,

    -- optionally use on_attach to set keymaps when aerial has attached to a buffer
    -- on_attach = function(bufnr)
    --     -- Jump forwards/backwards with '{' and '}'
    --     vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', {buffer = bufnr})
    --     vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', {buffer = bufnr})
    -- end,

    show_guides = true,
})

vim.keymap.set('n', '<leader>ta', '<cmd>AerialToggle<CR>')
