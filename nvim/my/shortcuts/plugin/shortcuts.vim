augroup ShortcutsAuGroup
    autocmd!
    autocmd FileType cpp command -buffer NS :call shortcuts#expand_cpp_ns_current_line()
augroup end
