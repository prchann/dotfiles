set nocompatible               " disable compatibility to old-time vi
set encoding=utf-8
set wildmode=longest,list      " get bash-like tab completions
set updatetime=100
set ttyfast                    " Speed up scrolling in Vim
set splitright                 " split windows to right
set splitbelow                 " split windows below
set hidden
set nobackup
set nowritebackup
set nospell

set ignorecase                 " case insensitive
set showmatch                  " show matching
set nohlsearch                 " highlight search
set incsearch                  " incremental search

" using system clipboard
if has('clipboard')
  set clipboard+=unnamedplus
endif
if has('mouse')
  set mouse=a
endif

syntax on                      " syntax highlighting
filetype plugin on
filetype plugin indent on      " allow auto-indenting depending on file type
set autoindent
set ts=4                       " show existing tab with 4 spaces width
set sw=4                       " when indenting with '>', use 4 spaces width
set et                         " on pressing tab, insert spaces
autocmd BufNewFile,BufRead,BufLeave *.go,*.mod setlocal noet
autocmd BufNewFile,BufRead,BufLeave *.sh,*.js,*.ts,*.json setlocal ts=2 sw=2
set list listchars=tab:\¦\     " set list to use tabs and spaces

if has('patch-8.2.0750') || has('nvim-0.4.0') " map C-f and C-b to right and left
  inoremap <silent><nowait><expr> <C-f> "\<Right>"
  inoremap <silent><nowait><expr> <C-b> "\<Left>"
endif

set background=dark
colorscheme default
if has("termguicolors")
  if !has("nvim")
    let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
  endif
  set termguicolors
endif

set cc=80                      " set cursor column
set cursorline                 " highlight current cursor line
if !has("nvim")
    hi clear CursorLine        " set cursor column style as underline
    autocmd ColorScheme * hi! clear CursorLine
    hi CursorLine gui=underline cterm=underline
    autocmd ColorScheme * hi! CursorLine gui=underline cterm=underline
endif

" set relative line number
set nu rnu
if !has("nvim")
  hi clear LineNr
  autocmd ColorScheme * hi! clear LineNr
  hi clear CursorLineNr
  autocmd ColorScheme * hi! clear CursorLineNr
  " set signcolumn
  hi clear SignColumn
  autocmd ColorScheme * hi! clear SignColumn
  autocmd ColorScheme * hi! link SignColumn LineNr
  " set signcolumn=yes scl=yes     " show sign column
endif

if empty($TMUX) && has("nvim")
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1 " use tmux's 24-bit color support
endif

if !has("nvim")                     " italic comment
  set t_ZH=[3m
  set t_ZR=[23m
  if has("termguicolors")
    highlight Comment gui=italic
    autocmd ColorScheme * hi Comment gui=italic
  else
    highlight Comment cterm=italic
    autocmd ColorScheme * hi Comment cterm=italic
  endif
endif

" return to last edit position when opening files
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
  \ endif

" remove trailing lines on save
" autocmd BufWritePre * :%s#\($\n\s*\)\+\%$##e

" " trim white space on save
" autocmd BufWritePre * :%s/\s\+$//e
