if get(s:, 'loaded', 0)
  finish
endif
let s:loaded = 1

augroup Langcli
    autocmd!
    autocmd User CocNvimInit call CocRegistNotification(
        \ 'clangd', 'textDocument/clangd.fileStatus', function('langcli#OnClangdFileStatusChanged')
    \ )
augroup END

function langcli#InitAirline() abort
    call airline#parts#define('linenr_lite', {'raw': '%4l', 'accent': 'bold'})
    call airline#parts#define('maxlinenr_lite', {'raw': '/%L', 'accent': 'bold'})
    call airline#parts#define_function('langclistatus', 'langcli#GetStatus')
    let g:airline_section_z = airline#section#create([
        \ '%3p%%', 'linenr_lite', 'maxlinenr_lite', ':%v'.g:airline_symbols.space, 'langclistatus'
    \ ])
endfunction

function langcli#SwitchSourceHeader() abort
    let filename = expand('<afile>:p')
    if !filename
        let filename = expand('%:p')
    endif
    let this_uri = 'file://' . filename
    function! s:switch(error, resp) abort
        let filename = substitute(a:resp, '^file://', '', '')
        if !filereadable(filename)
            return
        endif
        exe 'edit ' . filename
    endfunction
    call CocRequestAsync('clangd', 'textDocument/switchSourceHeader', {'uri': this_uri}, funcref('s:switch'))
endfunction

let s:clangdFileStatusMap = {}
function! langcli#OnClangdFileStatusChanged(data) abort
    let l:file = substitute(a:data['uri'], '^file://', '', '')
    let l:buf = bufnr(l:file)
    if l:buf > 0
        let s:clangdFileStatusMap[l:buf] = a:data['state']
    endif
endfunction

function! langcli#GetStatus() abort
    let l:buf = bufnr('%')
    if has_key(s:clangdFileStatusMap, l:buf)
        return 'clangd:' . s:clangdFileStatusMap[l:buf]
    else
        return get(g:, 'coc_status', '')
    endif
endfunction
