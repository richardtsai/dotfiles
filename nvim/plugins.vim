silent! call plug#begin('~/.config/nvim/bundle')
Plug 'w0rp/ale'
Plug 'jiangmiao/auto-pairs'
Plug 'dyng/ctrlsf.vim'
Plug 'vim-scripts/kwbdi.vim'
Plug 'Shougo/echodoc.vim'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': 'bash install.sh' }
Plug 'ncm2/ncm2'
Plug 'ncm2/ncm2-bufword'
Plug 'fgrsnau/ncm2-otherbuf'
Plug 'ncm2/ncm2-path'
Plug 'ncm2/ncm2-ultisnips'
Plug 'scrooloose/nerdtree'
Plug 'roxma/nvim-yarp'
Plug 'majutsushi/tagbar'
Plug 'SirVer/ultisnips'
Plug 'mbbill/undotree'
Plug 'vim-airline/vim-airline'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'Lokaltog/vim-easymotion'
Plug 'terryma/vim-multiple-cursors'
Plug 'rakr/vim-one'
Plug 'hynek/vim-python-pep8-indent'
Plug 'kshenoy/vim-signature'
Plug 'mhinz/vim-signify'
Plug 'honza/vim-snippets'
Plug 'tpope/vim-surround'
Plug 'cespare/vim-toml'
" Plug 'lervag/vimtex'
call plug#end()

" ale
let g:ale_enabled = 1
let g:ale_linters = {
    \ 'cpp': ['cpplint', 'clangtidy'],
\ }
" cppcheck will check EVERYTHING in compdb, disable it for now
" let g:ale_c_cppcheck_options = '--enable=warning,style,performance,portability,information,missingInclude --inline-suppr'
" let g:ale_cpp_cppcheck_options = '--enable=warning,style,performance,portability,information,missingInclude --inline-suppr'

" auto-paris
let g:AutoPairsMultilineClose = 0
autocmd FileType * let g:AutoPairsMapCR = 1
autocmd FileType text let g:AutoPairsMapCR = 0

" ctrlsf
if executable('rg')
    let g:ctrlsf_ackprg = 'rg'
elseif executable('ag')
    let g:ctrlsf_ackprg = 'ag'
endif

let g:ctrlsf_extra_backend_args = {
    \ 'ag': '--ignore \*.pb.h --ignore \*.pb.cc',
    \ 'rg': '-g !\*.pb.h -g !\*.pb.cc',
\ }
let g:ctrlsf_auto_focus = {"at": "start"}

" echodoc
let g:echodoc#enable_at_startup = 1
let g:echodoc#type = 'signature'

" fzf
let g:fzf_colors = {
    \ 'fg':      ['fg', 'Normal'],
    \ 'bg':      ['bg', 'Normal'],
    \ 'hl':      ['fg', 'Comment'],
    \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
    \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
    \ 'hl+':     ['fg', 'Statement'],
    \ 'info':    ['fg', 'PreProc'],
    \ 'border':  ['fg', 'Ignore'],
    \ 'prompt':  ['fg', 'Conditional'],
    \ 'pointer': ['fg', 'Exception'],
    \ 'marker':  ['fg', 'Keyword'],
    \ 'spinner': ['fg', 'Label'],
    \ 'header':  ['fg', 'Comment'],
\ }

" LanguageClient
let s:clangd = expand($LLVM_PATH . '/bin/clangd')
if !executable(s:clangd)
    let s:clangd = 'clangd'
endif
let g:LanguageClient_serverCommands = {}
if executable(s:clangd)
    let clangd_cmd = [
      \ s:clangd,
      \ '-j=4',
      \ '-pch-storage=memory',
      \ '-header-insertion-decorators=false',
    \ ]
    let g:LanguageClient_serverCommands['c'] = clangd_cmd
    let g:LanguageClient_serverCommands['cpp'] = clangd_cmd
endif
if executable('pyls')
    let g:LanguageClient_serverCommands['python'] = ['pyls', '--log-file', '/tmp/pyls.log']
endif
if executable('rustup')
    let g:LanguageClient_serverCommands['rust'] = ['rustup', 'run', 'stable', 'rls']
endif
if executable('go-langserver')
    let g:LanguageClient_serverCommands['go'] = ['bingo', '-maxparallelism=4', '-disable-diagnostics']
endif
let g:LanguageClient_hasSnippetSupport = 1

" ncm2
autocmd BufEnter * call ncm2#enable_for_buffer()
set completeopt=noinsert,menuone,noselect

" nerdtree
let g:NERDTreeWinSize = 40

function IsNTOpen()
  return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
endfunction

function IsNormalBufName(name)
    return a:name !~# '\(__.*__\|NERD_tree_\)'
endfunction

function BufNerdHighlight()
    if !IsNTOpen()  " no nerdtree
        return
    elseif bufnr('$') <= 1 || winnr() == 1  " root window
        return
    elseif getwinvar(winnr(), '&syntax') == 'qf'  " quickfix / location list
        return
    elseif !IsNormalBufName(bufname('%'))  " not normal file buffer
        return
    elseif &previewwindow  " not preview window
        return
    elseif !filereadable(expand(bufname('%')))  " not exists
        return
    endif

    if !(getline(1) ==# '' && 1 == line('$'))
       :NERDTreeFind
       wincmd p
    else
       :NERDTreeCWD
       wincmd p
    endif
endfunction

function RefNerdTree(do_refresh)
    if !IsNTOpen()
        return
    endif
    if a:do_refresh
        if getbufvar('%', 'should_ref_nerd_tree', v:false)
            :NERDTreeRefreshRoot
        endif
    else
        call setbufvar('%', 'should_ref_nerd_tree', !filereadable(expand(bufname('%'))))
    endif
endfunction()

autocmd BufEnter * call BufNerdHighlight()
autocmd BufWrite * call RefNerdTree(v:false)
autocmd BufWritePost * call RefNerdTree(v:true)

" tagbar
let g:tagbar_ctags_bin='ctags'
let g:tagbar_width = 40
let g:tagbar_left = 0

" undotree
let g:undotree_WindowLayout = 3
let g:undotree_SetFocusWhenToggle = 1

" airline
let g:airline_theme='one'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#whitespace#enabled = 0
augroup AirlineLangcli
    autocmd!
    autocmd User AirlineAfterInit call langcli#InitAirline()
augroup END

" cpp-enhanced-highlight
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1

" easymotion
let g:EasyMotion_smartcase = 1

" multiple-cursors
function! Multiple_cursors_before()
    call ncm2#lock('vim-multiple-cursors')
endfunction

function! Multiple_cursors_after()
    call ncm2#unlock('vim-multiple-cursors')
endfunction

" one
let g:one_allow_italics = 1
set background=dark
colorscheme one
" set t_8b=[48;2;%lu;%lu;%lum
" set t_8f=[38;2;%lu;%lu;%lum
