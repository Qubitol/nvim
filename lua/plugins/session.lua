-- Session

local map = require("config.utils").map

vim.pack.add({
    { src = "https://github.com/tpope/vim-obsession.git" },
})

map("n", "<leader>so", "<cmd>Obsession<CR>", "[S]ession tracking [O]n")
