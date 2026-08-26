" general
set nocompatible " explicit
set encoding=utf-8
set shellcmdflag=-c

if has('mac')
  set clipboard=unnamed
else
  set clipboard=unnamedplus
endif

set regexpengine=0  " use automatic regex engine selection

syntax on
filetype plugin indent on

" editing
:set autoindent
:set smartindent
:set tabstop=2    " width of hard tab
:set shiftwidth=2 " size of indent
:set smarttab
:set shiftround " round indent to a multiple of shiftwidth
:set formatoptions+=j " strip comment leader when joining lines with J
:set matchpairs+=<:>
:set nofixendofline
:set undolevels=10000
:set virtualedit=block
:set backspace=indent,eol,start " explicit, like everything else

augroup filetype_indent
  autocmd!
  autocmd Filetype python setlocal expandtab tabstop=4 shiftwidth=4 " tabs to 4 spaces in python
  autocmd Filetype rust setlocal expandtab tabstop=2 shiftwidth=2
  autocmd Filetype markdown setlocal expandtab tabstop=2 shiftwidth=2
augroup END

" Use faster NFA regexp engine for JS/TS/JSX/TSX, old engine backtracking times out
augroup fast_syntax_engine
  autocmd!
  autocmd Filetype typescript,typescriptreact,javascript,javascriptreact setlocal regexpengine=2
augroup END

" search
:set ignorecase
:set smartcase
:set hlsearch
:set incsearch

" ui
:set number
:set listchars=space:·,tab:>\|,trail:~,extends:>,precedes:<
:set list
:set colorcolumn=80,100,120

:set cursorline
:set cursorcolumn
:set scrolloff=4
:set wildmenu
:set wildmode=longest:full,full
:set splitright
:set splitbelow
:set title
:set confirm
:set laststatus=1
:set showcmd
:set wrap ":set nowrap

:set mouse=a
if !has('nvim') && !has('gui_running')
  set ttymouse=sgr
endif

" colors
:set termguicolors
:colorscheme torte
:highlight ColorColumn ctermbg=236 guibg=#2a2a2a
:highlight CursorLine cterm=None ctermbg=235 guibg=#222222
:highlight CursorColumn cterm=None ctermbg=235 guibg=#181818
:highlight SpecialKey cterm=None ctermfg=238 guifg=#444444
:highlight NonText cterm=None ctermfg=238 guifg=#444444

" key mappings
let mapleader = " "    " leader key prefix
" <leader>e: netrw file explorer sidebar
nnoremap <leader>e : :Lexplore<CR>
"
" Tab and Shift-Tab indenting in normal mode
nnoremap <Tab> >>
nnoremap <S-Tab> <<

" Stay in visual mode after indenting
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv

" Better up/down with gj/gk for wrapped lines (1j/1k for default behavior)
nnoremap <expr> j v:count == 0 ? 'gj' : 'j'
xnoremap <expr> j v:count == 0 ? 'gj' : 'j'
nnoremap <expr> <Down> v:count == 0 ? 'gj' : 'j'
xnoremap <expr> <Down> v:count == 0 ? 'gj' : 'j'
nnoremap <expr> k v:count == 0 ? 'gk' : 'k'
xnoremap <expr> k v:count == 0 ? 'gk' : 'k'
nnoremap <expr> <Up> v:count == 0 ? 'gk' : 'k'
xnoremap <expr> <Up> v:count == 0 ? 'gk' : 'k'

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

" Custom commands

cabbrev ! T
" replaces ! for T
" T: run a shell command in a terminal in a new tab (vim or nvim)
function! s:OpenTerm(...) abort
  tab new
  setlocal nonumber nolist noswapfile bufhidden=wipe
  if has('nvim')
    call termopen(a:000)
    startinsert
  else
    " vim uses term_start(); curwin reuses new tab's window
    call term_start(a:000, {'curwin': 1})
  endif
endfunction
command! -nargs=+ -complete=file T call s:OpenTerm(<f-args>)

" W: use sudo tee to write a file opened without sudo
command! W execute 'w !sudo tee % > /dev/null' <bar> edit!
