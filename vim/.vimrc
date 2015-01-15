" vim: set foldmarker={,} foldmethod=marker:

" Runtime Path {
  runtime bundle/pathogen/autoload/pathogen.vim
  call pathogen#infect()
  call pathogen#helptags()
" }

" a handful of basic config options come from vim-sensible

" General {
  set nocompatible " get out of vi-compatibility mode
  set history=9999 " keep plenty of history
  set undodir^=~/.vim/undo
  set undofile
  set spellfile=~/.vim/en.utf-8.add
  set hidden " allow changing buffers without saving
  set wildmode=list:longest,full
  set modelines=5
" }

" Vim UI {
  set list
  set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
  set number " show line numbers
  set splitright "open vertical splits on the right
  set linebreak

  " Scrolling
  set scrolloff=3
  set sidescroll=1
  set sidescrolloff=10
" }

" Text Formatting / Layout {
  set ignorecase smartcase infercase " smart case matching
  set tabstop=2 shiftwidth=2 expandtab  " 2 space indents
  if v:version >= 704
    set formatoptions+=cqj
  endif

  set diffopt=filler,vertical

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78
" }

" Folding {
  set foldenable " turn on folding
  set foldmethod=marker "fold on markers
  set foldlevel=100 " don't autofold anything
  set foldopen=block,hor,mark,percent,quickfix,tag " what movements open folds
  set foldcolumn=1
" }

" Colors {
  if $HTERM == 1
    let g:solarized_termtrans = 1
    let g:solarized_termcolors=256
  else
    let g:solarized_termtrans = 0
  endif

  if $THEME == "light"
    set background=light
  else
    set background=dark
  endif

  "let g:solarized_visibility = "high"
  "let g:solarized_contrast = "high"
  colorscheme solarized
  syntax on
  set hlsearch
  set colorcolumn=+1 " display column at edge of textwidth

  if $THEME == "light"
    highlight SignColumn ctermbg=7
    highlight FoldColumn ctermbg=7
  else
    highlight SignColumn ctermbg=8
    highlight FoldColumn ctermbg=8
  endif
" }

" Mappings {
  let mapleader = ";"

  " Don't use Ex mode, use Q for formatting
  noremap Q gq

  " Use sane regexes.
  nnoremap / /\v
  vnoremap / /\v

  noremap j gj
  noremap k gk

  " Join lines and restore cursor location (J)
  nnoremap J :call Preserve("join")<CR>

  " Buffer navigation (;;) (;]) (;[) (;ls)
  nnoremap <leader>; <C-^>
  " :map <leader>] :bnext<CR>
  " :map <leader>[ :bprev<CR>
  nnoremap <leader>ls :buffers<CR>

  " strip trailing whitespace
  nnoremap _$ :call Preserve("%s/\\s\\+$//e")<CR>

  inoremap jk <esc>

  nnoremap <silent> <leader>R :redraw!<CR>:redrawstatus!<CR>

  nnoremap <silent> <leader>tt :TagbarToggle<CR>

  " tab navigation
  nnoremap <silent> <leader>tn :tabnew<CR>
  nnoremap <silent> <leader>tc :tabclose<CR>

  nnoremap <silent> <leader>sc :SyntasticCheck<CR>:Errors<CR>
  nnoremap <silent> <leader>st :SyntasticToggleMode<CR>
  nnoremap <leader>su :sign unplace *<CR>

  nnoremap <leader>u :GundoToggle<CR>

  nnoremap <leader>fu :CtrlPFunky<CR>
  " narrow the list down with a word under cursor
  nnoremap <leader>fU :execute 'CtrlPFunky ' . expand('<cword>')<CR>

  " find current word in quickfix
  nnoremap <leader>fw :execute "vimgrep ".expand("<cword>")." %"<CR>:copen<CR>
  " find last search in quickfix
  nnoremap <leader>ff :execute 'vimgrep /'.@/.'/g %'<CR>:copen<CR>

  " move around split windows with ctrl
  noremap <C-H> <C-W>h
  noremap <C-J> <C-W>j
  noremap <C-K> <C-W>k
  noremap <C-L> <C-W>l

  inoremap <C-I>t <C-R>=system('timestamp -rfc3339')<CR>
  inoremap <C-I>e <C-R>=system('timestamp -epoch')<CR>
" }

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
" Also don't do it when the mark is in the first line, that is the default
" position when opening a file.
autocmd BufReadPost *
  \ if line("'\"") > 1 && line("'\"") <= line("$") |
  \   exe "normal! g`\"" |
  \ endif

augroup END

" Functions {
  " Convenient command to see the difference between the current buffer and
  " the file it was loaded from, thus the changes you made.
  " Only define it when not defined already.
  if !exists(":DiffOrig")
    command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
        \ | wincmd p | diffthis
  endif

  function! Preserve(command) "{
    " preparation: save last search, and cursor position.
    let _s=@/
    let view = winsaveview()
    " do the business:
    execute a:command
    " clean up: restore previous search history, and cursor position
    let @/=_s
    call winrestview(view)
  endfunction "}

  function! EnsureExists(path) "{
    if !isdirectory(expand(a:path))
      call mkdir(expand(a:path))
    endif
  endfunction "}
" }


" Plugins {
  " automatically show diff when running 'git commit'
  autocmd BufRead *.git/COMMIT_EDITMSG DiffGitCached | wincmd p

  source $VIMRUNTIME/macros/matchit.vim

  let g:localvimrc_ask = 0

  let g:statline_fugitive = 1
  let g:statline_filename_relative = 1

  let g:gundo_preview_bottom = 1

  let g:ctrlp_cache_dir = $HOME.'/.vim/ctrlp_cache'
  let g:ctrlp_extensions = ['funky']
  let g:ctrlp_funky_matchtype = 'path'

  let g:signify_vcs_list = [ 'git', 'hg' ]
  let g:signify_mapping_toggle_highlight = '<leader>sh'
  let g:signify_mapping_toggle = '<leader>st'

  let g:syntastic_go_checkers=['go', 'gofmt', 'golint', 'gotype', 'govet']
" }

" Google-specific settings {
  if filereadable($HOME . "/.vim/google.vim")
    source $HOME/.vim/google.vim
  endif
" }
