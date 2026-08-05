" FIXME range selection not working

let s:opencode_buf = 0
let s:opencode_source_win = 0
let g:opencode_dir = "~"


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
            execute OpenCodeWindow() . 'close'
        else
            execute 'botright vertical sbuffer ' . OpenCodeBuffer()
        endif
    else
        call OpenCodeRun("Standby for further instructions.")
    endif
endfunction

function! OpenCodeToBackground()
    if winbufnr(s:opencode_source_win) != -1 && s:opencode_source_win != winnr()
        execute s:opencode_source_win . 'wincmd w'
    else
        wincmd p
    endif
endfunction

function! OpenCodeClose()
    if OpenCodeIsRunning()
        let l:win = OpenCodeWindow()
        if l:win != -1
            call term_sendkeys(OpenCodeBuffer(), "\<C-C>\<C-D>")
            execute l:win . 'close'
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

function! OpenCodeUserLocation() range
    let l:abs_filepath = expand('%:p')

    " Make path relative to repo root if inside repo root, otherwise fall back to full path
    if l:abs_filepath =~ '^' . escape(g:opencode_dir, '/\')
        let l:rel_filepath = simplify(strpart(l:abs_filepath, strlen(g:opencode_dir) + 1))
    else
        let l:rel_filepath = l:abs_filepath
    endif

    if a:firstline == a:lastline && mode() !=# 'v' && mode() !=# 'V' && mode() !=# "\<C-V>"
        let l:location = l:rel_filepath . ":" . line('.') . ":" . col('.')
    else
        let l:start_line = a:firstline
        let l:start_col = col("'<")
        let l:end_line = a:lastline
        let l:end_col = col("'>")
        let l:location = l:rel_filepath . ":" . l:start_line . ":" . l:start_col
                    \ . "-" . l:end_line . ":" . l:end_col
    endif

    return l:location
endfunction

function! OpenCodeInsertLocation()
    let l:source_id = win_getid(s:opencode_source_win)
    call win_execute(l:source_id, 'call term_sendkeys(OpenCodeBuffer(), OpenCodeUserLocation())')
endfunction


" Main flow
function! OpenCodeRun(prompt, context = v:true) range
    let l:context = a:context
                \ ? 'Context: ' . OpenCodeUserLocation() . ' | '
                \ : ""

    if !OpenCodeIsRunning()
        call OpenCodeRunNew(l:context . a:prompt)
    else
        call OpenCodeRunExisting(l:context . a:prompt)
    endif
endfunction

function! OpenCodeRunNew(prompt)
    let s:opencode_source_win = winnr()

    execute 'botright vertical terminal ++close opencode '
        \ . ' --prompt "' . a:prompt . '" '
        \ . ' --agent plan '
        \ . g:opencode_dir

    " When in buffer-normal mode, press i or a to return to interactive mode
    tnoremap <buffer> <C-o> <C-\><C-n><C-o>
    tnoremap <buffer> <C-i> <C-\><C-n><C-i>
    tnoremap <buffer> <C-6> <C-\><C-n><C-6>
    tnoremap <buffer> <C-^> <C-\><C-n><C-^>
    tnoremap <buffer> <C-5> <C-\><C-n>:call OpenCodeInsertLocation()<CR>i

    let s:opencode_buf = bufnr('%')
endfunction

function! OpenCodeRunExisting(prompt)
    call term_sendkeys(OpenCodeBuffer(), a:prompt . "\<CR>")
    execute 'buffer ' . OpenCodeBuffer()
endfunction

augroup AutocmdOpenCode
    autocmd!
    autocmd VimLeavePre * call OpenCodeClose()
augroup END


let g:opencode_dir = GetRepoRoot()

" Normal Mode Mappings (uses current cursor position)
command! -range Explain :call OpenCodeRun("Explain this code step-by-step")
command! -range Comment :call OpenCodeRun("Add inline documentation and comments")
command! -range Ask     :call OpenCodeRun("How can I improve this?")
command! -range -nargs=? Chat :call OpenCodeRun(<q-args>)

nnoremap <leader>o      :call OpenCodeActivate()<CR>
