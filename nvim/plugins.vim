silent! call plug#begin('~/.config/nvim/bundle')
Plug 'w0rp/ale'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'dyng/ctrlsf.vim'
Plug 'vim-scripts/kwbdi.vim'
Plug 'Shougo/echodoc.vim'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'scrooloose/nerdtree'
Plug 'roxma/nvim-yarp'
Plug 'joshdick/onedark.vim'
Plug 'majutsushi/tagbar'
Plug 'mbbill/undotree'
Plug 'vim-airline/vim-airline'
Plug 'ryanoasis/vim-devicons'
Plug 'bfrg/vim-cpp-modern'
Plug 'Lokaltog/vim-easymotion'
Plug 'jackguo380/vim-lsp-cxx-highlight'
Plug 'terryma/vim-multiple-cursors'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'hynek/vim-python-pep8-indent'
Plug 'derekwyatt/vim-scala'
Plug 'kshenoy/vim-signature'
Plug 'mhinz/vim-signify'
Plug 'honza/vim-snippets'
Plug 'tpope/vim-surround'
Plug 'cespare/vim-toml'

Plug '~/.config/nvim/my/shortcuts'
call plug#end()

" ale
let g:ale_enabled = 1
let g:ale_linters = {
    \ 'cpp': ['cpplint'],
\ }
" cppcheck will check EVERYTHING in compdb, disable it for now
" let g:ale_c_cppcheck_options = '--enable=warning,style,performance,portability,information,missingInclude --inline-suppr'
" let g:ale_cpp_cppcheck_options = '--enable=warning,style,performance,portability,information,missingInclude --inline-suppr'

" coc.nvim
let g:has_language_server = {"c": 1, "cpp": 1, "objc": 1, "objcpp": 1, "python": 1}
let g:coc_global_extensions = ['coc-emmet', 'coc-highlight', 'coc-json', 'coc-python', 'coc-snippets', 'coc-pairs', 'coc-clangd']
highlight link CocHighlightText Pmenu
augroup CocAu
    autocmd!
    autocmd CursorHold * silent call CocActionAsync('highlight')
augroup end

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

" nerdtree
let g:NERDTreeWinSize = 38

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
let g:tagbar_width = 38
let g:tagbar_left = 0

" undotree
let g:undotree_WindowLayout = 3
let g:undotree_SetFocusWhenToggle = 1

" airline
let g:airline_theme='onedark'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#whitespace#enabled = 0

" cpp-modern
let g:cpp_simple_highlight = 1
let c_no_curly_error = 1

" easymotion
let g:EasyMotion_smartcase = 1

" lsp-cxx-highlight
highlight link LspCxxHlSymEnumConstant Constant
highlight link LspCxxHlSymEnum Special
highlight link LspCxxHlSymNamespace Identifier

" one
let g:onedark_terminal_italics = 1
colorscheme onedark
