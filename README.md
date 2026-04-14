# nvim

Personal Neovim configuration built on **Neovim 0.12**, designed around minimalism, reliability, and reducing external dependencies (as much as I could, but some plugins are so cool):
- Plugin manager framework: `vim.pack`.
- No LSP client plugin, I just use native `vim.lsp.enable()`.
- I'm starting to hate autocompletion, so I switched to using just the (incredible) `<C-x><C-o>`, and related.

## Philosophy

I tried to stick as much as possible to the guiding principle that if Neovim can do it natively, I won't install a plugin for it.

- **`vim.pack`** replaces `lazy.nvim`. Plugins are declared, cloned, and loaded with the built-in package manager.
  I lose lazy loading, though, however, most plugins loads only on certain filetypes or user commands anyway.
- **`vim.lsp.enable()` + `lsp/` directory** replaces `nvim-lspconfig`.
  Each language server is a standalone Lua file returning a `vim.lsp.Config` table.
  I still use `mason` for the installation, because, well, it is **really good**.
- I tried setting up Treesitter using the native API (also because `nvim-treesitter` has been recently archived), but I just couldn't bother, and I'm still using `nvim-treesitter` to manage parsers and query, maybe in the future...
- **Manual completion** via omnifunc (`<C-x><C-o>` and related).
- **`vim.g.pretty`**, a single flag at the top of `init.lua` that controls whether the config uses nerd font icons or plain-text fallbacks.
  Every plugin reads from `config/ui.lua`, which resolves the flag once at load time.
- **`vim.g.ai`**, another flag to control the AI-related plugins.
  I use `nvim` to write my grocery list, I'm ok with *\*insert big tech company here\** not knowing what kind of risotto I will cook today (shout out to Risotto Pumpkin and Gorgonzola).
- **Theme-agnostic colors**: the highlight palette is derived from whatever colorscheme is active (default: `gruvbox` - come on, that is just the **best** colorscheme available).
  A `ColorScheme` autocmd reapplies custom groups automatically, so switching themes doesn't break anything.

## Structure

```
~/.config/nvim/
├── init.lua                    -- vim.loader, flags, require order
├── lua/
│   ├── config/
│   │   ├── init.lua            -- requires sub-modules
│   │   ├── globals.lua         -- generic global functions (e.g. recursive table print)
│   │   ├── settings.lua        -- core vim options
│   │   ├── mappings.lua        -- general keymaps
│   │   ├── ui.lua              -- icon tables (pretty / plain), single source of truth
│   │   ├── utils.lua           -- map(), bufdelete(), helpers
│   │   ├── argpick.lua         -- custom arglist picker (harpoon replacement)
│   │   ├── autocmds.lua        -- some general useful autocmd
│   │   ├── usercommands.lua    -- user commands
│   │   └── statusline.lua      -- custom statusline and winbar
│   └── plugins/
│       ├── init.lua            -- requires all plugin sub-files
│       ├── builtins.lua        -- enable those amazing builtin plugins
│       ├── git.lua             -- fugitive + gitsigns
│       ├── colors.lua          -- colorscheme + derived palette + custom highlights
│       ├── fuzzy.lua           -- fzf-lua + custom git blame pickers
│       ├── lsp.lua             -- mason + conform + nvim-lint + LspAttach
│       ├── treesitter.lua      -- nvim-treesitter and treesitter-context
│       ├── wiki.lua            -- wiki.vim, render-markdown, calendar, image.nvim, devicons
│       ├── aerial.lua          -- code outline
│       ├── latex.lua           -- vimtex + ltex-extra
│       ├── snippets.lua        -- luasnip
│       ├── surround.lua        -- nvim-surround
│       ├── indent.lua          -- indent-blankline
│       └── codecompanion.lua   -- AI in neovim
└── lsp/                        -- vim.lsp.Config files (one per server)
    ├── clangd.lua
    ├── pyright.lua
    ├── lua_ls.lua
    ├── fortls.lua
    ├── rust_analyzer.lua
    └── ...                     -- 15 servers total
```

## Features

### Custom components (no plugins)

- **argpick**: harpoon-like file switcher built on Vim's arglist.
  Opens a floating buffer listing argfiles; reorder lines with `dd`/`p`, delete entries, press `<CR>` to jump.
  Changes sync back to the arglist on close.
  The arglist persists across sessions via `Session.vim`.
  I decided to not use harpoon (still an amazing plugin), because I wasn't using all of its features,
  and I reckoned a very small utility function based on the arglist would do the trick.

- **Statusline and winbar**: hand-written `statusline` and `winbar` with mode indicator, cwd, diagnostics, LSP status, git diff counts, file-relative paths, and inactive window dimming.
  All symbols are obtained from `ui.lua`.

- **Derived color palette**: `colors.lua` extracts colors from the active colorscheme's highlight groups at runtime and builds a consistent set of custom highlights on top.
  Switching colorschemes re-derives everything automatically.

### Built-in Neovim 0.12 plugins

These are shipped with Neovim and activated via `packadd`:

- `nvim.undotree`: interactive undo tree (`:Undotree`)
- `nvim.difftool`: directory/file diff (`:DiffTool`)
- `cfilter`: quickfix list filtering
  Not many people use this plugin, actually, not many people use the quickfix list **at all**, that's an amazing tool, check it out!

### External plugins

#### Git

| Plugin | Description |
|--------|-------------|
| [vim-fugitive](https://github.com/tpope/vim-fugitive) | Git commands from inside Neovim |
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Git signs in the sign column, hunk staging, inline blame |


#### Fuzzy finding

| Plugin | Description |
|--------|-------------|
| [fzf-lua](https://github.com/ibhagwan/fzf-lua) | Fuzzy finder over files, buffers, grep, LSP symbols |


#### Code intelligence

| Plugin | Description |
|--------|-------------|
| [mason.nvim](https://github.com/mason-org/mason.nvim) | LSP/formatter/linter installer |
| [conform.nvim](https://github.com/stevearc/conform.nvim) | Formatter runner (clang-format, black, stylua, prettier, ...) |
| [nvim-lint](https://github.com/mfussenegger/nvim-lint) | Linter runner (shellcheck, cpplint, pylint, luacheck, ...) |
| [aerial.nvim](https://github.com/stevearc/aerial.nvim) | Code outline / symbol sidebar |


#### Treesitter

| Plugin | Description |
|--------|-------------|
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Automatic management of parsers and queries |
| [nvim-treesitter-context](https://github.com/nvim-treesitter/nvim-treesitter-context) | Sticky context lines at the top of the window |


#### Writing and wiki

| Plugin | Description |
|--------|-------------|
| [wiki.vim](https://github.com/lervag/wiki.vim) | Personal research wiki with journal support |
| [render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim) | In-buffer markdown rendering with conceal, checkboxes, callouts |
| [calendar.vim](https://github.com/itchyny/calendar.vim) | Calendar view, integrated with wiki journal |
| [image.nvim](https://github.com/3rd/image.nvim) | Inline image rendering (kitty terminal only) |
| [vim-table-mode](https://github.com/dhruvasagar/vim-table-mode) | Markdown table formatting |
| [vim-easy-align](https://github.com/junegunn/vim-easy-align) | Text alignment |
| [link.vim](https://github.com/qadzek/link.vim) | Link handling |


#### LaTeX

| Plugin | Description |
|--------|-------------|
| [vimtex](https://github.com/lervag/vimtex) | LaTeX editing, compilation, and preview |
| [ltex_extra.nvim](https://github.com/barreiroleo/ltex_extra.nvim) | ltex-ls dictionary and rule management (for now I'm using [my fork](https://github.com/Qubitol/ltex_extra.nvim) because of some incompatibilities) |


#### Editing

| Plugin | Description |
|--------|-------------|
| [nvim-surround](https://github.com/kylechui/nvim-surround) | Add/change/delete surrounding pairs |
| [indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim) | Indent guides |
| [LuaSnip](https://github.com/L3MON4D3/LuaSnip) | Snippet engine |


#### UI and terminal

| Plugin | Description |
|--------|-------------|
| [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons) | File type icons (only loaded when `vim.g.pretty = true`) |


#### AI

| Plugin | Description |
|--------|-------------|
| [codecompanion.nvim](https://github.com/olimorris/codecompanion.nvim) | Use different LLM chatbots and agents within neovim (only loaded when `vim.g.ai = true`) |


#### Quality-of-Life (QoL)

| Plugin | Description |
|--------|-------------|
| [vim-obsession](https://github.com/tpope/vim-obsession) | Smart session management |



### Language servers

Configured via native `lsp/` directory files.
Each returns a `vim.lsp.Config` table.

| Server | Languages |
|--------|-----------|
| `clangd` | C, C++, CUDA |
| `ty` | Python |
| `lua_ls` | Lua |
| `fortls` | Fortran |
| `bashls` | Bash, Sh |
| `awk_ls` | AWK |
| `cmake` | CMake |
| `cssls` | CSS |
| `dockerls` | Dockerfile |
| `html` | HTML |
| `jsonls` | JSON |
| `ltex-plus` | LaTeX, Markdown (grammar/spell checking) |
| `texlab` | LaTeX (compilation, references) |
| `vimls` | Vimscript |
| `yamlls` | YAML |


## Requirements

- **Neovim 0.12+** (for `vim.pack`, `vim.lsp.enable()`, built-in opt plugins)
- **luarocks** with Lua 5.1 (for treesitter parser installation)
- **fzf** and **delta** on `$PATH` (for fuzzy finding and git diff previews)
- **kitty** terminal (optional, for inline image rendering)
- A **nerd font** (optional, only if `vim.g.pretty == true` in `init.lua` - default)
- A subscription to an AI tool (in my case **Copilot** and **ClaudeCode**, optional only if `vim.g.ai == true` in `init.lua` - default) 

## Installation

```bash
git clone https://github.com/<user>/nvim.git ~/.config/nvim
nvim
```

On first launch, `vim.pack` clones all plugins automatically. Then install treesitter parsers:

```vim
:TSInstallAll
```

And install LSP servers, formatters, and linters:

```vim
:Mason
```

## Run modes

You can run with
```bash
NOPRETTY=1 nvim
```
To disable icons and general nerd UI features.

If you run with
```bash
NOAI=1 nvim
```
You disable AI-related plugins (grocery list is safe).

## Defined keymaps

To generate the following table, launch the command `:DumpKeymaps`.
It will catch all mappings generated through the use of the custom `map` function defined in `config.utils` module.

| Mode | Keymap | Description | Source |
|------|--------|-------------|--------|
| `c` | `<C-a>` | Move cursor to the beginning of the line | config/mappings |
| `c` | `<C-b>` | Move cursor one character to the left | config/mappings |
| `c` | `<C-d>` | Delete the character under the cursor | config/mappings |
| `c` | `<C-e>` | Move cursor to the end of the line | config/mappings |
| `c` | `<C-f>` | Move cursor one character to the right | config/mappings |
| `c` | `<M-b>` | Move cursor one word to the left | config/mappings |
| `c` | `<M-d>` | Delete the word after the cursor | config/mappings |
| `c` | `<M-f>` | Move cursor one word to the right | config/mappings |
| `n` | `'` | Jump to mark (easy to press on my keyboard, and more efficient) | config/mappings |
| `n` | `<C-d>` | Scroll half-page down and center viewport | config/mappings |
| `n` | `<C-h>` | Edit 1st element of arglist | config/mappings |
| `n` | `<C-j>` | Edit 2nd element of arglist | config/mappings |
| `n` | `<C-k>` | Edit 3rd element of arglist | config/mappings |
| `n` | `<C-l>` | Edit 4th element of arglist | config/mappings |
| `n` | `<C-u>` | Scroll half-page up and center viewport | config/mappings |
| `n` | `<Esc>` | Disable search-highlighting | config/mappings |
| `n` | `<leader>D` | Delete without polluting the register | config/mappings |
| `n` | `<leader>N` | Find previous (original) | config/mappings |
| `n` | `<leader>aa` | [A]dd the current file to the [A]rg list and remove possible duplicates | config/mappings |
| `n` | `<leader>bd` | Unload the current [B]uffer and [D]elete it from the list | config/mappings |
| `n` | `<leader>cd` | [C]hange current [D]irectory to the base directory of the active buffer | config/mappings |
| `n` | `<leader>d` | Delete without polluting the register | config/mappings |
| `n` | `<leader>ln` | Go to the [L]oclist [N]ext | config/mappings |
| `n` | `<leader>lp` | Go to the [L]oclist [P]revious | config/mappings |
| `n` | `<leader>n` | Find next (original) | config/mappings |
| `n` | `<leader>oa` | [O]pen [A]rglist picker | config/mappings |
| `n` | `<leader>qn` | Go to the [Q]uickfix list [N]ext | config/mappings |
| `n` | `<leader>qp` | Go to the [Q]uickfix list [P]revious | config/mappings |
| `n` | `<leader>sr` | [S]earch and [R]eplace the word under the cursor | config/mappings |
| `n` | `<leader>tcd` | [C]hange current [D]irectory to the base directory of the active buffer, locally to the [T]ab page | config/mappings |
| `n` | `<leader>th` | [T]oggle search-[H]ighlighting | config/mappings |
| `n` | `<leader>tl` | [T]oggle [L]ocation list | config/mappings |
| `n` | `<leader>tn` | [T]oggle relative line [N]umbers | config/mappings |
| `n` | `<leader>tq` | [T]oggle [Q]uickfix list | config/mappings |
| `n` | `<leader>tu` | [T]oggle [U]ndotree | config/mappings |
| `n` | `<leader>tw` | [T]oggle word-[W]rap | config/mappings |
| `n` | `N` | Find previous and center viewport | config/mappings |
| `n` | `[<C-L>` | Display the last error in the previous file in the location list | config/mappings |
| `n` | `[<C-Q>` | Display the first error in the next file in the quickfix list | config/mappings |
| `n` | `[A` | Go to first [A]rg | config/mappings |
| `n` | `[B` | Go to first [B]uffer | config/mappings |
| `n` | `[L` | Go to first [L]ocation list element and center viewport | config/mappings |
| `n` | `[Q` | Go to first [Q]uickfix list element and center viewport | config/mappings |
| `n` | `[a` | Go to previous [A]rg | config/mappings |
| `n` | `[b` | Go to previous [B]uffer | config/mappings |
| `n` | `[d` | Go to previous [D]iagnostic, center viewport | config/mappings |
| `n` | `[l` | Go to previous [L]ocation list element and center viewport | config/mappings |
| `n` | `[q` | Go to previous [Q]uickfix list element and center viewport | config/mappings |
| `n` | `]<C-L>` | Display the first error in the next file in the location list | config/mappings |
| `n` | `]<C-Q>` | Display the first error in the next file in the quickfix list | config/mappings |
| `n` | `]A` | Go to last [A]rg | config/mappings |
| `n` | `]B` | Go to last [B]uffer | config/mappings |
| `n` | `]L` | Go to last [L]ocation list element and center viewport | config/mappings |
| `n` | `]Q` | Go to last [Q]uickfix list element and center viewport | config/mappings |
| `n` | `]a` | Go to next [A]rg | config/mappings |
| `n` | `]b` | Go to next [B]uffer | config/mappings |
| `n` | `]d` | Go to next [D]iagnostic, center viewport | config/mappings |
| `n` | `]l` | Go to next [L]ocation list element and center viewport | config/mappings |
| `n` | `]q` | Go to next [Q]uickfix list element and center viewport | config/mappings |
| `n` | `g[` | [G]et the merge resolution from the buffer on the left [h] (target parent) | config/mappings |
| `n` | `g]` | [G]et the merge resolution from the buffer on the right [l] (merge parent) | config/mappings |
| `n` | `n` | Find next and center viewport | config/mappings |
| `v` | `<leader>D` | Delete without polluting the register | config/mappings |
| `v` | `<leader>d` | Delete without polluting the register | config/mappings |
| `v` | `<leader>fi` | [FI]nd the visual selection in the current file | config/mappings |
| `v` | `<leader>p` | Replace selected text with the content of the default register but don't pollute the register itself | config/mappings |
| `v` | `<leader>sr` | [S]earch and [R]eplace the visual selection | config/mappings |
| `v` | `J` | Move line down, respect indentation | config/mappings |
| `v` | `K` | Move line up, respect indentation | config/mappings |
| `n` | `<leader>tt` | [T]oggle [T]ags sidebar, powered by Aerial | plugins/aerial |
| `n,v` | `<leader>ca` | [C]odeCompation CLI for [A]gent interaction | plugins/codecompanion |
| `n,v` | `<leader>cc` | [C]ode[C]ompanion Actions | plugins/codecompanion |
| `n,v` | `<leader>co` | [C]odeCompation Chat [O]pen | plugins/codecompanion |
| `v` | `ga` | Add visually selected chat to the current chat buffer | plugins/codecompanion |
| `n` | `<leader>/` | FZF search in current buffer [/] | plugins/fuzzy |
| `n` | `<leader>fO` | FZF over files [unrestricted] -- [F]ind [O]pen | plugins/fuzzy |
| `n` | `<leader>fb` | FZF over loaded buffers -- [F]ind [B]uffers | plugins/fuzzy |
| `n` | `<leader>ff` | Resume latest FZF search -- [F]ind [F]ind | plugins/fuzzy |
| `n` | `<leader>fo` | FZF over files -- [F]ind [O]pen | plugins/fuzzy |
| `n` | `<leader>fq` | FZF over quickfix stack -- [F]ind [Q]uickfix | plugins/fuzzy |
| `n` | `<leader>fw` | FZF over wiki files -- [F]ind [W]iki | plugins/fuzzy |
| `n` | `<leader>gO` | Live grep over files [unrestricted] -- [G]rep [O]pen | plugins/fuzzy |
| `n` | `<leader>gT` | Live grep of the WORD under the cursor -- [G]rep [T]his | plugins/fuzzy |
| `n` | `<leader>go` | Live grep over files -- [G]rep [O]pen | plugins/fuzzy |
| `n` | `<leader>gt` | Live grep of the word under the cursor -- [G]rep [T]his | plugins/fuzzy |
| `n` | `<leader>gw` | Live grep over files -- [G]rep [W]iki | plugins/fuzzy |
| `n` | `<leader>sf` | FZF over LSP [S]ymbols in the current [F]ile | plugins/fuzzy |
| `n` | `<leader>sw` | FZF over LSP [S]ymbols in the current [W]orkspace | plugins/fuzzy |
| `n` | `<leader>dv` | Open a [D]iff view of the current buffer in a [V]ertical split | plugins/git |
| `n` | `<leader>gD` | Populate command line with [G]it [D]iff | plugins/git |
| `n` | `<leader>gF` | Populate the command line with `git pull --rebase -u origin` | plugins/git |
| `n` | `<leader>gP` | Populate command line with [G]it [P]ush -u origin | plugins/git |
| `n` | `<leader>gb` | [G]it [B]lame | plugins/git |
| `n` | `<leader>gd` | [G]it [D]iff in quickfix list | plugins/git |
| `n` | `<leader>gf` | Run `git pull --rebase` (a [G]it [F]etch followed by a rebase in the current branch) | plugins/git |
| `n` | `<leader>gl` | [G]it [L]og | plugins/git |
| `n` | `<leader>gp` | Run a [G]it [P]ush | plugins/git |
| `n` | `<leader>gs` | Run [G]it [S]tatus (open vim-fugitive prompt) | plugins/git |
| `n` | `<leader>hp` | Current [H]unk and [P]review it | plugins/git |
| `n` | `<leader>hr` | Current [H]unk and [R]eset it | plugins/git |
| `n` | `<leader>hs` | Current [H]unk and [S]tage it | plugins/git |
| `n` | `<leader>hu` | Current [H]unk and [U]nstage it | plugins/git |
| `n` | `<leader>tB` | [T]oggle git [B]lame (full blame with count) | plugins/git |
| `n` | `<leader>tD` | [T]oggle git [D]iff | plugins/git |
| `n` | `[c` | Go to the previous [C]hange (git hunk) or [C]onflict marker (in diff mode) | plugins/git |
| `n` | `]c` | Go to the next [C]hange (git hunk) or [C]onflict marker (in diff mode) | plugins/git |
| `o` | `ih` | Select [I]nside the current [H]unk | plugins/git |
| `v` | `<leader>gb` | [G]it [B]lame -- range history (pickaxe) | plugins/git |
| `v` | `<leader>hr` | Current [H]unk and [R]eset it | plugins/git |
| `v` | `<leader>hs` | Current [H]unk and [S]tage it | plugins/git |
| `x` | `ih` | Select [I]nside the current [H]unk | plugins/git |
| `i` | `<C-s>` | Signature help (insert mode) | plugins/lsp |
| `n` | `<leader>cf` | [C]ode [F]ormatting | plugins/lsp |
| `n` | `<leader>ll` | Open the [L]ist of diagnostics in the [L]ocation list | plugins/lsp |
| `n` | `<leader>lq` | Open the [L]ist of diagnostics in the [Q]uickfix list | plugins/lsp |
| `n` | `<leader>om` | [O]pen [M]ason dashboard | plugins/lsp |
| `n` | `<leader>sd` | Go to [S]ymbol [D]eclaration | plugins/lsp |
| `n` | `<leader>sh` | [S]ignature [H]elp | plugins/lsp |
| `n` | `<leader>tv` | [T]oggle [V]irtual text in diagnostic | plugins/lsp |
| `n` | `[d` | Go to previous [D]iagnostic, center viewport | plugins/lsp |
| `n` | `]d` | Go to next [D]iagnostic, center viewport | plugins/lsp |
| `i` | `<S-Tab>` | When inside a snippet, jump back | plugins/snippets |
| `i` | `<Tab>` | Expand snippet or jump forward, fallback to Tab | plugins/snippets |
| `i,n` | `<C-n>` | When inside a choice node, select next choice | plugins/snippets |
| `i,n` | `<C-p>` | When inside a choice node, select previous choice | plugins/snippets |
| `n` | `<leader>U` | Reload/[U]pdate the snippets at runtime | plugins/snippets |
| `s` | `<S-Tab>` | When inside a snippet, jump back | plugins/snippets |
| `s` | `<Tab>` | When inside a snippet, jump forward | plugins/snippets |
| `n,x,o` | `[M` | Move to @function.outer | plugins/treesitter |
| `n,x,o` | `[[` | Move to @class.outer | plugins/treesitter |
| `n,x,o` | `[m` | Move to @function.outer | plugins/treesitter |
| `n,x,o` | `[o` | Move to @loop.inner,@loop.outer | plugins/treesitter |
| `n,x,o` | `]M` | Move to @function.outer | plugins/treesitter |
| `n,x,o` | `]]` | Move to @class.outer | plugins/treesitter |
| `n,x,o` | `]m` | Move to @function.outer | plugins/treesitter |
| `n,x,o` | `]o` | Move to @loop.inner,@loop.outer | plugins/treesitter |
| `x,o` | `aa` | Select @parameter.outer | plugins/treesitter |
| `x,o` | `ac` | Select @class.outer | plugins/treesitter |
| `x,o` | `ad` | Select @comment.outer | plugins/treesitter |
| `x,o` | `af` | Select @function.outer | plugins/treesitter |
| `x,o` | `as` | Select @statement.outer | plugins/treesitter |
| `x,o` | `ia` | Select @parameter.inner | plugins/treesitter |
| `x,o` | `ic` | Select @class.inner | plugins/treesitter |
| `x,o` | `if` | Select @function.inner | plugins/treesitter |
| `n` | `<leader>cm` | [C]alendar for the current [M]onth | plugins/wiki |
| `n` | `<leader>cy` | [C]alendar for the current [Y]ear | plugins/wiki |
| `n` | `<leader>tc` | [T]oggle render-markdown [C]oncealment | plugins/wiki |
