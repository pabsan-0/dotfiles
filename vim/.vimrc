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

" allow unsaved buffers in bg
set hidden

" tabs are really 4 spaces
set tabstop=4     " sets width of tab charcter
set shiftwidth=4  " amount of whitespace to use with <, > in normal mode
set softtabstop=4 " amount of whitespace to insert/delete in insert mode
set expandtab     " insert spaces rather than tabs in insert mode
set autoindent

" whitespace inspecting tools, toggle visuals
set listchars=eol:¬,tab:▷\ ,trail:⎵,nbsp:⎵
noremap <Leader><Tab><Tab> :set invlist<CR>

" Bash-like completion on cmd mode
set wildmode=longest,list

" display partially fed commands
set showcmd

" search highlight, incremental, and smart case
set hlsearch
set incsearch
set ignorecase
set smartcase

" Saner behavior of C-a on 0-leading numbers
set nrformats=

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

" Comfier buffer nav
nnoremap <silent> [b :bprevious<CR>
nnoremap <silent> ]b :bnext<CR>
nnoremap <silent> [B :bfirst<CR>
nnoremap <silent> ]B :blast<CR>

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
Plug 'junegunn/fzf.vim'       " fuzzy finding
Plug 'tpope/vim-fugitive'     " git 
Plug 'tpope/vim-surround'     " bracing conveniences
Plug 'airblade/vim-gitgutter' " git hints
Plug 'kshenoy/vim-signature'  " display marks
Plug 'tpope/vim-vinegar'      " super netrw
"Plug 'madox2/vim-ai'
call plug#end()

" Fzf.vim
let $FZF_DEFAULT_OPTS = '--bind "alt-j:down,alt-k:up,ctrl-j:preview-down,ctrl-k:preview-up"'
nnoremap <leader>f <Esc>:Files<cr> 
nnoremap <leader>b <Esc>:Buffers<cr>
nnoremap <leader>r <Esc>:Rg<cr>
nnoremap <leader>d <Esc>:GFiles?<cr>


" Rip grepping of snippets, yay!
let s:snippets_path = "~/snippets/"

function! s:rg_file_read(location)
    let string_list = split(a:location, ':', 2)
    execute 'read ' .. s:snippets_path .. string_list[0]
endfunction

command! -bang -nargs=* CustomSnippets
    \ call fzf#vim#grep(
    \ "rg -m 1 -L --column --no-heading --pretty --smart-case ".shellescape(<q-args>), 
    \ 1, 
    \ fzf#vim#with_preview({'dir': s:snippets_path, 'sink': function('s:rg_file_read')}),
    \ <bang>0)

nnoremap <leader>s <Esc>:CustomSnippets<cr>


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
nnoremap <leader>r :!%:p 

""" FOR THE FUTURE
""" https://vim.fandom.com/wiki/Generating_a_column_of_increasing_numbers
""" inoremap <C-Enter> <>o 
