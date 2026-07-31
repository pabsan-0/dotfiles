" K binding fallback ladder
let g:default_kp = &keywordprg
set keywordprg=:ChainedLookup

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

command! -nargs=+ ChainedLookup call ChainedLookupCb(<f-args>)
