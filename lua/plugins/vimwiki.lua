return {
    "vimwiki/vimwiki",
    version = "*",
    event = "BufReadPost",
    keys = function()
        local lazy_map = require("utils").lazy_map
    end,
}
