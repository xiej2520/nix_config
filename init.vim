set shellcmdflag=-c
set clipboard=unnamedplus

:set number
:set autoindent
:set smartindent
:set tabstop=2    " width of hard tabstop
:set shiftwidth=2 " size of indent
:set smarttab
:set nofixendofline
:set undolevels=10000
:set virtualedit=block

:set listchars=space:·,tab:>\|,trail:~,extends:>,precedes:<
:set list
:set colorcolumn=80,100,120

:set cursorline
:set cursorcolumn
:set termguicolors
:colorscheme torte
:highlight CursorLine cterm=None ctermbg=235 guibg=#222222
:highlight CursorColumn cterm=None ctermbg=235 guibg=#181818

:autocmd Filetype python setlocal expandtab tabstop=4 shiftwidth=4 " tabs to 4 spaces in python
:autocmd Filetype rust setlocal expandtab tabstop=2 shiftwidth=2
:autocmd Filetype markdown setlocal expandtab tabstop=2 shiftwidth=2

:set mouse=a
:set ignorecase
:set smartcase

" Tab and Shift-Tab indenting in normal mode
nnoremap <Tab> >>
nnoremap <S-Tab> <<

" Stay in visual mode after indenting
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv


:set wrap ":set nowrap
" Better up/down with gj/gk for wrapped lines (1j/1k for default behavior)
nnoremap <expr> j v:count == 0 ? 'gj' : 'j'
xnoremap <expr> j v:count == 0 ? 'gj' : 'j'
nnoremap <expr> <Down> v:count == 0 ? 'gj' : 'j'
xnoremap <expr> <Down> v:count == 0 ? 'gj' : 'j'
nnoremap <expr> k v:count == 0 ? 'gk' : 'k'
xnoremap <expr> k v:count == 0 ? 'gk' : 'k'
nnoremap <expr> <Up> v:count == 0 ? 'gk' : 'k'
xnoremap <expr> <Up> v:count == 0 ? 'gk' : 'k'

" Swap 0 and g0 (beginning of line/beginning of visible line)
nnoremap 0 g0
xnoremap 0 g0
nnoremap g0 0
xnoremap g0 0

" Swap $ and g$ (end of line/end of visible line)
nnoremap $ g$
xnoremap $ g$
nnoremap g$ $
xnoremap g$ $

" Move to window using <ctrl> hjkl keys
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
" Resize window using <ctrl> arrow keys
nnoremap <C-Up> :resize +2<CR>
nnoremap <C-Down> :resize -2<CR>
nnoremap <C-Left> :vertical resize -2<CR>
nnoremap <C-Right> :vertical resize +2<CR>

" Move Lines in normal mode
nnoremap <A-j> :execute 'move .+' . v:count1<CR>==
nnoremap <A-k> :execute 'move .-' . (v:count1 + 1)<CR>==
" Move Lines in insert mode
inoremap <A-j> <Esc>:execute 'm .+1'<CR>==gi
inoremap <A-k> <Esc>:execute 'm .-2'<CR>==gi
" Move Lines in visual mode
vnoremap <A-j> :<C-u>execute \"'<,'>move '>+\" . v:count1<CR>gv=gv
vnoremap <A-k> :<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<CR>gv=gv


cabbrev ! T
" replaces ! for T
" T for executing shell commands in nvim
command! -nargs=+ -complete=file T
    \ tab new | setlocal nonumber nolist noswapfile bufhidden=wipe |
    \ call termopen([<f-args>]) |
    \ startinsert
