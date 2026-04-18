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

call plug#begin(has('nvim') ? stdpath('data') . '/plugged' : '~/.vim/plugged')

" :PlugInstall
Plug 'navarasu/onedark.nvim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'preservim/nerdtree'
Plug 'ap/vim-css-color'
Plug 'ryanoasis/vim-devicons'
Plug 'neoclide/coc.nvim'
Plug 'tc50cal/vim-terminal'
Plug 'dstein64/nvim-scrollview'
Plug 'voldikss/vim-floaterm' " :FloatermNew

call plug#end()

lua << EOF
require('onedark').setup {
	colors = {
		black = '#000000',
		bg0 = '#000000',
	},
	style = 'darker',
}
require('onedark').load()
EOF

" Start NERDTree. If a file is specified, move the cursor to its window.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * NERDTree | if argc() > 0 || exists("s:std_in") | wincmd p | endif

" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" Ctrl+T: Toggles NERDTree
nnoremap <C-t> :NERDTreeToggle<CR>
" Select all
nnoremap <C-a> gg0vG


" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file.
" use <tab> for trigger completion and navigate to the next complete item
function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Use <c-s> to trigger completion.
inoremap <silent><expr> <C-s> coc#refresh()

" :CocInstall coc-clangd coc-java coc-python coc-tsserver coc-json coc-html coc-css
" :CocInstall coc-markdownlint coc-markdown-preview-enhanced coc-webview
" :CocInstall coc-discord-neovim
