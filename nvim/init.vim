" environment-specific settings, might alter behaviors of other initialization
" processes so need to load first
silent! source <sfile>:h/local.vim
" settings of nvim core functions
source <sfile>:h/core.vim
" plugin loadding and plugin-specific settings
source <sfile>:h/plugins.vim
" key mappings
source <sfile>:h/mappings.vim

" load again to override settings
silent! source <sfile>:h/local.vim
