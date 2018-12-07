syntax on
filetype plugin indent on
set history=50
set mouse=a
set showmatch
set matchtime=1
set matchpairs+=<:>
set laststatus=2
set expandtab
set shiftwidth=4
set tabstop=4
set softtabstop=4
set number
set encoding=utf-8
set fileencodings=utf-8,gb18030
set hidden
set scrolloff=2
set cursorline
set foldmethod=syntax
set foldlevel=99
set undofile
set completeopt=longest,menu
set pumheight=10
set previewheight=5
set noshowmode
if (has("termguicolors"))
    set termguicolors
endif

autocmd FileType javascript setlocal tabstop=2 shiftwidth=2 softtabstop=2 colorcolumn=80
autocmd FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4 colorcolumn=79
autocmd FileType c,cpp setlocal tabstop=2 shiftwidth=2 softtabstop=2 colorcolumn=80
autocmd FileType html,htmldjango,xhtml,haml setlocal tabstop=2 shiftwidth=2 softtabstop=2 textwidth=0
autocmd FileType crontab set nowritebackup

autocmd BufReadPost *
  \ if line("'\"") > 1 && line("'\"") <= line("$") |
  \   exe "normal! g`\"" |
  \ endif

if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
          \ | wincmd p | diffthis
endif
