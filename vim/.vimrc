" Automatic reloading of .vimrc
autocmd! bufwritepost .vimrc source %

" All swap files in the same dir, make sure it exists!
set directory^=$HOME/.vim/swap//
if has('persistent_undo')
  set undodir=$HOME/.vim/undo
  set undofile
endif


filetype plugin indent on

" line numbers
set relativenumber
set number


" tabs are really 4 spaces
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent

" buggy
" map <S-Enter> o<ESC>
map <Enter> O<ESC>


" search highlight, and smart case
set hlsearch
set ignorecase
set smartcase


" Netrw filetree options
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 3
let g:netrw_altv = 1
let g:netrw_winsize = 75

" toggle netrw 
inoremap <c-b> <Esc>:Lex<cr>:vertical resize 50%<cr>
nnoremap <c-b> <Esc>:Lex<cr>:vertical resize 50%<cr>

" autodelete netrw buffers
augroup AutoDeleteNetrwHiddenBuffers
  au!
  au FileType netrw setlocal bufhidden=wipe
augroup end


" Cursor options
set cursorline
set colorcolumn=80
highlight colorcolumn ctermbg=None ctermfg=green
highlight Comment ctermfg=gray

" center cursor on screen
nnoremap j jzz
nnoremap k kzz
"inoremap <C-Enter> <>o

""" FOR THE FUTURE
""" https://vim.fandom.com/wiki/Generating_a_column_of_increasing_numbers