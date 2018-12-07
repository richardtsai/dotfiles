silent! call plug#begin('~/.config/nvim/bundle')
Plug 'w0rp/ale'
Plug 'jiangmiao/auto-pairs'
Plug 'dyng/ctrlsf.vim'
Plug 'vim-scripts/kwbdi.vim'
Plug 'Shougo/echodoc.vim'
Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': 'bash install.sh' }
Plug 'Yggdroot/LeaderF', { 'do': './install.sh' }
Plug 'ncm2/ncm2'
Plug 'ncm2/ncm2-bufword'
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
let g:ale_enabled = 0
let g:ale_set_quickfix = 1
let g:ale_linters = {
    \ 'c': ['cppcheck'],
    \ 'cpp': ['cppcheck', 'cpplint', 'clangtidy'],
\ }
let g:ale_c_cppcheck_options = '--enable=warning,style,performance,portability,information,missingInclude --inline-suppr'
let g:ale_cpp_cppcheck_options = '--enable=warning,style,performance,portability,information,missingInclude --inline-suppr'
let g:ale_cpp_clangtidy_executable = 'run-clang-tidy'
let g:ale_cpp_clangtidy_checks = ['-*', 'boost-*', 'bugprune-*', 'cert-*', 'google-*', 'hicpp-*', 'misc-*', 'modernize-*', 'performance-*', 'readability-*']

" auto-paris
let g:AutoPairsMultilineClose = 0
autocmd FileType * let g:AutoPairsMapCR = 1
autocmd FileType text let g:AutoPairsMapCR = 0

" ctrlsf
if executable('rg')
    let g:ackprg = 'rg --vimgrep'
    let g:ctrlsf_ackprg = 'rg'
    let g:user_command_async = 1
elseif executable('ag')
    let g:ackprg = 'ag --vimgrep'
    let g:ctrlsf_ackprg = 'ag'
    let g:user_command_async = 1
endif

let g:ctrlsf_extra_backend_args = {
    \ 'ag': '--ignore \*.pb.h --ignore \*.pb.cc',
    \ 'rg': '-g !\*.pb.h -g !\*.pb.cc',
\ }
let g:ctrlsf_auto_focus = {"at": "start"}

" echodoc
let g:echodoc#enable_at_startup = 1
let g:echodoc#type = 'signature'

" LanguageClient
let g:LanguageClient_serverCommands = {
    \ 'rust': ['rustup', 'run', 'stable', 'rls'],
    \ 'cpp': ['clangd', '-j=4', '-index', '-pch-storage=memory'],
    \ 'python': ['pyls', '--log-file', '/tmp/pyls.log'],
    \ 'go': ['go-langserver', '-maxparallelism=4', '-gocodecompletion'],
\ }
let g:LanguageClient_hasSnippetSupport = 0
let g:LanguageClient_autoOpenLists = ["Locations"]

" LeaderF
let g:Lf_WindowHeight = 0.3
let g:Lf_DefaultMode = 'FullPath'
let g:Lf_WildIgnore = {
    \ 'dir': ['.svn', '.git', '.hg'],
    \ 'file': ['*.sw?', '~$*', '*.bak', '*.exe', '*.o', '*.so', '*.py[co]', '*.pb.h', '*.pb.cc']
\ }
let g:Lf_StlColorscheme = 'powerline'
let g:Lf_UseVersionControlTool = 0
let g:Lf_UseCache = 0

" ncm2
autocmd BufEnter * call ncm2#enable_for_buffer()
set completeopt=noinsert,menuone,noselect
let g:ncm2#filter = 'same_word'

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
    endif

    if !(getline(1) ==# '' && 1 == line('$'))
       :NERDTreeFind
       wincmd p
    else
       :NERDTreeCWD
       wincmd p
    endif
endfunction

autocmd BufEnter * call BufNerdHighlight()

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
