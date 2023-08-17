set number relativenumber
syntax on && syntax enable

set colorcolumn=80
autocmd FileType * set colorcolumn=80

" Remap Esc in INSERT mode
inore kj <Esc>
inore KJ <Esc>

" Enable mouse motions
set mouse=a

" Indentation
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set autoindent
set smartindent
filetype plugin indent on

" Searching
set hlsearch
set incsearch
set ignorecase

" Fun with <leader>
let mapleader = ' '
nnoremap <leader>pv :execute ":Explore"<CR>
nnoremap <leader>gs :execute ":!git status"<CR>
nnoremap <leader>cc :execute 'set colorcolumn=' . (&colorcolumn == "" ? "80" : "")<CR>

  
" Use :RandomColorscheme on startup
function! SetRandomColorscheme()
  let schemes = getcompletion('', 'color')
  let random_scheme = schemes[rand() % len(schemes)]
  execute 'colorscheme ' . random_scheme
  echo "Selected colorscheme: " . random_scheme " WON'T WORK!
endfunction  
command! RandomColorscheme call SetRandomColorscheme()    
autocmd VimEnter * call SetRandomColorscheme()

" Increment the number under the cursor
function! IncrementNumber()
  execute 'normal \<C-a>'
endfunction



" -------------- INOP --------------
    
" let my_colorschemes = ['delek', 'slate', 'pablo' , 'zellner', 'elflord']
" execute 'colorscheme' my_colorschemes[rand() % (len(my_colorschemes) - 1 ) ]

" Disable arrow-keys -- not during INSERT
  "map <Left> <NOP>
  "map <Down> <NOP>
  "map <Up> <NOP>
  "map <Right> <NOP>

" Generate matching punctuation
  "inoremap " ""<left>
  "inoremap ' ''<left>
  "inoremap ( ()<left>
  "inoremap [ []<left>
  "inoremap { {}<left>
  "inoremap {<CR> {<CR>}<ESC>O
  "inoremap {;<CR> {<CR>};<ESC>O

" Statusline
  "set laststatus=2
  "set statusline=
  "set statusline=%F         " Path to the file
  "set statusline+=%=        " Switch to the right side
  "set statusline+=%l        " Current line
  "set statusline+=/         " Separator
  "set statusline+=%L        " Total lines

" Git for statusline
  "function! GitBranch()
  "  return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
  "endfunction
  "
  "function! StatuslineGit()
  "    let l:branchname = GitBranch()
  "    return strlen(l:branchname) > 0?'  '.l:branchname.' ':''
  "endfunction
  "
  "  set statusline+=%{StatuslineGit()}
