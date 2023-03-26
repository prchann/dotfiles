" vim-plug
call plug#begin()
  " UI and themes
  Plug 'Yggdroot/indentLine'
  Plug 'scrooloose/nerdtree', { 'branch': 'master' }
  Plug 'ryanoasis/vim-devicons', { 'branch': 'master' }
  Plug 'sheerun/vim-polyglot'
  Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'morhetz/gruvbox'

  " tools
  Plug 'APZelos/blamer.nvim'
  Plug 'AndrewRadev/splitjoin.vim'
  Plug 'SirVer/ultisnips'
  Plug 'airblade/vim-gitgutter'
  Plug 'jiangmiao/auto-pairs'
  Plug 'junegunn/fzf'
  Plug 'junegunn/fzf.vim'
  Plug 'majutsushi/tagbar'
  Plug 'mhinz/vim-startify'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-rhubarb'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-unimpaired'

  " for program languages
  " Plug 'valloric/youcompleteme'
  Plug 'fatih/vim-go'
  Plug 'github/copilot.vim'
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()


" load ~/.vimrc
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath=&runtimepath
source ~/.vimrc


" keymaps
let mapleader=","
nnoremap <Leader>gg :G<CR>
nnoremap <Leader>gd :G difftool<CR>
nnoremap <Leader>ff :Files<CR>
nnoremap <Leader>\ :GoDecls<CR>
nnoremap <Leader>/ :BLines<CR>
nnoremap <Leader><Leader>/ :Ag<CR>
nnoremap <Leader>so :source $MYVIMRC<CR>
" buffer
nnoremap <Leader>bb :Buffers<CR>
nnoremap <Leader>bd :bd<CR>
" tab
nnoremap <Leader>tc :tabclose<CR>
" quickfix
nnoremap <Leader>cc :cclose<CR>
" preview
nnoremap <Leader>pc :pclose<CR>
" toggle
nnoremap yob :BlamerToggle<CR>
nnoremap yon :NERDTreeToggle<CR>
nnoremap yoN :NERDTree<CR>
nnoremap yof :NERDTreeFind<CR>
nnoremap yot :TagbarToggle<CR>


" colorscheme
" solarized
" colorscheme default
" let g:airline_solarized_bg="dark"
" let g:airline_theme="solarized"
" gruvbox
let g:gruvbox_contrast_dark='hard'
let g:gruvbox_contrast_light='soft'
let g:gruvbox_invert_selection=0
let g:gruvbox_sign_column='bg0'
let g:gruvbox_invert_signs=0
let g:gruvbox_invert_indent_guides=1
colorscheme gruvbox
let g:airline_theme="gruvbox"


" airline
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#tabline#formatter="unique_tail_improved"
let g:airline_powerline_fonts=1
let g:airline_detect_modified=1


" nerdtree
let NERDTreeShowHidden=1
let NERDTreeShowLineNumbers=0
let NERDTreeIgnore=['\.swo$', '\.swp$']


" startify
let g:startify_change_to_dir=0
" returns all modified files of the current git repo
" `2>/dev/null` makes the command fail quietly, so that when we are not
" in a git repo, the list will be empty
function! s:gitModified()
  let files=systemlist('git ls-files -m 2>/dev/null')
  return map(files, "{'line': v:val, 'path': v:val}")
endfunction
" same as above, but show untracked files, honouring .gitignore
function! s:gitUntracked()
  let files=systemlist('git ls-files -o --exclude-standard 2>/dev/null')
  return map(files, "{'line': v:val, 'path': v:val}")
endfunction
let g:startify_lists=[
  \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
  \ { 'type': function('s:gitModified'),  'header': ['   git modified']},
  \ { 'type': function('s:gitUntracked'), 'header': ['   git untracked']},
  \ { 'type': 'files',     'header': ['   MRU']            },
  \ { 'type': 'sessions',  'header': ['   Sessions']       },
  \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
  \ { 'type': 'commands',  'header': ['   Commands']       },
  \ ]


" tagbar
let g:tagbar_autofocus=0
let g:tagbar_autoclose=0
let g:tagbar_indent=1
let g:tagbar_type_go={
  \ 'ctagstype' : 'go',
  \ 'kinds'     : [
    \ 'p:package',
    \ 'i:imports:1',
    \ 'c:constants',
    \ 'v:variables',
    \ 't:types',
    \ 'n:interfaces',
    \ 'w:fields',
    \ 'e:embedded',
    \ 'm:methods',
    \ 'r:constructor',
    \ 'f:functions'
  \ ],
  \ 'sro' : '.',
  \ 'kind2scope' : {
    \ 't' : 'ctype',
    \ 'n' : 'ntype'
  \ },
  \ 'scope2kind' : {
    \ 'ctype' : 't',
    \ 'ntype' : 'n'
  \ },
  \ 'ctagsbin'  : 'gotags',
  \ 'ctagsargs' : '-sort -silent'
\ }


" indentLine
" let g:indentLine_concealcursor='inc'
let g:vim_json_conceal=0
let g:vim_json_syntax_conceal=0
let g:vim_markdown_conceal_code_blocks=0
let g:vim_markdown_conceal=0


" gitgutter
let g:gitgutter_sign_allow_clobber=0


" blamer
let g:blamer_delay=700
let g:blamer_show_in_visual_modes=0
let g:blamer_show_in_insert_modes=0
let g:blamer_relative_time=1


" ycm
" let g:ycm_confirm_extra_conf=0
" let g:ycm_seed_identifiers_with_syntax=1
" let g:ycm_complete_in_comments=1
" let g:ycm_key_list_select_completion=['<Down>']
" let g:ycm_key_list_previous_completion=['<Up>']
" let g:ycm_enable_semantic_highlighting=1
" let g:ycm_enable_inlay_hints=1

" nmap <silent> K :YcmCompleter GetDoc<CR>
" nmap <Leader>gr :YcmCompleter<Space>GoToReferences<CR>
" nmap <Leader>gi :YcmCompleter<Space>GoToImplementation<CR>
" nmap <Leader>rn :YcmCompleter<Space>RefactorRename<Space>
" nmap <Leader>yd :YcmDiags<CR>


" golang
let g:go_highlight_types=1
let g:go_highlight_extra_types=1
let g:go_highlight_fields=1
let g:go_highlight_functions=1
let g:go_highlight_function_calls=1
let g:go_highlight_methods=1
let g:go_highlight_operators=1
let g:go_highlight_generate_tags=1
let g:go_highlight_build_constraints=1


" vim-go
let g:go_fmt_autosave=1
let g:go_fmt_command='goimports'
let g:go_list_type='quickfix'
let g:godef_split=2
let g:go_def_mode='gopls'
let g:go_info_mode='gopls'
let g:completor_filetype_map={}
let g:completor_filetype_map.go={'ft': 'lsp', 'cmd': 'gopls -remote=auto'}"
let g:go_version_warning=1
let g:go_autodetect_gopath=1
let g:go_doc_keywordprg_enabled=0
let g:go_doc_popup_window=1
let g:go_metalinter_command="golangci-lint"
let g:go_metalinter_enabled=['staticcheck', 'vet', 'revive', 'errcheck']
let g:go_metalinter_autosave=0
let g:go_code_completion_enabled=0
let g:go_doc_keywordprg_enabled=0

set autowrite
au FileType go nmap <silent> gr <Plug>(go-run)
" au FileType go nmap <leader>b <Plug>(go-build)
" au FileType go nmap <leader>t <Plug>(go-test)
" au FileType go nmap <leader>c <Plug>(go-coverage-toggle)
" au FileType go nmap <Leader>s <Plug>(go-implements)
" au FileType go nmap <Leader>i <Plug>(go-info)
" au FileType go nmap <Leader>ds <Plug>(go-def-split)
" au FileType go nmap <Leader>dv <Plug>(go-def-vertical)
" autocmd Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
" autocmd Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
" autocmd Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
" autocmd Filetype go command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')
" autocmd FileType go nmap <Leader>i <Plug>(go-info)
" autocmd FileType go nmap <leader>gb :<C-u>call <SID>build_go_files()<CR>
" " run :GoBuild or :GoTestCompile based on the go file
" function! s:build_go_files()
"   let l:file=expand('%')
"   if l:file =~# '^\f\+_test\.go$'
"     call go#test#Test(0, 1)
"   elseif l:file =~# '^\f\+\.go$'
"     call go#cmd#Build(0)
"   endif
" endfunction

" copilot
let g:copilot_no_tab_map=v:true

" coc
" Use tab for trigger completion with characters ahead and navigate.
" use <C-e> to cancel the popup menu.
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1):
      \ exists('b:_copilot.suggestions') ? copilot#Accept("\<CR>") :
      \ CheckBackSpace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col=col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> ge <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>fs  <Plug>(coc-format-selected)
nmap <leader>fs  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Run the Code Lens action on the current line.
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> "\<Right>"
  inoremap <silent><nowait><expr> <C-b> "\<Left>"
  " inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  " inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')
