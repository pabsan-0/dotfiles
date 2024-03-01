" Automatic reloading of .vimrc
autocmd! bufwritepost .vimrc source %

""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" Customisation of existing features 
""""""""""""""""""""""""""""""""""""""""""""""""""""""""

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

" whitespace inspecting tools, toggle visuals. See with :set invlist
set listchars=eol:¬,tab:▷\ ,trail:⎵,nbsp:⎵

" Bash-like completion on cmd mode
set wildmode=longest,list

" display partially fed key combos
set showcmd

" search highlight, incremental, and smart case
set hlsearch
set incsearch
set ignorecase
set smartcase

" Saner behavior of C-a on 0-leading numbers
set nrformats=

" search for entire visual selection
xnoremap * :<C-u>call <SID>VSetSearch()<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>call <SID>VSetSearch()<CR>?<C-R>=@/<CR><CR>
function! s:VSetSearch()
    let temp = @s
    norm! gv"sy
    let @/ = '\V' . substitute(escape(@s, '/\'), '\n', '\\n', 'g')
    let @s = temp
endfunction

" Cursor options
set cursorline
set colorcolumn=80
highlight colorcolumn ctermbg=None ctermfg=green
highlight Comment ctermfg=gray
set scrolloff=15

" Status line with filename
set laststatus=2
set statusline=%F
hi StatusLine ctermbg=white ctermfg=black

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

" Comfier navigations
nnoremap <silent> [b :bprevious<CR>
nnoremap <silent> ]b :bnext<CR>
nnoremap <silent> [B :bfirst<CR>
nnoremap <silent> ]B :blast<CR>
" 
nnoremap <silent> [q :cprev<CR>
nnoremap <silent> ]q :cnext<CR>
nnoremap <silent> [Q :cfirst<CR>
nnoremap <silent> ]Q :clast<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" Plugins and plugin-related
""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Install with :PlugInstall
call plug#begin()
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'       " fuzzy finding
Plug 'tpope/vim-fugitive'     " git 
Plug 'tpope/vim-surround'     " bracing conveniences
Plug 'airblade/vim-gitgutter' " git hints
Plug 'kshenoy/vim-signature'  " display marks
Plug 'tpope/vim-vinegar'      " super netrw
call plug#end()

" Fzf.vim
let $FZF_DEFAULT_OPTS = '--bind "alt-j:down,alt-k:up,ctrl-j:preview-down,ctrl-k:preview-up"'
nnoremap <leader>f <Esc>:Files<cr> 
nnoremap <leader>b <Esc>:Buffers<cr>
nnoremap <leader>r <Esc>:Rg<cr>
nnoremap <leader>d <Esc>:GFiles?<cr>
nnoremap <leader>s <Esc>:CustomSnippets<cr>

" Rip grepping of snippets, yay!
let s:snippets_path = "~/snippets/"
"
function! s:rg_file_read(location)
    let string_list = split(a:location, ':', 2)
    execute 'read ' .. s:snippets_path .. string_list[0]
endfunction
"
command! -bang -nargs=* CustomSnippets
    \ call fzf#vim#grep(
    \ "rg -m 1 -L --column --no-heading --pretty --smart-case ".shellescape(<q-args>), 
    \ 1, 
    \ fzf#vim#with_preview({'dir': s:snippets_path, 'sink': function('s:rg_file_read')}),
    \ <bang>0)


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


""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" Custom functionality 
""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" look for # vimcmd: in the first lines and execute it
function! VimExecute()
    " default command
    let command = "%:p"   

    let line = 1
    while line <= 5 && line('$') >= line
        let comment = getline(line)
        if comment =~ 'vimcmd:\s*\S\+'
            let command = substitute(comment, '.*vimcmd:\s*\(\S\+.*\)$', '\1', '')
            break 
        endif
        let line += 1
    endwhile
    execute "!".command
    "normal ":!".command
endfunction


" Custom remaps

" coding and debugging
nnoremap <leader><leader>r :!%:p 
nnoremap <leader><leader>R :call VimExecute()<CR>
nnoremap <leader><leader>m :make<CR>
nnoremap <leader><leader>v <Esc>:!cd &&  glow %:p -p vim <CR><CR><cr>

" help me better see what im doing
nnoremap <leader><leader><Tab> :set invlist<CR>
nnoremap <silent> <C-l> :<C-u>nohlsearch<CR><C-l>
