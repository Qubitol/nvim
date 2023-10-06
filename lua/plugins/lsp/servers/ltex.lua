-- local dictionaries = {
-- 	"en-US",
-- 	"it",
-- }
--
-- local dictionary_path = function(language)
-- 	return vim.fn.stdpath("config") .. "/spell/ltex.dictionary." .. language .. ".txt"
-- end
--
-- local utils = require("core.utils")
--
-- local words_tables = {}
-- for _, language in pairs(dictionaries) do
-- 	local to_append = {
-- 		[language] = utils.concat_file_lines(dictionary_path(language)),
-- 	}
-- 	words_tables = vim.tbl_deep_extend("force", to_append, words_tables)
-- end

return {
    on_attach = function(_, _)
        require("ltex_extra").setup({
            load_langs = { "en-US", "it" },
            init_check = true,
            path = vim.fn.expand("~") .. "/.config/nvim/spell",
        })
    end,
    settings = {
        ltex = {
            -- dictionary = words_tables,
        },
    },
}
