"----------------------------------------------------------#
" Global Settings
"----------------------------------------------------------#
runtime bundle/pathogen/autoload/pathogen.vim
call pathogen#infect()
call pathogen#helptags()

" add golang configs to runtimepath
if isdirectory($GOROOT . "/misc/vim" )
  call pathogen#surround( $GOROOT . "/misc/vim" )
endif
if isdirectory($GOPATH . "/src/github.com/golang/lint/misc/vim")
  call pathogen#surround($GOPATH . "/src/github.com/golang/lint/misc/vim")
endif

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set history=50                 " keep 50 lines of command line history
set ruler                      " show the cursor position all the time
set showcmd                    " display incomplete commands
set incsearch                  " do incremental searching
set ignorecase smartcase       " smart case matching
set hidden

set undodir^=~/.vim/undo//

set tabstop=2 shiftwidth=2 expandtab  " 2 space indents
set listchars=tab:>-,trail:-,extends:>,precedes:<
set modelines=5
set number                     " show line numbers
set wildmenu wildmode=list:longest,full

" Scrolling
set scrolloff=3
set sidescroll=1
set sidescrolloff=10

let mapleader = ";"

" Don't use Ex mode, use Q for formatting
map Q gq

" Try to setup colors
try
  set background=dark
  colorscheme solarized
  syntax on
  set hlsearch
catch /E185:/
  colorscheme default
endtry


" Customize solarized color
if exists('g:colors_name') && g:colors_name == 'solarized'
  let g:solarized_termtrans = 0
  colorscheme solarized
endif


" less contrast on status line
"hi StatusLine guifg=#000000 guibg=#FFFFFF ctermfg=0 ctermbg=15
"hi StatusLineNC guifg=#666666 guibg=#666666 ctermfg=7 ctermbg=8
"hi StatusLineNC guifg=#808080 guibg=#000000 ctermfg=8 ctermbg=0

" Use sane regexes.
nnoremap / /\v
vnoremap / /\v

noremap j gj
noremap k gk

" Join lines and restore cursor location (J)
nnoremap J mjJ`j

" Buffer navigation (,,) (,]) (,[) (,ls)
nmap <leader>; <C-^>
" :map <leader>] :bnext<CR>
" :map <leader>[ :bprev<CR>
nmap <leader>ls :buffers<CR>

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

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

else

  set autoindent               " always set autoindenting on

endif " has("autocmd")


" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
      \ | wincmd p | diffthis
endif


" automatically show diff when running 'git commit'
autocmd BufRead *.git/COMMIT_EDITMSG DiffGitCached | wincmd p

source $VIMRUNTIME/macros/matchit.vim

" Google-specific settings
if filereadable($HOME . "/.vim/google.vim")
  source $HOME/.vim/google.vim
endif

" localvimrc settings
let g:localvimrc_ask = 0

let g:statline_fugitive = 1
let g:statline_filename_relative = 1

" auto-close NERDtree if it's the only thing running
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

let g:gundo_preview_bottom = 1
let g:nerdtree_tabs_startup_cd = 1
let NERDTreeShowHidden=1
let NERDTreeIgnore=['\~$', '\.swp$', '\.pyc$']
let NERDTreeMapOpenVSplit="v"
let NERDTreeMapOpenSplit="s"

"----------------------------------------------------------#
" Key bindings
"----------------------------------------------------------#
inoremap jk <ESC>

nmap <silent> <leader>p :set invpaste paste?<CR>
nmap <silent> <leader>r :redraw!<CR>:redrawstatus!<CR>

nmap <silent> <leader>ff :NERDTreeTabsToggle<CR>
nmap <silent> <leader>fs :NERDTreeFind<CR>
nmap <silent> <leader>tt :TagbarToggle<CR>

" tab navigation
nmap <silent> <leader>tn :tabnew<CR>
nmap <silent> <leader>tc :tabclose<CR>

nmap <silent> <leader>sc :SyntasticCheck<CR>:Errors<CR>
nmap <silent> <leader>st :SyntasticToggleMode<CR>

nmap <silent> <leader>god :Godoc<CR>
nmap <silent> <leader>gof mg:%!gofmt<CR>`g

nnoremap <leader>u :GundoToggle<CR>

" move around split windows with ctrl
map <c-h> <c-w>h
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l
