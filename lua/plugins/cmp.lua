return {
	"hrsh7th/nvim-cmp",
	version = false, -- last release is way too old
	event = "InsertEnter",
	dependencies = {
		"L3MON4D3/LuaSnip",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"saadparwaiz1/cmp_luasnip",
		"zbirenbaum/copilot.lua",
	},

	opts = function()
		local cmp = require("cmp")
		local luasnip = require("luasnip")

		-- Needed to keep Luasnip Tab completion consistent
		local function has_words_before()
			unpack = unpack or table.unpack
			local line, col = unpack(vim.api.nvim_win_get_cursor(0))
			return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
		end

		local kind_icons = require("utils.ui").icons.kinds

		-- Source mapping
		local source_mapping = {
			nvim_lsp = "[LSP]",
			luasnip = "[Snippet]",
			buffer = "[Buffer]",
			path = "[Path]",
		}

		-- Border options
		local border_opts = {
			border = "single",
			winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
		}

		-- cmp configuration
		return {
			-- Enable condition
			enabled = function()
				-- disable completion in comments
				local context = require("cmp.config.context")
				-- keep command mode completion enabled when cursor is in a comment
				if vim.api.nvim_get_mode().mode == "c" then
					return true
				else
					return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
				end
			end,

			-- Autocompletion on demand by calling cmp.complete()
			completion = {
				autocomplete = false,
				completeopt = "menu,menuone,noinsert",
			},

			-- Snippet engine
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
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
					behavior = cmp.SelectBehavior.Insert,
				}),
				["<C-n>"] = cmp.mapping.select_next_item({
					behavior = cmp.SelectBehavior.Insert,
				}),
				["<C-k>"] = cmp.mapping({
					i = cmp.mapping.select_prev_item({
						behavior = cmp.SelectBehavior.Insert,
					}),
					s = cmp.mapping.select_prev_item({
						behavior = cmp.SelectBehavior.Insert,
					}),
					c = cmp.mapping.select_prev_item({
						behavior = cmp.SelectBehavior.Insert,
					}),
				}),
				["<C-j>"] = cmp.mapping({
					i = cmp.mapping.select_next_item({
						behavior = cmp.SelectBehavior.Insert,
					}),
					s = cmp.mapping.select_next_item({
						behavior = cmp.SelectBehavior.Insert,
					}),
					c = cmp.mapping.select_next_item({
						behavior = cmp.SelectBehavior.Insert,
					}),
				}),
				-- Documentation
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				-- Accept/Abort
				["<C-Space>"] = cmp.config.disable,
				["<C-y>"] = cmp.mapping({
					i = function(fallback)
						if cmp.visible() then
							cmp.confirm({
								behavior = cmp.ConfirmBehavior.Insert,
								select = true,
							})
						elseif require("copilot.suggestion").is_visible() then
							require("copilot.suggestion").accept()
						else
							fallback()
						end
					end,
					s = cmp.mapping.confirm({
						select = true,
					}),
					c = cmp.mapping.confirm({
						behavior = cmp.ConfirmBehavior.Insert,
						select = true,
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
						select = true,
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
					if luasnip.expand_or_locally_jumpable() then
						luasnip.expand_or_jump()
					elseif cmp.visible() then
						cmp.select_next_item()
					elseif has_words_before() then
						cmp.complete()
					else
						fallback()
					end
				end, { "i", "s" }),
				-- Multi-purpose Shift+Tab
				["<S-Tab>"] = cmp.mapping(function(fallback)
					if luasnip.locally_jumpable(-1) then
						luasnip.jump(-1)
					elseif cmp.visible() then
						cmp.select_prev_item()
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
						if detail and detail:find(".*%%.*") then
							vim_item.kind = vim_item.kind .. " " .. detail
						end
						if (entry.completion_item.data or {}).multiline then
							vim_item.kind = vim_item.kind .. " " .. "[ML]"
						end
					end
					local maxwidth = 80
					vim_item.abbr = string.sub(vim_item.abbr, 1, maxwidth)
					return vim_item
				end,
			},

			-- Completion sources for all filetypes
			-- the two tables as arguments are interpreted as groups of sources:
			-- sources belonging to the same group are not shown together
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "luasnip" },
				-- { name = "cmp_tabnine" },
				{ name = "path" },
			}, {
				{ name = "buffer" },
			}),

			experimental = {
				ghost_text = true,
			},
		}
	end,

	config = function(_, opts)
		local cmp = require("cmp")
		cmp.setup(opts)
		-- Set configuration for specific filetype.
		cmp.setup.filetype("gitcommit", {
			sources = cmp.config.sources({
				{ name = "cmp_git" },
			}, {
				{ name = "buffer" },
			}),
			completion = {
				autocomplete = {
					cmp.TriggerEvent.TextChanged,
				},
			},
		})

		-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
		cmp.setup.cmdline({ "/", "?" }, {
			mapping = cmp.mapping.preset.cmdline({
				["<C-p>"] = cmp.config.disable,
				["<C-n>"] = cmp.config.disable,
			}),
			sources = {
				{ name = "buffer" },
			},
			view = {
				entries = {
					name = "wildmenu",
					separator = "|",
				},
			},
			completion = {
				autocomplete = {
					cmp.TriggerEvent.TextChanged,
				},
			},
		})

		-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
		cmp.setup.cmdline(":", {
			mapping = cmp.mapping.preset.cmdline({
				["<C-p>"] = cmp.config.disable,
				["<C-n>"] = cmp.config.disable,
			}),
			sources = cmp.config.sources({
				{ name = "path" },
			}, {
				{ name = "cmdline" },
			}),
			completion = {
				autocomplete = {
					cmp.TriggerEvent.TextChanged,
				},
			},
		})
	end,

	keys = function()
		local lazy_map = require("utils").lazy_map
		return {
			lazy_map("n", "<leader>ta", function()
				local cmp = require("cmp")
				local autocomplete = vim.b.autocomplete
				local set_autocomplete
				if autocomplete then
					set_autocomplete = false
					vim.api.nvim_buf_set_var(0, "autocomplete", false)
					vim.api.nvim_echo({ { "Autocompletion disabled" } }, false, {})
				else
					set_autocomplete = { cmp.TriggerEvent.TextChanged }
					vim.api.nvim_buf_set_var(0, "autocomplete", true)
					vim.api.nvim_echo({ { "Autocompletion enabled" } }, false, {})
				end
				cmp.setup.buffer({
					completion = {
						autocomplete = set_autocomplete,
					},
				})
			end, "[T]oggle nvim-cmp [A]utocompletion for the current buffer"),
		}
	end,
}
