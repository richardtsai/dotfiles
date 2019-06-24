if get(s:, 'loaded', 0)
  finish
endif
let s:loaded = 1

function snip_support#CppDefaultIncludeHeader()
    let current_file = expand('%:t')
    let header_file = substitute(current_file, '^\(.\{-1,}\)\(_test\)\?\.[^.]*$', '\1.h', '')
    if current_file != header_file && filereadable(expand('%:p:h') . '/' . header_file)
        return header_file
    endif
    return ''
endfunction

let s:cpp_include_common_components = {
  \ 'gtest': '<gtest/gtest.h>',
  \ 'gmock': '<gmock/gmock.h>',
  \ 'protobuf': '<google/protobuf/'
\ }

function snip_support#CppIncludeCommon(component)
    return get(s:cpp_include_common_components, a:component, '')
endfunction
