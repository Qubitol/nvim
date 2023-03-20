local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
	return
end

local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local transform_mod = require("telescope.actions.mt").transform_mod
local telescope_config = require("telescope.config")

-- Attempt to fix multiselect without having to rely on the quickfix list
-- Taken from https://github.com/nvim-telescope/telescope.nvim/issues/1048
local function multiopen(prompt_bufnr, method)
	local edit_file_cmd_map = {
		vertical = "vsplit",
		horizontal = "split",
		tab = "tabedit",
		default = "edit",
	}
	local edit_buf_cmd_map = {
		vertical = "vert sbuffer",
		horizontal = "sbuffer",
		tab = "tab sbuffer",
		default = "buffer",
	}
	local picker = action_state.get_current_picker(prompt_bufnr)
	local multi_selection = picker:get_multi_selection()

	if #multi_selection > 1 then
		require("telescope.pickers").on_close_prompt(prompt_bufnr)
		pcall(vim.api.nvim_set_current_win, picker.original_win_id)

		-- in case of multi-selection, make drop behave like default
		if method == "drop" then
			method = "default"
		end

		for i, entry in ipairs(multi_selection) do
			local filename, row, col

			if entry.path or entry.filename then
				filename = entry.path or entry.filename

				row = entry.row or entry.lnum
				col = vim.F.if_nil(entry.col, 1)
			elseif not entry.bufnr then
				local value = entry.value
				if not value then
					return
				end

				if type(value) == "table" then
					value = entry.display
				end

				local sections = vim.split(value, ":")

				filename = sections[1]
				row = tonumber(sections[2])
				col = tonumber(sections[3])
			end

			local entry_bufnr = entry.bufnr

			if entry_bufnr then
				if not vim.api.nvim_buf_get_option(entry_bufnr, "buflisted") then
					vim.api.nvim_buf_set_option(entry_bufnr, "buflisted", true)
				end
				local command = i == 1 and "buffer" or edit_buf_cmd_map[method]
				pcall(vim.cmd, string.format("%s %s", command, vim.api.nvim_buf_get_name(entry_bufnr)))
			else
				local command = i == 1 and "edit" or edit_file_cmd_map[method]
				if vim.api.nvim_buf_get_name(0) ~= filename or command ~= "edit" then
					filename = require("plenary.path"):new(vim.fn.fnameescape(filename)):normalize(vim.loop.cwd())
					pcall(vim.cmd, string.format("%s %s", command, filename))
				end
			end

			if row and col then
				pcall(vim.api.nvim_win_set_cursor, 0, { row, col - 1 })
			end
		end
	else
		actions["select_" .. method](prompt_bufnr)
	end
end

local custom_actions = transform_mod({
	multi_selection_open_vertical = function(prompt_bufnr)
		multiopen(prompt_bufnr, "vertical")
	end,
	multi_selection_open_horizontal = function(prompt_bufnr)
		multiopen(prompt_bufnr, "horizontal")
	end,
	multi_selection_open_tab = function(prompt_bufnr)
		multiopen(prompt_bufnr, "tab")
	end,
	multi_selection_open = function(prompt_bufnr)
		-- in case only one file is selected, jump to it if it is already open
		multiopen(prompt_bufnr, "drop")
	end,
})

local function stopinsert(callback)
	return function(prompt_bufnr)
		vim.cmd.stopinsert()
		vim.schedule(function()
			callback(prompt_bufnr)
		end)
	end
end

--
-- Clone the default Telescope configuration
local vimgrep_arguments = { unpack(telescope_config.values.vimgrep_arguments) }

-- I want to search in hidden/dot files.
table.insert(vimgrep_arguments, "--hidden")
-- I don't want to search in the `.git` directory.
table.insert(vimgrep_arguments, "--glob")
table.insert(vimgrep_arguments, "!**/.git/*")

telescope.setup({
	defaults = {
		prompt_prefix = " ",
		selection_caret = "❯ ",
		entry_prefix = "  ",
        multi_icon = "",
		initial_mode = "insert",
		selection_strategy = "reset",
		-- sorting_strategy = "ascending",
		layout_strategy = "horizontal",
		layout_config = {
			horizontal = {
				prompt_position = "bottom",
				preview_width = 0.55,
				results_width = 0.8,
			},
			vertical = {
				mirror = false,
			},
			width = 0.87,
			height = 0.80,
			preview_cutoff = 120,
		},
		path_display = { "truncate" },
		winblend = 0,
		border = {},
		-- borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
		color_devicons = true,
		mappings = {
			i = {
				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,
				["<M-q>"] = actions.nop, -- clash with map from tmux
			},
		},
		vimgrep_arguments = vimgrep_arguments,
	},

	pickers = {
		find_files = {
			-- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
			find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
			mappings = {
				i = {
					["<C-v>"] = stopinsert(custom_actions.multi_selection_open_vertical),
					["<C-s>"] = stopinsert(custom_actions.multi_selection_open_horizontal),
					["<C-t>"] = stopinsert(custom_actions.multi_selection_open_tab),
					["<CR>"] = stopinsert(custom_actions.multi_selection_open),
				},
				n = {
					["<C-v>"] = custom_actions.multi_selection_open_vertical,
					["<C-s>"] = custom_actions.multi_selection_open_horizontal,
					["<C-t>"] = custom_actions.multi_selection_open_tab,
					["<CR>"] = custom_actions.multi_selection_open,
				},
			},
		},
		buffers = {
			sort_lastused = true,
			sort_mru = true,
			ignore_current_buffer = true,
			mappings = {
				i = {
					["<C-v>"] = stopinsert(custom_actions.multi_selection_open_vertical),
					["<C-s>"] = stopinsert(custom_actions.multi_selection_open_horizontal),
					["<C-t>"] = stopinsert(custom_actions.multi_selection_open_tab),
					["<CR>"] = stopinsert(custom_actions.multi_selection_open),
				},
				n = {
					["dd"] = actions.delete_buffer,
					["<C-v>"] = custom_actions.multi_selection_open_vertical,
					["<C-s>"] = custom_actions.multi_selection_open_horizontal,
					["<C-t>"] = custom_actions.multi_selection_open_tab,
					["<CR>"] = custom_actions.multi_selection_open,
				},
			},
		},
	},
})

-- Load extensions
telescope.load_extension("fzf")
telescope.load_extension("aerial")
telescope.load_extension("harpoon")
telescope.load_extension("git_worktree")

-- Mappings (mnemonic)
local map = vim.keymap.set
local builtin = require("telescope.builtin")
-- find files (Find Open)
map("n", "<leader>fo", builtin.find_files, {})
-- find *all* files (in the important filesystem folders, hidden and ignored) (Find All)
map(
	"n",
	"<leader>fa",
	[[<cmd>lua require "telescope.builtin".find_files{ find_command = { "rg", "--files", "--hidden", "--no-ignore", "--glob", "!**/.git/*" }, search_dirs = { "$HOME/Documents", "$HOME/Downloads", "$HOME/Scratch", "$HOME/.config", "$HOME/.jupyter", "$HOME/.local", "$HOME/.ssh", "$HOME/.zsh" } }<CR>]],
	{}
)
-- live grep in all files (Grep Open)
map("n", "<leader>go", builtin.live_grep, {})
-- live grep inside current buffer (Grep File)
map("n", "<leader>gf", builtin.current_buffer_fuzzy_find, {})
-- live grep of the string under cursor in all files (Grep This)
map("n", "<leader>gt", builtin.grep_string, {})
-- browse buffers (Find Buffers)
map("n", "<leader>fb", builtin.buffers, {})
-- browse aerial tags (Find Tags)
map("n", "<leader>ft", "<cmd>Telescope aerial<CR>", {})
-- browse lsp symbols (Find Lsp)
map("n", "<leader>fl", builtin.lsp_document_symbols, {})
-- browse harpoon marks (Find Harpoon)
map("n", "<leader>fh", "<cmd>Telescope harpoon marks<CR>", {})
-- browse git commit (Git Commits) -- <leader>gc means Git Commit
map("n", "<leader>gc", builtin.git_commits, {})
-- browse git commit for this buffer (Git Commits -- capitalize for buffer)
map("n", "<leader>gC", builtin.git_bcommits, {})
-- browse git branches (Git Branches)
map("n", "<leader>gb", builtin.git_branches, {})
-- browse files in git status with diff preview (Git Status)
map("n", "<leader>gs", builtin.git_status, {})
-- browse git stashes (Git stasHes)
map("n", "<leader>gh", builtin.git_stash, {})
-- browse git worktrees (Git Worktree)
map("n", "<leader>gw", [[<cmd>lua require "telescope".extensions.git_worktree.git_worktrees()<CR>]])
-- create git worktree (Create Worktree)
map("n", "<leader>cw", [[<cmd>lua require "telescope".extensions.git_worktree.create_git_worktree()<CR>]])
-- browse all symbols (Symbols Open)
map(
	"n",
	"<leader>so",
	[[<cmd>lua require "telescope.builtin".symbols{ sources = { "accented_letters", "latex", "math", "nerd" } }<CR>]]
)
-- browse accenter letters (Symbols Accents)
map("n", "<leader>sa", [[<cmd>lua require "telescope.builtin".symbols{ sources = { "accented_letters" } }<CR>]])
-- browse latex symbols (Symbols lateX)
map("n", "<leader>sx", [[<cmd>lua require "telescope.builtin".symbols{ sources = { "latex" } }<CR>]])
-- browse math symbols (Symbols Math)
map("n", "<leader>sm", [[<cmd>lua require "telescope.builtin".symbols{ sources = { "math" } }<CR>]])
-- browse nerd font symbols (Symbols Nerd)
map("n", "<leader>sn", [[<cmd>lua require "telescope.builtin".symbols{ sources = { "nerd" } }<CR>]])
