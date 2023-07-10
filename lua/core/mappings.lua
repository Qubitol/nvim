local M = {}

M.general = {
	n = {
		["<C-u>"] = { "<C-u>zz", "Scroll and center viewport" },
		["<C-d>"] = { "<C-d>zz", "Scroll and center viewport" },
		["n"] = { "nzz", "Find next and center viewport" },
		["N"] = { "Nzz", "Find previous and center viewport" },
		["<leader>sr"] = {
			":%s/\\<<C-r><C-w>\\>//gI<left><left><left>",
			"[S]earch and [R]eplace the word under the cursor",
		},
		["<leader>th"] = { "<cmd>set hlsearch! hlsearch?<CR>", "[T]oggle search-[H]ighlighting" },
		["<leader>tw"] = { "<cmd>set wrap! wrap?<CR>", "[T]oggle word-[W]rap" },
		["<leader>x"] = { "<cmd>!chmod +x %<CR>", "Make file e[X]ecutable" },
		["<leader>bd"] = { ":bnext<CR>:bdelete#<CR>", "Unload the current [B]uffer and [D]elete it from the list" },
		["[b"] = { ":bprevious<CR>", "Go to previous [B]uffer" },
		["]b"] = { ":bnext<CR>", "Go to next [B]uffer" },
		["[B"] = { ":bfirst<CR>", "Go to first [B]uffer" },
		["]B"] = { ":blast<CR>", "Go to last [B]uffer" },
		["[t"] = { ":tprevious<CR>", "Go to previous [T]ag" },
		["]t"] = { ":tnext<CR>", "Go to next [T]ag" },
		["[T"] = { ":tfirst<CR>", "Go to first [T]ag" },
		["]T"] = { ":tlast<CR>", "Go to last [T]ag" },
		["[<C-T>"] = { ":ptprevious<CR>", "Go to previous tag in the preview window" },
		["]<C-T>"] = { ":ptnext<CR>", "Go to next tag in the preview window" },
		["[q"] = { ":cprevious<CR>zz", "Go to previous [Q]uickfix list element and center viewport" },
		["]q"] = { ":cnext<CR>zz", "Go to next [Q]uickfix list element and center viewport" },
		["[Q"] = { ":cfirst<CR>zz", "Go to first [Q]uickfix list element and center viewport" },
		["]Q"] = { ":clast<CR>zz", "Go to last [Q]uickfix list element and center viewport" },
		["[<C-Q>"] = { ":cpfile<CR>", "Display the first error in the next file in the quickfix list" },
		["]<C-Q>"] = { ":cnfile<CR>", "Display the first error in the next file in the quickfix list" },
		["<leader>qn"] = { ":cnewer<CR>", "Go to the [Q]uickfix list [N]ext" },
		["<leader>qp"] = { ":colder<CR>", "Go to the [Q]uickfix list [P]revious" },
		["[l"] = { ":lprevious<CR>zz", "Go to previous [L]ocation list element and center viewport" },
		["]l"] = { ":lnext<CR>zz", "Go to next [L]ocation list element and center viewport" },
		["[L"] = { ":lfirst<CR>zz", "Go to first [L]ocation list element and center viewport" },
		["]L"] = { ":llast<CR>zz", "Go to last [L]ocation list element and center viewport" },
		["[<C-L>"] = { ":lpfile<CR>", "Display the last error in the previous file in the location list" },
		["]<C-L>"] = { ":lnfile<CR>", "Display the first error in the next file in the location list" },
		["[a"] = { ":previous<CR>", "Go to previous [A]rg" },
		["]a"] = { ":next<CR>", "Go to next [A]rg" },
		["[A"] = { ":first<CR>", "Go to first [A]rg" },
		["]A"] = { ":last<CR>", "Go to last [A]rg" },
		["gl"] = {
			"<cmd>diffget //3<CR>",
			"[G]et the merge resolution from the buffer on the right (in the direction of the [L] key)",
		},
		["gh"] = {
			"<cmd>diffget //2<CR>",
			"[G]et the merge resolution from the buffer on the left (in the direction of the [H] key)",
		},
		["<leader>cd"] = {
			[[<cmd>cd `=expand("%:p:h")`<CR>]],
			"[C]hange current [D]irectory to the base directory of the active buffer",
		},
		["<leader>tcd"] = {
			[[<cmd>tcd `=expand("%:p:h")`<CR>]],
			"[C]hange current directory to the base directory of the active buffer, locally to the [T]ab page",
		},
		["<leader>d"] = { [["_d]], "Delete without polluting the register" },
		["<leader>D"] = { [["_D]], "Delete without polluting the register" },
		["<leader>c"] = { [["_c]], "Change without polluting the register" },
		["<leader>C"] = { [["_C]], "Change without polluting the register" },
		[ [[<C-w>\]] ] = { ":vsplit<CR>", "Split current window vertically |" },
		[ [[<C-w>-]] ] = { ":split<CR>", "Split current window horizontally -" },
		["<leader>tq"] = { require("core.utils").toggle_qf, "[T]oggle [Q]uickfix list" },
	},
	v = {
		["<Leader>fi"] = {
			[[""y/\v<C-r>=escape('<C-r>"', '/\\(){}+?~"')<CR><CR>]],
			"[FI]nd the visual selection in the current file",
		},
		["<Leader>sr"] = {
			[[""y:%s/\v<C-r>=escape('<C-r>"', '/\\(){}+?~"')<CR>//gI<left><left><left>]],
			"[S]earch and [R]eplace the visual selection",
		},
		["<Leader>d"] = { [["_d]], "Delete without polluting the register" },
		["<Leader>D"] = { [["_D]], "Delete without polluting the register" },
		["<Leader>c"] = { [["_c]], "Change without polluting the register" },
		["<Leader>C"] = { [["_C]], "Change without polluting the register" },
		["<Leader>p"] = {
			[["_dP]],
			"Replace selected text with the content of the default register but don't pollute the register itself",
		},
		["J"] = { "<Esc>:m '>+1<CR>gv=gv", "Move line down, respect indentation" },
		["K"] = { "<Esc>:m '<-2<CR>gv=gv", "Move line up, respect indentation" },
	},
	x = {
		["<Leader>p"] = {
			[["_dP]],
			"Replace selected text with the content of the default register but don't pollute the register itself",
		},
	},
}

M.plugins = {
	aerial = {
		n = {
			["<leader>tt"] = { "<cmd>AerialToggle<CR>", "[T]oggle [T]ags sidebar, powered by Aerial" },
		},
	},

	gitsigns = {
		n = {
			["]c"] = {
				function()
					if vim.wo.diff then
						return "]c"
					end
					vim.schedule(function()
						package.loaded.gitsigns.next_hunk()
					end)
					return "<Ignore>"
				end,
				"Go to the next [C]hange (git hunk)",
				{ expr = true },
			},
			["[c"] = {
				function()
					if vim.wo.diff then
						return "[c"
					end
					vim.schedule(function()
						package.loaded.gitsigns.prev_hunk()
					end)
					return "<Ignore>"
				end,
				"Go to the previous [C]hange (git hunk)",
				{ expr = true },
			},
			["<leader>hs"] = { "<cmd>Gitsigns stage_hunk<CR>", "Consider the current [H]unk and [S]tage it" },
			["<leader>hr"] = { "<cmd>Gitsigns reset_hunk<CR>", "Consider the current [H]unk and [R]eset it" },
			["<leader>hu"] = { "<cmd>Gitsigns undo_stage_hunk<CR>", "Consider the current [H]unk and [U]nstage it" },
			["<leader>hp"] = { "<cmd>Gitsigns preview_hunk<CR>", "Consider the current [H]unk and [P]review it" },
			["<leader>tb"] = { "<cmd>Gitsigns toggle_current_line_blame<CR>", "[T]oggle inline [B]lame" },
			["<leader>td"] = { "<cmd>Gitsigns toggle_deleted<CR>", "[T]oggle [D]eleted lines" },
			["<leader>tB"] = {
				function()
					package.loaded.gitsigns.blame_line({ full = true })
				end,
				"[T]oggle full [B]lame preview for the current line",
			},
			["<leader>dv"] = {
				function()
					package.loaded.gitsigns.diffthis(nil, { vertical = true })
				end,
				"Open a [D]iff view of the current buffer in a [V]ertical split",
			},
		},
		v = {
			["<leader>hs"] = { "<cmd>Gitsigns stage_hunk<CR>", "Consider the current [H]unk and [S]tage it" },
			["<leader>hr"] = { "<cmd>Gitsigns reset_hunk<CR>", "Consider the current [H]unk and [R]eset it" },
		},
		o = {
			["ih"] = { "<cmd><C-U>Gitsigns select_hunk<CR>", "Select [I]nside the current [H]unk" },
		},
		x = {
			["ih"] = { "<cmd><C-U>Gitsigns select_hunk<CR>", "Select [I]nside the current [H]unk" },
		},
	},

	harpoon = {
		n = {
			["<leader>ho"] = {
				function()
					require("harpoon.ui").toggle_quick_menu()
				end,
				"Toggle [H]arpoon menu [O]pening",
			},
			["<leader>hm"] = {
				function()
					require("harpoon.mark").add_file()
				end,
				"Add current file to [H]arpoon [M]arks",
			},
			["<C-h>"] = {
				function()
					require("harpoon.ui").nav_file(1)
				end,
				"Navigate to first mark (mnemonic: [H]jkl)",
			},
			["<C-j>"] = {
				function()
					require("harpoon.ui").nav_file(2)
				end,
				"Navigate to first mark (mnemonic: h[J]kl)",
			},
			["<C-k>"] = {
				function()
					require("harpoon.ui").nav_file(3)
				end,
				"Navigate to first mark (mnemonic: hj[K]l)",
			},
			["<C-l>"] = {
				function()
					require("harpoon.ui").nav_file(4)
				end,
				"Navigate to first mark (mnemonic: hjk[L])",
			},
		},
	},

	lsp = {
		n = {
			["gD"] = { "<cmd>lua vim.lsp.buf.declaration()<CR>", "[G]o to [D]eclaration of identifier under the cursor" },
			["<C-W>gD"] = {
				"<cmd>vsplit | lua vim.lsp.buf.declaration()<CR>",
				"Split [W]indow vertically and [G]o to [D]eclaration of identifier under the cursor",
			},
			["<C-W><C-G>D"] = {
				"<cmd>vsplit | lua vim.lsp.buf.declaration()<CR>",
				"Same as \"CTRL-W gi\"",
			},
			["<C-W>D"] = {
				"<cmd>split | lua vim.lsp.buf.declaration()<CR>",
				"Split [W]indow and jump to [D]eclaration of identifier under the cursor",
			},
			["<C-W>i"] = {
				"<cmd>split | lua vim.lsp.buf.declaration()<CR>",
				"Split [W]indow and jump to declaration of [I]dentifier under the cursor",
			},
			["<C-W><C-I>"] = {
				"<cmd>split | lua vim.lsp.buf.declaration()<CR>",
				"Same as \"CTRL-W i\"",
			},
			["gd"] = { "<cmd>lua vim.lsp.buf.definition()<CR>", "[G]o to [D]efinition under the cursor" },
			["<C-W>gd"] = {
				"<cmd>vsplit | lua vim.lsp.buf.definition()<CR>",
				"Split [W]indow vertically and [G]o to [D]efinition under the cursor",
			},
			["<C-W><C-G>d"] = {
				"<cmd>vsplit | lua vim.lsp.buf.definition()<CR>",
				"Same as \"CTRL-W gd\"",
			},
			["<C-W>d"] = {
				"<cmd>split | lua vim.lsp.buf.definition()<CR>",
				"Split [W]indow and jump to [D]efinition under the cursor",
			},
			["<C-W><C-D>"] = {
				"<cmd>split | lua vim.lsp.buf.definition()<CR>",
				"Same as \"CTRL-W d\"",
			},
			["<leader>li"] = {
				"<cmd>lua vim.lsp.buf.implementation()<CR>",
				"[L]ist of [I]mplementations under the cursor in quickfix window",
			},
			["<leader>lr"] = {
				"<cmd>lua vim.lsp.buf.references()<CR>",
				"[L]ist of [R]eferences under the cursor in quickfix window",
			},
			-- ["gtd"] = {
			--     "<cmd>vsplit | lua vim.lsp.buf.definition()<CR><C-w>T",
			--     "[G]o to a new [T]ab with [D]efinition of the term under the cursor",
			-- },
			["K"] = {
				"<cmd>lua vim.lsp.buf.hover()<CR>",
				"Show information about the term under the cursor, like hovering",
			},
			["<leader>lf"] = {
				"<cmd>lua vim.lsp.buf.format({ async = true })<cr>",
				"Run the [L]SP [F]ormatter on the current file",
			},
			["<leader>lI"] = { "<cmd>LspInfo<cr>", "Show the [L]SP [I]nfo of the current file" },
			["<leader>ca"] = {
				"<cmd>lua vim.lsp.buf.code_action()<cr>",
				"Open possible LSP [C]ode [A]ctions for the diagnostic under the cursor",
			},
			["]d"] = {
				"<cmd>lua vim.diagnostic.goto_next({ buffer = 0 })<cr>zz",
				"Go to next [D]iagnostic, center viewport",
			},
			["[d"] = {
				"<cmd>lua vim.diagnostic.goto_prev({ buffer = 0 })<cr>zz",
				"Go to previous [D]iagnostic, center viewport",
			},
			["<F2>"] = {
				"<cmd>lua vim.lsp.buf.rename()<cr>",
				"Rename the identifier under the cursor",
			},
			["<leader>H"] = {
				"<cmd>lua vim.lsp.buf.signature_help()<CR>",
				"Show an [H]elper with the signature of the term under the cursor",
			},
			["<leader>ll"] = {
				"<cmd>lua vim.diagnostic.setloclist()<CR>",
				"Open the [L]SP diagnostics in the [L]ocation list",
			},
			["<leader>lq"] = {
				"<cmd>lua vim.diagnostic.setqflist()<CR>",
				"Open the [L]SP diagnostics in the [Q]uickfix list",
			},
		},
	},

	luasnip = {},

	neorg = {
		n = {
			["<leader>tc"] = { "<cmd>Neorg toggle-concealer<CR>", "[T]oggle Neorg [C]oncelaer" },
			["<leader>no"] = {
				"<cmd>Neorg keybind all core.looking-glass.magnify-code-block<CR>",
				"Run [N]eorg looking glass to [O]pen code blocks in separate buffers",
			},
			["<leader>nt"] = { "<cmd>Neorg toc<CR>", "Open [N]eorg [T]oc" },
			["<leader>nu"] = {
				"<cmd>Neorg keybind norg core.qol.todo_items.todo.task_undone<CR>",
				"Mark the [N]eorg task under the cursor as '[U]ndone'",
			},
			["<leader>np"] = {
				"<cmd>Neorg keybind norg core.qol.todo_items.todo.task_pending<CR>",
				"Mark the [N]eorg task under the cursor as '[P]ending'",
			},
			["<leader>nd"] = {
				"<cmd>Neorg keybind norg core.qol.todo_items.todo.task_done<CR>",
				"Mark the [N]eorg task under the cursor as '[D]one'",
			},
			["<leader>nh"] = {
				"<cmd>Neorg keybind norg core.qol.todo_items.todo.task_on_hold<CR>",
				"Mark the [N]eorg task under the cursor as 'on [H]old'",
			},
			["<leader>nc"] = {
				"<cmd>Neorg keybind norg core.qol.todo_items.todo.task_cancelled<CR>",
				"Mark the [N]eorg task under the cursor as '[C]ancelled'",
			},
			["<leader>nr"] = {
				"<cmd>Neorg keybind norg core.qol.todo_items.todo.task_recurring<CR>",
				"Mark the [N]eorg task under the cursor as '[R]ecurring'",
			},
			["<leader>ni"] = {
				"<cmd>Neorg keybind norg core.qol.todo_items.todo.task_important<CR>",
				"Mark the [N]eorg task under the cursor as '[I]mportant'",
			},
			["<C-n>"] = {
				"<cmd>Neorg keybind norg core.qol.todo_items.todo.task_cycle<CR>",
				"Cycle among [N]eorg task statuses",
			},
			[">>"] = {
				"<cmd>Neorg keybind norg core.promo.promote_range<CR><cmd>Neorg keybind norg core.promo.promote<CR>",
				"Promote list item (recursively)",
			},
			["<<"] = {
				"<cmd>Neorg keybind norg core.promo.promote_range<CR><cmd>Neorg keybind norg core.promp.demote<CR>",
				"Demote list item (recursively)",
			},
			[">."] = {
				"<cmd>Neorg keybind norg core.promo.promote<CR>",
				"Promote list item (non-recursively)",
			},
			["<."] = {
				"<cmd>Neorg keybind norg core.promp.demote<CR>",
				"Demote list item (non-recursively)",
			},
		},
		i = {
			["<C-t>"] = {
				"<cmd>Neorg keybind norg core.promo.promote<CR>",
				"Promote list item (non-recursively)",
			},
			["<C-d>"] = {
				"<cmd>Neorg keybind norg core.promp.demote<CR>",
				"Demote list item (non-recursively)",
			},
			["<C-n>"] = { -- I rebinded Shift-Enter on my terminal to output \x0e
				"<cmd>Neorg keybind norg core.itero.next-iteration<CR>",
				"Create next list item",
			},
		},
	},

	netrw = {
		n = {
			["<leader>e"] = {
				function() require("plugins.netrw").toggle_explorer_current("L", false) end,
				"Toggle file [E]xplorer netrw on current directory with cursor on current file",
			},
			["<leader>E"] = {
				function() require("plugins.netrw").toggle_explorer("L", "", false) end,
				"Toggle file [E]xplorer netrw on root directory",
			},
			["<C-W>e"] = {
                function() require("plugins.netrw").go_to_explorer_window() end,
				"Go to the [W]indow containing the file [E]xplorer netrw, if no such window is present, open it",
			},
			["<C-W><C-E>"] = {
                function() require("plugins.netrw").go_to_explorer_window() end,
				"Go to the [W]indow containing the file [E]xplorer netrw, if no such window is present, open it",
			},
		},
	},

	["no-neck-pain"] = {
		n = {
			["<leader>tn"] = {
				"<cmd>NoNeckPain<CR>",
				"[T]oggle [N]o-neck-pain: create a side buffer to center the current buffer",
			},
			["<leader>n="] = { "<cmd>NoNeckPainWidthUp<CR>", "Increase the size of the [N]o-neck-pain side buffer [+]" },
			["<leader>n-"] = {
				"<cmd>NoNeckPainWidthDown<CR>",
				"Decrease the size of the [N]o-neck-pain side buffer [-]",
			},
			["<leader>ns"] = {
				"<cmd>NoNeckPainScratchPad<CR>",
				"Make the [N]o-neck-pain side buffer a [S]cratchpad, opening default file ./notes-left.norg",
			},
		},
	},

	telescope = {
		n = {
			["<leader>fo"] = { "<cmd>Telescope find_files<CR>", "Telescope over files -- [F]ind [O]pen" },
			["<leader>fb"] = { "<cmd>Telescope buffers<CR>", "Telescope over loaded buffers -- [F]ind [B]uffers" },
			["<leader>ft"] = { "<cmd>Telescope aerial<CR>", "Telescope over documents tags -- [F]ind [T]ags" },
			["<leader>fq"] = {
				"<cmd>Telescope quickfixhistory<CR>",
				"Telescope over quickfix lists history -- [F]ind [Q]uickfix",
			},
			["<leader>/"] = {
				function()
					require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
						winblend = 10,
						previewer = false,
					}))
				end,
				"Fuzzy search in current buffer [/]",
			},
			["<leader>go"] = { "<cmd>Telescope live_grep<CR>", "Live grep over files -- [G]rep [O]pen" },
			["<leader>gt"] = {
				"<cmd>Telescope grep_string<CR>",
				"Live grep of the word under the cursor -- [G]rep [T]his",
			},
			["<leader>sf"] = {
				"<cmd>Telescope lsp_document_symbols<CR>",
				"Telescope over LSP [S]ymbols in the current [F]ile",
			},
			["<leader>sw"] = {
				"<cmd>Telescope lsp_workspace_symbols<CR>",
				"Telescope over LSP [S]ymbols in the current [W]orkspace",
			},
			["<leader>gl"] = { "<cmd>Telescope git_commits<CR>", "Telescope over [G]it [L]og" },
			["<leader>gb"] = { "<cmd>Telescope git_branches<CR>", "Telescope over [G]it [B]ranches" },
			["<leader>gz"] = {
				"<cmd>Telescope git_stash<CR>",
				"Telescope over [G]it Stashes (mnemonic: S is similar to [Z])",
			},
			["<leader>gw"] = {
				[[<cmd>lua require("telescope").extensions.git_worktree.git_worktrees()<CR>]],
				"Open a different [G]it [W]orktree",
			},
			["<leader>gW"] = {
				[[<cmd>lua require("telescope").extensions.git_worktree.create_git_worktree()<CR>]],
				"Run `git worktree add ...`, choosing the branch with Telescope -- [G]it [W]orktree",
			},
			["<leader>ff"] = { "<cmd>Telescope resume<CR>", "Resume latest Telescope search -- [F]ind [F]ind" },
		},
	},

	undotree = {
		n = {
			["<leader>tu"] = { vim.cmd.UndotreeToggle, "[T]oggle [U]ndotree" },
		},
	},

	["vim-fugitive"] = {
		n = {
			["<leader>gs"] = { vim.cmd.Git, "Run [G]it [S]tatus (open vim-fugitive prompt)" },
			["<leader>gp"] = { "<cmd>Git push<CR>", "Run a [G]it [P]ush" },
			["<leader>gf"] = {
				"<cmd>Git pull --rebase<CR>",
				"Run `git pull --rebase` (a [G]it [F]etch followed by a rebase in the current branch)",
			},
			["<leader>gC"] = { ":Git commit", "Populate command line with [G]it [C]ommit" },
			["<leader>gB"] = { ":Git branch", "Populate command line with [G]it [B]ranch" },
			["<leader>gZ"] = {
				":Git stash",
				"Populate command line with [G]it Stash (mnemonic: S and [Z] are similar)",
			},
			["<leader>gO"] = { ":Git checkout", "Populate command line with [G]it Check[O]ut" },
			["<leader>gL"] = { ":Git log", "Populate command line with [G]it [L]og" },
			["<leader>gP"] = { ":Git push -u origin", "Populate command line with [G]it [P]ush -u origin" },
			["<leader>gF"] = {
				":Git pull --rebase -u origin",
				"Populate the command line with `git pull --rebase` (a [G]it [F]etch followed by a rebase in the current branch)",
			},
		},
	},
}

return M
