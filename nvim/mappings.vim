let mapleader = ';'

function EnsureInNormalWindow()
    if !buflisted(bufnr('%'))
        for buf in getbufinfo({'buflisted': 1})
            let l:win = bufwinnr(buf.bufnr)
            if l:win > 0
                exe l:win . 'wincmd w'
                break
            endif
        endfor
    endif
endfunction

command EnsureNormWin call EnsureInNormalWindow()

" navigation {{
nnoremap <C-l> <C-W>l
nnoremap <C-h> <C-W>h
nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap H :EnsureNormWin<CR>:bprevious<CR>
nnoremap L :EnsureNormWin<CR>:bnext<CR>
" keep-windows-buffer-delete
nmap <leader>D <Plug>Kwbd

" airline tabs
nmap <M-q> <Plug>lightline#bufferline#go(1)
nmap <M-w> <Plug>lightline#bufferline#go(2)
nmap <M-e> <Plug>lightline#bufferline#go(3)
nmap <M-r> <Plug>lightline#bufferline#go(4)
nmap <M-t> <Plug>lightline#bufferline#go(5)
nmap <M-y> <Plug>lightline#bufferline#go(6)
nmap <M-u> <Plug>lightline#bufferline#go(7)
nmap <M-i> <Plug>lightline#bufferline#go(8)
nmap <M-o> <Plug>lightline#bufferline#go(9)

" move to character
map <leader>s <Plug>(easymotion-s)
" override builtin search
map / <Plug>(easymotion-sn)
map <leader>n <Plug>(easymotion-next)
map <leader>N <Plug>(easymotion-prev)
" }}

" panels {{
" main layout
lua << EOF
function make_fern_root_smart()
    local buf_dir = vim.fn.expand('%:p:h')
    local cwd = vim.fn.getcwd()
    if cwd == '/' or vim.startswith(buf_dir, cwd) then
        return '.'
    else
        return buf_dir
    end
end
EOF
nnoremap <leader><Space> :Vista!!<CR>:Fern . -drawer -reveal=% -stay -toggle<CR>
nnoremap vvv :execute 'Fern ' . v:lua.make_fern_root_smart() . ' -drawer -reveal=% -stay'<CR>
nnoremap <leader>u :UndotreeToggle<CR>
" files
function! s:fern_exec(cmd) abort
    let node = fern#helper#new().sync.get_cursor_node()
    if l:node['status'] == g:fern#STATUS_NONE
        let node = l:node['__owner']
    endif
    let path = l:node['_path']
    let orig_path = getcwd()
    exec 'lcd ' . l:path
    execute '!' . a:cmd
    exec 'lcd ' . l:orig_path
endfunction
command! -complete=shellcmd -nargs=+ FernExec call s:fern_exec(<q-args>)
command! -complete=shellcmd -nargs=+ FernExecIn FernDo -stay :FernExec <args>
nnoremap t :EnsureNormWin<CR>:Files<CR>
" choose tag
" use LSP symbol list for supported languages
function ShowSymbolList()
    call EnsureInNormalWindow()
    Vista finder
    " if has_key(g:has_language_server, &syntax)
    "     CocFzfList outline
    " else
    "     :BTags
    " endif
endfunction
nnoremap <leader>t :call ShowSymbolList()<CR>
" nnoremap <leader>t :CocFzfList outline<CR>
" choose buffer
nnoremap <leader>b :EnsureNormWin<CR>:Buffers<CR>
" choose command
nnoremap <leader>c :EnsureNormWin<CR>:Commands<CR>
" }}

" superpower {{
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
	  \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ "\<TAB>"
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

vmap <C-j> <Plug>(coc-snippets-select)
imap <C-j> <Plug>(coc-snippets-expand-jump)

inoremap <silent><expr> <leader><TAB> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? coc#_select_confirm() : 
                                                            \"\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? coc#_select_confirm() : 
                                     \"\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
endif

nnoremap <leader>gt :call CocActionAsync('doHover')<CR>
nmap <leader>jd <Plug>(coc-definition)
autocmd FileType qf nmap <buffer> <CR> <CR>:lcl<CR>
nmap <leader>ji <Plug>(coc-implementation)
nmap <leader>jr <Plug>(coc-references)
nnoremap <leader>hl :call CocActionAsync('highlight')<CR>
nnoremap <leader>gh :CocCommand clangd.switchSourceHeader<CR>
nnoremap qq :pclose<CR>
command! -nargs=0 Format :call CocActionAsync('format')
command! Rename call CocActionAsync('rename')
" command! Error call CocAction('diagnosticInfo')
command! Error :CocFzfList diagnostics --current-buf
nnoremap <leader>qf :belowright copen<CR>

" clang-format works better
let s:clang_format_py_path = expand($LLVM_PATH . '/share/clang/clang-format.py')
if filereadable(s:clang_format_py_path)
    let g:clang_format_fallback_style = 'Google'
    autocmd FileType c,cpp,proto command! -buffer -range=% Format execute '<line1>,<line2>py3file' . s:clang_format_py_path
endif
" }}

" misc
nmap <M-F> <Plug>CtrlSFPrompt
vmap <M-F> <Plug>CtrlSFVwordPath
nnoremap <leader>R :%s/<C-r><C-w>/
