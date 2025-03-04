return {
    "nvim-treesitter/nvim-treesitter",
    version = "*",
    main = "nvim-treesitter.configs",
    lazy = false,
    build = ":TSUpdate",
    opts = {
        -- A list of parser names, or "all"
        ensure_installed = {
            "bash",
            "bibtex",
            "c",
            "cmake",
            "cpp",
            "css",
            "csv",
            "cuda",
            "dockerfile",
            "doxygen",
            "fortran",
            "git_config",
            "git_rebase",
            "gitattributes",
            "gitcommit",
            "gitignore",
            "html",
            "http",
            "ini",
            "javascript",
            "json",
            -- "latex",
            "llvm",
            "lua",
            "make",
            "markdown",
            "markdown_inline",
            "meson",
            "ninja",
            "objdump",
            "requirements",
            "python",
            "regex",
            "rust",
            "sql",
            "tmux",
            "toml",
            "vim",
            "vimdoc",
            "yaml",
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
            disable = { "lua", "cpp", "c", "python" },
        },
    },
}
