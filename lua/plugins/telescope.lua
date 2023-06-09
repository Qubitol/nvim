local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
	return
end

local utils = require("core.utils")
local mappings = require("core.mappings")

local actions = require("telescope.actions")
local actions_layout = require("telescope.actions.layout")
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

local function open_selected_quickfix(prompt_bufnr)
    local nr = action_state.get_selected_entry().nr
    actions.close(prompt_bufnr)
    vim.cmd(nr .. "chistory")
    vim.cmd "copen"
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
				["<C-t>"] = actions_layout.toggle_preview,
				["<C-l>"] = actions.cycle_previewers_next,
				["<C-h>"] = actions.cycle_previewers_prev,
				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,
                ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
                ["<C-x>"] = actions.smart_add_to_qflist + actions.open_qflist,
                ["<M-q>"] = actions.nop, -- clash with map from tmux
			},
            n = {
				["<C-t>"] = actions_layout.toggle_preview,
				["<C-l>"] = actions.cycle_previewers_next,
				["<C-h>"] = actions.cycle_previewers_prev,
                ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
                ["<C-x>"] = actions.smart_add_to_qflist + actions.open_qflist,
                ["<M-q>"] = actions.nop, -- clash with map from tmux
            },
		},
		vimgrep_arguments = vimgrep_arguments,
	},

	pickers = {
		find_files = {
			-- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
			-- find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
            find_command = { "fd", "--type", "f", "--threads", "4", "--color", "never", "--relative-path", "--hidden",
                "--exclude", "**/.git/*", "--exclude", "**/.bzr/*", "." },
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
        quickfixhistory = {
            mappings = {
                i = {
                    ["<CR>"] = open_selected_quickfix,
                },
                n = {
                    ["<CR>"] = open_selected_quickfix,
                },
            },
        },
	},
})

-- Load extensions
telescope.load_extension("fzf")
telescope.load_extension("aerial")
telescope.load_extension("git_worktree")

utils.load_mappings(mappings.plugins["telescope"])
