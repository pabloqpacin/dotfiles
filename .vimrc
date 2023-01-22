set number relativenumber
syntax on && syntax enable

" Remap Esc in INSERT mode
inore kj <Esc>

" Disable arrow-keys (except INSERT mode)
map <Left> <NOP>
map <Down> <NOP>
map <Up> <NOP>
map <Right> <NOP>

" Color schemes!
  colo pablo
  "colo elflord
  "colo slate
  "colo zellner

" Generate matching signs
  "inoremap " ""<left>
  inoremap ' ''<left>
  inoremap ( ()<left>
  inoremap [ []<left>
  inoremap { {}<left>
  inoremap {<CR> {<CR>}<ESC>O
  inoremap {;<CR> {<CR>};<ESC>O

" Indentation
  set expandtab
  set tabstop=4
  set shiftwidth=4
  set softtabstop=4
  set autoindent
  set smartindent
  filetype plugin indent on
  " todo: markdown bullet-lists
  " enable 'markdown.vim'

" Enable mouse motions
  "set mouse=a

" LEADER commands: \ + <key>
nnoremap <leader>c :execute "set colorcolumn=" . (&colorcolumn == "" ? "80" : "")<CR>
nnoremap <leader>gs :execute "!git status"<CR>

" Statusline
  set laststatus=2
  set statusline=
  set statusline=%F         " Path to the file
  set statusline+=%=        " Switch to the right side
  set statusline+=%l        " Current line
  set statusline+=/         " Separator
  set statusline+=%L        " Total lines

" Git for statusline
function! GitBranch()
  return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfunction

function! StatuslineGit()
    let l:branchname = GitBranch()
    return strlen(l:branchname) > 0?'  '.l:branchname.' ':''
endfunction

  set statusline+=%{StatuslineGit()}

