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
" nnoremap j jzz
" nnoremap k kzz
set scrolloff=15

" Install with :PlugInstall
call plug#begin()
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
call plug#end()

" Vim gitgutter
set updatetime=100
set signcolumn=yes
highlight clear SignColumn
highlight GitGutterAdd    guifg=#009900 ctermfg=green ctermbg=NONE
highlight GitGutterDelete guifg=#ff2222 ctermfg=red ctermbg=NONE
highlight GitGutterChange guifg=#bbbb00 ctermfg=3 ctermbg=NONE " orange


""" FOR THE FUTURE
""" https://vim.fandom.com/wiki/Generating_a_column_of_increasing_numbers
""" inoremap <C-Enter> <>o 