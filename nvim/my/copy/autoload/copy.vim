if get(s:, 'loaded', 0)
  finish
endif
let s:loaded = 1

function copy#select() abort
    let candidates = [
        \ 'qpath: ' . s:path_in_qqmail(),
        \ 'wpath: ' . s:path_in_workspace(),
        \ 'path: ' . expand('%:p'),
        \ 'file: ' . expand('%:t'),
      \ ]
    let opts = {
        \ 'source': candidates,
        \ 'sink': function('s:copy'),
      \ }
    call fzf#run(fzf#wrap(opts))
endfunction

function s:copy(candidate) abort
    let @@ = substitute(a:candidate, '\s*\w*: \(.*\)', '\1', '')
endfunction

function s:path_in_workspace() abort
    let path = expand('%:p')
    let result = path
    for workspace in g:WorkspaceFolders
        let p = substitute(path, resolve(workspace) . '/', '', '')
        if len(p) < len(result)
            let result = p
        endif
    endfor
    return result
endfunction

function s:path_in_qqmail() abort
    return substitute(expand('%:p'), '.\{-}\<QQMail/', '', '')
endfunction
