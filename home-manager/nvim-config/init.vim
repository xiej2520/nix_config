set shellcmdflag=-c
set clipboard+=unnamedplus

:set number
:set autoindent
:set smartindent
:set tabstop=2    " width of hard tabstop
:set shiftwidth=2 " size of indent
:set smarttab
:set nofixendofline

:set listchars=space:·,tab:>\|,trail:~,extends:>,precedes:<
:set list
:set colorcolumn=80,100,120

:autocmd Filetype python setlocal expandtab tabstop=4 shiftwidth=4 " tabs to 4 spaces in python

:autocmd Filetype markdown setlocal expandtab tabstop=2 shiftwidth=2

:set mouse=a

vmap <Tab> >gv
vmap <S-Tab> <gv

cabbrev ! T
" replaces ! for T
" T for executing shell commands in nvim
command! -nargs=+ -complete=file T
    \ tab new | setlocal nonumber nolist noswapfile bufhidden=wipe |
    \ call termopen([<f-args>]) |
    \ startinsert
