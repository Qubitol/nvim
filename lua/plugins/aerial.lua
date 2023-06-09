local status_ok, aerial = pcall(require, "aerial")
if not status_ok then
	return
end

local utils = require("core.utils")
local mappings = require("core.mappings")

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

    -- on_attach = function(bufnr)
    -- end,

    show_guides = true,
})

utils.load_mappings(mappings.plugins["aerial"])
