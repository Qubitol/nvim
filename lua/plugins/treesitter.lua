return {
    "nvim-treesitter/nvim-treesitter",
    version = "*",
    dependencies = {
        "JoosepAlviste/nvim-ts-context-commentstring",
    },
    build = ":TSUpdate",
    lazy = false,
    opts = {
        -- A list of parser names, or "all"
        ensure_installed = {
            "bash",
            "bibtex",
            "c",
            "cpp",
            "css",
            "dockerfile",
            "fortran",
            "gitcommit",
            "gitignore",
            "html",
            "javascript",
            "json",
            "latex",
            "lua",
            "make",
            "markdown",
            "markdown_inline",
            "norg",
            "python",
            "regex",
            "rust",
            "scss",
            "toml",
            "typescript",
            "vim",
        },

        -- Install parsers synchronously (only applied to `ensure_installed`)
        sync_install = false,

        -- Automatically install missing parsers when entering buffer
        auto_install = true,

        highlight = {
            -- `false` will disable the whole extension
            enable = true,

            -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
            -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
            -- the name of the parser)
            -- list of language that will be disabled
            disable = { "latex" },
            -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
            -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
            -- Using this option may slow down your editor, and you may see some duplicate highlights.
            -- Instead of true it can also be a list of languages
            additional_vim_regex_highlighting = false,
        },

        indent = {
            enable = true,
            disable = { "lua" },
        },

        -- Enable nvim-ts-context-commentstring
        context_commentstring = {
            enable = true,
            enable_autocmd = false,
        },
    },
    config = function(_, opts)
        require("nvim-treesitter.configs").setup(opts)
    end,
}
