
""""""""""""
" SETTINGS "
""""""""""""

" Basic settings
syntax on
syntax enable
set number
set relativenumber
set mouse=a
set scrolloff=8
set colorcolumn=80

"Searching 
set hlsearch
set incsearch
set ignorecase

" Indentation
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set autoindent
set smartindent
filetype plugin indent on


""""""""""""
" KEYBINDS "
""""""""""""

" Remap Esc in INSERT and VISUAL modes
inoremap kj <Esc>
vnoremap kj <Esc>

" Move visual selection up and down
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv


