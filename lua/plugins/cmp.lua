local status_cmp_ok, cmp = pcall(require, "cmp")
if not status_cmp_ok then
	return
end
local status_luasnip_ok, luasnip = pcall(require, "luasnip")
if not status_luasnip_ok then
	return
end
-- local status_tabnine_ok, tabnine = pcall(require, "cmp_tabnine.config")
-- if not status_tabnine_ok then
-- 	return
-- end

-- Needed to keep Luasnip Tab completion
local function has_words_before()
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

-- TabNine completion settings
-- tabnine:setup({
-- 	max_lines = 1000,
-- 	max_num_results = 20,
-- 	sort = true,
-- 	run_on_every_keystroke = true,
-- 	snippet_placeholder = '..',
-- 	ignored_file_types = {},
-- 	show_prediction_strength = false
-- })

-- vim.keymap.set("n", "<Leader>tpf", function() require("cmp_tabnine"):prefetch(vim.fn.expand("%")) end, { noremap = true, silent = true })

--   פּ ﯟ   some other good icons
local kind_icons = {
    Text = "",
    Method = "m",
    Function = "",
    Constructor = "", -- ""
    Field = "󰜢",
    Variable = "󰀫",
    Class = "󰠱",
    Interface = "",
    Module = "",
    Property = "󰜢",
    Unit = "",
    Value = "",
    Enum = "",
    Keyword = "",
    Snippet = "",
    Color = "",
    File = "",
    Reference = "",
    Folder = "",
    EnumMember = "",
    Constant = "󰏿",
    Struct = "",
    Event = "",
    Operator = "",
    TypeParameter = "",
}

-- Source mapping
local source_mapping = {
    nvim_lsp = "[LSP]",
    luasnip = "[Snippet]",
    buffer = "[Buffer]",
    cmp_tabnine = "[TN]",
    path = "[Path]",
}

-- Border options
local border_opts = {
    border = "single",
    winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
}

-- cmp configuration
cmp.setup({
    -- Snippet engine
	snippet = {
		expand = function(args)
			require('luasnip').lsp_expand(args.body)
		end,
	},

    -- Windows style
	window = {
		completion = cmp.config.window.bordered(border_opts),
		documentation = cmp.config.window.bordered(border_opts),
	},

    -- Mappings
	mapping = cmp.mapping.preset.insert({
        -- Scroll items
        ["<C-p>"] = cmp.mapping.select_prev_item({
            behaviour = cmp.SelectBehavior.Insert
        }),
        ["<C-n>"] = cmp.mapping.select_next_item({
            behaviour = cmp.SelectBehavior.Insert
        }),
        ["<C-k>"] = cmp.mapping.select_prev_item({
            behaviour = cmp.SelectBehavior.Insert
        }),
        ["<C-j>"] = cmp.mapping.select_next_item({
            behaviour = cmp.SelectBehavior.Insert
        }),
        -- Documentation
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
        -- Accept/Abort
        ["<C-Space>"] = cmp.config.disable,
        ["<C-y>"] = cmp.mapping({
            i = function(fallback)
                if cmp.visible() and cmp.get_active_entry() then
                    cmp.confirm({
                        behavior = cmp.ConfirmBehavior.Insert,
                        select = false,
                    })
                else
                    fallback()
                end
            end,
            s = cmp.mapping.confirm({
                select = true
            }),
            c = cmp.mapping.confirm({
                behavior = cmp.ConfirmBehavior.Insert,
                select = true
            }),
        }),
		["<C-e>"] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
        }),
        ["<CR>"] = cmp.mapping({
            i = function(fallback)
                if cmp.visible() and cmp.get_active_entry() then
                    cmp.confirm({
                        behavior = cmp.ConfirmBehavior.Insert,
                        select = false,
                    })
                else
                    fallback()
                end
            end,
            s = cmp.mapping.confirm({
                select = true
            }),
            c = function(fallback)
                if cmp.visible() and cmp.get_active_entry() then
                    cmp.confirm({
                        behavior = cmp.ConfirmBehavior.Insert,
                        select = false,
                    })
                else
                    fallback()
                end
            end,
        }),
        -- Multi-purpose Tab
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
                -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable() 
                -- they way you will only jump inside the snippet region
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, { "i", "s" }),
        -- Multi-purpose Shift+Tab
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
    }),

    -- Formatting
    formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
            -- Kind icons
            vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
            vim_item.menu = source_mapping[entry.source.name]
            -- Add icons for tabnine completions
            if entry.source.name == "cmp_tabnine" then
                local detail = (entry.completion_item.labelDetails or {}).detail
                vim_item.kind = ""
                if detail and detail:find('.*%%.*') then
                    vim_item.kind = vim_item.kind .. ' ' .. detail
                end
                if (entry.completion_item.data or {}).multiline then
                    vim_item.kind = vim_item.kind .. ' ' .. '[ML]'
                end
            end
            local maxwidth = 80
            vim_item.abbr = string.sub(vim_item.abbr, 1, maxwidth)
            return vim_item
        end,
    },

    -- Completion sources for all filetypes
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = 'luasnip' },
		{ name = "buffer" },
		-- { name = "cmp_tabnine" },
		{ name = "path" },
	}),
})

-- Set configuration for specific filetype.
cmp.setup.filetype("gitcommit", {
	sources = cmp.config.sources({
		{ name = "cmp_git" },
		{ name = "buffer" },
	}),
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ "/", "?" }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" },
	},
    view = {
        entries = {
            name = "wildmenu",
            separator = "|",
        },
    },
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "path" },
		{ name = "cmdline" },
	}),
})
