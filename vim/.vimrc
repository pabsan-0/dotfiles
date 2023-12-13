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

" buggy - space insertion
"nmap <S-Enter> <ESC>o<ESC>d^
nmap <Enter> <ESC>O<ESC>


" search highlight, and smart case
set hlsearch
set ignorecase
set smartcase


" Netrw filetree options
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 0
let g:netrw_altv = 1
let g:netrw_winsize = 75
let g:netrw_bufsettings = 'noma nomod nu nobl nowrap ro'

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

" Status line with filename
set laststatus=2
set statusline=%F
hi StatusLine ctermbg=white ctermfg=black

" center cursor on screen
" nnoremap j jzz
" nnoremap k kzz
set scrolloff=15

" Install with :PlugInstall
call plug#begin()
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'airblade/vim-gitgutter'
Plug 'kshenoy/vim-signature'
Plug 'tpope/vim-vinegar'
"Plug 'madox2/vim-ai'
call plug#end()

" Fzf.vim
let $FZF_DEFAULT_OPTS = '--bind "alt-j:down,alt-k:up,ctrl-j:preview-down,ctrl-k:preview-up"'
nnoremap <leader>f <Esc>:Files<cr> 
nnoremap <leader>b <Esc>:Buffers<cr>
nnoremap <leader>r <Esc>:Rg<cr>
nnoremap <leader>d <Esc>:GFiles?<cr>

" Vim gitgutter
" jump hunks: [c ]c; preview, stage, and undo hunks:  <leader>hp, <leader>hs, and <leader>hu
set updatetime=100
set signcolumn=yes
highlight clear SignColumn
highlight GitGutterAdd    guifg=#009900 ctermfg=green ctermbg=NONE
highlight GitGutterDelete guifg=#ff2222 ctermfg=red ctermbg=NONE
highlight GitGutterChange guifg=#bbbb00 ctermfg=3 ctermbg=NONE " orange

" Vim signature
" inherit color to make compatible with git-gutter
let g:SignatureMarkTextHLDynamic = 1

nnoremap <leader>v <Esc>:!cd &&  glow %:p -p vim <CR><CR><cr>

""" FOR THE FUTURE
""" https://vim.fandom.com/wiki/Generating_a_column_of_increasing_numbers
""" inoremap <C-Enter> <>o 
