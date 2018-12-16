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

" move to character
map <leader>s <Plug>(easymotion-s)
" override builtin search
map / <Plug>(easymotion-sn)
map <leader>n <Plug>(easymotion-next)
map <leader>N <Plug>(easymotion-prev)
" }}

" panels {{
" main layout
nnoremap <leader><Space> :TagbarToggle<CR>:NERDTreeToggle<CR>:wincmd p<CR>:call BufNerdHighlight()<CR>
nnoremap <leader>u :UndotreeToggle<CR>
" choose file
let g:NERDTreeMapOpenInTab = '<C-t>' " prevent conflict
nnoremap t :EnsureNormWin<CR>:call fzf#vim#files('', {'source': 'rg --color never --no-messages --files'})<CR>
" choose tag
nnoremap <leader>t :EnsureNormWin<CR>:BTags<CR>
nnoremap <leader>T :EnsureNormWin<CR>:exec 'BTags ' . expand('<cword>')<CR>
autocmd FileType c,cpp,rust,python,go nnoremap <buffer> <leader>t :EnsureNormWin<CR>:call LanguageClient#textDocument_documentSymbol()<CR>
" choose buffer
nnoremap <leader>b :EnsureNormWin<CR>:Buffers<CR>
" }}

" superpower {{
inoremap <expr> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
" inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

nnoremap <leader>gt :call LanguageClient#textDocument_hover()<CR>
nnoremap <leader>jd :call LanguageClient#textDocument_definition()<CR>
autocmd FileType qf nmap <buffer> <CR> <CR>:lcl<CR>
nnoremap <leader>ji :call LanguageClient#textDocument_implementation()<CR>
nnoremap <leader>jr :call LanguageClient#textDocument_references()<CR>
nnoremap <leader>hl :call LanguageClient#textDocument_documentHighlight()<CR>
nnoremap <leader>HL :call LanguageClient#clearDocumentHighlight()<CR>
nnoremap qq :pclose<CR>
command! Format call LanguageClient#textDocument_formatting()
" command! -range=% Format call LanguageClient#textDocument_rangeFormatting()
command! Rename call LanguageClient#textDocument_rename()
command! Error call LanguageClient#explainErrorAtPoint()

let g:UltiSnipsExpandTrigger = '<S-TAB>'

" clang-format works better
let s:clang_format_py_path = expand($LLVM_PATH . '/share/clang/clang-format.py')
if filereadable(s:clang_format_py_path)
    autocmd FileType c,cpp,proto command! -buffer -range=% Format execute '<line1>,<line2>py3file' . s:clang_format_py_path
endif
" }}

" misc
nmap <M-F> <Plug>CtrlSFPrompt
vmap <M-F> <Plug>CtrlSFVwordPath
nnoremap <leader>R :%s/<C-r><C-w>/
