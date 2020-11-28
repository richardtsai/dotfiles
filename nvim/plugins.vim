silent! call plug#begin('~/.config/nvim/bundle')
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Plug 'neoclide/coc.nvim', {'branch': 'feat/lsp-316', 'do': 'yarn install --frozen-lockfile'}
Plug 'antoinemadec/coc-fzf'
Plug 'dyng/ctrlsf.vim'
Plug 'lambdalisue/fern.vim'
Plug 'lambdalisue/fern-renderer-nerdfont.vim'
Plug 'antoinemadec/FixCursorHold.nvim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'vim-scripts/kwbdi.vim'
Plug 'Shougo/echodoc.vim'
Plug 'itchyny/lightline.vim'
Plug 'mengelbrecht/lightline-bufferline'
Plug 'lambdalisue/nerdfont.vim'
Plug 'joshdick/onedark.vim'
Plug 'mbbill/undotree'
Plug 'bfrg/vim-cpp-modern', {'for': ['c', 'cpp']}
Plug 'Lokaltog/vim-easymotion'
Plug 'terryma/vim-multiple-cursors'
Plug 'derekwyatt/vim-scala', {'for': 'scala'}
Plug 'kshenoy/vim-signature'
Plug 'mhinz/vim-signify'
Plug 'honza/vim-snippets'
Plug 'tpope/vim-surround'
Plug 'cespare/vim-toml', {'for': 'toml'}
Plug 'liuchengxu/vista.vim'

Plug '~/.config/nvim/my/shortcuts'
Plug '~/.config/nvim/my/copy'
call plug#end()

" coc.nvim
let g:has_language_server = {"c": 1, "cpp": 1, "objc": 1, "objcpp": 1, "python": 1}
let g:coc_global_extensions = ['coc-highlight', 'coc-json', 'coc-pairs', 'coc-clangd']
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

" fern
function! s:fern_reveal_current() abort
    if !buflisted(bufnr('%'))
        return
    endif
    let current = expand('%:p')
    if filereadable(l:current)
        execute 'FernDo -stay FernReveal ' . fnameescape(l:current)
    endif
endfunction
function! s:fern_init() abort
    setlocal nonumber
    nmap <buffer><expr><nowait> <cr>
	      \ fern#smart#leaf(
	      \   "\<Plug>(fern-action-open)",
	      \   "\<Plug>(fern-action-expand)",
	      \   "\<Plug>(fern-action-collapse)",
	      \ )
    nmap <buffer><nowait> R <Plug>(fern-action-reload)
endfunction
augroup FernCustom
    autocmd!
    autocmd BufEnter * call s:fern_reveal_current()
    autocmd FileType fern call s:fern_init()
augroup end
let g:fern#disable_default_mappings = 1
let g:fern#drawer_width = 45
let g:fern#renderer = 'nerdfont'
let g:fern#renderer#nerdfont#leading = '  '

" FixCursorHold
let g:cursorhold_updatetime = 200

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

" lightline
function! GetCocCurrentFunction() abort
    return get(b:, 'coc_current_function', '')
endfunction
function! s:get_coc_diagnostic(kind, sign) abort
    let info = get(b:, 'coc_diagnostic_info', {})
    if empty(info)
        return ''
    endif
    let num = get(info, a:kind, 0)
    if num == 0
        return ''
    endif
    return printf('%s %d', a:sign, num)
endfunction
function! GetCocDiagnosticError() abort
    " return s:get_coc_diagnostic('error', "\u274C")
    return s:get_coc_diagnostic('error', "\uF00D")
endfunction
function! GetCocDiagnosticWarn() abort
    return s:get_coc_diagnostic('warning', "\u26A0")
endfunction
function! GetCocDiagnosticInfo() abort
    return s:get_coc_diagnostic('information', "\u2139")
endfunction
function! GetCocDiagnosticHint() abort
    return s:get_coc_diagnostic('hint', "\u270F")
endfunction
function! GetCocStatus() abort
    return get(g:, 'coc_status', '')
endfunction
let g:lightline = {
    \ 'colorscheme': 'one',
    \ 'active': {
    \   'left': [['mode', 'paste'],
    \            ['currentfunction'],
    \            ['coc_error', 'coc_warn', 'coc_info', 'coc_hint', 'coc_status']]
    \ },
    \ 'tabline': {
    \   'left': [['buffers']],
    \   'right': [['close']]
    \ },
    \ 'component_expand': {
    \   'buffers': 'lightline#bufferline#buffers',
    \   'coc_error': 'GetCocDiagnosticError',
    \   'coc_warn': 'GetCocDiagnosticWarn',
    \   'coc_info': 'GetCocDiagnosticInfo',
    \   'coc_hint': 'GetCocDiagnosticHint',
    \   'coc_status': 'GetCocStatus',
    \ },
    \ 'component_type': {
    \   'buffers': 'tabsel',
    \   'coc_error': 'error',
    \   'coc_warn': 'warning',
    \   'coc_info': 'normal',
    \   'coc_hint': 'normal',
    \ },
    \ 'component_function': {
    \   'currentfunction': 'GetCocCurrentFunction',
    \ },
  \ }
let g:lightline#bufferline#show_number = 2
let g:lightline#bufferline#enable_nerdfont = 1
let g:lightline#bufferline#unicode_symbols = 1
let g:lightline#bufferline#smart_path = 0
let g:lightline#bufferline#modified = " \U1F589 "
autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()

" undotree
let g:undotree_WindowLayout = 3
let g:undotree_SetFocusWhenToggle = 1

" cpp-modern
let g:cpp_no_function_highlight = 1
let g:cpp_attributes_highlight = 1
let g:cpp_simple_highlight = 1
let c_no_curly_error = 1

" easymotion
let g:EasyMotion_smartcase = 1

" one
let g:onedark_terminal_italics = 1
colorscheme onedark

" vista
let g:vista_sidebar_keepalt = 1
let g:vista_stay_on_open = 0
let g:vista_executive_for = {
    \ 'c': 'coc',
    \ 'cpp': 'coc',
    \ 'python': 'coc',
    \ 'rust': 'coc',
    \ 'proto': 'ctags',
\ }
let g:vista_update_on_text_changed = 1
let g:vista_update_on_text_changed_delay = 3000
let g:vista_sidebar_width = 40
let g:vista#renderer#enable_icon = 1
let g:vista#renderer#icons = {
    \ 'func': "\uf121",
    \ 'function': "\uf121",
    \ 'functions': "\uf121",
    \ 'constructor': "\uf121",
    \ 'method': "\uf121",
    \ 'field': "\uf1b2",
    \ 'fields': "\uf1b2",
    \ 'var': "\uf1b2",
    \ 'variable': "\uf1b2",
    \ 'variables': "\uf1b2",
\ }
let g:vista_fzf_opt = ['--nth', '1..1000']
function! s:vista_try_reload() abort
    if vista#sidebar#IsOpen() && buflisted(bufnr('%'))
        call vista#sidebar#Open()
    endif
endfunction
augroup VistaAu
    autocmd!
    autocmd BufEnter * silent call s:vista_try_reload()
augroup end

function! s:all_listed_bufs_closed(except_winid)
    for win in getwininfo()
        if win.winid != a:except_winid && buflisted(win.bufnr)
            return v:false
        endif
    endfor
    return v:true
endfunction
autocmd WinClosed * if s:all_listed_bufs_closed(expand('<afile>')) | qall | endif

highlight! link CocHighlightText Pmenu
hi! link CocSem_namespace Constant
hi! link CocSem_type Type
hi! link CocSem_class Type
" hi! link CocSem_variable Identifier
hi! link CocSem_enum Structure
hi! link CocSem_enumMember Constant
hi! link CocSem_function Function
" hi! link CocSem_parameter Identifier
hi! link CocSem_method Function
hi! link CocSem_property Function
hi! link CocSem_typeParameter Type
hi! link CocSem_macro Macro
" hi! link CocSem_unknown
