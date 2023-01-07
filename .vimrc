set relativenumber
syntax enable && syntax on

" Remap Esc in INSERT mode
inore jj <Esc>

" Disable arrow-keys (except INSERT mode)
map <Left> <NOP>
map <Down> <NOP>
map <Up> <NOP>
map <Right> <NOP>

" Color schemes!
  "colo elflord
  colo pablo
  "colo slate

" Generate matching signs
  "inoremap " ""<left>
  "inoremap ' ''<left>
  inoremap ( ()<left>
  inoremap [ []<left>
  inoremap { {}<left>
  inoremap {<CR> {<CR>}<ESC>O
  inoremap {;<CR> {<CR>};<ESC>O

" Indentation
  set tabstop=4
  set shiftwidth=4
  set softtabstop=4
  set autoindent
  set expandtab
  filetype plugin indent on
" 2023-01-05: why a '- foo' line in .md file
" doesn't replicate (autoindent) in new line below?


" Statusline stuff
  set laststatus=2
  set statusline=
  set statusline+=\ %F
