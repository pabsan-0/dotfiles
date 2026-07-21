" Indices to jump with gF
" ~/.vimrc:138

" Automatic reloading of .vimrc
autocmd! bufwritepost .vimrc source %

""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" Customisation of existing features
""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" All swap files in the same dir, make sure dir exists!
set directory^=$HOME/.vim/files/swap//
set updatecount=200

" Persistent undo files, make sure dir exists!
if has('persistent_undo')
  set undofile
  set undodir=$HOME/.vim/files/undo/
endif

" Backup files, make sure dir exists!
set backup
set backupdir=$HOME/.vim/files/backup//
set backupcopy=yes
set backupskip=
augroup RenameBackupFiles
    au BufWritePre * let &bex = '@' . strftime("%F.%H:%M")
augroup end

" Viminfo
set viminfo='100,n$HOME/.vim/files/info/viminfo


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

" Filename completion ^x^f works after assignments
set isfname-==

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
let g:netrw_fastbrowse = 0

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
Plug 'junegunn/fzf.vim'          " fuzzy finding
Plug 'tpope/vim-fugitive'        " git tool
Plug 'tpope/vim-rhubarb'         " github tool
Plug 'tpope/vim-surround'        " bracing conveniences
Plug 'tpope/vim-eunuch'          " Move, Chmod, SudoWrite...
Plug 'airblade/vim-gitgutter'    " git hints
Plug 'kshenoy/vim-signature'     " display marks
Plug 'tpope/vim-vinegar'         " super netrw
Plug 'dense-analysis/ale'        " async lint engine
Plug 'puremourning/vimspector'   " tui debugger
Plug 'junegunn/vim-easy-align'   " vertical alignment
Plug 'tpope/vim-commentary'      " very easy comment switching
Plug 'rhysd/conflict-marker.vim' " easy merge conflict mappings
Plug 'junegunn/gv.vim'           " commit history inspector
Plug 'wellle/context.vim'        " see scope as shadow text at the top
Plug 'vim-scripts/a.vim'         " alternate source/header files
Plug 'vim-scripts/taglist.vim'   " taglist utility
Plug 'TamaMcGlinn/quickfixdd'    " remove from quickfix with dd
Plug 'Yggdroot/indentLine'       " preview indent lines

Plug 'gh-tui-tools/gh-review.vim'

Plug 'pabsan-0/vim-actions'      " commands atop fzf
Plug 'pabsan-0/vim-flashcards'   " notes atop fzf
Plug 'pabsan-0/vim-snippets'     " snippets atop fzf
Plug 'pabsan-0/vim-slidev'       " slidev conveniences
Plug 'pabsan-0/vim-pr-fix'       " pr fixing conveniences
Plug 'pabsan-0/vim-gst-debug'    " vim log parsing
Plug 'pabsan-0/vim-paginate'     " vim pager


Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
" Plug 'vimwiki/vimwiki', { 'do': g:vimwiki_post_hook }
" Plug 'kkoomen/vim-doge', { 'do': { -> doge#install() } }
" Plug 'DanBradbury/copilot-chat.vim'
" Plug 'github/copilot.vim'        " copilot autocomplete
call plug#end()

" Fzf.vim

" Lets you keep history of searches.
" Explicitly map c-p and c-n to keep usual behavior
let g:fzf_history_dir = '~/.local/share/fzf-history'
let $FZF_DEFAULT_OPTS = '--bind ctrl-n:down,ctrl-p:up,alt-n:next-history,alt-p:prev-history,ctrl-j:preview-down,ctrl-k:preview-up'
let g:fzf_layout = { 'down': '60%' }

nnoremap <leader>f <Esc>:Files<cr>
nnoremap <leader>b <Esc>:Buffers<cr>
nnoremap <leader>D <Esc>:GFiles?<cr>

nnoremap <leader>r <Esc>:Rg<cr>
xnoremap <leader>r "hy:Rg <C-r>=escape(@h, '[]\/*?.$^()')<CR><CR>
nnoremap <leader>R :Rg <C-r><C-w><CR>

" Vim fugitive
nnoremap <leader>dt :G difftool<CR>
nnoremap <leader>dT :G difftool
nnoremap <leader>ds :Gvdiffsplit<CR>
nnoremap <leader>dS :Gvdiffsplit

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
\   'javascript': ['deno --options-indent-width 4'],
\   'sh': ['shellcheck'],
\   'python': ['ruff'],
\   'dockerfile': ['hadolint']
\}
nnoremap <silent> [e :ALEPrevious<CR>
nnoremap <silent> ]e :ALENext<CR>

let g:ale_virtualtext_cursor = 0 " dont add virtual text
let g:ale_fix_on_save = 1
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'help': ['align_help_tags'],
\   'javascript': ['deno'],
\   'python': ['black', 'isort'],
\   'cpp': ['clang-format'],
\   'markdown': ['prettier']
\}
" Easy saving without reformatting
command! W :noautocmd w

" Vimspector
let g:vimspector_enable_mappings = 'HUMAN'
let g:vimspector_sign_priority = {}  " TBD
let g:vimspector_configurations = {
\   'Python: Run Current File': {
\     'adapter': 'debugpy',
\     'filetypes': [ 'python' ],
\     'configuration': {
\       'request': 'launch',
\       'program': '${file}',
\       'cwd': '${workspaceRoot}',
\       'stopOnEntry': v:true
\     }
\   },
\   'C/C++: Launch Current Binary': {
\     'adapter': 'vscode-cpptools',
\     'filetypes': [ 'c', 'cpp', 'rust' ],
\     'configuration': {
\       'request': 'launch',
\       'program': '${fileDirname}/${fileBasenameNoExtension}',
\       'cwd': '${workspaceRoot}',
\       'stopOnEntry': v:true
\     }
\   },
\   'Bash: GDB Bash running Current Script': {
\     'adapter': 'vscode-cpptools',
\     'filetypes': [ 'sh', 'bash' ],
\     'configuration': {
\       'request': 'launch',
\       'program': '/bin/bash',
\       'args': [ '${file}' ],
\       'cwd': '${workspaceRoot}',
\       'stopOnEntry': v:false
\     }
\   }
\ }

" Vimwiki
let g:vimwiki_list = [{'path': '~/vimwiki', 'syntax': 'default', 'ext': '.wiki'}]
let g:vimwiki_global_ext = 1
let g:vimwiki_syntax_list = {}
let g:vimwiki_syntax_list['markdown'] = {}
let g:vimwiki_syntax_list['markdown']['typeface'] = {'bold': [], 'italic': [], 'underline': [], 'bold_italic': [], 'code': [], 'del':  [], 'sup':  [], 'sub':  [], 'eq': []}

" Easy align
nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)

" Commentary (not really plugin-specific) overrides
augroup commentStrings
    autocmd BufEnter *.md,*.markdown setlocal commentstring=<!--\ %s\ -->
augroup end

" Copilot chat
nnoremap <leader>C :CopilotChatOpen<CR>
vmap <leader>a <Plug>CopilotChatAddSelection

" Context
let g:context_highlight_border = 'Comment'
let g:context_highlight_border = '<hide>'
let g:context_highlight_tag = '<hide>'
highlight ContextBg ctermfg=darkgray
let g:context_highlight_normal = 'ContextBg'

" taglist
let g:Tlist_WinWidth = 50

" indentlines
" disable by default
let g:indentLine_enabled = 0
let g:indentLine_char = '⎸'

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
nnoremap <leader><leader><Tab> :IndentLinesToggle<CR>:set invlist<CR>
nnoremap <silent> <C-l> :<C-u>nohlsearch<CR><C-l>

" To be incorporated
nnoremap <c-t> /[A-Z]<return>

" Detect Arduino .ino files as C++
augroup cpp_detect
    au BufNewFile,BufRead *.ino setlocal filetype=cpp
augroup end


function! GstFormat() range
  " Append ; if not already there
  exec 's/\v;?\s*$/ ;/'

  " Replace !| with newline and proper indentation
  "    <--- actual subs ---> <--------------- indentation bullshit ------------------------------>
  exec 's/\v([!|])/\="\\\r" . repeat(" ", indent(".")) . repeat(" ", &shiftwidth) . submatch(1)/g'

  if exists(':EasyAlign')
    normal gaip-\' \'
  endif
endfunction
command! GstFormat :call GstFormat()
nnoremap <silent> <Leader>gf :GstFormat<CR>


" gf but create file if it does not exist
nnoremap <leader>gf :e <cfile><cr>
vnoremap <leader>gf y:e <C-r>"<CR>


" K binding fallback ladder
let g:default_kp = &keywordprg
set keywordprg=:ChainedLookup
command! -nargs=+ ChainedLookup call ChainedLookupCb(<f-args>)

function! ChainedLookupCb(...)
    let l:count = a:0 > 1 ? a:1 : ''
    let l:word = a:0 > 1 ? a:2 : a:1

    " GStreamer plugins
    call system('gst-inspect-1.0 ' .. l:word .. ' >/dev/null 2>&1')
    if v:shell_error == 0
        let l:cmd = 'env PAGER=cat gst-inspect-1.0 ' .. l:word
        call term_start(l:cmd, {
        \   'curwin': 1,
        \   'exit_cb': {job, status -> timer_start(10, {-> feedkeys(":\<C-u>keepjumps normal! gg\<CR>", 'n')})}
        \ })
        return
    endif

    " Fallback to native
    let &keywordprg = g:default_kp
    try
        execute 'normal! ' .. l:count .. 'K'
    finally
        set keywordprg=:ChainedLookup
    endtry
endfunction
