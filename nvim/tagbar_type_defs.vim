if filereadable(expand('~/.ctags.d/optlib/proto.ctags'))
    let g:tagbar_type_proto = {
        \ 'deffile': expand('~/.ctags.d/optlib/proto.ctags'),
        \ 'ctagstype': 'proto',
        \ 'kinds': [
            \ 'p:package',
            \ 'i:imports',
            \ 'm:message',
            \ 'f:field',
            \ 'e:enum',
            \ 'v:enum value',
            \ 's:service',
            \ 'r:method',
            \ 'q:request',
            \ 't:response',
        \ ],
        \ 'sro': '.',
        \ 'kind2scope': {
            \ 'm': 'message',
            \ 'f': 'field',
            \ 'e': 'enum',
            \ 'v': 'enum value',
            \ 's': 'service',
            \ 'r': 'method',
            \ 'q': 'request',
            \ 't': 'response',
        \ },
        \ 'scope2kind': {
            \ 'package': 'p',
            \ 'message': 'm',
            \ 'field': 'f',
            \ 'enum': 'e',
            \ 'enum value': 'v',
            \ 'service': 's',
            \ 'method': 'r',
            \ 'request': 'q',
            \ 'response': 't',
        \ },
        \ 'sort': 0
    \ }
endif
