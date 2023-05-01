" My configuration of the VimTeX plugin
" https://github.com/ejmastnak/dotfiles/blob/main/config/nvim/ftplugin/tex/vimtex.vim

" Only load this plugin it has not yet been loaded for this buffer
if exists("b:did_myvimtexsettings")
  finish
endif
let b:did_myvimtexsettings = 1

nmap <leader>i <plug>(vimtex-info)

" nmap <leader>t <CMD>VimtexTocToggle<CR>

" Disabling some default features
" ---------------------------------------------
" Turn off VimTeX indentation
let g:vimtex_indent_enabled = 0

" Disable default mappings
" let g:vimtex_mappings_enabled = 0

" Disable insert mode mappings
let g:vimtex_imaps_enabled = 0

" Turn off completion (not currently used so more efficient to turn off)
let g:vimtex_complete_enabled = 0

" Disable syntax conceal
let g:vimtex_syntax_conceal_disable = 1  

" Default is 500 lines and gave me lags on missed key presses
let g:vimtex_delim_stopline = 5

" VimTeX toggle delimeter configuration
" ------------------------------- "
let g:vimtex_delim_toggle_mod_list = [
  \ ['\bigl', '\bigr'],
  \ ['\Bigl', '\Bigr'],
  \ ['\biggl', '\biggr'],
  \ ['\Biggl', '\Biggr'],
  \]

" Don't open quickfix for warning messages if no errors are present
let g:vimtex_quickfix_open_on_warning = 0  

" Disable some compilation warning messages
let g:vimtex_quickfix_ignore_filters = [
      \ 'LaTeX hooks Warning',
      \ 'Underfull \\hbox',
      \ 'Overfull \\hbox',
      \ 'Fatal error occurred, no output PDF file produced!',
      \]

if has('unix')
  let g:vimtex_view_method = 'zathura'
elseif has('macunix')
  let g:vimtex_view_method = 'skim'
else
  echom "Error: forward show not supported on this OS"
endif

" Don't automatically open PDF viewer after first compilation
let g:vimtex_view_automatic = 0

" Close viewers when VimTeX buffers are closed (see :help vimtex-events)
function! CloseViewers()
  if executable('xdotool')
        \ && exists('b:vimtex.viewer.xwin_id')
        \ && b:vimtex.viewer.xwin_id > 0
    call system('xdotool windowclose '. b:vimtex.viewer.xwin_id)
  endif
endfunction

augroup vimtex_event_close
  au!
  au User VimtexEventQuit call CloseViewers()
augroup END
