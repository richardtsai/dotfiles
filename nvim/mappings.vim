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
nmap <M-q> <Plug>AirlineSelectTab1
nmap <M-w> <Plug>AirlineSelectTab2
nmap <M-e> <Plug>AirlineSelectTab3
nmap <M-r> <Plug>AirlineSelectTab4
nmap <M-t> <Plug>AirlineSelectTab5
nmap <M-y> <Plug>AirlineSelectTab6
nmap <M-u> <Plug>AirlineSelectTab7
nmap <M-i> <Plug>AirlineSelectTab8
nmap <M-o> <Plug>AirlineSelectTab9

" move to character
map <leader>s <Plug>(easymotion-s)
" override builtin search
map / <Plug>(easymotion-sn)
map <leader>n <Plug>(easymotion-next)
map <leader>N <Plug>(easymotion-prev)
" }}

" panels {{
" main layout
" nnoremap <leader><Space> :TagbarToggle<CR>:NERDTreeToggle<CR>:wincmd p<CR>:call BufNerdHighlight()<CR>
nnoremap <leader><Space> :Vista!!<CR>:NERDTreeToggle<CR>:wincmd p<CR>:call BufNerdHighlight()<CR>
nnoremap <leader>u :UndotreeToggle<CR>
" choose file
let g:NERDTreeMapOpenInTab = '<C-t>' " prevent conflict
" nnoremap t :EnsureNormWin<CR>:call fzf#vim#files('', {'source': 'rg --color never --no-messages --files'})<CR>
nnoremap t :EnsureNormWin<CR>:Files<CR>
" choose tag
" use LSP symbol list for supported languages
function ShowSymbolList()
    call EnsureInNormalWindow()
    if has_key(g:has_language_server, &syntax)
        CocFzfList outline
    else
        :BTags
    endif
endfunction
nnoremap <leader>t :call ShowSymbolList()<CR>
" nnoremap <leader>t :CocFzfList outline<CR>
" choose buffer
nnoremap <leader>b :EnsureNormWin<CR>:Buffers<CR>
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
