" *opencode.vim*                    Use OpenCode from a Vim terminal window
"
" Installation ~                                         *opencode-install*
"   Dump this file in `~/.vim/plugin`
"
" Mappings ~                                            *opencode-mappings*
"
" Always ~
" >
"   \o      Toggle the OpenCode window on the side
" <
" Text Buffers ~
" >
"   \o      Toggle (and focus) the OpenCode window on the side
"   \O      Focus OpenCode and insert cursor / visual selection location
" <
" OpenCode Buffer ~
" >
"   Ctrl-%       Insert the cursor's location (file:line)
"   Ctrl-d       Close the OpenCode window
"   Ctrl-c       Mimic Esc to interrupt the agent
"   Ctrl-w w     Switch window (default Vim behavior)
"   Ctrl-w c     Close window (default Vim behavior)
" <
" Other keys are absorbed by OpenCode as usual.
"
" Commands ~                                            *opencode-commands*
" >
"   :Explain :Comment :Ask :Chat   Send a prompt with current context
" <
" Create custom commands for your preferred prompts.
"

let s:opencode_buf = 0
let s:opencode_source_win = 0
let g:opencode_dir = "~"

set autoread

" Internal convenience API
function! OpenCodeIsRunning()
    return s:opencode_buf && bufexists(s:opencode_buf)
endfunction

function! OpenCodeBuffer()
    return s:opencode_buf
endfunction

function! OpenCodeWindow()
    return OpenCodeIsRunning() ? bufwinnr(s:opencode_buf) : -1
endfunction

function! OpenCodeIsForeground()
    return OpenCodeWindow() != -1
endfunction

function! OpenCodeIsActive()
    return OpenCodeWindow() != winnr()
endfunction


" Window and session handling
function! OpenCodeActivate()
    if OpenCodeIsRunning()
        if OpenCodeIsForeground()
            execute OpenCodeWindow() . 'close!'
        else
            execute 'botright vertical sbuffer ' . OpenCodeBuffer()
            execute OpenCodeWindow() . 'wincmd w'
        endif
    else
        call OpenCodeRunNew("")
        if OpenCodeIsRunning()
            execute OpenCodeWindow() . 'wincmd w'
        endif
    endif
endfunction

function! OpenCodeToBackground()
    if win_id2win(s:opencode_source_win)
        call win_gotoid(s:opencode_source_win)
    else
        wincmd p
    endif
endfunction

function! OpenCodeClose()
    if OpenCodeIsRunning()
        let l:win = OpenCodeWindow()
        if l:win != -1
            call term_sendkeys(OpenCodeBuffer(), "\<C-C>\<C-D>")
            execute l:win . 'close!'
        endif
        let s:opencode_buf = 0
    endif
endfunction


" Path handling
function! GetRepoRoot()
    let l:root = system('git -C ' . shellescape(expand('%:p:h')) . ' rev-parse --show-toplevel 2>/dev/null')
    let l:root = substitute(l:root, '\n$', '', '')
    if empty(l:root)
        return getcwd()
    endif
    return l:root
endfunction

function! OpenCodeUserLocation(start, end)
    let l:abs_filepath = expand('%:p')

    " No file in the buffer: send a bare line reference
    if empty(l:abs_filepath)
        return '#' . a:start . (a:start == a:end ? '' : '-' . a:end)
    endif

    " Make path relative to repo root if inside repo root, otherwise fall back to full path
    if l:abs_filepath =~ '^' . escape(g:opencode_dir, '/\')
        let l:rel_filepath = simplify(strpart(l:abs_filepath, strlen(g:opencode_dir) + 1))
    else
        let l:rel_filepath = l:abs_filepath
    endif

    " OpenCode V2 attaches files as @path#first[-last]; columns are not supported
    if a:start == a:end
        let l:location = '@' . l:rel_filepath . '#' . a:start
    else
        let l:location = '@' . l:rel_filepath . '#' . a:start . '-' . a:end
    endif

    return l:location
endfunction

" Line range to send as context, in order of precedence: the range the command
" was given, a newer visual selection, then the last range used. A selection is
" recognised by its marks, which are read now because they are live while the
" command runs even after Vim has drained the keys that ended visual mode.
function! OpenCodeSourceRange(...)
    let l:given = a:0 ? a:1 : [line('.'), line('.')]
    let [l:first, l:last] = sort([line("'<"), line("'>")], 'n')
    let l:selected = l:first > 0 && l:first != l:last
    let l:fresh = l:selected && [l:first, l:last] != get(g:, 'opencode_selected', [0, 0])

    if exists('g:opencode_command_range')
        let l:range = l:fresh ? [l:first, l:last] : l:given
    elseif l:selected && (l:fresh || line('.') != get(g:, 'opencode_cursor', -1))
        let l:range = [l:first, l:last]
    else
        let l:range = get(g:, 'opencode_selection', l:given)
    endif

    let g:opencode_selection = l:range
    let g:opencode_selected = l:selected ? [l:first, l:last] : get(g:, 'opencode_selected', [0, 0])
    let g:opencode_cursor = line('.')
    unlet! g:opencode_command_range
    return l:range
endfunction

function! OpenCodeInsertLocation()
    if !win_id2win(s:opencode_source_win)
        return
    endif
    call win_execute(s:opencode_source_win, 'call OpenCodeSendLocation()')
endfunction

function! OpenCodeSendLocation()
    let l:range = OpenCodeSourceRange([line('.'), line('.')])
    call term_sendkeys(OpenCodeBuffer(), OpenCodeUserLocation(l:range[0], l:range[1]) . ' ')
endfunction

function! OpenCodeJump()
    let s:opencode_source_win = win_getid()
    let l:starting = !OpenCodeIsRunning()

    if l:starting
        call OpenCodeActivate()
    elseif OpenCodeIsForeground()
        execute OpenCodeWindow() . 'wincmd w'
    else
        execute 'botright vertical sbuffer ' . OpenCodeBuffer()
        execute OpenCodeWindow() . 'wincmd w'
    endif

    if OpenCodeIsRunning()
        if l:starting
            call timer_start(300, {-> OpenCodeInsertLocation()})
        else
            call OpenCodeInsertLocation()
        endif
        startinsert
    endif
endfunction


" Main flow
function! OpenCodeRun(prompt, context = v:true) range
    let g:opencode_command_range = [a:firstline, a:lastline]
    let l:range = OpenCodeSourceRange(g:opencode_command_range)

    let l:context = a:context
                \ ? 'Context: ' . OpenCodeUserLocation(l:range[0], l:range[1]) . ' | '
                \ : ""

    " Terminal mode owns the keyboard, so the prompt must be typed in from normal mode
    if mode() ==# 't'
        execute "normal! \<C-\>\<C-n>"
    endif

    if !OpenCodeIsRunning()
        call OpenCodeRunNew(l:context . a:prompt)
    else
        call OpenCodeRunExisting(l:context . a:prompt)
    endif
endfunction

function! OpenCodeJobExit(job, status) abort
    " Exit status 1 means opencode rejected the command line (e.g. an unknown flag)
    if a:status == 1
        echohl ErrorMsg
        echomsg 'OpenCode failed to start (exit 1). Check the opencode window for usage.'
        echohl None
    endif
    " Closing the last window of a tab would leave an empty buffer behind
    if winnr('$') == 1 && bufname('%') ==# ''
        bwipeout!
    endif
endfunction

function! OpenCodeRunNew(prompt)
    let s:opencode_source_win = win_getid()

    " Leave the source window first: splitting is not allowed while 'hidden' is off
    " Args are passed as a list because :terminal expands @ and # in a string
    let l:cmd = ['opencode']
    if !empty(a:prompt)
        call extend(l:cmd, ['--prompt', a:prompt])
    endif
    call add(l:cmd, g:opencode_dir)

    execute 'botright vertical new'
    call term_start(
        \ l:cmd,
        \ {'curwin': 1, 'term_finish': 'close', 'exit_cb': function('OpenCodeJobExit')})

    let s:opencode_buf = bufnr('%')
    setlocal nomodified

    " When in buffer-normal mode, press i or a to return to interactive mode
    tnoremap <buffer> <C-o> <C-\><C-n><C-o>
    tnoremap <buffer> <C-i> <C-\><C-n><C-i>
    tnoremap <buffer> <C-6> <C-\><C-n><C-6>
    tnoremap <buffer> <C-^> <C-\><C-n><C-^>
    tnoremap <buffer> <C-5> <C-\><C-n>:call OpenCodeInsertLocation()<CR>i
    tnoremap <buffer> <C-d> <C-w>c
    tnoremap <buffer> <C-c> <Esc>
    tnoremap <buffer> <C-z> <C-w>N<C-z>i
    tnoremap <buffer> \o    <C-w>c
    tnoremap <buffer> \\    \

    call OpenCodeToBackground()
endfunction

function! OpenCodeRunExisting(prompt)
    call term_sendkeys(OpenCodeBuffer(), a:prompt . "\<CR>")

    " Do not steal the cursor: jump to the terminal only when typing in it already
    if bufwinnr(OpenCodeBuffer()) == winnr()
        return
    endif
    execute 'buffer ' . OpenCodeBuffer()
    startinsert
endfunction

function! s:QuitOpencode()
    if !OpenCodeIsRunning()
        return
    endif
    let l:job = term_getjob(s:opencode_buf)
    if l:job isnot v:null
        call job_stop(l:job, 'kill')
    endif
    silent! execute 'bwipeout!' s:opencode_buf
endfunction

augroup AutocmdOpenCode
    autocmd!
    autocmd VimLeavePre * call OpenCodeClose()
    " :qa refuses while a terminal job runs; drop it before the decision
    autocmd QuitPre * call s:QuitOpencode()
    " The marks are live on the way out of visual mode, the anchor is not
augroup END


let g:opencode_dir = GetRepoRoot()

" Normal Mode Mappings (uses current cursor position)
command! -range Explain <line1>,<line2>call OpenCodeRun("Explain this code step-by-step")
command! -range Comment <line1>,<line2>call OpenCodeRun("Add inline documentation and comments")
command! -range Ask     <line1>,<line2>call OpenCodeRun("How can I improve this?")
command! -range -nargs=? Chat <line1>,<line2>call OpenCodeRun(<q-args>)

nnoremap <leader>o      :call OpenCodeActivate()<CR>
xnoremap <leader>o      :<C-u>call OpenCodeActivate()<CR>
nnoremap <leader>O      :call OpenCodeJump()<CR>
xnoremap <leader>O      :<C-u>call OpenCodeJump()<CR>
