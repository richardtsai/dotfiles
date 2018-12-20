if get(s:, 'loaded', 0)
  finish
endif
let s:loaded = 1

function langcliext#SwitchSourceHeader() abort
    let this_uri = 'file://' . LSP#filename()
    function! s:switch(resp) abort
        if !has_key(a:resp, 'result')
            return
        endif
        let filename = substitute(a:resp['result'], '^file://', '', '')
        if !filereadable(filename)
            return
        endif
        exe 'edit ' . filename
    endfunction
    call LanguageClient#Call('textDocument/switchSourceHeader', {'uri': this_uri}, funcref('s:switch'))
endfunction
