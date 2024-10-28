" Indices to jump with gF
" ~/.vimrc:118 

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
let g:netrw_altfile = 1 " alternate file is never netrw

" autodelete netrw buffers on exit
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
nnoremap <silent> [a :prev<CR>
nnoremap <silent> ]a :next<CR>
nnoremap <silent> [A :first<CR>
nnoremap <silent> ]A :last<CR>
"
nnoremap <silent> [q :cprev<CR>
nnoremap <silent> ]q :cnext<CR>
nnoremap <silent> [Q :cfirst<CR>
nnoremap <silent> ]Q :clast<CR>

nnoremap <silent> [t :tabp<CR>
nnoremap <silent> ]t :tabn<CR>
nnoremap <silent> [T :tabfirst<CR>
nnoremap <silent> ]T :tablast<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" Plugins and plugin-related
""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Prevents vimwiki from stepping on vim-vinegar mapping. Needs PlugInstall
let g:vimwiki_post_hook = 'sed -i /map_key.*-.*VimwikiRemoveHeaderLevel/d ftplugin/vimwiki.vim'

" Install with :PlugInstall
call plug#begin()
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'       " fuzzy finding
Plug 'tpope/vim-fugitive'     " git 
Plug 'tpope/vim-surround'     " bracing conveniences
Plug 'airblade/vim-gitgutter' " git hints
Plug 'kshenoy/vim-signature'  " display marks
Plug 'tpope/vim-vinegar'      " super netrw
Plug 'dense-analysis/ale'     " async lint engine 
Plug 'puremourning/vimspector' " tui debugger
Plug 'vimwiki/vimwiki', { 'do': g:vimwiki_post_hook }
Plug 'junegunn/vim-easy-align' 
Plug 'tpope/vim-commentary'
Plug 'pabsan-0/vim-actions'
Plug 'pabsan-0/vim-flashcards'
call plug#end()

" Fzf.vim

" Lets you keep history of searches. 
" Explicitly map c-p and c-n to keep usual behavior
let g:fzf_history_dir = '~/.local/share/fzf-history'
let $FZF_DEFAULT_OPTS = '--bind ctrl-n:down,ctrl-p:up,alt-n:next-history,alt-p:prev-history,ctrl-j:preview-down,ctrl-k:preview-up'

nnoremap <leader>f <Esc>:Files<cr> 
nnoremap <leader>b <Esc>:Buffers<cr>
nnoremap <leader>r <Esc>:Rg<cr>
nnoremap <leader>d <Esc>:GFiles?<cr>
nnoremap <leader>s <Esc>:CustomSnippets<cr>
nnoremap <leader>S <Esc>:CustomSnippetsEdit<cr>

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
"
" Open the snippet directory ready for edition
function! CustomSnippetsEdit()
    execute "vsplit"
    execute "lcd " .. s:snippets_path
    execute "Explore " .. s:snippets_path
endfunction
command! CustomSnippetsEdit call CustomSnippetsEdit()


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

" ALE
let g:ale_linters_explicit = 1
let g:ale_linters = {
\   'sh': ['shellcheck']
\}
nnoremap <silent> [e :ALEPrevious<CR>
nnoremap <silent> ]e :ALENext<CR>

let g:ale_fix_on_save = 1
let g:ale_fixers = {
\   '*': [],
\   'help': ['align_help_tags'],
\   'python': ['black', 'isort'],
\   'cpp': ['clang-format']
\}

" Vimspector
let g:vimspector_enable_mappings = 'HUMAN'
let g:vimspector_sign_priority = {}  " TBD

" Vimwiki
let g:vimwiki_list = [{'path': '~/vimwiki', 'syntax': 'default', 'ext': '.wiki'}]
let g:vimwiki_global_ext = 1
let g:vimwiki_syntax_list = {}
let g:vimwiki_syntax_list['markdown'] = {}
let g:vimwiki_syntax_list['markdown']['typeface'] = {'bold': [], 'italic': [], 'underline': [], 'bold_italic': [], 'code': [], 'del':  [], 'sup':  [], 'sub':  [], 'eq': []}

" Easy align
nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)

" Commentary
" autocmd FileType apache setlocal commentstring=#\ %s


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


function! OpenReadmeAtGitRoot()
    " Get the path to the repository root (empty on error)
    let root = system('git rev-parse --show-toplevel 2>/dev/null')

    " Check if root is empty (indicates error)
    if empty(root)
        echoerr "Not a git repository"
        return
    endif

    " Open README.md in a new buffer
    let root = root[0:-2]
    execute 'edit ' . root .'/README.md'
endfunction


function! UECppSwitch()
    " Switch between header and source in UE cpp file structures

    let l:extension = expand('%:e')
    let l:filename_noext = expand('%:p:r')

    " Source file in case-insensitive Private directory
    if l:extension == 'cpp' && l:filename_noext =~ '/private/'

        " Append extension and case-preserving substitution
        let l:filename = l:filename_noext .. '.h'
        if l:filename_noext =~# '/private/'
            let l:filename = substitute (l:filename, '/\Cprivate/', '/public/', 'gi')
        else
            let l:filename = substitute (l:filename, '/\CPrivate/', '/Public/', 'gi')
        endif

        execute "edit " ..  expand(l:filename)

    " Header file in case-insensitive Public directory
    elseif l:extension == 'h' && l:filename_noext =~ '/public/'

        " Append extension and case-preserving substitution
        let l:filename = l:filename_noext .. '.cpp'
        if l:filename_noext =~# '/public/'
            let l:filename = substitute (l:filename, '/\Cpublic/', '/private/', 'gi')
        else
            let l:filename = substitute (l:filename, '/\CPublic/', '/Private/', 'gi')
        endif

        execute "edit " ..  expand(l:filename)
    endif
endfunction


nnoremap <silent> <leader><leader>c :call UECppSwitch()<CR>
" Custom remaps

" Coding and debugging
nnoremap <leader><leader>r :!%:p 
nnoremap <leader><leader>R :call VimExecute()<CR>
nnoremap <leader><leader>m :make<CR>
nnoremap <leader><leader>v <Esc>:!cd &&  glow %:p -p vim <CR><CR><cr>

" Documentation and sanity
nnoremap <leader>gr :call OpenReadmeAtGitRoot()<CR>

" Help me better see what im doing
nnoremap <leader><leader><Tab> :set invlist<CR>
nnoremap <silent> <C-l> :<C-u>nohlsearch<CR><C-l>

" To be incorporated
nnoremap <c-t> /[A-Z]<return>

augroup cpp_detect
    au BufNewFile,BufRead *.ino setlocal filetype=cpp
augroup end
