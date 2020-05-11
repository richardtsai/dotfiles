if get(s:, 'loaded', 0)
  finish
endif
let s:loaded = 1

function shortcuts#expand_cpp_ns_current_line()
lua << EOF
local shortcuts = require('shortcuts')
shortcuts.expand_current_line(shortcuts.cpp_ns)
EOF
endfunction
